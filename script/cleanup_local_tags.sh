#!/bin/bash

# 获取所有本地标签和主分支的名称
local_tags=$(git tag)
main_branch="main"  # 如果你的主分支名称不是 main，请相应地修改

# 遍历每个本地标签
for tag_name in $local_tags; do
    # 检查标签所指向的提交是否在主分支上
    if git branch --contains "$tag_name" | grep -q "$main_branch"; then
        echo "Local tag '$tag_name' points to the main branch. Skipping."
    else
        echo "Local tag '$tag_name' does not point to the main branch. Deleting..."
        git tag -d "$tag_name"
        echo "Local tag '$tag_name' deleted."
    fi
done
