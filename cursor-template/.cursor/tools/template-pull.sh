#!/bin/bash

# Pull latest changes from template repo
# Preserves project-specific files

set -e

TEMPLATE_REMOTE="template"
TEMPLATE_BRANCH="main"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}📥 Pulling from template repo...${NC}"

# Check if template remote exists
if ! git remote | grep -q "^${TEMPLATE_REMOTE}$"; then
    echo -e "${RED}❌ Template remote not configured. Run: bash .cursor/tools/template-sync-setup.sh${NC}"
    exit 1
fi

# Fetch latest
echo "Fetching latest changes..."
git fetch ${TEMPLATE_REMOTE} ${TEMPLATE_BRANCH}

# Backup project-specific files
echo "💾 Backing up project-specific files..."
mkdir -p .template-backup
[ -f .cursor/notepads/project_context.md ] && cp .cursor/notepads/project_context.md .template-backup/project_context.md.backup || true

# List of files/folders to sync from template
SYNC_PATHS=(
    ".cursor/rules"
    ".cursor/tools"
    ".cursorrules"
    ".cursorignore"
    "docs"
)

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo -e "${YELLOW}⚠️  Warning: You have uncommitted changes${NC}"
    echo "Stashing changes..."
    git stash push -m "Template sync stash $(date +%Y%m%d_%H%M%S)"
    STASHED=true
else
    STASHED=false
fi

# Merge template changes
echo "Merging template changes..."
git merge ${TEMPLATE_REMOTE}/${TEMPLATE_BRANCH} --no-edit --no-commit || {
    echo -e "${YELLOW}⚠️  Merge conflicts detected. Resolve manually.${NC}"
    if [ "$STASHED" = true ]; then
        git stash pop
    fi
    exit 1
}

# Restore project-specific files
if [ -f .template-backup/project_context.md.backup ]; then
    echo "Restoring project-specific files..."
    cp .template-backup/project_context.md.backup .cursor/notepads/project_context.md
    git add .cursor/notepads/project_context.md
fi

# Restore stash if needed
if [ "$STASHED" = true ]; then
    echo "Restoring stashed changes..."
    git stash pop || true
fi

echo -e "${GREEN}✅ Template changes pulled successfully!${NC}"
echo ""
echo "Review changes with: git status"
echo "Commit when ready: git commit -m 'Update: Sync with template'"

