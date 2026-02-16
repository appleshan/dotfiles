#!/bin/bash

echo "🚀 Code is cheap, show me your talk (spec).";

# 定义文件名变量
FILE="PROJECT_INDEX.json"

# 判断当前目录下是否存在该文件
if [ -f "$FILE" ]; then
    #echo "检测到 $FILE，正在执行格式化..."
    codebase-map format
else
    #echo "未找到 $FILE，正在初始化扫描..."
    codebase-map scan
fi
