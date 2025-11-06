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
# Downloads and runs the latest update script from GitHub
cursor-update() {
  local SCRIPT_URL="https://raw.githubusercontent.com/adiomas/flutter-cursor-template/main/update-template.sh"
  local TEMP_SCRIPT="/tmp/cursor-update-$$.sh"
  
  echo "🔄 Downloading latest update script..."
  
  # Download latest script
  if ! curl -fsSL "$SCRIPT_URL" -o "$TEMP_SCRIPT"; then
    echo "❌ Failed to download update script"
    echo "Check your internet connection or GitHub status"
    return 1
  fi
  
  # Make executable
  chmod +x "$TEMP_SCRIPT"
  
  # Run script
  "$TEMP_SCRIPT"
  local exit_code=$?
  
  # Cleanup
  rm -f "$TEMP_SCRIPT"
  
  return $exit_code
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

