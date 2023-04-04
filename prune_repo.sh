#!/bin/bash
set -e

analize_disk_usage () {
  local repo_description=$1
  echo "$repo_description size:"
  echo -e "\033[31m$(du -sh .)\033[0m"
  echo "10 biggest items:"
  echo -e  "\033[32m$(find . -type f -exec du -a --block-size=1M {} + | sort -n -r | head -n 10)\033[0m"
}

cd /repo

analize_disk_usage "Original repo"

# ===== Emulate a shallow clone =====

git clone --depth 1 --branch main "file:///repo" /cloned_repo
cd /cloned_repo

analize_disk_usage "Original repo shallow clone"

cd /repo
rm -rf /cloned_repo

# ===== Prune =====

# Specify the list of file extensions to be removed
file_extensions="$1"

# Remove files with the specified file extensions from the repository history
for ext in $file_extensions; do
  git filter-repo --force --invert-paths --path-glob="*.$ext"
done

# Run garbage collection to clean up the repository
git reflog expire --expire=now --all
git gc --prune=now --aggressive

analize_disk_usage "Pruned repo"

# ===== Emulate a shallow clone =====

git clone --depth 1 --branch main "file:///repo" /cloned_repo
cd /cloned_repo

analize_disk_usage "Pruned repo shallow clone"
