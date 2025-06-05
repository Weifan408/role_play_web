#!/bin/bash

# 配置变量
REMOTE_ALIAS="PC"
env_name=$1
FILENAME_PATTERN=$2  # 要搜索的文件名模式
first_part=$(echo "$FILENAME_PATTERN" | cut -d'_' -f1)
REMOTE_PATH="~/tmp/role_play/results/baseline_eval/final/${first_part}/${env_name}"      # 远程主机上的搜索目录
LOCAL_PATH="/Users/fanelong/tmp/role_play.github.io/static/images/meltingpot/cleanup/inequity"        # 本地保存文件的目录


# 创建一个临时文件来保存文件列表
FILELIST=$(mktemp)

# 远程主机上搜索文件，并将结果保存到本地临时文件中
echo "正在从远程主机搜索文件..."
ssh ${REMOTE_ALIAS} "find ${REMOTE_PATH} -name '${FILENAME_PATTERN}'" > ${FILELIST}

# 检查是否找到文件
if [[ ! -s ${FILELIST} ]]; then
    echo "未找到符合条件的文件。"
    rm ${FILELIST}
    exit 1
fi

# 逐行读取文件列表并传输文件到本地
echo "开始传输文件到本地..."
while read -r REMOTE_FILE; do
    scp ${REMOTE_ALIAS}:"${REMOTE_FILE}" ${LOCAL_PATH}/
done < ${FILELIST}

# 清理临时文件
rm ${FILELIST}

echo "文件传输完成。"