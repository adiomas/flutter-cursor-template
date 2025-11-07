#!/bin/bash

# Push changes to template repo
# Only pushes template-related files (.cursor/, docs/, .cursorrules, .cursorignore)

set -e

TEMPLATE_REMOTE="template"
TEMPLATE_BRANCH="main"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}📤 Pushing to template repo...${NC}"

# Check if template remote exists
if ! git remote | grep -q "^${TEMPLATE_REMOTE}$"; then
    echo -e "${RED}❌ Template remote not configured. Run: bash .cursor/tools/template-sync-setup.sh${NC}"
    exit 1
fi

# Check if we have changes to push
if git diff-index --quiet HEAD -- .cursor/ docs/ .cursorrules .cursorignore 2>/dev/null; then
    echo -e "${YELLOW}⚠️  No changes to push${NC}"
    exit 0
fi

# Show what will be pushed
echo "Files to push:"
git status --short .cursor/ docs/ .cursorrules .cursorignore | head -20

echo ""
read -p "Push these changes to template repo? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

# Create a temporary branch for template changes
TEMP_BRANCH="template-push-$(date +%Y%m%d-%H%M%S)"
echo "Creating temporary branch: ${TEMP_BRANCH}"

# Stash any uncommitted changes
STASHED=false
if ! git diff-index --quiet HEAD --; then
    echo "Stashing uncommitted changes..."
    git stash push -m "Template push stash $(date +%Y%m%d_%H%M%S)"
    STASHED=true
fi

# Create branch from template
git checkout -b ${TEMP_BRANCH} ${TEMPLATE_REMOTE}/${TEMPLATE_BRANCH} 2>/dev/null || {
    echo "Creating new branch from current state..."
    git checkout -b ${TEMP_BRANCH}
}

# Copy template files
echo "Copying template files..."
git checkout HEAD -- .cursor/rules .cursor/tools docs .cursorrules .cursorignore 2>/dev/null || true
git checkout HEAD~1 -- .cursor/rules .cursor/tools docs .cursorrules .cursorignore 2>/dev/null || true

# Add template files from current branch
git checkout - -- .cursor/rules .cursor/tools docs .cursorrules .cursorignore 2>/dev/null || true

# Check if there are changes
if git diff --quiet --cached; then
    echo -e "${YELLOW}⚠️  No template changes detected${NC}"
    git checkout -
    [ "$STASHED" = true ] && git stash pop || true
    git branch -D ${TEMP_BRANCH} 2>/dev/null || true
    exit 0
fi

# Commit
echo "Committing changes..."
git add .cursor/rules .cursor/tools docs .cursorrules .cursorignore
git commit -m "Update: Template sync $(date +%Y-%m-%d)" || {
    echo -e "${RED}❌ Commit failed${NC}"
    git checkout -
    [ "$STASHED" = true ] && git stash pop || true
    git branch -D ${TEMP_BRANCH} 2>/dev/null || true
    exit 1
}

# Push to template repo
echo "Pushing to template repo..."
git push ${TEMPLATE_REMOTE} ${TEMP_BRANCH}:${TEMPLATE_BRANCH} || {
    echo -e "${RED}❌ Push failed. Check permissions.${NC}"
    git checkout -
    [ "$STASHED" = true ] && git stash pop || true
    git branch -D ${TEMP_BRANCH} 2>/dev/null || true
    exit 1
}

# Cleanup
echo "Cleaning up..."
git checkout -
[ "$STASHED" = true ] && git stash pop || true
git branch -D ${TEMP_BRANCH} 2>/dev/null || true

echo -e "${GREEN}✅ Successfully pushed to template repo!${NC}"
echo ""
echo "View changes: https://github.com/adiomas/flutter-cursor-template"

