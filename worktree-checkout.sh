#!/bin/bash

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if required commands exist
if ! command_exists fzf; then
    echo "Error: fzf is not installed. Please install it first."
    exit 1
fi

if ! command_exists git; then
    echo "Error: git is not installed"
    exit 1
fi

git fetch --all --prune

# Get branch name either from argument or fzf selection
if [ $# -ge 1 ]; then
    BRANCH_NAME=$1
else
    # List all branches (both local and remote) and use fzf to select
    BRANCH_NAME=$(git branch -a | \
        grep -v HEAD | \
        sed 's/.* //' | \
        sed 's#remotes/origin/##' | \
        sort -u | \
        fzf --height 40% --prompt="Select branch > " --preview "git log --color=always -n 50 {}")

    # Exit if no branch selected
    if [ -z "$BRANCH_NAME" ]; then
        echo "No branch selected"
        exit 1
    fi
fi

# If worktree path is not provided, use branch name as directory
WORKTREE_PATH=${2:-"$BRANCH_NAME"}

# Create new worktree
git worktree add "$WORKTREE_PATH" "$BRANCH_NAME"

if [ $? -eq 0 ]; then
    echo "Successfully created worktree for branch '$BRANCH_NAME' at '$WORKTREE_PATH'"
else
    echo "Failed to create worktree"
    exit 1
fi