import logging
import os
import mysql.connector
from mysql.connector import pooling
from util.yamlConfig import read_config

# 读取配置
config = read_config()
sql_config = config['mysql']

# 环境变量优先，其次使用配置文件
SQL_HOST = os.getenv('SQL_HOST', sql_config['host'])
SQL_PORT = int(os.getenv('SQL_PORT', sql_config['port']))
SQL_ACCESS_KEY = os.getenv('SQL_ACCESS_KEY', sql_config['username'])
SQL_SECRET_KEY = os.getenv('SQL_SECRET_KEY', sql_config['password'])
SQL_DATABASE = os.getenv('SQL_DATABASE', sql_config['database'])

# 创建连接池
db_pool = pooling.MySQLConnectionPool(
    pool_name="my_pool",
    pool_size=5,
    host=SQL_HOST,
    port=SQL_PORT,
    user=SQL_ACCESS_KEY,
    password=SQL_SECRET_KEY,
    database=SQL_DATABASE
)

# 获取数据库连接
def get_db_connection():
    try:
        return db_pool.get_connection()
    except mysql.connector.Error as e:
        logging.error(f"获取数据库连接失败: {e}")
        return None

# 更新任务状态
def update_task_status(taskid):
    conn = get_db_connection()
    if not conn:
        return False
    try:
        with conn.cursor() as cursor:
            cursor.execute("UPDATE detection_task SET status = 0 WHERE task_id = %s", (taskid,))
            conn.commit()
            return cursor.rowcount > 0
    except mysql.connector.Error as e:
        logging.error(f"数据库更新失败: {e}")
        return False
    finally:
        conn.close()

# 查询任务列表
def select_tasks():
    conn = get_db_connection()
    if not conn:
        return None
    try:
        with conn.cursor(dictionary=True) as cursor:
            cursor.execute("SELECT * FROM detection_task WHERE status = %s", (1,))
            return cursor.fetchall()
    except mysql.connector.Error as e:
        logging.error(f"数据库查询失败: {e}")
        return None
    finally:
        conn.close()

# 查询摄像头信息
def select_camera(cameraId):
    conn = get_db_connection()
    if not conn:
        return None
    try:
        with conn.cursor(dictionary=True) as cursor:
            cursor.execute("SELECT * FROM ai_camera WHERE id = %s", (cameraId,))
            return cursor.fetchall() or []
    except mysql.connector.Error as e:
        logging.error(f"数据库查询失败: {e}")
        return None
    finally:
        conn.close()

# 查询多个模型
def select_models(ids):
    if not ids:
        return []
    conn = get_db_connection()
    if not conn:
        return None
    try:
        with conn.cursor(dictionary=True) as cursor:
            placeholders = ','.join(['%s'] * len(ids))
            query = f"SELECT id, model_location, model_name, model FROM ai_model WHERE id IN ({placeholders})"
            cursor.execute(query, tuple(ids))
            return cursor.fetchall() or []
    except mysql.connector.Error as e:
        logging.error(f"数据库查询失败: {e}")
        return None
    finally:
        conn.close()

# 更新任务标记
def update_task(id, taking):
    conn = get_db_connection()
    if not conn:
        return False
    try:
        with conn.cursor() as cursor:
            cursor.execute("UPDATE detection_task SET task_tagging = %s WHERE id = %s", (taking, id))
            conn.commit()
            return cursor.rowcount > 0
    except mysql.connector.Error as e:
        logging.error(f"数据库更新失败: {e}")
        return False
    finally:
        conn.close()

# 更新视频分析结果
def update_video_analysis(id, video_status=None,video_result_path=None, video_progress=None, video_result=None):
    if id is None:
        logging.error("视频ID不能为空")
        return False

    conn = get_db_connection()
    if not conn:
        return False

    try:
        with conn.cursor() as cursor:
            fields = []
            values = []

            if video_status is not None:
                fields.append("video_status = %s")
                values.append(video_status)
            if video_result_path is not None:
                fields.append("video_result_path = %s")
                values.append(video_result_path)
            if video_progress is not None:
                fields.append("video_progress = %s")
                values.append(video_progress)
            if video_result is not None:
                fields.append("video_result = %s")
                values.append(video_result)


            if not fields:
                logging.info("没有字段需要更新")
                return True

            query = f"UPDATE video_analysis SET {', '.join(fields)} WHERE video_id = %s"
            values.append(id)

            cursor.execute(query, values)
            conn.commit()

            if cursor.rowcount == 0:
                logging.warning(f"未找到视频ID为 {id} 的记录")
                return False

            return True
    except mysql.connector.Error as e:
        logging.error(f"数据库更新失败: {e}，SQL: {query}，参数: {values}")
        conn.rollback()
        return False
    except Exception as e:
        logging.error(f"未知错误: {e}")
        return False
    finally:
        conn.close()
