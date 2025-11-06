#!/bin/bash

# Setup aliases for Flutter Cursor Template
# Run: source setup-aliases.sh (or add to ~/.zshrc)

echo "🚀 Setting up Flutter Cursor Template aliases..."

# Check if aliases already exist
if grep -q "cursor-setup" ~/.zshrc 2>/dev/null; then
    echo "⚠️  Aliases already exist in ~/.zshrc"
    read -p "Overwrite? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping..."
        exit 0
    fi
    # Remove old aliases
    sed -i '' '/# Flutter Cursor Template/,/^$/d' ~/.zshrc
fi

# Add aliases
cat >> ~/.zshrc << 'EOF'

# Flutter Cursor Template - Manual Setup (for private repo use SSH)
cursor-setup() {
  echo "🚀 Setting up Flutter Cursor Template..."
  
  # Use SSH for private repo
  if ! git clone git@github.com:adiomas/flutter-cursor-template.git .cursor-tmp 2>/dev/null; then
    echo "❌ Failed to clone template repo"
    echo "Make sure SSH key is configured: github.com/settings/keys"
    return 1
  fi
  
  # Copy files
  cp -r .cursor-tmp/.cursor . 2>/dev/null || true
  cp .cursor-tmp/.cursorrules . 2>/dev/null || true
  cp .cursor-tmp/.cursorignore . 2>/dev/null || true
  cp -r .cursor-tmp/docs . 2>/dev/null || true
  
  # Cleanup
  rm -rf .cursor-tmp
  
  echo "✅ Setup complete! Edit .cursor/notepads/project_context.md"
}

# Flutter Cursor Template - AI Setup (copies prompt to clipboard)
cursor-ai-setup() {
  local project_name="\${1:-My Flutter App}"
  local project_desc="\${2:-Flutter application}"
  
  local prompt="Postavi Flutter projekt sa Cursor elite template-om:

Template: https://github.com/adiomas/flutter-cursor-template (private - use SSH)
Project: \$project_name
Description: \$project_desc

Koraci:
1. Clone: git clone git@github.com:adiomas/flutter-cursor-template.git .cursor-tmp
2. Copy: cp -r .cursor-tmp/{.cursor,.cursorrules,.cursorignore,docs} .
3. Update .cursor/notepads/project_context.md (name, description)
4. Cleanup: rm -rf .cursor-tmp
5. Summary

@project_context.md @workflow_shortcuts.md"
  
  echo "\$prompt" | pbcopy
  echo "✅ Prompt copied to clipboard!"
  echo "📋 Paste in Cursor chat (⌘L → ⌘V → Enter)"
}

# Flutter Cursor Template - Update existing project (for private repo)
cursor-update() {
  echo "🔄 Updating Flutter Cursor Elite Template..."
  
  # Check if in Flutter project
  if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Not a Flutter project (pubspec.yaml not found)"
    return 1
  fi
  
  # Backup project context
  if [ -f .cursor/notepads/project_context.md ]; then
    echo "📦 Backing up project_context.md..."
    cp .cursor/notepads/project_context.md .cursor/notepads/project_context.md.backup
  fi
  
  # Clone latest (use SSH for private repo)
  echo "📥 Downloading latest template..."
  if ! git clone --depth 1 git@github.com:adiomas/flutter-cursor-template.git .cursor-tmp 2>/dev/null; then
    echo "❌ Failed to clone template"
    echo "Make sure SSH key is configured: github.com/settings/keys"
    return 1
  fi
  
  # Update files
  echo "📝 Updating..."
  cp -r .cursor-tmp/.cursor/rules .cursor/ 2>/dev/null || true
  cp -r .cursor-tmp/.cursor/tools .cursor/ 2>/dev/null || true
  mkdir -p .cursor/notepads
  cp .cursor-tmp/.cursor/notepads/workflow_shortcuts.md .cursor/notepads/ 2>/dev/null || true
  cp .cursor-tmp/.cursor/notepads/context7_patterns.md .cursor/notepads/ 2>/dev/null || true
  cp .cursor-tmp/.cursor/notepads/SETUP_PROMPT.md .cursor/notepads/ 2>/dev/null || true
  cp .cursor-tmp/.cursorrules . 2>/dev/null || true
  cp .cursor-tmp/.cursorignore . 2>/dev/null || true
  cp -r .cursor-tmp/docs . 2>/dev/null || true
  
  # Restore project context
  if [ -f .cursor/notepads/project_context.md.backup ]; then
    cp .cursor/notepads/project_context.md.backup .cursor/notepads/project_context.md
    rm .cursor/notepads/project_context.md.backup
  fi
  
  # Cleanup
  rm -rf .cursor-tmp
  
  echo "✅ Template updated! Project context preserved."
}

EOF

echo "✅ Aliases added to ~/.zshrc"
echo ""
echo "Reload shell: source ~/.zshrc"
echo ""
echo "Available commands:"
echo "  cursor-setup              - Manual setup for new project"
echo "  cursor-ai-setup NAME DESC - AI-powered setup (copies prompt)"
echo "  cursor-update             - Update existing project"

