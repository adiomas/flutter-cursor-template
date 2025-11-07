#!/bin/bash

# Show detailed diff with template repo

TEMPLATE_REMOTE="template"
TEMPLATE_BRANCH="main"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}📋 Detailed Diff with Template${NC}"
echo "================================"

# Check if template remote exists
if ! git remote | grep -q "^${TEMPLATE_REMOTE}$"; then
    echo "Template remote not configured. Run: bash .cursor/tools/template-sync-setup.sh"
    exit 1
fi

# Fetch latest
git fetch ${TEMPLATE_REMOTE} ${TEMPLATE_BRANCH} --quiet

echo ""
echo "Files changed:"
git diff --name-status ${TEMPLATE_REMOTE}/${TEMPLATE_BRANCH} -- .cursor/rules .cursor/tools docs .cursorrules .cursorignore

echo ""
read -p "Show full diff? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    git diff ${TEMPLATE_REMOTE}/${TEMPLATE_BRANCH} -- .cursor/rules .cursor/tools docs .cursorrules .cursorignore
fi

