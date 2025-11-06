#!/bin/bash

# Flutter Cursor Template Update Script
# Usage: ./update-template.sh (in your Flutter project)

set -e

echo "🔄 Updating Flutter Cursor Elite Template..."
echo ""

# Check if we're in a Flutter project
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Not a Flutter project (pubspec.yaml not found)"
    exit 1
fi

# Backup project context (VAŽNO!)
if [ -f .cursor/notepads/project_context.md ]; then
    echo "📦 Backing up project_context.md..."
    cp .cursor/notepads/project_context.md .cursor/notepads/project_context.md.backup
fi

# Clone latest template
echo "📥 Downloading latest template..."
git clone https://github.com/adiomas/flutter-cursor-template.git .cursor-tmp

# Update files
echo "📝 Updating configuration files..."
cp -r .cursor-tmp/.cursor/rules .cursor/ 2>/dev/null || true
cp .cursor-tmp/.cursorrules . 2>/dev/null || true
cp .cursor-tmp/.cursorignore . 2>/dev/null || true
cp -r .cursor-tmp/docs . 2>/dev/null || true

# Restore project context
if [ -f .cursor/notepads/project_context.md.backup ]; then
    echo "✅ Restoring project_context.md..."
    cp .cursor/notepads/project_context.md.backup .cursor/notepads/project_context.md
    rm .cursor/notepads/project_context.md.backup
fi

# Cleanup
echo "🧹 Cleaning up..."
rm -rf .cursor-tmp

echo ""
echo "✅ Template updated successfully!"
echo "📋 Your project_context.md was preserved."
echo ""
echo "Next: Open Cursor and start building!"

