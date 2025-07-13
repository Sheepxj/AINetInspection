import time

import cv2
import os

from minio import S3Error

from util.uploader import initialize_minio_client

BASE_DIR = os.getcwd()
BUCKET_NAME = "camera-covers"
OUTPUT_DIR = os.path.join(BASE_DIR, 'output_img')

# 初始化 MinIO 客户端
minio_client = initialize_minio_client()

# 确保输出目录存在
if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

def get_stream_information(video_path, CameraId):
    local_frame_path = None  # 初始化变量
    cap = None  # 确保 cap 被定义
    try:
        # 尝试打开视频流
        cap = cv2.VideoCapture(video_path)
        if not cap.isOpened():
            print("打开流失败")
        # 获取视频属性
        width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
        height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
        fps = cap.get(cv2.CAP_PROP_FPS)
        aspect_ratio = width / height if height != 0 else None
        fourcc = int(cap.get(cv2.CAP_PROP_FOURCC))  # 获取编码格式
        codec = chr(fourcc & 0xFF) + chr((fourcc >> 8) & 0xFF) + chr((fourcc >> 16) & 0xFF) + chr((fourcc >> 24) & 0xFF)
        # # 读取一帧
        # ret, frame = cap.read()
        # if not ret:
        #     print("读取帧失败")
        # # 保存截取的帧为图片
        # frame_filename = f"{CameraId+get_timestamp_string()}.jpg"
        # local_frame_path = os.path.join(OUTPUT_DIR, frame_filename)
        # cv2.imwrite(local_frame_path, frame)
        #
        # # 上传到 MinIO
        # minio_client.fput_object(BUCKET_NAME, frame_filename, local_frame_path)

        # 构造成功返回的 JSON 数据
        result = {
            "success": True,
            "width": width,
            "height": height,
            "fps": fps,
            "aspect_ratio": aspect_ratio,
            "codec": codec,
            # "frame_path": "/"+BUCKET_NAME+"/"+frame_filename
        }
        return result

    except S3Error as e:
        # 捕获 MinIO 上传错误
        return {
            "success": False,
            "error": f"MinIO error: {e}"
        }


    except Exception as e:
        # 捕获其他未知错误
        return {
            "success": False,
            "error": f"Unexpected error: {e}"
        }

    finally:
        # 清理资源和临时文件
        if cap is not None:
            cap.release()
        if local_frame_path and os.path.exists(local_frame_path):
            os.remove(local_frame_path)

def get_stream_codec(video_path):
    local_frame_path = None  # 初始化变量
    cap = None  # 确保 cap 被定义
    try:
        # 尝试打开视频流
        cap = cv2.VideoCapture(video_path)
        if not cap.isOpened():
            print("Error opening video stream")
        fourcc = int(cap.get(cv2.CAP_PROP_FOURCC))  # 获取编码格式
        codec = chr(fourcc & 0xFF) + chr((fourcc >> 8) & 0xFF) + chr((fourcc >> 16) & 0xFF) + chr((fourcc >> 24) & 0xFF)

        # 构造成功返回的 JSON 数据
        result = {
            "success": True,
            "codec": codec,
        }
        return result

    except S3Error as e:
        # 捕获 MinIO 上传错误
        return {
            "success": False,
            "error": f"MinIO error: {e}"
        }


    except Exception as e:
        # 捕获其他未知错误
        return {
            "success": False,
            "error": f"Unexpected error: {e}"
        }

def get_timestamp_string():
    return str(int(time.time()))