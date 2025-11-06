# Flutter Cursor Elite Template

> **Elite Cursor setup za Flutter development sa Context7 integracijom i AI-powered workflow**

## 🚀 Quick Start

### Setup Alias (Jednom, 2 minute)

Dodaj u `~/.zshrc` ili `~/.bash_profile`:

```bash
# Flutter Cursor Template - Manual Setup
alias cursor-setup='git clone https://github.com/adiomas/flutter-cursor-template.git .cursor-tmp && cp -r .cursor-tmp/.cursor . && cp .cursor-tmp/.cursorrules . && cp .cursor-tmp/.cursorignore . && cp -r .cursor-tmp/docs . && rm -rf .cursor-tmp && echo "✅ Setup complete! Edit .cursor/notepads/project_context.md"'

# Flutter Cursor Template - AI Setup (kopira prompt u clipboard)
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

# Reload shell
source ~/.zshrc
```

### Za Novi Projekt (30 sekundi!)

**Opcija 1: Manual Setup (Brzo)**
```bash
flutter create my_app
cd my_app
cursor-setup
nano .cursor/notepads/project_context.md  # Edit project info
cursor .
```

**Opcija 2: AI-Powered Setup (Najbolje! ⭐)**
```bash
flutter create my_app
cd my_app
cursor-ai-setup "My App" "Description here"
cursor .
# ⌘L → ⌘V → Enter
# AI automatski postavlja sve i update-a project_context.md!
```

---

## 📦 Što Sadrži Template

### Core Configuration
- **`.cursorrules`** - AI agent configuration sa Context7 integration
- **`.cursorignore`** - Optimizirano za brzinu (exclude build files)
- **`.cursor/rules/`** - Auto-apply rules:
  - `flutter_feature.md` - Feature implementation patterns
  - `supabase_integration.md` - Database patterns
  - `performance_optimization.md` - Performance rules
- **`.cursor/notepads/`** - Reusable context:
  - `project_context.md` - Project overview (EDIT PER PROJECT)
  - `workflow_shortcuts.md` - Quick commands (crud, auth, realtime)
  - `context7_patterns.md` - Context7-enhanced patterns

### Documentation
- **`docs/CURSOR_QUICK_ACTIONS.md`** - Master reference za shortcuts
- **`docs/07_FEATURE_TEMPLATE.md`** - Complete feature guide
- **`docs/REUSABLE_SETUP.md`** - Setup guide za buduće projekte
- **`docs/templates/`** - Code templates (repository, notifier, page, etc.)
- **`docs/checklists/`** - Quality checklists

---

## 🔄 Update Postojećih Projekata

### Kada Template Dobije Update

```bash
# 1. U postojećem projektu
cd ~/Developer/my_existing_project

# 2. Clone latest template
git clone https://github.com/adiomas/flutter-cursor-template.git .cursor-tmp

# 3. Backup postojećeg project_context.md (VAŽNO!)
cp .cursor/notepads/project_context.md .cursor/notepads/project_context.md.backup

# 4. Update configs (overwrite)
cp -r .cursor-tmp/.cursor/rules .cursor/
cp .cursor-tmp/.cursorrules .
cp .cursor-tmp/.cursorignore .
cp -r .cursor-tmp/docs .

# 5. Restore project_context.md (tvoj project-specific info)
cp .cursor/notepads/project_context.md.backup .cursor/notepads/project_context.md
rm .cursor/notepads/project_context.md.backup

# 6. Cleanup
rm -rf .cursor-tmp

# 7. Done! Imaš latest template ali zadržao si project-specific info
```

### Automated Update Script

Dodaj u `~/.zshrc`:

```bash
cursor-update() {
  echo "🔄 Updating Cursor template..."
  
  # Backup project context
  if [ -f .cursor/notepads/project_context.md ]; then
    cp .cursor/notepads/project_context.md .cursor/notepads/project_context.md.backup
  fi
  
  # Clone latest
  git clone https://github.com/adiomas/flutter-cursor-template.git .cursor-tmp
  
  # Update files
  cp -r .cursor-tmp/.cursor/rules .cursor/ 2>/dev/null || true
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
```

**Korištenje:**
```bash
cd my_existing_project
cursor-update
```

---

## 🎯 AI-Powered Workflow

### Quick Commands

Nakon setup-a, u Cursor chat možeš koristiti:

```
crud [entity]          → Complete CRUD feature
auth                   → Full authentication system
realtime [feature]     → Realtime subscriptions
upload                 → Image/file upload system
optimize [target]      → Performance optimization
fix [issue]            → Bug fix with latest docs
```

### Context7 Integration

AI automatski učitava real-time dokumentaciju:

```
@Docs Flutter ListView.builder
@Docs Supabase authentication
@Docs riverpod provider patterns
```

### Multi-Layer Context

Za svaki feature, AI automatski kombinuje:
1. **External Docs** (via @Docs) - Latest Flutter/Supabase patterns
2. **Project Context** (@project_context.md) - Your project standards
3. **Auto-Apply Rules** (@.cursor/rules/) - Patterns based on file type
4. **Codebase** - Similar existing implementations

**Rezultat:** Production-ready code sa latest patterns u minutama!

---

## 📚 Dokumentacija

### Za Developere

- **[CURSOR_QUICK_ACTIONS.md](docs/CURSOR_QUICK_ACTIONS.md)** - Svi shortcuts i commands
- **[07_FEATURE_TEMPLATE.md](docs/07_FEATURE_TEMPLATE.md)** - Kako implementirati feature
- **[REUSABLE_SETUP.md](docs/REUSABLE_SETUP.md)** - Setup guide za nove projekte

### Za AI

- **`.cursor/notepads/workflow_shortcuts.md`** - Quick command reference
- **`.cursor/notepads/context7_patterns.md`** - Context7 patterns
- **`.cursor/rules/*.md`** - Auto-apply rules

---

## 🔧 Maintenance

### Kada Poboljšaš Template

```bash
# 1. U main projektu gdje radiš improvements
cd ~/Developer/main_project

# 2. Update template repo
cd ~/Developer/flutter-cursor-template
cp -r ../main_project/.cursor/rules .cursor/
cp ../main_project/.cursorrules .
cp ../main_project/.cursorignore .
cp -r ../main_project/docs .

# 3. Commit i push
git add .
git commit -m "Update: added XYZ feature"
git push

# 4. Svi budući projekti dobiju update!
# Postojeći projekti: koristi cursor-update command
```

### Version History

- **v1.0.0** (2024-11-06) - Initial release
  - Context7 integration
  - Auto-loading documentation
  - Workflow shortcuts
  - Performance optimization rules

---

## 💡 Best Practices

### 1. Project Context

**UVIJEK** editaj `.cursor/notepads/project_context.md` za svaki projekt:
- Project name
- Description
- Tech stack
- Existing features
- Project-specific conventions

**NE** editaj druge notepads - oni su shared!

### 2. Update Strategy

- **Novi projekti:** Koristi `cursor-setup` ili `cursor-ai-setup`
- **Postojeći projekti:** Koristi `cursor-update` (preserves project_context.md)
- **Template improvements:** Update template repo, push, onda `cursor-update` u projektima

### 3. Git Strategy

**Template files u projektu:**
- Možeš commitati (`.cursor/`, `.cursorrules`, `.cursorignore`)
- Ili dodati u `.gitignore` ako ne želiš

**Preporuka:** Commitaj - lakše za team members!

---

## 🎓 Learning Path

1. **Setup** → Koristi `cursor-ai-setup` za novi projekt
2. **Learn** → Pročitaj `docs/CURSOR_QUICK_ACTIONS.md`
3. **Practice** → Probaj `crud test`, `auth`, `realtime chat`
4. **Master** → Koristi `@Docs` za latest patterns
5. **Optimize** → Enable Long Context (⌘.) za complex tasks

---

## 🚀 Features

### What You Get

✅ **Context7 Integration** - Real-time Flutter/Supabase docs  
✅ **Auto-Loading** - AI automatski učitava relevant docs  
✅ **Workflow Shortcuts** - `crud`, `auth`, `realtime` commands  
✅ **Nested Rules** - Auto-apply patterns based on file type  
✅ **Performance Rules** - Automatic optimization patterns  
✅ **Complete Templates** - Repository, Notifier, Page, Widget  
✅ **Quality Checklists** - Feature implementation checklist  
✅ **Multi-Layer Context** - External docs + Project + Rules + Codebase  

### Speed Improvements

| Task | Manual | With Template | Improvement |
|------|--------|---------------|-------------|
| CRUD Feature | 2-4 hours | 2-5 minutes | **24-48x** |
| Auth System | 1-2 days | 5-10 minutes | **144-288x** |
| Bug Fix | 30-60 min | 30 sec - 2 min | **15-120x** |
| Optimization | 2-4 hours | 5-10 minutes | **12-48x** |

---

## 🤝 Contributing

Ako imaš improvements:

1. Test u main projektu
2. Update template repo
3. Commit i push
4. Team members koriste `cursor-update`

---

## 📞 Support

**Questions?**
- Check `docs/CURSOR_QUICK_ACTIONS.md` for commands
- Review `docs/REUSABLE_SETUP.md` for setup
- Read `.cursor/notepads/workflow_shortcuts.md` for quick commands

**Issues?**
- Open issue na GitHub repo
- Check template version
- Verify MCP setup (Context7)

---

## 🎉 Result

**Elite Flutter development sa:**
- Real-time documentation
- Auto-loading patterns
- Ultra-fast feature generation
- Production-ready code
- Latest best practices

**Setup novi projekt: < 1 minuta**  
**Generate feature: 2-5 minuta**  
**Quality: Production-ready**  

**Happy coding! 🚀**
