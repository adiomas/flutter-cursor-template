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

# Flutter Cursor Template - Bidirectional Sync (Subtree)
# Initialize template as subtree for bidirectional sync
template-init() {
  local script_path=""
  
  # Try to find script in common locations
  if [ -f "$HOME/Developer/flutter-cursor-template/sync-template-to-project.sh" ]; then
    script_path="$HOME/Developer/flutter-cursor-template/sync-template-to-project.sh"
  elif [ -f "./sync-template-to-project.sh" ]; then
    script_path="./sync-template-to-project.sh"
  elif [ -f "cursor-template/sync-template-to-project.sh" ]; then
    script_path="cursor-template/sync-template-to-project.sh"
  else
    echo "❌ sync-template-to-project.sh not found"
    echo ""
    echo "Download it from template repository:"
    echo "  curl -fsSL https://raw.githubusercontent.com/adiomas/flutter-cursor-template/main/sync-template-to-project.sh -o sync-template-to-project.sh"
    echo "  chmod +x sync-template-to-project.sh"
    echo "  ./sync-template-to-project.sh"
    return 1
  fi
  
  bash "$script_path"
}

# Pull latest changes from template
template-pull() {
  local script_path=""
  
  if [ -f "$HOME/Developer/flutter-cursor-template/pull-from-template.sh" ]; then
    script_path="$HOME/Developer/flutter-cursor-template/pull-from-template.sh"
  elif [ -f "./pull-from-template.sh" ]; then
    script_path="./pull-from-template.sh"
  elif [ -f "cursor-template/pull-from-template.sh" ]; then
    script_path="cursor-template/pull-from-template.sh"
  else
    echo "❌ pull-from-template.sh not found"
    echo ""
    echo "Download it from template repository:"
    echo "  curl -fsSL https://raw.githubusercontent.com/adiomas/flutter-cursor-template/main/pull-from-template.sh -o pull-from-template.sh"
    echo "  chmod +x pull-from-template.sh"
    echo "  ./pull-from-template.sh"
    return 1
  fi
  
  bash "$script_path"
}

# Push changes back to template
template-push() {
  local commit_msg="$1"
  local script_path=""
  
  if [ -f "$HOME/Developer/flutter-cursor-template/push-to-template.sh" ]; then
    script_path="$HOME/Developer/flutter-cursor-template/push-to-template.sh"
  elif [ -f "./push-to-template.sh" ]; then
    script_path="./push-to-template.sh"
  elif [ -f "cursor-template/push-to-template.sh" ]; then
    script_path="cursor-template/push-to-template.sh"
  else
    echo "❌ push-to-template.sh not found"
    echo ""
    echo "Download it from template repository:"
    echo "  curl -fsSL https://raw.githubusercontent.com/adiomas/flutter-cursor-template/main/push-to-template.sh -o push-to-template.sh"
    echo "  chmod +x push-to-template.sh"
    echo "  ./push-to-template.sh \"your commit message\""
    return 1
  fi
  
  bash "$script_path" "$commit_msg"
}

# Check sync status
template-status() {
  if [ ! -d "cursor-template" ]; then
    echo "❌ Subtree not initialized"
    echo ""
    echo "Run 'template-init' first to setup bidirectional sync"
    return 1
  fi
  
  if ! git remote | grep -q "^template-upstream$"; then
    echo "❌ Template remote not found"
    echo ""
    echo "Run 'template-init' first to setup bidirectional sync"
    return 1
  fi
  
  echo "📊 Template Sync Status"
  echo ""
  echo "📁 Subtree directory: cursor-template/"
  
  # Check for uncommitted changes
  if ! git diff --quiet cursor-template/ 2>/dev/null || ! git diff --cached --quiet cursor-template/ 2>/dev/null; then
    echo "⚠️  Uncommitted changes detected:"
    git status --short cursor-template/
    echo ""
    echo "💡 Commit and push with: template-push \"your message\""
  else
    echo "✅ No uncommitted changes"
  fi
  
  # Check for upstream updates
  git fetch template-upstream main --quiet 2>/dev/null || true
  
  if ! git diff --quiet HEAD template-upstream/main -- cursor-template/ 2>/dev/null; then
    echo ""
    echo "📥 Updates available from template:"
    git log --oneline HEAD..template-upstream/main --prefix="cursor-template/" | head -5
    echo ""
    echo "💡 Pull updates with: template-pull"
  else
    echo "✅ Template is up to date"
  fi
  
  echo ""
  echo "🔗 Remote: template-upstream"
  echo "🌿 Branch: main"
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
echo ""
echo "Bidirectional Sync (Subtree):"
echo "  template-init             - Setup template as subtree (bidirectional sync)"
echo "  template-pull              - Pull latest changes from template"
echo "  template-push MSG         - Push your improvements to template"
echo "  template-status           - Check sync status"

