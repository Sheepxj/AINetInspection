from flask import Flask
from HTTP_api.routes import setup_routes
import torch.multiprocessing as mp
# from multiprocessing import Process
# from SQL.auto_task import autoTask

# 将多进程相关代码放到 main 块中
app = Flask(__name__)
setup_routes(app)


if __name__ == '__main__':
    # 设置多进程启动方法为 spawn，以避免 Windows 平台下的挂起问题
    mp.set_start_method('spawn', force=True)
    # task_process = Process(target=autoTask)
    # task_process.start()
    # 启动 Flask 服务
    app.run(host='0.0.0.0', port=5050)


# import threading
# import time
# import logging
# import schedule
# from flask import Flask
# from HTTP_api.routes import setup_routes
# import torch.multiprocessing as mp
# from videoRegister.regiester import register_node, scheduled_register_node
# from util.yamlConfig import read_config, read_config_port
#
# # 设置多进程启动方法为 spawn，以避免 Windows 平台下的挂起问题
# mp.set_start_method('spawn', force=True)
#
# def create_app():
#     app = Flask(__name__)
#     setup_routes(app)
#     return app
#
# def run_scheduler(pyid):
#     while True:
#         schedule.run_pending()
#         time.sleep(1)
#
# if __name__ == '__main__':
#     config = read_config()
#     local_config = config['server']
#     LOCAL_PORT = local_config['port']
#     LOCAL_NAME = local_config['name']
#
#     try:
#         register_node(LOCAL_PORT, LOCAL_NAME)
#         pyid = read_config_port()
#         scheduled_register_node(pyid)
#         # 设置定时任务，每分钟执行一次
#         schedule.every(1).minutes.do(scheduled_register_node, pyid)
#
#         # 启动调度线程
#         scheduler_thread = threading.Thread(target=run_scheduler, args=(pyid,), daemon=True)
#         scheduler_thread.start()
#         logging.info("定时任务启动成功")
#
#     except Exception as e:
#         logging.error(f"节点注册失败: {e}")
#         exit(1)  # 退出程序
#
#     app = create_app()
#     try:
#         # 启动 Flask 服务
#         app.run(host='0.0.0.0', port=LOCAL_PORT, debug=False)
#     except Exception as e:
#         print(f"启动 Flask 服务失败: {e}")
