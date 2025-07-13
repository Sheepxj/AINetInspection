from Crypto.Cipher import AES
from Crypto.Util.Padding import pad
from Crypto.Random import get_random_bytes
import torch

# 使用一个固定的密钥
key = b'secret_key_12345'  # 固定的密钥

# 创建一个加密对象
cipher = AES.new(key, AES.MODE_CBC)

# 读取 YOLOv 权重文件
with open('../upweights/cartype.pt', 'rb') as f:
    data = f.read()

# 对数据进行填充，使其大小符合 AES 块大小的要求
padded_data = pad(data, AES.block_size)

# 加密
ciphertext = cipher.encrypt(padded_data)

# 保存加密后的数据
with open('../crypto/cartype.pt', 'wb') as f:
    f.write(cipher.iv + ciphertext)  # 保存 IV 和密文
