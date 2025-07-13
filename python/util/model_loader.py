import cv2
import torch

from ultralytics import YOLO

def load_models(labels):
    models = []
    result_labels = []
    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    imgsz = 640  # 图像尺寸

    for label in labels:
        result_labels.append(label)

    # 加载模型
    model = YOLO("yolov8s-world.pt")
    # 设置检测类别（可选，确保只检测感兴趣类别）
    model.set_classes(result_labels)
    models.append(model)

    return models, device, imgsz

def load_truck_models(model_path):
    # 检查 CUDA 是否可用
    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    # 加载 YOLO 模型
    model = YOLO(model_path)
    # 将模型移动到相应的设备
    model.to(device)

    return model


def prepare_image(frame, imgsz, device):
    return frame

def detect_objects(model, img):
    results = model.predict(img, verbose=False)  # 禁用输出日志
    return results


