from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad
import torch
import io

def decrypt_model(key,encrypted_model_path):
    # 加载加密后的权重文件
    with open(encrypted_model_path, 'rb') as f:
        iv = f.read(16)  # 读取 IV
        ciphertext = f.read()  # 读取密文

    # 创建解密对象
    cipher = AES.new(key, AES.MODE_CBC, iv)

    # 解密数据并去除填充
    decrypted_data = unpad(cipher.decrypt(ciphertext), AES.block_size)

    # 使用 io.BytesIO 将解密后的数据加载到内存中
    decrypted_model = io.BytesIO(decrypted_data)

    # 在内存中加载模型（解密后的文件内容）
    model = torch.load(decrypted_model)

    return model