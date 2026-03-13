#!/bin/bash
# List all .md or .mdx files that do not have a corresponding _zh_TW version
find . -type f \( -name "*.md" -o -name "*.mdx" \) ! -name "PROGRESS.md" ! -name "*_zh_TW.md" ! -name "*_zh_TW.mdx" | sort | while read file; do
    base="${file%.*}"
    ext="${file##*.}"
    if [ ! -f "${base}_zh_TW.${ext}" ]; then
        echo "$file"
    fi
done
