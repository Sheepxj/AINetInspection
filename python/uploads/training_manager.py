import os
import threading
import time
import logging
import torch

from ultralytics import YOLO
from rabbitmq.rabbitmq_utils import send_to_rabbitmq
from util.myutils import extract_and_split_times, extract_and_split_epoch, parse_time

# 设置日志基本配置
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# 调整 pika 库的日志级别
logging.getLogger("pika").setLevel(logging.WARNING)

def start_monitoring(train_id, process_id, stop_event):
    send_to_rabbitmq(train_id, process_id, 0, 1, "正在计算剩余时间...")

    # 构造日志目录路径并创建
    log_dir = os.path.join('runs', 'log', process_id)
    os.makedirs(log_dir, exist_ok=True)

    # 构造日志文件路径并确保文件存在
    log_file_path = os.path.join(log_dir, 'training_log.txt')
    open(log_file_path, 'a').close()

    while not stop_event.is_set():
        time.sleep(2)
        try:
            if os.path.exists(log_file_path):
                with open(log_file_path, 'r') as file:
                    lines = [line.strip() for line in file]
                    if lines:
                        last_line = lines[-1]
                        if last_line:
                            elapsed_time, remaining_time = extract_and_split_times(last_line)
                            current_epoch, total_epochs = extract_and_split_epoch(last_line)
                            if elapsed_time and remaining_time:
                                elapsed_seconds = parse_time(elapsed_time)
                                remaining_seconds = parse_time(remaining_time)
                                # 计算总的预计剩余时间并减去已经使用的时间
                                total_predicted_time = (elapsed_seconds + remaining_seconds) * (
                                            total_epochs - current_epoch)
                                predicted_remaining_time = total_predicted_time - elapsed_seconds

                                if predicted_remaining_time > 0:
                                    send_to_rabbitmq(train_id, process_id, current_epoch, 1, predicted_remaining_time)
                                else:
                                    send_to_rabbitmq(train_id, process_id, 100, 2, 0)
                            else:
                                logging.warning("时间轮次为空")
                        else:
                            logging.warning("最后一行为空")
                    else:
                        logging.warning("日志文件为空")
            else:
                logging.warning("文件不存在")
        except Exception as e:
            logging.error(f"读取日志文件出错: {e}")


def start_training(train_id, data_path, process_id):
    stop_event = threading.Event()
    monitor_thread = threading.Thread(target=start_monitoring, args=(train_id, process_id, stop_event))
    monitor_thread.start()

    try:
        model = YOLO(r'ultralytics/cfg/models/11/yolo11.yaml')
        model.load(r'yolo11n.pt')

        total_epochs = 100

        log_dir = os.path.join('runs', 'log', process_id)
        os.makedirs(log_dir, exist_ok=True)
        log_file_path = os.path.join(log_dir, 'training_log.txt')

        print("开始训练...")

        with open(log_file_path, 'a') as log_file:
            log_file.write("Training started...\n")

            device = 'cuda' if torch.cuda.is_available() else 'cpu'

            print(f"Using device: {device}")

            try:
                print("开始训练...。。。")
                model.train(
                    data=data_path,
                    imgsz=640,
                    epochs=total_epochs,
                    batch=16,
                    close_mosaic=10,
                    workers=0,
                    device=device,
                    optimizer='SGD',
                    project='runs/train',
                    name=process_id,
                )
                log_file.write("训练成功完成。\n")
            except Exception as e:
                log_file.write(f"训练过程中出现错误: {e}\n")
            finally:
                log_file.write("训练过程正在结束...\n")
    finally:
        # 设置停止事件，通知监控线程退出
        stop_event.set()
        monitor_thread.join()  # 等待监控线程安全结束
        print("训练完成，发送训练信息")
        send_to_rabbitmq(train_id, process_id, 100, 2, 0)
        print("训练完成，发送训练信息，信息发送完成")