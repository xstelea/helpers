#!/bin/bash

# Check if fzf is installed
if ! command -v fzf >/dev/null 2>&1; then
    echo "Error: fzf is not installed. Please install it first."
    exit 1
fi

# Check if current directory is a git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: Not a git repository"
    exit 1
fi

# Get all branches (both local and remote) and use fzf to select one
selected_branch=$(git branch -a | \
    grep -v HEAD | \
    sed 's/remotes\/origin\///g' | \
    sort -u | \
    fzf --height 40% --prompt="Select branch > " --preview "git log --color=always {1}")

# Exit if no branch was selected
if [ -z "$selected_branch" ]; then
    echo "No branch selected"
    exit 0
fi

# Clean up branch name (remove leading spaces/asterisk)
branch_name=$(echo "$selected_branch" | sed 's/^[* ]*//')

# Checkout the selected branch
git checkout $(echo "$branch_name" | sed 's/remotes\/origin\///g') 