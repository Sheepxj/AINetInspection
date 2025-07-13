import logging
import os
import signal
import threading
import random
import string
import time
from multiprocessing import Process


from util.yamlConfig import read_config
from video_processor import process_video_stream,process_video_frame_stream


#
# 设置日志基本配置
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
threads = {}
thread_data = {}
training_processes ={}


def generate_random_name():
    return ''.join(random.choices(string.ascii_letters + string.digits, k=8))

def generate_random_process_id():
    return str(int(time.time() * 1000))


def start_thread(rtsp_urls, labels, taskId):
    name = generate_random_name()
    stop_event = threading.Event()
    thread = threading.Thread(target=process_video_stream, args=(name, rtsp_urls, labels, stop_event, taskId))
    threads[name] = {"thread": thread, "stop_event": stop_event}
    thread_data[name] = {"rtsp_urls": rtsp_urls, "model_paths": labels}
    thread.start()
    return name

def start_frame_thread(rtsp_url, zlm_url,labels, taskId, frame_boxs, frame_select, interval_time, frame_interval):
    name = generate_random_name()
    stop_event = threading.Event()  # 创建停止事件
    thread = threading.Thread(
        target=process_video_frame_stream,
        args=( rtsp_url, zlm_url, labels, stop_event, taskId, frame_boxs, frame_select, interval_time, frame_interval)
    )
    threads[name] = {"thread": thread, "stop_event": stop_event}
    thread_data[name] = {"rtsp_urls": rtsp_url, "labels": labels}
    thread.start()  # 启动线程
    return name  # 返回线程名称


def stop_thread(name):
    if name in threads:
        thread_info = threads[name]
        stop_event = thread_info["stop_event"]
        stop_event.set()
        thread_info["thread"].join()
        threads.pop(name)
        thread_data.pop(name)
        return True
    else:
        return False

def get_thread_status(thread_name):
    """
    获取线程任务的状态
    :param thread_name: 线程名称
    :return: 线程状态信息
    """
    if thread_name in threads:
        thread_info = threads[thread_name]
        thread = thread_info["thread"]
        stop_event = thread_info["stop_event"]
        if thread.is_alive():
            return {
                "identifier": thread_name,
                "type": "thread",
                "status": "running",
                "details": {
                    "name": thread_name,
                    "rtsp_urls": thread_data.get(thread_name, {}).get("rtsp_urls"),
                    "model_paths": thread_data.get(thread_name, {}).get("model_paths")
                }
            }
        else:
            return {
                "identifier": thread_name,
                "type": "thread",
                "status": "stopped",
                "details": {
                    "name": thread_name,
                    "rtsp_urls": thread_data.get(thread_name, {}).get("rtsp_urls"),
                    "model_paths": thread_data.get(thread_name, {}).get("model_paths")
                }
            }
    else:
        return {
            "identifier": thread_name,
            "status": "notfound"
        }

def get_training_process_status(process_id):
    """
    获取训练任务的状态
    :param process_id: 训练进程 ID
    :return: 训练任务状态信息
    """
    if process_id in training_processes:
        process_info = training_processes[process_id]
        pid = process_info['pid']
        try:
            # 尝试发送信号 0 来检查进程是否存在
            os.kill(pid, 0)
            return {
                "identifier": process_id,
                "type": "training_process",
                "status": "running",
                "details": {
                    "pid": pid
                }
            }
        except OSError:
            return {
                "identifier": process_id,
                "type": "training_process",
                "status": "stopped",
                "details": {
                    "pid": pid
                }
            }
    else:
        return {
            "identifier": process_id,
            "status": "notfound"
        }