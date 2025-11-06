# Flutter Cursor Template - Update System

## How It Works

The template update system has two components that work together:

### 1. `update-template.sh` (The Script)
- Main update logic
- Handles file copying, backups, cleanup
- Shows commit info and progress
- Located in template root

### 2. `cursor-update` (The Alias)
- Shell alias defined in `~/.zshrc`
- Downloads latest `update-template.sh` from GitHub
- Runs it automatically
- Always uses the newest version

## Update Flow

```
User runs: cursor-update
    ↓
Alias downloads latest update-template.sh from GitHub
    ↓
Script runs in temporary location (/tmp/)
    ↓
Script clones template repo
    ↓
Updates files (.cursor/, docs/, etc.)
    ↓
Preserves project context
    ↓
Shows commit info and summary
    ↓
Cleanup (removes temp files)
```

## What Gets Updated

### ✅ Always Updated:
- `.cursor/rules/` - AI rules and patterns
- `.cursor/tools/` - Python/Shell utility scripts
- `.cursorrules` - Main AI configuration
- `.cursorignore` - Ignore patterns
- `docs/` - All documentation
- `setup-aliases.sh` - Alias setup script
- `CURSOR_AI_SETUP.md` - Setup guide

### ⊗ Always Preserved:
- `README.md` - Your project README
- `.cursor/notepads/project_context.md` - Your project context
- `pubspec.yaml` - Your dependencies
- `lib/` - Your application code
- All other project files

## Usage

### Option 1: Use Alias (Recommended)
```bash
# From any Flutter project with template installed
cursor-update
```

**Output:**
```
🔄 Downloading latest update script...
🔄 Updating Flutter Cursor Elite Template...
📥 Downloading latest template...
📌 Latest version: a1b2c3d - Added tools update (2 hours ago)

📝 Updating template files...
  ✓ .cursor/rules/ (AI rules)
  ✓ .cursor/tools/ (Python/Shell scripts)
  ✓ .cursorrules (main AI config)
  ...
  ⊗ README.md (preserved - project-specific)
  ⊗ .cursor/notepads/ (preserved - project context)

✅ Template updated successfully!
```

### Option 2: Use Script Directly
```bash
# From project root
./update-template.sh
```

Useful for:
- Testing local script changes
- Debugging update issues
- Offline updates (if you have script locally)

## Benefits of This Architecture

### 1. Single Source of Truth
- `update-template.sh` is the only place with update logic
- No duplication between alias and script
- Easy to maintain and improve

### 2. Always Latest
- Alias downloads fresh script every time
- No need to update alias when script changes
- Users automatically get improvements

### 3. No Sync Issues
- No "outdated alias" problems
- Script and alias always in sync
- One place to fix bugs

### 4. Fast & Reliable
- Uses `raw.githubusercontent.com` (no CDN delay)
- `--depth 1` for fast clones
- Proper error handling

## Troubleshooting

### "Failed to download update script"

**Cause:** Repo is private or doesn't exist on GitHub.

**Solution 1: Make Repo Public (Recommended)**
```bash
# On GitHub.com:
# Settings → General → Danger Zone → Change visibility → Public

# Verify:
curl -I https://github.com/adiomas/flutter-cursor-template
# Expected: HTTP/2 200
```

**Solution 2: Use GitHub Personal Access Token (Private Repo)**
```bash
# 1. Create token: https://github.com/settings/tokens
#    Permissions: repo (Full control of private repositories)

# 2. Set in shell:
export GITHUB_PAT='ghp_yourTokenHere'

# 3. Add to ~/.zshrc for persistence:
echo 'export GITHUB_PAT="ghp_yourTokenHere"' >> ~/.zshrc

# 4. Try update:
cursor-update
```

**Solution 3: Use SSH Clone (Private Repo)**
```bash
# Update update-template.sh to use SSH:
sed -i '' 's|https://github.com/adiomas/flutter-cursor-template.git|git@github.com:adiomas/flutter-cursor-template.git|g' update-template.sh

# Update alias in setup-aliases.sh (same change)

# Requires SSH key setup:
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh
```

### "curl: (56) The requested URL returned error: 404"
```bash
# Repo doesn't exist or is private
# See solutions above
```

### "Not a Flutter project"
```bash
# Make sure you're in Flutter project root
ls pubspec.yaml

# If yes, run update
cursor-update
```

### Updates seem outdated
```bash
# GitHub CDN might be cached (rare with raw.githubusercontent.com)
# Wait 2-3 minutes, then:
cursor-update
```

### Want to see what will be updated?
```bash
# Check latest commit in template repo
curl -s https://api.github.com/repos/adiomas/flutter-cursor-template/commits/main | grep '"message"' | head -1
```

## Development Workflow

### Testing Script Changes

1. **Make changes to `update-template.sh`**
2. **Test locally:**
   ```bash
   cd ~/test-project
   ~/path/to/template/update-template.sh
   ```
3. **Push changes:**
   ```bash
   git add update-template.sh
   git commit -m "Improve update script"
   git push
   ```
4. **Users get it automatically:**
   ```bash
   cursor-update  # Downloads your latest script
   ```

### Updating Alias Logic

1. **Edit `setup-aliases.sh`**
2. **Users re-run setup:**
   ```bash
   source setup-aliases.sh
   # Overwrites old alias
   ```

**Note:** Alias changes require manual re-setup, but script changes are automatic!

## Architecture Decision

**Why this design?**

We considered three approaches:

### ❌ Option 1: Alias calls local script
```bash
cursor-update() {
  ./update-template.sh
}
```
**Problem:** Requires local script, can be outdated

### ❌ Option 2: Duplicate logic in alias
```bash
cursor-update() {
  # 50 lines of update logic here
}
```
**Problem:** Hard to maintain, gets out of sync

### ✅ Option 3: Alias downloads and runs script
```bash
cursor-update() {
  curl script.sh > /tmp/script.sh
  /tmp/script.sh
}
```
**Benefits:** Always fresh, single source of truth, self-updating

## File Structure

```
flutter-cursor-template/
├── update-template.sh      # Main update logic (downloaded by alias)
├── setup-aliases.sh         # Defines cursor-update alias
└── docs/
    └── 26_TROUBLESHOOTING.md  # Troubleshooting guide
```

## Summary

- 🎯 **Use:** `cursor-update` (recommended)
- 🔧 **Logic in:** `update-template.sh`
- 🔄 **Flow:** Alias → Download script → Run script → Update files
- ✅ **Result:** Always latest, no sync issues, easy to maintain

## Important: Repo Visibility

**The update system requires repo to be accessible!**

If you get **404 errors**, your repo is private or doesn't exist.

**Quick fix:**
```bash
# Option 1: Make public (easiest)
GitHub → Settings → Change visibility → Public

# Option 2: Use SSH (private repo)
# Updates scripts to use SSH automatically
# Requires SSH key at: https://github.com/settings/keys

# Option 3: Use PAT (private repo)
export GITHUB_PAT='ghp_yourToken'
echo 'export GITHUB_PAT="ghp_yourToken"' >> ~/.zshrc
```

**See full guide:** `REPO_VISIBILITY_GUIDE.md`

---

**Questions?** See `docs/26_TROUBLESHOOTING.md` or `REPO_VISIBILITY_GUIDE.md`

