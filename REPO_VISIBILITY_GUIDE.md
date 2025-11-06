# Repository Visibility Guide

## Current Status

**Your repo `adiomas/flutter-cursor-template` returns HTTP 404.**

This means it's either:
- 🔒 **Private** (only you can access)
- 🚫 **Doesn't exist** on GitHub
- ⏳ **Not yet pushed** to GitHub

## Why This Matters

The update system (`cursor-update`) downloads files from GitHub using:
```bash
https://raw.githubusercontent.com/adiomas/flutter-cursor-template/main/update-template.sh
```

**If repo is private or missing → 404 → Update fails!**

---

## 🎯 Decision Matrix

### Option 1: Public Repo ✅ (RECOMMENDED)

**When to use:**
- Want others to use your template
- Open source philosophy
- Free GitHub features (Pages, Discussions, Actions unlimited)
- Easiest setup - zero configuration

**How to make public:**

1. **On GitHub.com:**
   ```
   Your Repo → Settings → General → Scroll to bottom
   → Danger Zone → Change visibility → Make public
   ```

2. **Verify:**
   ```bash
   curl -I https://github.com/adiomas/flutter-cursor-template
   # Expected: HTTP/2 200
   ```

3. **Test update:**
   ```bash
   cursor-update
   # Should work immediately!
   ```

**Pros:**
- ✅ `cursor-update` works out-of-the-box
- ✅ Anyone can clone and use
- ✅ No authentication needed
- ✅ GitHub Actions free minutes (2000/month)
- ✅ Community can contribute via PRs

**Cons:**
- ⚠️ Code is visible to everyone
- ⚠️ Can't include secrets (but shouldn't anyway!)

---

### Option 2: Private Repo with PAT 🔐

**When to use:**
- Must keep code private
- Don't want public visibility
- Only you (or your team) use template

**Setup:**

1. **Create GitHub Personal Access Token:**
   - Go to: https://github.com/settings/tokens
   - Click: **Generate new token (classic)**
   - Name: `flutter-template-access`
   - Permissions: ✅ **repo** (Full control of private repositories)
   - Click: **Generate token**
   - **Copy token** (you won't see it again!)

2. **Add token to shell:**
   ```bash
   # For this session only:
   export GITHUB_PAT='ghp_yourActualTokenHere'
   
   # Permanently (add to ~/.zshrc):
   echo 'export GITHUB_PAT="ghp_yourActualTokenHere"' >> ~/.zshrc
   source ~/.zshrc
   ```

3. **Test:**
   ```bash
   cursor-update
   # Will use token automatically if public access fails
   ```

**Pros:**
- ✅ Keep repo private
- ✅ Works from any machine (with token)
- ✅ Can revoke access anytime

**Cons:**
- ⚠️ Need to set token on every machine
- ⚠️ Token has expiration (unless set to never)
- ⚠️ Must secure token (don't commit!)

---

### Option 3: SSH Clone 🔑

**When to use:**
- Already have SSH keys set up
- Don't want to manage tokens
- Private repo for personal use

**Setup:**

1. **Setup SSH keys** (if not done):
   ```bash
   # Check if you have SSH key:
   ls ~/.ssh/id_*.pub
   
   # If not, create one:
   ssh-keygen -t ed25519 -C "your_email@example.com"
   
   # Add to GitHub:
   cat ~/.ssh/id_ed25519.pub
   # Copy output → GitHub → Settings → SSH and GPG keys → New SSH key
   ```

2. **Change repo URL in scripts:**
   ```bash
   cd ~/path/to/flutter-cursor-template
   
   # Update update-template.sh:
   sed -i '' 's|https://github.com/adiomas/|git@github.com:adiomas/|g' update-template.sh
   
   # Update setup-aliases.sh:
   sed -i '' 's|https://github.com/adiomas/|git@github.com:adiomas/|g' setup-aliases.sh
   
   # Commit changes:
   git add update-template.sh setup-aliases.sh
   git commit -m "Use SSH for private repo access"
   git push
   ```

3. **Update aliases on your machine:**
   ```bash
   source setup-aliases.sh  # Reload alias with SSH URL
   ```

4. **Test:**
   ```bash
   cursor-update
   ```

**Pros:**
- ✅ No tokens to manage
- ✅ Works seamlessly with `git` commands
- ✅ More secure than HTTPS

**Cons:**
- ⚠️ Requires SSH key setup on every machine
- ⚠️ Slightly harder for beginners
- ⚠️ Need to update URLs in scripts

---

## 🚀 Recommended Flow

### For Open Source Template (Most Users)

```bash
# 1. Make repo public
GitHub → Settings → Change visibility → Public

# 2. Verify it works
curl -I https://github.com/adiomas/flutter-cursor-template
# HTTP/2 200 ✅

# 3. Test update
cd ~/your-flutter-project
cursor-update
# ✅ Template updated successfully!
```

---

### For Private Template (Personal Use)

**Quick Start (PAT):**
```bash
# 1. Create token: https://github.com/settings/tokens
#    Permissions: repo ✅

# 2. Add to ~/.zshrc
echo 'export GITHUB_PAT="ghp_yourTokenHere"' >> ~/.zshrc
source ~/.zshrc

# 3. Test
cursor-update
```

**Advanced (SSH):**
```bash
# 1. Setup SSH keys (one-time)
ssh-keygen -t ed25519 -C "your@email.com"
cat ~/.ssh/id_ed25519.pub  # Add to GitHub

# 2. Update scripts to use SSH
cd ~/flutter-cursor-template
sed -i '' 's|https://github.com/adiomas/|git@github.com:adiomas/|g' update-template.sh
sed -i '' 's|https://github.com/adiomas/|git@github.com:adiomas/|g' setup-aliases.sh
git add -A && git commit -m "SSH access" && git push

# 3. Reload aliases
source setup-aliases.sh

# 4. Test
cursor-update
```

---

## 🧪 Verification Checklist

Before using template system, verify:

```bash
# ✅ 1. Repo is accessible
curl -I https://github.com/adiomas/flutter-cursor-template
# Expected: HTTP/2 200 (or 301 redirect to 200)

# ✅ 2. Raw files are downloadable
curl -fsSL https://raw.githubusercontent.com/adiomas/flutter-cursor-template/main/README.md | head -5
# Expected: README content

# ✅ 3. Update script is downloadable
curl -fsSL https://raw.githubusercontent.com/adiomas/flutter-cursor-template/main/update-template.sh | head -5
# Expected: #!/bin/bash...

# ✅ 4. Alias is defined
type cursor-update
# Expected: cursor-update is a shell function

# ✅ 5. Test update (in any Flutter project)
cd ~/any-flutter-project
cursor-update
# Expected: ✅ Template updated successfully!
```

---

## 📊 Comparison Table

| Feature | Public Repo | Private + PAT | Private + SSH |
|---------|-------------|---------------|---------------|
| **Zero config** | ✅ | ❌ | ❌ |
| **Anyone can use** | ✅ | ❌ | ❌ |
| **Code visibility** | Public | Private | Private |
| **Multi-machine** | ✅ Easy | ⚠️ Need token | ⚠️ Need SSH |
| **Security** | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Setup time** | 2 min | 5 min | 10 min |
| **Maintenance** | None | Token renewal | SSH key mgmt |

---

## 🎓 Summary

### Quick Answer

**Most users should make repo public:**
- Easiest setup
- Works everywhere
- No authentication needed
- Community benefits

**Keep private only if:**
- Contains proprietary code
- Internal team use only
- Have specific privacy requirements

### Implementation

**Public Repo:**
```bash
# GitHub → Settings → Make public
curl -I https://github.com/adiomas/flutter-cursor-template  # Verify
cursor-update  # Done!
```

**Private Repo (PAT):**
```bash
export GITHUB_PAT='ghp_token'
echo 'export GITHUB_PAT="ghp_token"' >> ~/.zshrc
cursor-update
```

**Private Repo (SSH):**
```bash
# Update scripts to use git@github.com:
sed -i '' 's|https://github.com/adiomas/|git@github.com:adiomas/|g' *.sh
git commit -am "SSH access" && git push
source setup-aliases.sh
cursor-update
```

---

**Next:** Choose your approach and test with `cursor-update`!


