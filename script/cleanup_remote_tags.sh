#!/bin/bash

# 可能要执行多次，原因不明，有些tag调了删除还在，

# 获取所有远程标签和主分支的名称
remote_tags=$(git ls-remote --tags origin)
main_branch="main"  # 如果你的主分支名称不是 main，请相应地修改

# 遍历每个标签
while read -r line; do
    # 解析标签信息
    tag_hash=$(echo "$line" | awk '{print $1}')
    tag_name=$(echo "$line" | awk '{print $2}')

    # 检查标签所指向的提交是否在主分支上
    if git branch --contains "$tag_hash" | grep -q "$main_branch"; then
        echo "Tag '$tag_name' points to the main branch. Skipping."
    else
        echo "Tag '$tag_name' does not point to the main branch. Deleting..."
        git push --delete origin "$tag_name"
        echo "Tag '$tag_name' deleted."
    fi
done <<< "$remote_tags"
