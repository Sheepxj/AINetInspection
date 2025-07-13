import json
import os
import re
import requests  # 导入标准的 requests 模块
from util.yamlConfig import read_config

config = read_config()
sql_config = config['zlm']

ZLM_HOST = os.getenv('ZLM_HOST', sql_config['host'])
ZLM_PORT = os.getenv('ZLM_PORT', sql_config['port'])
ZLM_SECRET = os.getenv('ZLM_SECRET', sql_config['secret'])

def get_video_status(videourl):
    # 构造请求URL
    url = f"http://{ZLM_HOST}:{ZLM_PORT}/index/api/isMediaOnline"
    zlm_app, zlm_stream = extract_parts_from_url(videourl)
    if zlm_app is None or zlm_stream is None:
        print("无法从 URL 中提取所需的部分，请检查 URL 格式是否正确。")
        return False

    # 设置请求头
    headers = {
        "Content-Type": "application/json"
    }

    # 设置请求体
    data = {
        "secret": ZLM_SECRET,
        "schema": "ts",
        "vhost": f"{ZLM_HOST}:{ZLM_PORT}",
        "app": zlm_app,
        "stream": zlm_stream
    }

    # 发送POST请求
    try:
        response = requests.post(url, headers=headers, data=json.dumps(data))
        # 检查响应状态码
        if response.status_code == 200:
            response_json = response.json()
            if response_json.get("code") == 0:
                return response_json.get("online", False)
    except Exception as e:
        print(f"请求失败，错误信息：{e}")

    return False


def get_video(videourl,cameraurl):
    # 构造请求 URL
    url = f"http://{ZLM_HOST}:{ZLM_PORT}/index/api/addStreamProxy"

    zlm_app, zlm_stream = extract_parts_from_url(videourl)

    # 创建请求头
    headers = {
        "Content-Type": "application/json"
    }

    # 设置请求体
    data = {
        "secret": ZLM_SECRET,
        "vhost": f"{ZLM_HOST}:{ZLM_PORT}",
        "app": zlm_app,
        "url": cameraurl,
        "stream": zlm_stream
    }

    # 添加固定配置
    data = set_fixed_config(data)

    # 发送 POST 请求
    response = requests.post(url, headers=headers, data=json.dumps(data))

    # 解析响应
    if response.status_code == 200:
        response_json = response.json()
        if response_json.get("code") == 0:
            # 构造视频 URL
            video_url = f"http://{ZLM_HOST}:{ZLM_PORT}/{zlm_app}/{zlm_stream}.live.ts"
            print(f"视频 URL：{video_url}")
            return True

    return False


def extract_parts_from_url(url):
    # 使用正则表达式匹配 URL 中的特定部分
    pattern = r"http://[^/]+/([^/]+)/([^/.]+)"
    match = re.search(pattern, url)
    if match:
        part1 = match.group(1)
        part2 = match.group(2)
        return part1, part2
    else:
        return None, None
def set_fixed_config(json_data):
    # 添加固定的配置项
    json_data["retry_count"] = -1
    json_data["rtp_type"] = 0
    json_data["timeout_sec"] = 5
    json_data["mp4_max_second"] = 10
    json_data["enable_ts"] = True
    json_data["auto_close"] = True
    json_data["enable_hls"] = False
    json_data["enable_hls_fmp4"] = False
    json_data["enable_mp4"] = False
    json_data["enable_rtsp"] = False
    json_data["enable_rtmp"] = False
    json_data["enable_fmp4"] = False
    json_data["hls_demand"] = False
    json_data["rtsp_demand"] = False
    json_data["rtmp_demand"] = False
    json_data["ts_demand"] = False
    json_data["fmp4_demand"] = False
    json_data["enable_audio"] = False
    json_data["add_mute_audio"] = False
    json_data["mp4_as_player"] = False

    return json_data