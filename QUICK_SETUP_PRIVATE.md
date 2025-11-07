# Private Repo - Quick Setup

## Problem
- Repo je private → `cursor-update` ne radi
- GitHub vraća 404

## Rješenje: SSH Access

### 1. Check SSH Key
```bash
ls ~/.ssh/id_*.pub
```

**Ako nema output:**
```bash
# Napravi SSH key
ssh-keygen -t ed25519 -C "your@email.com"
# Enter 3x (defaults)

# Kopiraj public key
cat ~/.ssh/id_ed25519.pub
```

### 2. Dodaj na GitHub
```
GitHub.com → Settings → SSH and GPG keys → New SSH key
→ Paste key → Add
```

### 3. Test
```bash
ssh -T git@github.com
# Expected: "Hi username! You've successfully authenticated"
```

### 4. Update Scripts (Optional)
```bash
cd ~/Developer/flutter-cursor-template

# Change HTTPS to SSH
sed -i '' 's|https://github.com/adiomas/flutter-cursor-template.git|git@github.com:adiomas/flutter-cursor-template.git|g' update-template.sh

# Commit
git add update-template.sh
git commit -m "Use SSH for private repo"
git push
```

### 5. Reload Aliases
```bash
cd ~/Developer/flutter-cursor-template
source setup-aliases.sh
```

## Test Update
```bash
cd ~/any-flutter-project
cursor-update
# Should work now! ✅
```

## Summary
**Script automatski pokušava:**
1. HTTPS clone (public repos)
2. SSH clone (private repos) ← Radi ako imaš SSH key

**Samo jednom setup SSH key → sve radi!**
