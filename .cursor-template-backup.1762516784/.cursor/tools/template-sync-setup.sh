#!/bin/bash

# Template Repo Sync Script
# Syncs .cursor/, docs/, .cursorrules, .cursorignore with template repo
# Preserves project-specific files (project_context.md)

set -e

TEMPLATE_REPO="https://github.com/adiomas/flutter-cursor-template.git"
TEMPLATE_REMOTE="template"
TEMPLATE_BRANCH="main"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔄 Template Repo Sync${NC}"
echo "================================"

# Check if we're in a git repo
if [ ! -d ".git" ]; then
    echo -e "${RED}❌ Error: Not a git repository${NC}"
    exit 1
fi

# Check if template remote exists
if git remote | grep -q "^${TEMPLATE_REMOTE}$"; then
    echo -e "${YELLOW}✓ Template remote already configured${NC}"
else
    echo "📡 Adding template remote..."
    git remote add ${TEMPLATE_REMOTE} ${TEMPLATE_REPO}
    echo -e "${GREEN}✓ Template remote added${NC}"
fi

# Fetch latest from template
echo "📥 Fetching latest from template repo..."
git fetch ${TEMPLATE_REMOTE} ${TEMPLATE_BRANCH}

# Backup project-specific files
echo "💾 Backing up project-specific files..."
mkdir -p .template-backup
[ -f .cursor/notepads/project_context.md ] && cp .cursor/notepads/project_context.md .template-backup/project_context.md.backup || true

# Show status
echo ""
echo -e "${YELLOW}Current status:${NC}"
git status --short

echo ""
echo -e "${GREEN}✅ Template remote configured!${NC}"
echo ""
echo "Available commands:"
echo "  template-pull    - Pull latest changes from template repo"
echo "  template-push    - Push changes to template repo"
echo "  template-status  - Show sync status"
echo "  template-diff    - Show differences with template"

