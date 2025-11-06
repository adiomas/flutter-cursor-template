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
cursor-setup() {
  echo "🚀 Setting up Flutter Cursor Template..."
  
  # Try clone
  if ! git clone https://github.com/adiomas/flutter-cursor-template.git .cursor-tmp 2>/dev/null; then
    echo "❌ Failed to clone template repo"
    echo ""
    echo "If repo is private, use SSH instead:"
    echo "  git clone git@github.com:adiomas/flutter-cursor-template.git .cursor-tmp"
    echo "  # Then manually: cp -r .cursor-tmp/{.cursor,.cursorrules,.cursorignore,docs} ."
    echo "  # Cleanup: rm -rf .cursor-tmp"
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
  local project_name="${1:-My Flutter App}"
  local project_desc="${2:-Flutter application}"
  
  # Check if repo is accessible
  if ! curl -fsSL "https://raw.githubusercontent.com/adiomas/flutter-cursor-template/main/README.md" -o /dev/null 2>/dev/null; then
    echo "⚠️  Repo appears to be private or inaccessible"
    echo ""
    echo "For private repos, use SSH clone instead:"
    echo "  git clone git@github.com:adiomas/flutter-cursor-template.git .cursor-tmp"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      return 1
    fi
  fi
  
  echo "Postavi Flutter projekt sa Cursor elite template-om:

Template: https://github.com/adiomas/flutter-cursor-template
Project: $project_name
Description: $project_desc

Koraci:
1. Clone: git clone https://github.com/adiomas/flutter-cursor-template.git .cursor-tmp
   (Ako private, koristi: git clone git@github.com:adiomas/flutter-cursor-template.git .cursor-tmp)
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
  # Check if repo is private and needs authentication
  local GITHUB_TOKEN="${GITHUB_PAT:-}"
  local REPO_URL="https://github.com/adiomas/flutter-cursor-template.git"
  local SCRIPT_URL="https://raw.githubusercontent.com/adiomas/flutter-cursor-template/main/update-template.sh"
  local TEMP_SCRIPT="/tmp/cursor-update-$$.sh"
  
  echo "🔄 Downloading latest update script..."
  
  # Try public access first
  if ! curl -fsSL "$SCRIPT_URL" -o "$TEMP_SCRIPT" 2>/dev/null; then
    # If failed, try with token (for private repos)
    if [ -z "$GITHUB_TOKEN" ]; then
      echo "❌ Failed to download update script"
      echo ""
      echo "If this is a private repo, set GITHUB_PAT:"
      echo "  export GITHUB_PAT='your_token_here'"
      echo ""
      echo "Or make repo public on GitHub:"
      echo "  Settings → Danger Zone → Change visibility → Public"
      return 1
    fi
    
    # Try with authentication
    if ! curl -fsSL -H "Authorization: token $GITHUB_TOKEN" "$SCRIPT_URL" -o "$TEMP_SCRIPT"; then
      echo "❌ Failed to download update script (even with token)"
      echo "Check token permissions or repo URL"
      return 1
    fi
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

