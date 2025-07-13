import os
import platform
import shutil
import subprocess
import time
import uuid
import threading
import logging
import queue

import cv2

from SQL.mysqlCinfig import update_task_status, update_task
from ZLM.zlmConfig import get_video_status, get_video
from ultralytics.utils.plotting import colors, Annotator
from util.myutils import create_output_dirs, setup_rtsp_streams, send_json_record,send_json_box_record
from util.model_loader import load_models, detect_objects
from util.createbox import plot_one_box,plot_frame_box
from util.uploader import initialize_minio_client, setup_minio_bucket, upload_to_minio


# 初始化 MinIO 客户端
minio_client = initialize_minio_client()
setup_minio_bucket(minio_client)
create_output_dirs()

# 处理平台兼容性
plt = platform.system()
if plt == 'Windows':
    import pathlib
    pathlib.PosixPath = pathlib.WindowsPath

def save_frames_to_disk(frames, temp_dir):
    if not os.path.exists(temp_dir):
        os.makedirs(temp_dir)
    for idx, frame in enumerate(frames):
        try:
            cv2.imwrite(os.path.join(temp_dir, f"frame_{idx:04d}.png"), frame)
        except Exception as e:
            logging.error(f"保存帧失败：{e}")
def cleanup_temp_files(temp_dir):
    if os.path.exists(temp_dir):
        shutil.rmtree(temp_dir)

def process_video_stream(name, rtsp_urls, labels, stop_event, taskId):

    # 加载模型
    models, device, imgsz = load_models(labels)

    # 使用 OpenCV 打开 RTSP 视频流
    cap_objects, cap_properties = setup_rtsp_streams(rtsp_urls)


    # 初始化参数
    buffer_frames = [[] for _ in range(len(rtsp_urls))]
    recording = [False] * len(rtsp_urls)
    frame_count = [0] * len(rtsp_urls)
    first_detected_frames = [None] * len(rtsp_urls)
    print("开始处理视频流...")

    # 创建临时帧存储目录
    temp_dir = "temp_frames"
    if not os.path.exists(temp_dir):
        os.makedirs(temp_dir)

    # 主循环，处理视频流直到停止事件触发
    while not stop_event.is_set():
        frames = []
        # 从每个视频流中读取一帧
        for cap in cap_objects:
            ret, frame = cap.read()
            if not ret:
                break
            frames.append(frame)

        # 如果没有读取到任何帧，退出循环
        if len(frames) == 0:
            break

        # 处理每一帧
        for i, frame in enumerate(frames):
            # 对每个模型，准备图像并进行对象检测
            for model in models:
                results = detect_objects(model, frame)
                detected = False
                # 遍历检测结果
                for det in results[0].boxes:
                    xyxy = det.xyxy[0].cpu().numpy()  # 获取检测框坐标
                    conf = det.conf[0].cpu().item()  # 获取置信度
                    cls = det.cls[0].cpu().item()  # 获取类别编号
                    if conf > 0.7:  # 置信度大于0.7时处理
                        detected = True
                        label = f'{model.names[int(cls)]} {conf:.2f}'
                        plot_one_box(xyxy, frame, label=label, color=colors(int(cls), True))

                # 如果检测到对象
                if detected:
                    # 如果当前不在录制，则开始录制
                    if not recording[i]:
                        recording[i] = True
                        frame_count[i] = 0  # 重置帧计数
                        buffer_frames[i] = []  # 清空缓冲区
                        first_detected_frames[i] = frame.copy()
                        print(f"开始录制视频流 {i}...")  # 保存第一帧
                    buffer_frames[i].append(frame)
                else:
                    # 如果当前在录制，且没有检测到对象
                    if recording[i]:
                        buffer_frames[i].append(frame)
                        frame_count[i] += 1
                        # 检查是否已处理30帧置信度低于阈值
                        if frame_count[i] >= 60:
                            recording[i] = False
                            # 保存帧到磁盘
                            save_frames_to_disk(buffer_frames[i], temp_dir)
                            print(f"录制视频流 {i} 已完成...")

                            # 使用 ffmpeg 编码视频
                            timestamp = int(time.time())
                            video_filename = f"output_{timestamp}_{taskId}_{i}.mp4"
                            output_file = os.path.join("output_videos", video_filename)
                            encode_video_with_ffmpeg(temp_dir, output_file)
                            print(f"已保存视频 {output_file}")

                            # 保存并上传第一帧图片
                            image_filename = f"frame_{timestamp}_{taskId}_{i}.jpg"
                            image_path = os.path.join("output_img", image_filename)

                            try:
                                cv2.imwrite(image_path, first_detected_frames[i])
                            except Exception as e:
                                logging.error(f"保存帧失败：{e}")
                            i_path = upload_to_minio(image_path, "img", image_filename, minio_client)
                            print(f"已保存并上传第一帧图片 {image_path} 到 MinIO")

                            # 上传视频到 MinIO
                            v_path = upload_to_minio(output_file, "video", video_filename, minio_client)
                            video_path = f"/{v_path}"
                            img_path = f"/{i_path}"
                            send_json_record(video_path, img_path, rtsp_urls[i], timestamp, labels, taskId, i)

                            # 清空缓冲区，防止旧帧残留
                            buffer_frames[i] = []
                            first_detected_frames[i] = None
                            frame_count[i] = 0  # 重置不活动计数器

                            # 删除临时文件
                            cleanup_temp_files(temp_dir)
    # 释放资源
    for cap in cap_objects:
        cap.release()
    cv2.destroyAllWindows()


# 创建一个线程局部存储对象
thread_local = threading.local()

# 初始化 MAX_LEAVE
def initialize_thread_local():
    thread_local.MAX_LEAVE = 0
    thread_local.frame_count = 0  # 线程局部帧计数器
    thread_local.consecutive_detections = 0
    thread_local.consecutive_missing = 0

class FramePuller(threading.Thread):
    """
    专职拉流线程：持续读帧并发送心跳
    """
    def __init__(self, rtsp_url, zlm_url,taskId,frame_queue, stop_event, pull_interval=0.01, queue_max=20):
        super().__init__(daemon=True)
        self.rtsp_url = rtsp_url
        self.zlm_url = zlm_url
        self.taskId = taskId
        self.frame_queue = frame_queue
        self.stop_event = stop_event
        self.pull_interval = pull_interval
        self.cap = None

    def run(self):
        initialize_thread_local()
        self.cap = cv2.VideoCapture(self.zlm_url)
        reconnect_attempts = 0
        max_reconnect_attempts = 5
        while not self.stop_event.is_set():
            # 1. 读取一帧
            ret, frame = self.cap.read()
            if not ret:
                logging.warning("FramePuller: 视频流读取失败，尝试重新初始化...")
                reconnect_attempts += 1

                # 检测流状态
                if not get_video_status(self.zlm_url):
                    logging.warning("FramePuller: 检测到流已断开，尝试重新初始化...")
                    if not get_video(self.zlm_url,self.rtsp_url):
                        if reconnect_attempts >= max_reconnect_attempts:
                            logging.error("FramePuller: 重连尝试次数过多，退出...")
                            update_task_status(self.taskId)
                            break
                        logging.warning("FramePuller: 重连失败，等待后继续尝试...")
                        time.sleep(2)
                        continue
                    reconnect_attempts = 0
                else:
                    time.sleep(1)
                    self.cap.release()
                    self.cap = cv2.VideoCapture(self.zlm_url)
                    reconnect_attempts = 0
                continue

            # 2. 推入队列（满则丢弃最旧的一帧）
            try:
                if not self.frame_queue.full():
                    self.frame_queue.put(frame, timeout=0.1)
                else:
                    _ = self.frame_queue.get_nowait()
                    self.frame_queue.put(frame, timeout=0.1)
            except queue.Full:
                logging.warning("FramePuller: 队列已满，丢弃旧帧...")
            except Exception as e:
                logging.error(f"FramePuller: 推入队列时发生错误：{str(e)}")

            time.sleep(self.pull_interval)

        # 退出时释放
        self.cap.release()


class FrameProcessor(threading.Thread):
    """
    专职处理线程：消费帧、调用检测与录制逻辑
    """
    def __init__(self, frame_queue, stop_event, taskId, zlm_url, labels,
                 frame_boxs, frame_select, interval_time, frame_interval):
        super().__init__(daemon=True)
        self.frame_queue = frame_queue
        self.stop_event = stop_event
        self.taskId = taskId
        self.zlm_url = zlm_url
        self.labels = labels
        self.frame_boxs = frame_boxs
        self.frame_select = frame_select
        self.interval_time = interval_time
        self.frame_interval = max(1, frame_interval)

        # 初始化线程局部变量
        initialize_thread_local()
        # 加载模型
        self.models, self.device, self.imgsz = load_models(labels)
        # 初始化录制状态
        self.recording = False
        self.no_target_frame_count = 0
        self.recording_frame_count = 0
        self.max_no_target_frames = interval_time
        self.record_uuid = None
        self.imgid = 0
        self.stop_recording = False
        # 目录准备
        _, self.video_path, self.output_video_dir, _ = init_directories(taskId)

    def run(self):
        initialize_thread_local()

        while not self.stop_event.is_set():
            try:
                frame = self.frame_queue.get(timeout=0.1)
            except queue.Empty:
                continue

            # 帧过滤：按间隔检测
            thread_local.frame_count += 1
            if thread_local.frame_count % self.frame_interval != 0:
                continue

            # 调用分析
            if self.frame_select == 2:
                det, fupd, stop_rec, rec = analyze_frame_target_entry(
                    self.taskId, frame, self.models,
                    self.frame_boxs, self.imgsz, self.device,
                    self.recording
                )
            else:
                det, fupd, self.no_target_frame_count, stop_rec, rec, self.recording_frame_count = analyze_frame_target_absence(
                    frame, self.models, self.frame_boxs, self.imgsz,
                    self.device, self.no_target_frame_count,
                    self.recording_frame_count, self.max_no_target_frames,
                    self.recording
                )

            self.recording, self.stop_recording = rec, stop_rec
            frame = fupd

            # 录制开始
            if self.recording and self.record_uuid is None:
                self._on_start_record(frame)

            # 实际写帧
            if self.recording:
                fn = os.path.join(self.video_path, f"frame_{self.imgid:04d}.png")
                try:
                    cv2.imwrite(fn, frame)
                except Exception as e:
                    logging.error(f"保存帧失败：{e}")
                self.imgid += 1

            # 录制结束
            if self.stop_recording:
                self._on_stop_record()
                self._reset_record_state()

        # 退出时清资源
        cleanup_resources(None, self.video_path)

    def _on_start_record(self, first_frame):
        self.record_uuid = str(uuid.uuid4())
        logging.info(f"[{self.taskId}] 开始录制: {self.record_uuid}")
        img_path, img_name, ts = save_first_frame_image(first_frame, self.taskId)
        upath = upload_to_minio(img_path, "img", img_name, minio_client)
        send_json_box_record(None, f"/{upath}", self.zlm_url, ts,
                             self.labels, self.taskId, self.record_uuid)

    def _on_stop_record(self):
        out_file = os.path.join(self.output_video_dir, f"output_{self.record_uuid}.mp4")
        encode_video_with_ffmpeg(self.video_path, out_file)
        vpath = upload_to_minio(out_file, "video", os.path.basename(out_file), minio_client)
        send_json_box_record(f"/{vpath}", None, self.zlm_url,
                             int(time.time()), self.labels, self.taskId, self.record_uuid)

    def _reset_record_state(self):
        shutil.rmtree(self.video_path, ignore_errors=True)
        initialize_thread_local()
        self.recording = False
        self.stop_recording = False
        self.record_uuid = None
        self.imgid = 0
        self.no_target_frame_count = 0
        self.recording_frame_count = 0


def process_video_frame_stream(rtsp_url, zlm_url, labels,
                               stop_event, taskId, frame_boxs,
                               frame_select, interval_time, frame_interval):


    # 1. 校验并确保流可用
    if not get_video_status(zlm_url) and not get_video(zlm_url, rtsp_url):
        update_task_status(taskId)
        logging.error(f"[{taskId}] ZLM 拉流初始化失败")
        return

    # 2. 准备线程与队列
    frame_queue = queue.Queue(maxsize=20)
    puller = FramePuller(rtsp_url,zlm_url,taskId,frame_queue, stop_event)
    processor = FrameProcessor(frame_queue, stop_event, taskId,
                               zlm_url, labels,
                               frame_boxs, frame_select,
                               interval_time, frame_interval)

    # 3. 启动并等待结束
    puller.start()
    processor.start()
    puller.join()
    processor.join()

def analyze_frame_target_entry(taskId, frame, models, frame_boxs, imgsz, device, recording):
    """
    1. 需要连续3帧检测到目标才开始录制
    2. 需要连续30帧未检测到目标才停止录制
    """
    detected = False
    frame_updated = frame.copy()
    stop_recording = False

    # 初始化连续检测计数器
    if not hasattr(thread_local, 'consecutive_detections'):
        thread_local.consecutive_detections = 0
    if not hasattr(thread_local, 'MAX_LEAVE'):
        thread_local.MAX_LEAVE = 0

    # 检测目标
    for model in models:
        results = detect_objects(model,frame)

        for det in results[0].boxes:
            xyxy = det.xyxy[0].cpu().numpy()
            conf = det.conf[0].cpu().item()
            cls = det.cls[0].cpu().item()

            if conf > 0.85:
                target_in_box = any(is_within_box(xyxy, box) for box in frame_boxs)
                if target_in_box:
                    detected = True
                    # 绘制检测框
                    label = f'{model.names[int(cls)]} {conf:.2f}'
                    plot_one_box(xyxy, frame_updated, label, color=colors(int(cls), True))

    # 更新连续检测计数器
    if detected:
        thread_local.consecutive_detections += 1
        thread_local.MAX_LEAVE = 0  # 重置离开计数器
    else:
        thread_local.consecutive_detections = 0
        if recording:  # 仅在录制时更新离开计数器
            thread_local.MAX_LEAVE += 1

    print("连续检测计数器:", thread_local.consecutive_detections)
    # 绘制监控区域框
    for box in frame_boxs:
        plot_frame_box(box, frame_updated, color=(0, 0, 255), label="")

    # 状态转换逻辑
    if not recording:
        # 需要连续3帧检测到目标才开始录制
        if thread_local.consecutive_detections >= 3:
            recording = True
            print("连续3帧检测到目标，开始录制...")
            thread_local.consecutive_detections = 0  # 重置计数器
    else:
        # 连续30帧未检测到目标时停止
        if thread_local.MAX_LEAVE >= 30:
            stop_recording = True
            recording = False
            print("连续30帧未检测到目标，停止录制")

    return detected, frame_updated, stop_recording, recording

def analyze_frame_target_absence(frame, models, frame_boxs, imgsz, device,
                                no_target_frame_count, recording_frame_count,
                                max_no_target_frames, recording, max_recording_frames=60):
    """
    优化后的离岗检测逻辑：
    1. 需要连续5帧未检测到目标才开始录制
    2. 录制过程中重新检测到目标立即停止
    """
    detected = False
    frame_updated = frame.copy()
    stop_recording = False

    # 初始化连续丢失计数器
    if not hasattr(thread_local, 'consecutive_missing'):
        thread_local.consecutive_missing = 0

    # 检测目标
    for model in models:
        results = detect_objects(model, frame)

        for det in results[0].boxes:
            xyxy = det.xyxy[0].cpu().numpy()
            conf = det.conf[0].cpu().item()
            cls = det.cls[0].cpu().item()

            if conf > 0.85 and any(is_within_box(xyxy, box) for box in frame_boxs):
                detected = True
                label = f'{model.names[int(cls)]} {conf:.2f}'
                plot_one_box(xyxy, frame_updated, label, color=colors(int(cls), True))

    # 更新连续丢失计数器
    if not detected:
        thread_local.consecutive_missing += 1
    else:
        thread_local.consecutive_missing = 0
        if recording:  # 录制中重新检测到目标立即停止
            stop_recording = True
            recording = False

    # 绘制监控区域框
    for box in frame_boxs:
        plot_frame_box(box, frame_updated, color=(0, 0, 255), label="")

    # 状态转换逻辑
    if not recording:
        # 需要连续5帧未检测到目标才开始录制
        if thread_local.consecutive_missing >= max_no_target_frames:
            recording = True
            print(f"连续{max_no_target_frames}帧未检测到目标，开始录制...")
            thread_local.consecutive_missing = 0  # 重置计数器
    else:
        # 达到最大录制帧数停止
        recording_frame_count += 1
        if recording_frame_count >= max_recording_frames:
            stop_recording = True
            recording = False

    return detected, frame_updated, no_target_frame_count, stop_recording, recording, recording_frame_count

def encode_video_with_ffmpeg(temp_dir, output_file):
    """
    使用 FFmpeg 编码视频并保存到输出目录。
    """
    ffmpeg_command = [
        'ffmpeg', '-y', '-i', os.path.join(temp_dir, 'frame_%04d.png'),
        '-c:v', 'libx264', '-pix_fmt', 'yuv420p', output_file
    ]
    subprocess.run(ffmpeg_command, check=True)

def cleanup_temp_images(temp_dir):
    """
    清理临时的图片文件。
    """
    for file in os.listdir(temp_dir):
        if file.endswith(".png"):
            file_path = os.path.join(temp_dir, file)
            os.remove(file_path)
    print(f"已清理临时图片文件：{temp_dir}")







def save_video(frame, output_video_dir,fps,taskId):
    """
    使用 FFmpeg 编码视频并保存到输出目录，直接将每一帧写入视频文件。
    """
    timestamp = int(time.time())
    video_filename = f"output_{timestamp}_{taskId}.mp4"

    unique_id = str(uuid.uuid4())
    video_path = os.path.join(output_video_dir, f"video_{taskId}_{unique_id}")
    os.makedirs(video_path, exist_ok=True)

    # 初始化 VideoWriter 用于实时写入视频
    output_file = os.path.join(video_path, video_filename)
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')  # 使用 mp4 编码
    video_writer = cv2.VideoWriter(output_file, fourcc, fps, (frame.shape[1], frame.shape[0]))

    # 将当前帧写入视频文件
    video_writer.write(frame)

    # 释放 VideoWriter 资源
    video_writer.release()

    # 返回文件路径和视频文件名
    return output_file, video_filename, timestamp

def save_first_frame_image(frame,taskId):
    # 保存图像到本地文件
    timestamp = int(time.time())
    image_filename = f"frame_{timestamp}_{taskId}.jpg"
    image_path = os.path.join("output_img", image_filename)


    try:
        cv2.imwrite(image_path, frame)
    except Exception as e:
        logging.error(f"保存帧失败：{e}")

    return image_path, image_filename, timestamp

def init_directories(taskId):
    """
    初始化所需目录。
    """
    unique_id = str(uuid.uuid4())
    temp_dir = f"temp_videos"
    video_path = os.path.join(temp_dir, taskId + "_" + unique_id)
    output_video_dir = os.path.join(video_path, "output_videos")
    output_img_dir = os.path.join(video_path, "output_img")

    os.makedirs(temp_dir, exist_ok=True)
    os.makedirs(output_video_dir, exist_ok=True)
    os.makedirs(output_img_dir, exist_ok=True)

    return temp_dir,video_path, output_video_dir, output_img_dir

def is_within_box(target_xyxy, box_xyxy):
    """
    判断目标框的宽或高有一半进入指定框时返回True
    """
    target_left, target_top, target_right, target_bottom = target_xyxy
    box_left, box_top, box_right, box_bottom = box_xyxy

    # 目标框的宽度和高度
    target_width = target_right - target_left
    target_height = target_bottom - target_top

    # 目标框的一半宽度和高度
    target_half_width = target_width / 2
    target_half_height = target_height / 2

    # 判断目标框的至少一半宽度或高度是否进入指定框
    if (target_left < box_right and target_right > box_left and
        target_top < box_bottom and target_bottom > box_top):
        # 检查至少一半宽度进入
        if (target_left < box_right and target_right > box_left and
            target_right - box_left >= target_half_width and
            box_right - target_left >= target_half_width):
            return True

        # 检查至少一半高度进入
        if (target_top < box_bottom and target_bottom > box_top and
            target_bottom - box_top >= target_half_height and
            box_bottom - target_top >= target_half_height):
            return True

    return False

def cleanup_resources(cap, video_path):
    """
    清理资源，包括释放视频流和删除临时文件。
    """
    cap.release()
    cv2.destroyAllWindows()
    if os.path.exists(video_path):
        shutil.rmtree(video_path)