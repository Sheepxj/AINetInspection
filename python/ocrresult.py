import os
import json
import requests
from tqdm import tqdm

# 配置项
CROP_IMG_DIR = "crop_img"
OCR_URL = "http://192.168.71.126:8385/imgocr"
LABEL_FILE = "Label.txt"
REC_GT_FILE = "rec_gt.txt"

# 加载 Label.txt 为字典 {无 gas/ 的文件名: [标注列表]}
def load_label_dict(path):
    label_dict = {}
    with open(path, "r", encoding="utf-8") as f:
        for line in f:
            full_img_path, anns = line.strip().split("\t", 1)
            img_file = os.path.basename(full_img_path)  # 去掉 gas/
            label_dict[img_file] = json.loads(anns)
    return label_dict

# 写回 Label.txt
def write_label_dict(path, label_dict):
    with open(path, "w", encoding="utf-8") as f:
        for img_file, anns in label_dict.items():
            full_path = f"gas/{img_file}"
            f.write(f"{full_path}\t{json.dumps(anns, ensure_ascii=False)}\n")

# OCR请求
def ocr_image(image_path):
    with open(image_path, "rb") as f:
        files = {'file': f}
        try:
            response = requests.post(OCR_URL, files=files, timeout=10)
            result = response.json()
            if result["result"]:
                return result["result"][0][1]  # 返回文本
        except Exception as e:
            print(f"OCR失败: {image_path}, 错误: {e}")
    return "TEMPORARY"

def main():
    label_dict = load_label_dict(LABEL_FILE)
    new_rec_lines = []

    with open(REC_GT_FILE, "r", encoding="utf-8") as f:
        rec_lines = f.readlines()

    for line in tqdm(rec_lines, desc="处理 OCR"):
        crop_path, _ = line.strip().split("\t", 1)
        crop_filename = os.path.basename(crop_path)
        crop_full_path = os.path.join(CROP_IMG_DIR, crop_filename)

        if not os.path.exists(crop_full_path):
            print(f"文件不存在: {crop_full_path}")
            new_rec_lines.append(line.strip())
            continue

        # OCR识别
        text = ocr_image(crop_full_path)
        new_rec_lines.append(f"{crop_path}\t{text}")

        # 提取原图名和 index
        try:
            origin_name, crop_index = crop_filename.rsplit("_crop_", 1)
            crop_index = int(crop_index.split(".")[0])
            origin_img_name = f"{origin_name}.jpg"  # 例：20250211073410895_wzp.jpg
        except Exception as e:
            print(f"文件名解析失败: {crop_filename}, 错误: {e}")
            continue

        # 更新 Label.txt 中对应目标的 transcription
        if origin_img_name in label_dict:
            if crop_index < len(label_dict[origin_img_name]):
                label_dict[origin_img_name][crop_index]["transcription"] = text
            else:
                print(f"{crop_filename} 索引超出范围")
        else:
            print(f"{origin_img_name} 不在 Label.txt 中")

    # 写回新 rec_gt.txt
    with open(REC_GT_FILE, "w", encoding="utf-8") as f:
        f.write("\n".join(new_rec_lines) + "\n")

    # 写回新 Label.txt
    write_label_dict(LABEL_FILE, label_dict)

    print("✅ 所有 OCR 结果已更新至 rec_gt.txt 和 Label.txt")

if __name__ == "__main__":
    main()
