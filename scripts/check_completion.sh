#!/bin/bash
FILES=$(./scripts/list_md_files.sh)
if [ -z "$FILES" ]; then
    echo "所有檔案已完成翻譯！"
    exit 0
fi

echo "以下檔案尚未翻譯："
echo "$FILES"
exit 1
