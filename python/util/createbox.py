from random import random
import numpy as np
import cv2
from PIL import Image, ImageDraw, ImageFont


def plot_one_box(x, img, label=None, color=None, line_thickness=None):
    # 画框和标签的线条粗细
    tl = line_thickness or round(0.002 * (img.shape[0] + img.shape[1]) / 2) + 1  # 线条粗细
    color = color or [random() * 255 for _ in range(3)]

    # 计算框的坐标
    c1, c2 = (int(x[0]), int(x[1])), (int(x[2]), int(x[3]))

    # 用OpenCV绘制矩形框
    cv2.rectangle(img, c1, c2, color, thickness=tl, lineType=cv2.LINE_AA)

    # 如果有标签，需要处理中文或其他字符
    if label:
        tf = max(tl - 1, 1)  # 字体厚度
        # 使用PIL创建一个图片来绘制文本
        pil_img = Image.fromarray(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
        draw = ImageDraw.Draw(pil_img)

        # 加载字体，使用支持中文的字体文件
        font = ImageFont.truetype('Fonts/SimHei.ttf', size=tl * 3)

        # 使用textbbox来获取文本的宽度和高度
        bbox = draw.textbbox((0, 0), label, font=font)
        text_width, text_height = bbox[2] - bbox[0], bbox[3] - bbox[1]

        # 设置文本位置为框的左上角
        text_x = c1[0]  # 文本左对齐
        text_y = c1[1]  # 文本顶部对齐

        # 在图片上绘制背景框，背景框颜色与文本对比明显
        draw.rectangle([text_x, text_y, text_x + text_width, text_y + text_height], fill=(0, 0, 0))  # 黑色背景框

        # 在图片上绘制文本，白色字体
        draw.text((text_x, text_y), label, font=font, fill=(255, 255, 255), stroke_width=tf)

        # 转换回OpenCV格式
        img = cv2.cvtColor(np.array(pil_img), cv2.COLOR_RGB2BGR)

    return img

def plot_frame_box(xyxy, frame, label=None, color=(255,0,0), line_thickness=2):
    """
    在帧上绘制矩形框。
    """
    x_min, y_min, x_max, y_max = map(int, xyxy)
    cv2.rectangle(frame, (x_min, y_min), (x_max, y_max), color, thickness=line_thickness)
    if label:
        font_thickness = max(line_thickness - 1, 1)
        t_size = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.5, font_thickness)[0]
        label_y_min = max(y_min, t_size[1] + 10)
        cv2.rectangle(frame, (x_min, y_min - t_size[1] - 10), (x_min + t_size[0], y_min), color, -1)
        cv2.putText(frame, label, (x_min, label_y_min - 7), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), font_thickness)


