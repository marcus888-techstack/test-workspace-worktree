# Git Worktree + Cursor Workspace Guide

## Overview

This project is set up with Git worktrees integrated with Cursor IDE workspace management. This allows you to work on multiple branches simultaneously without switching contexts.

## Current Structure

```
test-workspace-worktree/          # Main branch (current directory)
├── worktrees/                    # All worktrees stored here
│   ├── feature-auth/            # Authentication feature branch
│   ├── feature-data/            # Data processing feature branch
│   └── hotfix/                  # Hotfix branch
├── myproject.code-workspace      # Cursor workspace file
├── worktree-manager.sh          # Helper script
└── [project files]              # Your actual project code
```

## Quick Start

### 1. Open the Workspace in Cursor

```bash
# From this directory, open Cursor with the workspace
cursor myproject.code-workspace
```

This will open Cursor with all worktrees visible in the sidebar:
- 🏠 Main Branch
- 🔐 Feature: Authentication
- 📊 Feature: Data Processing
- 🚨 Hotfix Branch

### 2. Using Claude Code in Different Worktrees

1. Open the integrated terminal in Cursor (Ctrl/Cmd + `)
2. Select which folder/worktree using the terminal dropdown
3. Run Claude Code commands in that specific worktree:

```bash
# In Feature: Authentication terminal
claude "implement user login with email and password"

# In Feature: Data Processing terminal
claude "create data validation functions"

# In Hotfix terminal
claude "fix the config loading issue"
```

### 3. Managing Worktrees

Use the included script for easy management:

```bash
# List all worktrees
./worktree-manager.sh list

# Create a new worktree
./worktree-manager.sh create feature/new-feature

# Remove a worktree
./worktree-manager.sh remove feature/new-feature

# Check status of all worktrees
./worktree-manager.sh status

# Open a specific worktree in Cursor
./worktree-manager.sh switch feature-auth
```

## Common Workflows

### Workflow 1: Working on Multiple Features

1. You're working on authentication in `worktrees/feature-auth`
2. Urgent bug comes in - switch to `worktrees/hotfix` terminal
3. Fix the bug, commit, and push
4. Return to authentication work without losing context

### Workflow 2: Parallel Development with Claude Code

1. Open multiple terminals in Cursor (one for each worktree)
2. Run different Claude Code tasks in parallel:
   - Terminal 1: `claude "implement JWT tokens"`
   - Terminal 2: `claude "optimize database queries"`
   - Terminal 3: `claude "add input validation"`

### Workflow 3: Code Review and Testing

1. Create a worktree for code review: `./worktree-manager.sh create review/pr-123`
2. Pull the PR branch into that worktree
3. Test and review without affecting your current work

## Best Practices

1. **Naming Convention**: Use descriptive branch names
   - Features: `feature/description`
   - Bugs: `bugfix/issue-number`
   - Hotfixes: `hotfix/description`

2. **Clean Up**: Remove worktrees after merging
   ```bash
   ./worktree-manager.sh remove feature-auth
   ```

3. **Sync Regularly**: Keep worktrees updated
   ```bash
   cd worktrees/feature-auth
   git pull origin main
   ```

4. **Use Workspace Search**: Cursor's search works across all worktrees
   - Use Cmd/Ctrl+Shift+F to search across all branches

## Git Commands Reference

```bash
# List all worktrees
git worktree list

# Add a new worktree
git worktree add worktrees/new-feature -b feature/new-feature

# Remove a worktree
git worktree remove worktrees/new-feature

# Prune stale worktree information
git worktree prune
```

## Tips for Claude Code Users

1. **Separate Contexts**: Each worktree maintains its own Claude Code context
2. **Parallel Tasks**: You can have Claude working on different problems simultaneously
3. **Quick Switches**: Use Cursor's terminal dropdown to switch between worktree contexts
4. **Shared Knowledge**: Changes in one worktree don't affect others until merged

## Troubleshooting

### "Worktree already exists" Error
```bash
# Remove the worktree first
git worktree remove worktrees/branch-name
# Then recreate it
./worktree-manager.sh create branch-name
```

### Can't Remove Worktree
```bash
# Force remove if there are uncommitted changes
git worktree remove --force worktrees/branch-name
```

### Workspace Not Loading Properly
1. Close Cursor
2. Open Cursor directly with the workspace file:
   ```bash
   cursor myproject.code-workspace
   ```

## Next Steps

1. Try creating a new feature branch with a worktree
2. Make changes in different worktrees simultaneously
3. Use Claude Code to implement features in parallel
4. Experiment with the workflow that works best for you!