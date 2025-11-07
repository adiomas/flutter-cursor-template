#!/bin/bash

# Pull from Template - Bidirectional Sync
# Pulls latest changes from flutter-cursor-template repository into subtree

set -e

SUBTREE_DIR="cursor-template"
REMOTE_NAME="template-upstream"
BRANCH="main"

# Check if we're in a Flutter project
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Not a Flutter project (pubspec.yaml not found)"
    exit 1
fi

# Check if subtree exists
if [ ! -d "$SUBTREE_DIR" ]; then
    echo "❌ Error: Subtree directory '$SUBTREE_DIR' not found"
    echo ""
    echo "   Run 'template-init' first to setup bidirectional sync"
    exit 1
fi

# Check if remote exists
if ! git remote | grep -q "^${REMOTE_NAME}$"; then
    echo "❌ Error: Template remote '$REMOTE_NAME' not found"
    echo ""
    echo "   Run 'template-init' first to setup bidirectional sync"
    exit 1
fi

echo "🔄 Pulling latest changes from template..."
echo ""

# Backup project_context.md if it exists
PROJECT_CONTEXT="${SUBTREE_DIR}/.cursor/notepads/project_context.md"
if [ -f "$PROJECT_CONTEXT" ]; then
    echo "📦 Backing up project_context.md..."
    cp "$PROJECT_CONTEXT" "${PROJECT_CONTEXT}.backup"
fi

# Fetch latest from remote
echo "📥 Fetching latest from template repository..."
git fetch "$REMOTE_NAME" "$BRANCH"

# Show what will be pulled
echo ""
echo "📋 Latest commits in template:"
git log --oneline HEAD.."${REMOTE_NAME}/${BRANCH}" --prefix="$SUBTREE_DIR" | head -5 || echo "   (No new commits)"

# Check if there are updates
if git diff --quiet HEAD "${REMOTE_NAME}/${BRANCH}" -- "$SUBTREE_DIR"; then
    echo ""
    echo "✅ Template is up to date!"
    [ -f "${PROJECT_CONTEXT}.backup" ] && rm "${PROJECT_CONTEXT}.backup"
    exit 0
fi

echo ""
read -p "🚀 Pull these changes? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "   Cancelled."
    [ -f "${PROJECT_CONTEXT}.backup" ] && rm "${PROJECT_CONTEXT}.backup"
    exit 0
fi

# Pull subtree changes
echo "🌳 Pulling subtree changes..."
if git subtree pull --prefix="$SUBTREE_DIR" "$REMOTE_NAME" "$BRANCH" --squash -m "chore: update template from upstream"; then
    echo ""
    echo "✅ Template updated successfully!"
    
    # Restore project_context.md if it was overwritten
    if [ -f "${PROJECT_CONTEXT}.backup" ]; then
        if [ -f "$PROJECT_CONTEXT" ]; then
            # Check if project_context.md was modified
            if ! git diff --quiet "${PROJECT_CONTEXT}.backup" "$PROJECT_CONTEXT" 2>/dev/null; then
                echo "📋 Restoring project_context.md..."
                cp "${PROJECT_CONTEXT}.backup" "$PROJECT_CONTEXT"
                git add "$PROJECT_CONTEXT"
                git commit -m "chore: preserve project_context.md" || true
            fi
        fi
        rm "${PROJECT_CONTEXT}.backup"
    fi
    
    echo ""
    echo "💡 Changes pulled:"
    echo "   • Check $SUBTREE_DIR/ for updates"
    echo "   • Symlinks automatically reflect changes"
    echo ""
    echo "📋 Your project_context.md was preserved."
else
    echo ""
    echo "❌ Pull failed!"
    echo ""
    echo "Possible reasons:"
    echo "   • Merge conflicts (resolve manually)"
    echo "   • Local changes conflict with upstream"
    echo ""
    echo "💡 Try:"
    echo "   1. Check git status: git status"
    echo "   2. Resolve conflicts if any"
    echo "   3. Commit: git commit"
    echo "   4. Pull again: template-pull"
    
    # Restore backup on failure
    if [ -f "${PROJECT_CONTEXT}.backup" ]; then
        echo ""
        echo "📋 Restoring project_context.md backup..."
        cp "${PROJECT_CONTEXT}.backup" "$PROJECT_CONTEXT"
    fi
    
    exit 1
fi

