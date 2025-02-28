#!/bin/bash

# Check if required commands are available
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed"
    exit 1
fi

if ! command -v fzf &> /dev/null; then
    echo "Error: fzf is not installed"
    exit 1
fi

# Fetch PRs and use fzf to select one
selected_pr=$(gh pr list --limit 100 --json number,title,headRefName,author --template \
    '{{range .}}{{printf "#%v\t%v\t(branch: %v, author: %v)\n" .number .title .headRefName .author.login}}{{end}}' |
    fzf --delimiter='\t' --preview 'gh pr view {1}' --preview-window=right:70% |
    cut -f1)

# Check if a PR was selected
if [ -n "$selected_pr" ]; then
    # Remove the '#' character from the PR number
    pr_number=${selected_pr#"#"}
    
    # Checkout the PR
    gh pr checkout "$pr_number"
else
    echo "No PR selected"
    exit 0
fi