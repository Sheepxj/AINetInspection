from flask import request, jsonify
from HTTP_api.thread_manager import start_thread, stop_thread,start_frame_thread
from VideoMsg.GetVideoMsg import get_stream_information, get_stream_codec
from file_handler import upload_file, tosend_file, upload_models, upload_image, delete_image
from util.getmsg import get_img_msg
import logging

logging.basicConfig(level=logging.INFO)
def setup_routes(app):

    @app.route('/start_stream', methods=['POST'])
    def start_stream():
        data = request.get_json()
        rtsp_url = data.get('rtsp_urls')
        zlm_url = data.get('zlm_url')
        labels = data.get('labels')
        task_id = data.get('task_id')
        frame_select = data.get('frame_select')
        frame_boxs = data.get('frame_boxs')
        interval_time=data.get('interval_time')
        frame_interval=data.get('frame_interval')

        if frame_select == 1:
            if not rtsp_url or not labels:
                return jsonify({"error": "rtsp_urls和model_paths是必需的"}), 400
            name = start_thread(rtsp_url, labels, task_id)
        elif frame_select > 1:
            if not rtsp_url or not labels:
                return jsonify({"error": "rtsp_urls和model_paths是必需的"}), 400
            name = start_frame_thread(rtsp_url,zlm_url,labels, task_id, frame_boxs,frame_select,interval_time,frame_interval)

        return jsonify({"thread_name": name})



    @app.route('/stop_stream/', methods=['POST'])
    def stop_stream():
        data = request.get_json()
        name = data.get('name')
        result = stop_thread(name)
        if result:
            return jsonify({"status": "已停止"}), 200
        else:
            return jsonify({"error": "线程未找到或未运行"}), 404


    @app.route('/upload', methods=['POST'])
    def upload_file_endpoint():
        return upload_file(request)

    @app.route('/get-file', methods=['POST'])
    def get_file():
        return tosend_file(request)

    @app.route('/up-model', methods=['POST'])
    def up_model():
        return upload_models(request)

    @app.route('/get-imgmsg', methods=['POST'])
    def get_imgmsg():
        imgpath=upload_image(request)
        if not imgpath:
            return jsonify({"error": "未找到图片"}), 404
        labels = request.form.get('labels')

        result = get_img_msg(imgpath,labels)
        delete_image(imgpath)
        return jsonify(result),200

    @app.route('/delete-file', methods=['POST'])
    def delete_file():

        file_path = request.json.get('modelPath')
        result=delete_image(file_path)
        if result:
            return jsonify({"message": "文件已删除"}), 200
        return jsonify({"error": "文件未找到"}), 404

    @app.route('/process_video', methods=['POST'])
    def process_video():
        try:
            # 获取请求数据
            data = request.get_json()

            # 验证输入
            video_stream = data.get('video_stream')  # 视频文件路径
            camera_id = data.get('camera_id')  # 摄像头 ID

            if not video_stream or not camera_id:
                logging.error("输入无效：缺少“video_stream”或“camera_id”")
                return jsonify({"success": False, "error": "“video_stream”和“camera_id”都是必需的。"}), 400

            # 调用视频解析方法
            result = get_stream_information(video_stream, camera_id)

            if result is None or not result.get('success'):
                logging.error(f"无法处理摄像机的视频流: {camera_id}. Error: {result.get('error')}")
                return jsonify({"success": False, "error": "Unable to process video stream."}), 500

            # 返回成功结果
            return jsonify(result), 200

        except Exception as e:
            # 捕获任何异常并记录
            logging.error(f"Unexpected error: {str(e)}")
            return jsonify({"success": False, "error": "An unexpected error occurred."}), 500

    @app.route('/process_video_codec', methods=['POST'])
    def process_video_codec():
        try:
            # 获取请求数据
            data = request.get_json()

            # 验证输入
            video_stream = data.get('video_stream')  # 视频文件路径

            if not video_stream:
                logging.error("输入无效：缺少“video_stream”或“camera_id”")
                return jsonify({"success": False, "error": "“video_stream”是必需的。"}), 400

            # 调用视频解析方法
            result = get_stream_codec(video_stream)

            if result is None or not result.get('success'):
                logging.error(f"无法处理摄像机的视频流:Error: {result.get('error')}")
                return jsonify({"success": False, "error": "Unable to process video stream."}), 500

            # 返回成功结果
            return jsonify(result), 200

        except Exception as e:
            # 捕获任何异常并记录
            logging.error(f"Unexpected error: {str(e)}")
            return jsonify({"success": False, "error": "An unexpected error occurred."}), 500