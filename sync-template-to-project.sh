#!/bin/bash

# Sync Template to Project - Subtree Initialization
# Sets up flutter-cursor-template as a git subtree in your Flutter project
# Enables bidirectional sync (template ↔ project)

set -e

TEMPLATE_REPO="https://github.com/adiomas/flutter-cursor-template.git"
TEMPLATE_REPO_SSH="git@github.com:adiomas/flutter-cursor-template.git"
SUBTREE_DIR="cursor-template"
REMOTE_NAME="template-upstream"

echo "🚀 Setting up Flutter Cursor Template as Subtree..."
echo ""

# Check if we're in a Flutter project
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Not a Flutter project (pubspec.yaml not found)"
    echo "   Run this command from your Flutter project root directory"
    exit 1
fi

# Check if git repo exists
if [ ! -d ".git" ]; then
    echo "⚠️  Not a git repository"
    echo "   Initializing git repository..."
    git init
    echo "✅ Git repository initialized"
fi

# Check if repo has any commits (required for subtree)
if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
    echo "📝 Creating initial commit (required for subtree)..."
    git add .
    git commit -m "chore: initial commit" || {
        # If nothing to commit, create empty commit
        git commit --allow-empty -m "chore: initial commit"
    }
    echo "✅ Initial commit created"
fi

# Check if subtree already exists
if [ -d "$SUBTREE_DIR" ]; then
    echo "⚠️  Subtree directory '$SUBTREE_DIR' already exists"
    read -p "   Overwrite? This will backup existing files first (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "   Skipping..."
        exit 0
    fi
    
    # Backup existing subtree
    echo "📦 Backing up existing subtree..."
    BACKUP_DIR="${SUBTREE_DIR}.backup.$(date +%s)"
    mv "$SUBTREE_DIR" "$BACKUP_DIR"
    echo "   Backup saved to: $BACKUP_DIR"
fi

# Backup existing template files if they exist
echo "📦 Backing up existing template files..."
BACKUP_ROOT=".cursor-template-backup.$(date +%s)"
mkdir -p "$BACKUP_ROOT"

[ -f ".cursorrules" ] && cp ".cursorrules" "$BACKUP_ROOT/" 2>/dev/null || true
[ -f ".cursorignore" ] && cp ".cursorignore" "$BACKUP_ROOT/" 2>/dev/null || true
[ -d ".cursor" ] && cp -r ".cursor" "$BACKUP_ROOT/" 2>/dev/null || true
[ -d "docs" ] && cp -r "docs" "$BACKUP_ROOT/" 2>/dev/null || true
[ -f "setup-aliases.sh" ] && cp "setup-aliases.sh" "$BACKUP_ROOT/" 2>/dev/null || true
[ -f "update-template.sh" ] && cp "update-template.sh" "$BACKUP_ROOT/" 2>/dev/null || true

echo "   Backup saved to: $BACKUP_ROOT"
echo ""

# Determine which repo URL to use
REPO_URL="$TEMPLATE_REPO"
if git ls-remote "$TEMPLATE_REPO" &>/dev/null; then
    echo "✅ Using HTTPS repository URL"
else
    echo "⚠️  HTTPS failed, trying SSH..."
    REPO_URL="$TEMPLATE_REPO_SSH"
    if ! git ls-remote "$REPO_URL" &>/dev/null; then
        echo "❌ Failed to access template repository"
        echo ""
        echo "Solutions:"
        echo "  1. Make repo public: GitHub → Settings → Change visibility"
        echo "  2. Setup SSH key: https://github.com/settings/keys"
        echo "  3. Use PAT: export GITHUB_PAT='your_token'"
        exit 1
    fi
    echo "✅ Using SSH repository URL"
fi

# Add remote if it doesn't exist
if ! git remote | grep -q "^${REMOTE_NAME}$"; then
    echo "📡 Adding template remote..."
    git remote add "$REMOTE_NAME" "$REPO_URL"
else
    echo "📡 Updating template remote..."
    git remote set-url "$REMOTE_NAME" "$REPO_URL"
fi

# Fetch template
echo "📥 Fetching template repository..."
git fetch "$REMOTE_NAME" main

# Add subtree
echo "🌳 Adding template as subtree..."
git subtree add --prefix="$SUBTREE_DIR" "$REMOTE_NAME" main --squash

# Create symlinks for Cursor IDE compatibility
echo "🔗 Creating symlinks for Cursor IDE..."

# Remove existing files/dirs if they exist (to make room for symlinks)
[ -f ".cursorrules" ] && rm ".cursorrules" 2>/dev/null || true
[ -f ".cursorignore" ] && rm ".cursorignore" 2>/dev/null || true
[ -d ".cursor" ] && rm -rf ".cursor" 2>/dev/null || true
[ -d "docs" ] && rm -rf "docs" 2>/dev/null || true
[ -f "setup-aliases.sh" ] && rm "setup-aliases.sh" 2>/dev/null || true
[ -f "update-template.sh" ] && rm "update-template.sh" 2>/dev/null || true

# Create symlinks
ln -s "${SUBTREE_DIR}/.cursorrules" ".cursorrules" 2>/dev/null || true
ln -s "${SUBTREE_DIR}/.cursorignore" ".cursorignore" 2>/dev/null || true
ln -s "${SUBTREE_DIR}/.cursor" ".cursor" 2>/dev/null || true
ln -s "${SUBTREE_DIR}/docs" "docs" 2>/dev/null || true
ln -s "${SUBTREE_DIR}/setup-aliases.sh" "setup-aliases.sh" 2>/dev/null || true
ln -s "${SUBTREE_DIR}/update-template.sh" "update-template.sh" 2>/dev/null || true

# Update .gitignore to ignore symlinks but track subtree
echo "📝 Updating .gitignore..."
if [ ! -f ".gitignore" ]; then
    touch ".gitignore"
fi

# Add template ignore rules if not present
if ! grep -q "# Cursor Template Symlinks" ".gitignore"; then
    cat >> .gitignore << 'EOF'

# Cursor Template Symlinks (tracked via subtree)
/.cursorrules
/.cursorignore
/.cursor
/docs
/setup-aliases.sh
/update-template.sh

# Track subtree directory
!/cursor-template/
EOF
fi

# Preserve project_context.md if it exists in backup
if [ -f "$BACKUP_ROOT/.cursor/notepads/project_context.md" ]; then
    echo "📋 Restoring project_context.md..."
    mkdir -p "${SUBTREE_DIR}/.cursor/notepads"
    cp "$BACKUP_ROOT/.cursor/notepads/project_context.md" "${SUBTREE_DIR}/.cursor/notepads/project_context.md"
    git add "${SUBTREE_DIR}/.cursor/notepads/project_context.md"
    git commit -m "chore: preserve project_context.md" || true
fi

echo ""
echo "✅ Subtree setup complete!"
echo ""
echo "📁 Structure:"
echo "   • cursor-template/     - Subtree directory (git-tracked)"
echo "   • .cursorrules         - Symlink to subtree"
echo "   • .cursor/             - Symlink to subtree"
echo "   • docs/                - Symlink to subtree"
echo ""
echo "🔄 Available commands:"
echo "   • template-pull        - Pull latest changes from template"
echo "   • template-push MSG    - Push your improvements to template"
echo "   • template-status      - Check sync status"
echo ""
echo "💡 Next steps:"
echo "   1. Edit cursor-template/ files as needed"
echo "   2. Use template-push to send improvements back to template"
echo "   3. Use template-pull to get latest template updates"
echo ""
echo "📦 Backup location: $BACKUP_ROOT"
echo "   (You can delete this after verifying everything works)"

