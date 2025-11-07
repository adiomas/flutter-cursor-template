# Bidirectional Template Sync Guide

> **Push your improvements back to template!** 🔄

Omogućava bidirekcionalnu sinkronizaciju između tvog Flutter projekta i `flutter-cursor-template` repozitorija. Kada napraviš poboljšanja (nova dokumentacija, bolje rules, optimizacije), možeš ih automatski poslati natrag u template.

---

## 🎯 Quick Start

### 1. Setup Bidirectional Sync

```bash
# U svom Flutter projektu
cd my-flutter-app
template-init
```

**Što radi:**
- Postavlja template kao git subtree u `cursor-template/`
- Kreira symlink-ove za Cursor IDE kompatibilnost
- Omogućava push/pull operacije

### 2. Pull Latest Changes

```bash
# Dohvati nove promjene iz template
template-pull
```

### 3. Push Your Improvements

```bash
# Pošalji svoje poboljšanja u template
template-push "feat: added new documentation for error handling"
```

### 4. Check Status

```bash
# Provjeri sync status
template-status
```

---

## 📋 Prerequisites

**Prije nego počneš:**

1. ✅ Flutter projekt sa `pubspec.yaml`
2. ✅ Git repository inicijaliziran (`git init`)
3. ✅ Aliases instalirani (`bash setup-aliases.sh`)
4. ✅ Write access na template repository (za push)

---

## 🏗️ Arhitektura

### Struktura Projekta

```
my-flutter-app/
├── lib/                     # Flutter kod (samo u projektu)
├── pubspec.yaml            # Flutter config (samo u projektu)
├── README.md               # Project-specific (samo u projektu)
│
├── cursor-template/         # Subtree root (bidirectional sync)
│   ├── .cursor/            # Sync ↔ template
│   ├── .cursorrules        # Sync ↔ template  
│   ├── .cursorignore       # Sync ↔ template
│   ├── docs/               # Sync ↔ template
│   ├── setup-aliases.sh    # Sync ↔ template
│   └── update-template.sh  # Sync ↔ template
│
├── .cursorrules → cursor-template/.cursorrules  # Symlink
├── .cursor/ → cursor-template/.cursor/          # Symlink
└── docs/ → cursor-template/docs/                # Symlink
```

**Zašto symlinks?**
- Cursor IDE očekuje `.cursorrules` u root-u
- Symlinks omogućuju da fajlovi izgledaju kao da su u root-u
- Promjene se automatski reflektiraju u subtree direktoriju
- Git prati samo subtree, ne symlink-ove

---

## 🔄 Workflow Commands

### `template-init`

**Setup subtree u projektu**

```bash
template-init
```

**Što radi:**
1. Verificira da je projekt Flutter (pubspec.yaml postoji)
2. Verificira da je git repo inicijaliziran
3. Backupuje postojeće template fajlove
4. Dodaje template kao git remote (`template-upstream`)
5. Kreira subtree u `cursor-template/`
6. Kreira symlink-ove za Cursor IDE
7. Ažurira `.gitignore`

**Output:**
```
🚀 Setting up Flutter Cursor Template as Subtree...
📦 Backing up existing template files...
📡 Adding template remote...
📥 Fetching template repository...
🌳 Adding template as subtree...
🔗 Creating symlinks for Cursor IDE...
✅ Subtree setup complete!
```

---

### `template-pull`

**Pulluje najnovije promjene iz template**

```bash
template-pull
```

**Što radi:**
1. Fetcha najnovije promjene iz template remote
2. Pulluje promjene u subtree
3. Preservuje `project_context.md` (ne prepisuje ga)
4. Ažurira symlink-ove automatski

**Output:**
```
🔄 Pulling latest changes from template...
📥 Fetching latest from template repository...
📋 Latest commits in template:
   abc123 - feat: added new documentation
   def456 - fix: improved error handling
🚀 Pull these changes? (y/n)
✅ Template updated successfully!
```

---

### `template-push`

**Pushuje tvoje poboljšanja u template**

```bash
template-push "feat: added analytics guide"
```

**Ili bez argumenta (pita za commit message):**
```bash
template-push
# Enter commit message: feat: improved error handling examples
```

**Što radi:**
1. Provjerava da li ima promjena u `cursor-template/`
2. Prikazuje što će biti pushano
3. Traži potvrdu
4. Commit-a promjene
5. Pushuje u template repository

**Output:**
```
🔍 Checking for changes in cursor-template...
📋 Changes to be pushed:
 M docs/19_MONITORING_ANALYTICS.md
 A docs/20_NEW_GUIDE.md
🚀 Push these changes to template repository? (y/n)
📦 Staging changes...
💾 Committing changes...
🚀 Pushing to template repository...
✅ Changes pushed successfully to template!
```

---

### `template-status`

**Provjeri sync status**

```bash
template-status
```

**Što radi:**
1. Provjerava da li je subtree inicijaliziran
2. Prikazuje uncommitted promjene
3. Provjerava da li ima upstream updates
4. Prikazuje status

**Output:**
```
📊 Template Sync Status

📁 Subtree directory: cursor-template/
⚠️  Uncommitted changes detected:
 M cursor-template/docs/06_ERROR_HANDLING.md

💡 Commit and push with: template-push "your message"

📥 Updates available from template:
   xyz789 - docs: updated performance guide

💡 Pull updates with: template-pull

🔗 Remote: template-upstream
🌿 Branch: main
```

---

## 💡 Use Case Primjeri

### Scenario 1: Dodao si novu dokumentaciju

```bash
# 1. Editaš u svom projektu
nano cursor-template/docs/25_NEW_PATTERN.md

# 2. Vidiš promjene
template-status
# Output: Uncommitted changes detected

# 3. Pushaš u template
template-push "docs: added new pattern guide"
# Output: ✅ Changes pushed successfully!

# 4. U drugim projektima dohvataš
cd ../other-project
template-pull
# Automatski dobija tvoje poboljšanje!
```

---

### Scenario 2: Poboljšao si AI rule

```bash
# 1. Editaš rule
nano cursor-template/.cursor/rules/flutter_feature.md

# 2. Testiraš u projektu
# ... develop feature ...

# 3. Kada je gotovo, pushaš
template-push "feat: improved Flutter feature rule"

# 4. Svi projekti mogu pullati
cd ../project2 && template-pull
cd ../project3 && template-pull
```

---

### Scenario 3: Dnevni workflow

```bash
# Ujutro - pull latest template improvements
template-pull

# Tokom dana - develop u projektu
# Napraviš poboljšanje u docs/

# Navečer - push improvement u template
template-push "feat: added analytics guide"

# Svi drugi projekti mogu pullati:
cd ../project2 && template-pull
```

---

## 🔒 Sigurnosne Mjere

### Što se MOŽE pushati:

✅ `.cursor/*` (svi AI rules, tools, notepads)  
✅ `docs/*` (sva dokumentacija)  
✅ `.cursorrules`  
✅ `.cursorignore`  
✅ Template scripts (`setup-aliases.sh`, `update-template.sh`)

### Što se NE MOŽE pushati:

❌ Project-specific fajlovi (`pubspec.yaml`, `lib/`)  
❌ User secrets (`.env` fajlovi)  
❌ Build artifakti  
❌ `project_context.md` (preservuje se automatski)

**Script automatski provjerava i sprječava pushanje project-specific fajlova.**

---

## 🛠️ Troubleshooting

### "Subtree directory not found"

**Problem:** `template-init` nije pokrenut.

**Rješenje:**
```bash
template-init
```

---

### "Template remote not found"

**Problem:** Remote nije postavljen.

**Rješenje:**
```bash
template-init
```

---

### "Push failed - remote branch has diverged"

**Problem:** Template ima promjene koje nemaju u lokalnom projektu.

**Rješenje:**
```bash
# 1. Pull najnovije promjene
template-pull

# 2. Riješi konflikte ako ih ima
git status

# 3. Push ponovno
template-push "your message"
```

---

### "No changes detected"

**Problem:** Nema promjena u `cursor-template/` direktoriju.

**Rješenje:**
```bash
# Provjeri status
template-status

# Ili provjeri ručno
git status cursor-template/
```

---

### "Failed to access template repository"

**Problem:** Nema pristup template repository-ju.

**Rješenje:**

**Opcija 1: Public Repo**
```bash
# Make repo public on GitHub
# Settings → Change visibility → Public
```

**Opcija 2: SSH Key**
```bash
# Setup SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"
cat ~/.ssh/id_ed25519.pub
# Add to GitHub → Settings → SSH and GPG keys
```

**Opcija 3: Personal Access Token**
```bash
# Create token: https://github.com/settings/tokens
# Permissions: repo (Full control)
export GITHUB_PAT='ghp_yourToken'
echo 'export GITHUB_PAT="ghp_yourToken"' >> ~/.zshrc
```

---

### Symlinks ne rade

**Problem:** Symlink-ovi se ne kreiraju ili ne rade.

**Rješenje:**
```bash
# Ručno kreiranje symlink-ova
rm -rf .cursorrules .cursorignore .cursor docs setup-aliases.sh update-template.sh
ln -s cursor-template/.cursorrules .cursorrules
ln -s cursor-template/.cursorignore .cursorignore
ln -s cursor-template/.cursor .cursor
ln -s cursor-template/docs docs
ln -s cursor-template/setup-aliases.sh setup-aliases.sh
ln -s cursor-template/update-template.sh update-template.sh
```

---

### `project_context.md` se prepisuje

**Problem:** Pull prepisuje `project_context.md`.

**Rješenje:**
Script automatski preservuje `project_context.md`. Ako se i dalje prepisuje:

```bash
# Backup prije pull-a
cp cursor-template/.cursor/notepads/project_context.md project_context.md.backup

# Pull
template-pull

# Restore ako je prepisan
cp project_context.md.backup cursor-template/.cursor/notepads/project_context.md
git add cursor-template/.cursor/notepads/project_context.md
git commit -m "chore: preserve project_context.md"
```

---

## 🔄 Migration iz Starog Sustava

### Stari projekt (clone + copy način)

```bash
cd old-project

# Pretvori u subtree način
template-init

# Sada možeš koristiti bidirectional sync
template-push "migrated to subtree"
```

**Kompatibilnost:**
- `cursor-update` i dalje radi (fallback na stari način)
- Subtree projekti mogu koristiti `cursor-update`
- Postupni migration path

---

## 📚 Best Practices

### 1. Commit Messages

**Dobri primjeri:**
```bash
template-push "feat: added analytics guide"
template-push "docs: improved error handling examples"
template-push "fix: corrected typo in performance guide"
template-push "refactor: reorganized documentation structure"
```

**Loši primjeri:**
```bash
template-push "update"  # Previše kratko
template-push "changes"  # Nejasno
template-push ""  # Prazno
```

### 2. Pull Prije Push-a

**Uvijek pull prije push-a:**
```bash
# 1. Pull latest
template-pull

# 2. Riješi konflikte ako ih ima
git status

# 3. Push svoje promjene
template-push "your message"
```

### 3. Test Prije Push-a

**Testiraj promjene prije pushanja:**
```bash
# 1. Napravi promjene
nano cursor-template/docs/06_ERROR_HANDLING.md

# 2. Testiraj u projektu
# ... develop feature sa novim docs ...

# 3. Kada je sve OK, push
template-push "docs: improved error handling"
```

### 4. Česti Pull

**Pulluj često da imaš najnovije:**
```bash
# Dnevno ili prije većih promjena
template-pull
```

### 5. Backup Prije Većih Promjena

**Backup prije većih operacija:**
```bash
# Backup subtree
cp -r cursor-template cursor-template.backup

# Ili git stash
git stash push -m "backup before template-pull"
template-pull
```

---

## 🎓 Git Subtree Objašnjenje

**Što je git subtree?**

Git subtree omogućava da držiš jedan git repository unutar drugog kao subdirektorij. Za razliku od git submodule-a:

✅ **Subtree:**
- Fajlovi su dio glavnog repo-a
- Jednostavniji workflow
- Nema potrebe za posebnim komandama
- Bidirekcional sync moguć

❌ **Submodule:**
- Fajlovi su referenca na drugi repo
- Kompliciraniji workflow
- Potrebne posebne komande
- Jednosmjerni sync

**Zašto subtree za template?**
- Jednostavno za korištenje
- Bidirekcional sync
- Čista git history
- Nema potrebe za submodulima

---

## 📞 Support

**Pitanja?**
- `template-status` - Provjeri status
- `git log cursor-template/` - Vidi commit history
- `git remote -v` - Provjeri remote-ove

**Problemi?**
- Provjeri [Troubleshooting](#-troubleshooting) sekciju
- Open issue na [GitHub](https://github.com/adiomas/flutter-cursor-template)
- Check template version

---

## 🎉 Rezultat

**Bidirectional sync omogućava:**
- 🔄 Two-way sync: template → projekt → template
- 📝 Dokumentacija se automatski širi na sve projekte
- 🚀 Poboljšanja odmah dostupna svima
- 🔧 Jednostavan workflow (3 komande)
- ✅ Continuous improvement cycle

**Happy coding! 🚀**

