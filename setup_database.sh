#!/bin/bash
# AI视频分析系统数据库安装脚本

echo "开始创建 yys_aivideo 数据库..."

# 导入SQL文件
echo "2. 导入数据库结构和数据"
/usr/local/mysql/bin/mysql -u root -p yys_aivideo < /home/wms/stonedtaiv-master/sql/yys_aivideo.sql

if [ $? -eq 0 ]; then
    echo "✓ 数据导入成功"
else
    echo "✗ 数据导入失败"
    exit 1
fi

# 验证导入结果
echo "3. 验证导入结果"
echo "正在检查数据库表和数据..."

/usr/local/mysql/bin/mysql -u root -p -e "
USE yys_aivideo;
SELECT '表数量:' as info, COUNT(*) as count FROM information_schema.tables WHERE table_schema='yys_aivideo'
UNION ALL
SELECT 'AI模型数量:', COUNT(*) FROM ai_model
UNION ALL  
SELECT 'AI模型类型数量:', COUNT(*) FROM ai_model_type
UNION ALL
SELECT '模型方案数量:', COUNT(*) FROM model_plan
UNION ALL
SELECT '用户数量:', COUNT(*) FROM ai_user;
"

echo ""
echo "🎉 yys_aivideo 数据库安装完成！"
echo ""
echo "数据库信息："
echo "- 数据库名: yys_aivideo"
echo "- 字符集: utf8mb4"
echo "- 排序规则: utf8mb4_0900_ai_ci"
echo "- 包含表: ai_model, ai_model_type, ai_modeltotype, ai_user, ai_camera, camera_sector, detection_task, model_plan"
