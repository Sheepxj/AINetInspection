from ultralytics import YOLO

# 加载模型
model = YOLO("yolov8s-world.pt")
# 设置检测类别（可选，确保只检测感兴趣类别）
model.set_classes(["person"])

# 预测一张图片
results = model.predict(
    source="text/textimg/1.jpg",
    save=False,  # 是否在推理结束后保存结果
    show=False,  # 是否在推理结束后显示结果
    project='runs/smoken',
    conf=0.5
)