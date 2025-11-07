#!/bin/bash

# Show sync status with template repo

TEMPLATE_REMOTE="template"
TEMPLATE_BRANCH="main"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}📊 Template Repo Sync Status${NC}"
echo "================================"

# Check if template remote exists
if ! git remote | grep -q "^${TEMPLATE_REMOTE}$"; then
    echo -e "${RED}❌ Template remote not configured${NC}"
    echo "Run: bash .cursor/tools/template-sync-setup.sh"
    exit 1
fi

# Fetch latest
echo "Fetching latest from template..."
git fetch ${TEMPLATE_REMOTE} ${TEMPLATE_BRANCH} --quiet

# Check differences
echo ""
echo -e "${YELLOW}Local changes not in template:${NC}"
git diff ${TEMPLATE_REMOTE}/${TEMPLATE_BRANCH} -- .cursor/rules .cursor/tools docs .cursorrules .cursorignore | head -30 || echo "  (none)"

echo ""
echo -e "${YELLOW}Template changes not in local:${NC}"
git diff HEAD -- ${TEMPLATE_REMOTE}/${TEMPLATE_BRANCH} -- .cursor/rules .cursor/tools docs .cursorrules .cursorignore | head -30 || echo "  (none)"

echo ""
echo -e "${GREEN}Status:${NC}"
git status --short .cursor/ docs/ .cursorrules .cursorignore | head -20

echo ""
echo "Commands:"
echo "  template-pull  - Pull latest from template"
echo "  template-push  - Push changes to template"
echo "  template-diff  - Show detailed diff"

