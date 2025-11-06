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

# Flutter Cursor Template - Manual Setup
alias cursor-setup='git clone https://github.com/adiomas/flutter-cursor-template.git .cursor-tmp && cp -r .cursor-tmp/.cursor . && cp .cursor-tmp/.cursorrules . && cp .cursor-tmp/.cursorignore . && cp -r .cursor-tmp/docs . && rm -rf .cursor-tmp && echo "✅ Setup complete! Edit .cursor/notepads/project_context.md"'

# Flutter Cursor Template - AI Setup (copies prompt to clipboard)
cursor-ai-setup() {
  local project_name="${1:-My Flutter App}"
  local project_desc="${2:-Flutter application}"
  echo "Postavi Flutter projekt sa Cursor elite template-om:

Template: https://github.com/adiomas/flutter-cursor-template
Project: $project_name
Description: $project_desc

Koraci:
1. Clone: git clone https://github.com/adiomas/flutter-cursor-template.git .cursor-tmp
2. Copy: cp -r .cursor-tmp/{.cursor,.cursorrules,.cursorignore,docs} .
3. Update .cursor/notepads/project_context.md:
   - Project name → \"$project_name\"
   - Description → \"$project_desc\"
   - Tech stack ako različit
   - Existing features → []
4. Cleanup: rm -rf .cursor-tmp
5. Pokaži summary što je postavljeno

@project_context.md @workflow_shortcuts.md

Kreni!" | pbcopy
  echo "✅ Prompt copied to clipboard!"
  echo "📋 Paste in Cursor chat (⌘L → ⌘V → Enter)"
}

# Flutter Cursor Template - Update existing project
cursor-update() {
  echo "🔄 Updating Cursor template..."
  
  # Backup project context
  if [ -f .cursor/notepads/project_context.md ]; then
    cp .cursor/notepads/project_context.md .cursor/notepads/project_context.md.backup
  fi
  
  # Clone latest
  git clone https://github.com/adiomas/flutter-cursor-template.git .cursor-tmp
  
  # Update files - kopiraj SVE iz .cursor/ osim project_context.md
  if [ -d .cursor-tmp/.cursor ]; then
    # Kopiraj rules
    cp -r .cursor-tmp/.cursor/rules .cursor/ 2>/dev/null || true
    
    # Kopiraj notepads (osim project_context.md koji ćemo restore-ati)
    mkdir -p .cursor/notepads
    for file in .cursor-tmp/.cursor/notepads/*; do
      if [ -f "$file" ] && [ "$(basename "$file")" != "project_context.md" ]; then
        cp "$file" .cursor/notepads/ 2>/dev/null || true
      fi
    done
    
    # Kopiraj tools folder ako postoji
    if [ -d .cursor-tmp/.cursor/tools ]; then
      cp -r .cursor-tmp/.cursor/tools .cursor/ 2>/dev/null || true
    fi
  fi
  
  # Update root config files
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
  echo "📋 Updated: rules, notepads, tools, docs, configs"
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

