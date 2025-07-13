from HTTP_api.thread_manager import get_thread_status, start_thread, start_frame_thread
from SQL.mysqlCinfig import select_tasks, select_camera, select_models, update_task
import logging

from ZLM.zlmConfig import extract_parts_from_url


def autoTask():
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    logging.info("自动任务开始")
    tasks = select_tasks()
    for task in tasks:
        logging.info(f"检测到任务 {task[1]},正在启动")
        taskstatus=(get_thread_status(task[17]))
        if taskstatus.get("status")=="notfound":
            camera=select_camera(task[4])


            width = camera[0][4]

            height = camera[0][5]

            camerafps = camera[0][7]

            fps = 0

            if task[23] != None :
                fps = camerafps*task[23]
            box = transform_coordinates(task[20], width,height);

            url = []
            url.append(camera[0][14])

            zlm_url=extract_parts_from_url(camera[0][18])


            models = select_models(task[18])
            model_paths=[]
            for model in models:
                model_paths.append(model[1]+"/"+model[3])

            type = task[19]
            if type == 1:
                name = start_thread(url, model_paths, task[1])
                if name == None:
                    logging.info(f"启动失败，线程名为{name}")
                if update_task(task[0], name) :
                    logging.info(f"启动成功，线程名为{name}")

            if type > 1:
                name = start_frame_thread(url, zlm_url,model_paths, task[1], box,type, fps,task[22])
                if name == None:
                    logging.info(f"启动失败，线程名为{name}")
                if update_task(task[0], name):
                    logging.info(f"启动成功，线程名为{name}")


def transform_coordinates(data_str, width, height):
    # 去掉字符串的外部括号并分割成矩形框的字符串数组
    data_str = data_str.replace("[[", "").replace("]]", "")
    rectangles = data_str.split("],[")

    # 用于存储结果
    transformed_rectangles = []

    # 遍历每个矩形框
    for rect in rectangles:
        # 分割矩形框的坐标并去掉多余的引号
        values = rect.split(",")
        x1 = float(values[0].replace("\"", "")) * width
        y1 = float(values[1].replace("\"", "")) * height
        x2 = float(values[2].replace("\"", "")) * width
        y2 = float(values[3].replace("\"", "")) * height

        # 将坐标转换为列表并添加到结果列表
        transformed_rectangles.append([round(x1, 1), round(y1, 1), round(x2, 1), round(y2, 1)])

    # 返回嵌套列表
    return transformed_rectangles
