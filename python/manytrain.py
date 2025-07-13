import os
import torch
from ultralytics import YOLO


def train_yolo(data_path, log_dirs, total_epochs=100):
    model = YOLO(r'D:/PycharmProjects/aivideo/yolov11/yolo11m.pt')

    # 设置日志文件路径
    log_dir = os.path.join('runs', 'log', log_dirs)
    os.makedirs(log_dir, exist_ok=True)
    log_file_path = os.path.join(log_dir, 'training_log.txt')

    print(f"开始训练: {data_path}")

    with open(log_file_path, 'a', encoding='utf-8') as log_file:
        log_file.write(f"Training started for {data_path}...\n")

        # 修改这里：指定使用第二张GPU（索引1）
        device = 1 if torch.cuda.is_available() else 'cpu'  # 关键修改
        print(f"使用设备: {device}")

        try:
            print("开始训练...")
            model.train(
                data=data_path,
                imgsz=800,
                epochs=total_epochs,
                batch=48,
                close_mosaic=10,
                workers=0,
                device=device,  # 这里传入修改后的设备参数
                optimizer='SGD',
                project='runs/train',
                name=log_dirs,
            )
            log_file.write(f"训练成功完成 for {data_path}.\n")
        except Exception as e:
            safe_error_message = str(e).encode('utf-8', errors='replace').decode('utf-8')
            log_file.write(f"训练过程中出现错误 for {data_path}: {safe_error_message}\n")
        finally:
            log_file.write(f"训练过程结束 for {data_path}...\n")


def batch_train(data_yaml_paths):
    for data_path in data_yaml_paths:
        dataset_dir = os.path.dirname(data_path)
        dataset_name = os.path.basename(dataset_dir)
        log_dirs = os.path.join(dataset_name)
        train_yolo(data_path, log_dirs)

if __name__ == "__main__":
    data_yaml_paths = [
            "data/Protections/data.yaml"
    ]

    model_path = "yolo11m.pt"
    batch_train(data_yaml_paths)