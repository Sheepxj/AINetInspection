# 导入必要的库
import os
import torch

from ultralytics import YOLO


# 定义训练参数
def train_yolo():
    model = YOLO(r'ultralytics/cfg/models/11/yolo11.yaml')
    model.load(r'yolo11s.pt')

    data_path = r'data/hoseModel/data.yaml'

    total_epochs = 100

    log_dir = os.path.join('runs', 'log', "hose")
    os.makedirs(log_dir, exist_ok=True)
    log_file_path = os.path.join(log_dir, 'training_log.txt')

    print("开始训练...")

    with open(log_file_path, 'a', encoding='utf-8') as log_file:
        log_file.write("Training started...\n")

        device = 'cuda' if torch.cuda.is_available() else 'cpu'

        print(f"Using device: {device}")

        try:
            print("开始训练...。。。")
            model.train(
                data=data_path,
                imgsz=640,
                epochs=total_epochs,
                save_period=1,
                batch=12,
                close_mosaic=10,
                workers=0,
                device=device,
                optimizer='SGD',
                project='runs/train',
                name='hose',
            )
            log_file.write("训练成功完成。\n")
        except Exception as e:
            # 处理异常信息，确保不会因为非ASCII字符导致写入失败
            safe_error_message = str(e).encode('utf-8', errors='replace').decode('utf-8')
            log_file.write(f"训练过程中出现错误: {safe_error_message}\n")
        finally:
            log_file.write("训练过程正在结束...\n")

# 主函数
if __name__ == "__main__":
    # 调用训练函数
    train_yolo()

