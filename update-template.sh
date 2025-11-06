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
echo "📝 Updating template files..."
echo ""

# Always update these
echo "  ✓ .cursor/rules/ (AI rules)"
cp -r .cursor-tmp/.cursor/rules .cursor/ 2>/dev/null || true

echo "  ✓ .cursor/tools/ (Python/Shell scripts)"
cp -r .cursor-tmp/.cursor/tools .cursor/ 2>/dev/null || true

echo "  ✓ .cursorrules (main AI config)"
cp .cursor-tmp/.cursorrules . 2>/dev/null || true

echo "  ✓ .cursorignore (ignore patterns)"
cp .cursor-tmp/.cursorignore . 2>/dev/null || true

echo "  ✓ docs/ (documentation)"
cp -r .cursor-tmp/docs . 2>/dev/null || true

echo "  ✓ setup-aliases.sh (alias setup)"
cp .cursor-tmp/setup-aliases.sh . 2>/dev/null || true

# Update setup guide if it exists (template-specific)
if [ -f .cursor-tmp/CURSOR_AI_SETUP.md ]; then
    echo "  ✓ CURSOR_AI_SETUP.md (setup guide)"
    cp .cursor-tmp/CURSOR_AI_SETUP.md . 2>/dev/null || true
fi

echo ""
echo "  ⊗ README.md (preserved - project-specific)"
echo "  ⊗ .cursor/notepads/ (preserved - project context)"
echo ""

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

