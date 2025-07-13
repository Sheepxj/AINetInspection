import cv2

from ultralytics import YOLO

from ultralytics import YOLO

def get_img_msg(imgpath, labels):
    result_labels = [labels]

    # 加载模型
    model = YOLO("yolov8s-world.pt")

    # 设置检测类别（可选，确保只检测感兴趣类别）
    model.set_classes(result_labels)

    # 推理
    results = model.predict(
        source=imgpath,
        save=False,
        show=False
    )

    outputs = []

    for result in results:
        boxes = result.boxes
        names = result.names
        img_w, img_h = result.orig_shape[1], result.orig_shape[0]

        if boxes is None:
            continue

        for box in boxes:
            cls_id = int(box.cls[0])  # 类别ID
            class_name = names[cls_id]  # 类别名
            conf = float(box.conf[0])  # 置信度
            xyxy = box.xyxy[0].tolist()  # 左上角xy，右下角xy
            x1, y1, x2, y2 = xyxy

            x_center = (x1 + x2) / 2 / img_w
            y_center = (y1 + y2) / 2 / img_h
            width = (x2 - x1) / img_w
            height = (y2 - y1) / img_h

            formatted = f"{class_name},{x_center:.6f},{y_center:.6f},{width:.6f},{height:.6f},{conf:.2f}"
            outputs.append(formatted)

    return outputs

