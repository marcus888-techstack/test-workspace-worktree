#!/bin/bash
# Git Worktree Manager Script
# This script helps manage Git worktrees for the project

PROJECT_NAME="test-workspace"
BASE_DIR="$(pwd)/worktrees"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

function print_help() {
    echo "Git Worktree Manager"
    echo "==================="
    echo ""
    echo "Usage: ./worktree-manager.sh [command] [args]"
    echo ""
    echo "Commands:"
    echo "  list                     - List all worktrees"
    echo "  create <branch-name>     - Create a new worktree for a branch"
    echo "  remove <branch-name>     - Remove a worktree"
    echo "  switch <branch-name>     - Open worktree in Cursor"
    echo "  status                   - Show status of all worktrees"
    echo "  clean                    - Remove all worktrees (except main)"
    echo ""
}

function list_worktrees() {
    echo -e "${BLUE}Current worktrees:${NC}"
    git worktree list
}

function create_worktree() {
    if [ -z "$1" ]; then
        echo -e "${RED}Error: Please provide a branch name${NC}"
        return 1
    fi
    
    # Create worktrees directory if it doesn't exist
    mkdir -p "${BASE_DIR}"
    
    local branch_name=$1
    local worktree_path="${BASE_DIR}/${branch_name}"
    
    echo -e "${GREEN}Creating worktree for branch: ${branch_name}${NC}"
    git worktree add "${worktree_path}" -b "${branch_name}"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Worktree created at: ${worktree_path}${NC}"
        echo -e "${BLUE}To open in Cursor, run: cursor ${worktree_path}${NC}"
    else
        echo -e "${RED}✗ Failed to create worktree${NC}"
    fi
}

function remove_worktree() {
    if [ -z "$1" ]; then
        echo -e "${RED}Error: Please provide a branch name${NC}"
        return 1
    fi
    
    local branch_name=$1
    local worktree_path="${BASE_DIR}/${branch_name}"
    
    echo -e "${GREEN}Removing worktree: ${worktree_path}${NC}"
    git worktree remove "${worktree_path}"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Worktree removed${NC}"
    else
        echo -e "${RED}✗ Failed to remove worktree${NC}"
    fi
}

function switch_worktree() {
    if [ -z "$1" ]; then
        echo -e "${RED}Error: Please provide a branch name${NC}"
        return 1
    fi
    
    local branch_name=$1
    local worktree_path="${BASE_DIR}/${branch_name}"
    
    if [ -d "${worktree_path}" ]; then
        echo -e "${GREEN}Opening ${worktree_path} in Cursor...${NC}"
        cursor "${worktree_path}"
    else
        echo -e "${RED}Error: Worktree not found at ${worktree_path}${NC}"
    fi
}

function show_status() {
    echo -e "${BLUE}Worktree Status:${NC}"
    echo "================"
    
    # Get all worktrees
    while IFS= read -r line; do
        worktree_path=$(echo "$line" | awk '{print $1}')
        commit_hash=$(echo "$line" | awk '{print $2}')
        branch_name=$(echo "$line" | awk '{print $3}' | tr -d '[]')
        
        echo -e "\n${GREEN}Branch: ${branch_name}${NC}"
        echo "Path: ${worktree_path}"
        echo "Commit: ${commit_hash}"
        
        # Show git status for each worktree
        if [ -d "${worktree_path}" ]; then
            cd "${worktree_path}"
            status=$(git status --porcelain)
            if [ -z "$status" ]; then
                echo "Status: Clean"
            else
                echo "Status: Has uncommitted changes"
                echo "$status" | head -5
            fi
            cd - > /dev/null
        fi
    done < <(git worktree list)
}

function clean_worktrees() {
    echo -e "${RED}Warning: This will remove all worktrees except main!${NC}"
    read -p "Are you sure? (y/N) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git worktree list | grep -v '\[main\]' | awk '{print $1}' | while read -r path; do
            echo -e "${GREEN}Removing: ${path}${NC}"
            git worktree remove "${path}"
        done
        echo -e "${GREEN}✓ Cleanup complete${NC}"
    else
        echo "Cancelled"
    fi
}

# Main script logic
case "$1" in
    list)
        list_worktrees
        ;;
    create)
        create_worktree "$2"
        ;;
    remove)
        remove_worktree "$2"
        ;;
    switch)
        switch_worktree "$2"
        ;;
    status)
        show_status
        ;;
    clean)
        clean_worktrees
        ;;
    *)
        print_help
        ;;
esac