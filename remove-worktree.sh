#!/bin/bash

# Check if fzf is installed
if ! command -v fzf >/dev/null 2>&1; then
    echo "Error: fzf is not installed. Please install it first."
    exit 1
fi

# Check if current directory is a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Current directory is not a git repository"
    exit 1
fi

# List all worktrees and let user select using fzf
selected_worktree=$(git worktree list | fzf --height 40% --reverse --header="Select worktree to remove")

if [ -z "$selected_worktree" ]; then
    echo "No worktree selected"
    exit 0
fi

# Extract the path from the selected worktree
worktree_path=$(echo "$selected_worktree" | awk '{print $1}')

# Remove the worktree
echo "Removing worktree at: $worktree_path"
git worktree remove "$worktree_path" --force

if [ $? -eq 0 ]; then
    echo "Worktree removed successfully"
else
    echo "Failed to remove worktree"
fi