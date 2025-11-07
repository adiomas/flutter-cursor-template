# Flutter Cursor Elite Template

> **Elite Cursor setup za Flutter development sa Context7 integracijom**

Setup novi projekt u **< 1 minutu** | Generate feature u **2-5 minuta** | **Production-ready code**

---

## ⚡ Quick Start

### 1. Setup Aliases (Jednom)

```bash
# Pokreni setup script
cd ~/Developer/flutter-cursor-template
bash setup-aliases.sh

# Reload shell
source ~/.zshrc
```

**Ili ručno:** Kopiraj aliase iz sekcije [Aliases](#-aliases) u `~/.zshrc`

### 2. Novi Projekt

**Opcija A: AI-Powered (Preporučeno ⭐)**
```bash
flutter create my_app
cd my_app
cursor-ai-setup "My App" "Description"
cursor .
# ⌘L → ⌘V → Enter (AI postavlja sve automatski!)
```

**Opcija B: Manual**
```bash
flutter create my_app
cd my_app
cursor-setup
nano .cursor/notepads/project_context.md  # Edit project info
cursor .
```

### 3. Update Postojeći Projekt

```bash
cd existing_project
cursor-update
```

> ⚠️ **Ako dobijete 404 error:** Repo mora biti public ili konfigurirajte access!  
> 📖 **Rješenja:** [REPO_VISIBILITY_GUIDE.md](REPO_VISIBILITY_GUIDE.md)

**Update-a:**
- ✅ `.cursor/rules/` - Sve rule fajlove
- ✅ `.cursor/tools/` - Python/Shell scripts
- ✅ `.cursorrules` - AI config
- ✅ `.cursorignore` - Ignore patterns
- ✅ `docs/` - Sva dokumentacija
- ✅ **Zadržava** `project_context.md` (tvoj project-specific info)

**Done!** 🎉

---

## 📦 Što Sadrži

- **`.cursorrules`** - AI config sa Context7 auto-loading
- **`.cursor/rules/`** - Auto-apply patterns (flutter, supabase, performance)
- **`.cursor/notepads/`** - Reusable context (workflow shortcuts, patterns)
- **`docs/`** - Complete documentation i code templates

**Detalji:** [Full Documentation](#-dokumentacija)

---

## 🔧 Aliases

Dodaj u `~/.zshrc`:

```bash
# Manual setup za novi projekt
alias cursor-setup='git clone https://github.com/adiomas/flutter-cursor-template.git .cursor-tmp && cp -r .cursor-tmp/.cursor . && cp .cursor-tmp/.cursorrules . && cp .cursor-tmp/.cursorignore . && cp -r .cursor-tmp/docs . && rm -rf .cursor-tmp && echo "✅ Setup complete! Edit .cursor/notepads/project_context.md"'

# AI-powered setup (kopira prompt u clipboard)
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
3. Update .cursor/notepads/project_context.md (project name, description)
4. Cleanup: rm -rf .cursor-tmp
5. Pokaži summary

@project_context.md @workflow_shortcuts.md

Kreni!" | pbcopy
  echo "✅ Prompt copied! Paste in Cursor (⌘L → ⌘V → Enter)"
}

# Update postojeći projekt
cursor-update() {
  [ -f .cursor/notepads/project_context.md ] && cp .cursor/notepads/project_context.md .cursor/notepads/project_context.md.backup
  git clone https://github.com/adiomas/flutter-cursor-template.git .cursor-tmp
  cp -r .cursor-tmp/.cursor/rules .cursor/ 2>/dev/null || true
  cp .cursor-tmp/.cursorrules . 2>/dev/null || true
  cp .cursor-tmp/.cursorignore . 2>/dev/null || true
  cp -r .cursor-tmp/docs . 2>/dev/null || true
  [ -f .cursor/notepads/project_context.md.backup ] && cp .cursor/notepads/project_context.md.backup .cursor/notepads/project_context.md && rm .cursor/notepads/project_context.md.backup
  rm -rf .cursor-tmp
  echo "✅ Template updated! Project context preserved."
}

# Bidirectional Sync (Subtree)
template-init      # Setup template as subtree
template-pull       # Pull latest changes from template
template-push MSG   # Push your improvements to template
template-status     # Check sync status
```

**📖 Full aliases:** Run `bash setup-aliases.sh` to install all aliases automatically.

---

## 🚀 Korištenje

### Quick Commands (u Cursor chat)

```
crud [entity]       → Complete CRUD feature
auth                → Full authentication system
realtime [feature]  → Realtime subscriptions
upload              → Image/file upload
optimize [target]   → Performance optimization
fix [issue]         → Bug fix with latest docs
```

### Context7 Integration

AI automatski učitava real-time docs:

```
@Docs Flutter ListView.builder
@Docs Supabase authentication
@Docs riverpod provider patterns
```

**Rezultat:** Production-ready code sa latest patterns!

---

## 🔄 Update Workflow

### Kada Template Dobije Update

```bash
# 1. Update template repo
cd ~/Developer/flutter-cursor-template
cp -r ../main_project/.cursor/rules .cursor/
cp ../main_project/.cursorrules .
cp ../main_project/.cursorignore .
cp -r ../main_project/docs .
git add . && git commit -m "Update: XYZ" && git push

# 2. U postojećim projektima
cd existing_project
cursor-update  # Automatski update, zadržava project_context.md
```

---

## 🔄 Bidirectional Sync (NEW! ⭐)

**Push your improvements back to template!**

Omogućava bidirekcionalnu sinkronizaciju između tvog Flutter projekta i template repozitorija. Kada napraviš poboljšanja (nova dokumentacija, bolje rules, optimizacije), možeš ih automatski poslati natrag u template.

### Quick Start

```bash
# 1. Setup bidirectional sync (jednom)
cd my-flutter-app
template-init

# 2. Pull latest changes
template-pull

# 3. Push your improvements
template-push "feat: added new documentation for X"

# 4. Check status
template-status
```

**Što omogućava:**
- ✅ Push poboljšanja natrag u template
- ✅ Pull najnovije promjene iz template
- ✅ Automatska preservacija `project_context.md`
- ✅ Git subtree pristup (čista git history)

**📖 Full Guide:** [BIDIRECTIONAL_SYNC.md](BIDIRECTIONAL_SYNC.md)

**Kompatibilnost:**
- Projekti sa subtree-om mogu koristiti `cursor-update`
- Projekti bez subtree-a (stari način) nastavljaju raditi
- Postupni migration path

---

## 📚 Dokumentacija

### Za Developere

- **[CURSOR_QUICK_ACTIONS.md](docs/CURSOR_QUICK_ACTIONS.md)** - Svi shortcuts i commands
- **[07_FEATURE_TEMPLATE.md](docs/07_FEATURE_TEMPLATE.md)** - Feature implementation guide
- **[REUSABLE_SETUP.md](docs/REUSABLE_SETUP.md)** - Setup za nove projekte

### Za AI

- **`.cursor/notepads/workflow_shortcuts.md`** - Quick commands
- **`.cursor/notepads/context7_patterns.md`** - Context7 patterns
- **`.cursor/rules/*.md`** - Auto-apply rules

---

## 💡 Best Practices

### Project Context

**UVIJEK** editaj `.cursor/notepads/project_context.md` za svaki projekt:
- Project name, description
- Tech stack
- Existing features

**NE** editaj druge notepads - oni su shared!

### Update Strategy

- **Novi projekti:** `cursor-setup` ili `cursor-ai-setup`
- **Postojeći projekti:** `cursor-update` (preserves project_context.md)
- **Template improvements:** Update template repo → `cursor-update` u projektima

---

## 📊 Speed Improvements

| Task | Manual | With Template | Improvement |
|------|--------|---------------|-------------|
| CRUD Feature | 2-4 hours | 2-5 minutes | **24-48x** |
| Auth System | 1-2 days | 5-10 minutes | **144-288x** |
| Bug Fix | 30-60 min | 30 sec - 2 min | **15-120x** |

---

## 🎯 Features

✅ Context7 Integration - Real-time Flutter/Supabase docs  
✅ Auto-Loading - AI automatski učitava relevant docs  
✅ Workflow Shortcuts - `crud`, `auth`, `realtime` commands  
✅ Nested Rules - Auto-apply patterns based on file type  
✅ Performance Rules - Automatic optimization  
✅ Complete Templates - Repository, Notifier, Page, Widget  
✅ Multi-Layer Context - External docs + Project + Rules + Codebase  

---

## 📞 Support

**Questions?**
- `docs/CURSOR_QUICK_ACTIONS.md` - Commands reference
- `docs/REUSABLE_SETUP.md` - Setup guide
- `.cursor/notepads/workflow_shortcuts.md` - Quick commands

**Issues?**
- **404 errors?** → [REPO_VISIBILITY_GUIDE.md](REPO_VISIBILITY_GUIDE.md)
- **Update not working?** → [UPDATE_SYSTEM.md](UPDATE_SYSTEM.md)
- **Bidirectional sync?** → [BIDIRECTIONAL_SYNC.md](BIDIRECTIONAL_SYNC.md)
- Open issue na [GitHub](https://github.com/adiomas/flutter-cursor-template)
- Check template version
- Verify MCP setup (Context7)

---

## 🎉 Result

**Elite Flutter development:**
- Setup novi projekt: **< 1 minuta**
- Generate feature: **2-5 minuta**
- Quality: **Production-ready**
- Patterns: **Latest best practices**

**Happy coding! 🚀**
