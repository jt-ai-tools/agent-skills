#!/bin/bash
find . -type f \( -name "*.md" -o -name "*.mdx" \) ! -name "PROGRESS.md" ! -name "*_zh_TW.md" ! -name "*_zh_TW.mdx" | sort
