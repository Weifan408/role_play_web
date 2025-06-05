#!/bin/bash

# 设置要处理的目录
INPUT_DIR="$1"

# 检查是否提供目录路径
if [ -z "$INPUT_DIR" ]; then
    echo "请提供包含 .webm 文件的目录路径。"
    echo "使用方法: $0 /path/to/directory"
    exit 1
fi

# 遍历所有 .webm 文件，并转换为 .gif
find "$INPUT_DIR" -type f \( -iname "*.webm" \) -print0 | while IFS= read -r -d '' webm_file; do
    # 获取文件的路径和文件名，不包括扩展名
    dir_path=$(dirname "$webm_file")
    base_name=$(basename "$webm_file" .webm)

    # 设置输出 .gif 文件路径
    gif_file="${dir_path}/${base_name}.gif"

    # 转换 .webm 为 .gif
    ffmpeg -i "$webm_file" -vf "fps=15,scale=224:-1:flags=lanczos" -c:v gif "$gif_file"

    echo "已转换: $webm_file -> $gif_file"
done

echo "所有 .webm 文件已转换为 .gif。"