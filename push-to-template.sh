#!/bin/bash

# Push to Template - Bidirectional Sync
# Pushes changes from cursor-template/ subtree back to flutter-cursor-template repository

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

# Get commit message from argument or prompt
COMMIT_MSG="${1:-}"

if [ -z "$COMMIT_MSG" ]; then
    echo "📝 Enter commit message for template changes:"
    read -r COMMIT_MSG
    if [ -z "$COMMIT_MSG" ]; then
        echo "❌ Commit message cannot be empty"
        exit 1
    fi
fi

# Check for ANY changes in subtree (modified, untracked, staged)
echo "🔍 Checking for changes in $SUBTREE_DIR..."

# Check if there are any changes in subtree directory (including untracked)
if git diff --quiet HEAD -- "$SUBTREE_DIR" && \
   git diff --cached --quiet HEAD -- "$SUBTREE_DIR" && \
   [ -z "$(git status --porcelain "$SUBTREE_DIR" 2>/dev/null)" ]; then
    echo "⚠️  No changes detected in $SUBTREE_DIR"
    echo ""
    echo "   Make changes to files in $SUBTREE_DIR/ first, then run:"
    echo "   template-push \"your commit message\""
    exit 0
fi

# Show what will be pushed (only subtree changes)
echo ""
echo "📋 Changes to be pushed:"
git diff --name-status HEAD -- "$SUBTREE_DIR" | head -20
if [ $(git diff --name-status HEAD -- "$SUBTREE_DIR" | wc -l) -gt 20 ]; then
    echo "   ... (and more)"
fi
echo ""

# Confirm push
read -p "🚀 Push these changes to template repository? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "   Cancelled."
    exit 0
fi

# Stage subtree changes
echo "📦 Staging changes..."
git add "$SUBTREE_DIR"

# Commit changes
echo "💾 Committing changes..."
git commit -m "$COMMIT_MSG" || {
    echo "⚠️  No changes to commit (already committed?)"
}

# Push to template repository
echo "🚀 Pushing to template repository..."
if git subtree push --prefix="$SUBTREE_DIR" "$REMOTE_NAME" "$BRANCH"; then
    echo ""
    echo "✅ Changes pushed successfully to template!"
    echo ""
    echo "📋 Summary:"
    echo "   • Commit: $COMMIT_MSG"
    echo "   • Remote: $REMOTE_NAME"
    echo "   • Branch: $BRANCH"
    echo ""
    echo "💡 Other projects can now pull these changes with:"
    echo "   template-pull"
else
    echo ""
    echo "❌ Push failed!"
    echo ""
    echo "Possible reasons:"
    echo "   • No write access to template repository"
    echo "   • Remote branch has diverged (try: template-pull first)"
    echo "   • Network issues"
    echo ""
    echo "💡 Try:"
    echo "   1. Pull latest: template-pull"
    echo "   2. Resolve conflicts if any"
    echo "   3. Push again: template-push \"$COMMIT_MSG\""
    exit 1
fi

