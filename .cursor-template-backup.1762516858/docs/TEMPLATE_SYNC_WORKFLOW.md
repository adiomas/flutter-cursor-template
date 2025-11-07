# Template Repo Sync Workflow

**Workflow za sinkronizaciju dokumentacije i Cursor konfiguracije s template repo-om.**

## 🎯 Problem

Imaš zasebni GitHub repo `flutter-cursor-template` koji sadrži:
- Dokumentaciju (`docs/`)
- Cursor konfiguracije (`.cursor/`, `.cursorrules`, `.cursorignore`)

Želiš moći:
1. ✅ Pull-ati najnovije promjene iz template repo-a
2. ✅ Push-ati svoje promjene natrag na template repo
3. ✅ Zadržati project-specific fajlove (npr. `project_context.md`)

## 🚀 Setup (Jednom)

### 1. Konfiguriraj Template Remote

```bash
# U svom projektu (glow_ai)
bash .cursor/tools/template-sync-setup.sh
```

Ovo će:
- Dodati git remote `template` koji pokazuje na `flutter-cursor-template` repo
- Konfigurirati sve potrebno za sync

### 2. Dodaj Aliases (Opcijski)

Dodaj u `~/.zshrc`:

```bash
# Template repo sync aliases
alias template-pull='bash .cursor/tools/template-pull.sh'
alias template-push='bash .cursor/tools/template-push.sh'
alias template-status='bash .cursor/tools/template-status.sh'
alias template-diff='bash .cursor/tools/template-diff.sh'
```

Reload shell:
```bash
source ~/.zshrc
```

## 📥 Pull Promjene iz Template Repo-a

Kada template repo dobije update:

```bash
# Opcija 1: Koristi alias
template-pull

# Opcija 2: Direktno
bash .cursor/tools/template-pull.sh
```

**Što radi:**
1. Fetch-uje najnovije promjene iz template repo-a
2. Merge-uje promjene u tvoj projekt
3. **Zadržava** `project_context.md` (project-specific)
4. Backup-uje project-specific fajlove prije merge-a

**Nakon pull-a:**
```bash
# Review changes
git status

# Commit ako sve izgleda dobro
git commit -m "Update: Sync with template repo"
```

## 📤 Push Promjene na Template Repo

Kada napraviš promjene u dokumentaciji ili konfiguraciji:

```bash
# Opcija 1: Koristi alias
template-push

# Opcija 2: Direktno
bash .cursor/tools/template-push.sh
```

**Što radi:**
1. Prikazuje što će biti push-ano
2. Traži potvrdu
3. Push-uje samo template-related fajlove:
   - `.cursor/rules/`
   - `.cursor/tools/`
   - `docs/`
   - `.cursorrules`
   - `.cursorignore`
4. **NE push-uje** project-specific fajlove

**Važno:**
- Samo push-uje promjene u template-related fajlovima
- Ne overwrite-uje project-specific content
- Kreira commit sa timestamp-om

## 📊 Provjeri Status

```bash
# Opcija 1: Koristi alias
template-status

# Opcija 2: Direktno
bash .cursor/tools/template-status.sh
```

Prikazuje:
- Lokalne promjene koje nisu u template repo-u
- Template promjene koje nisu u lokalnom projektu
- Status fajlova

## 🔍 Detaljni Diff

```bash
# Opcija 1: Koristi alias
template-diff

# Opcija 2: Direktno
bash .cursor/tools/template-diff.sh
```

Prikazuje detaljne razlike između lokalnog projekta i template repo-a.

## 🔄 Tipičan Workflow

### Scenario 1: Template Repo Dobio Update

```bash
# 1. Pull najnovije promjene
template-pull

# 2. Review changes
git status
git diff

# 3. Commit ako sve OK
git commit -m "Update: Sync with template"

# 4. Test da sve radi
# (npr. pokreni app, provjeri da AI radi kako treba)
```

### Scenario 2: Napravio Promjene u Dokumentaciji

```bash
# 1. Napravi promjene u docs/ ili .cursor/
# (npr. dodaj novi dokument, update-aj rule)

# 2. Provjeri status
template-status

# 3. Push na template repo
template-push

# 4. Provjeri na GitHub-u
# https://github.com/adiomas/flutter-cursor-template
```

### Scenario 3: Konflikt Resolucija

Ako imaš konflikte pri pull-u:

```bash
# 1. Pull pokušaj
template-pull

# 2. Ako ima konflikata, resolve ručno
git status  # Vidi koje fajlove imaju konflikte
# Edit fajlove, resolve konflikte

# 3. Commit
git add .
git commit -m "Resolve: Template sync conflicts"

# 4. Restore project-specific files ako treba
cp .template-backup/project_context.md.backup .cursor/notepads/project_context.md
```

## 🛡️ Što je Zaštićeno

**Project-specific fajlovi koji se NE sync-aju:**
- `.cursor/notepads/project_context.md` - Tvoj project-specific info
- Sve ostalo u projektu (lib/, test/, itd.)

**Template fajlovi koji SE sync-aju:**
- `.cursor/rules/` - Auto-apply rules
- `.cursor/tools/` - Utility scripts
- `docs/` - Dokumentacija
- `.cursorrules` - AI config
- `.cursorignore` - Ignore patterns

## ⚠️ Best Practices

### 1. Commit Lokalne Promjene Prije Pull-a

```bash
# Prije pull-a, commit-aj svoje promjene
git add .
git commit -m "My local changes"

# Onda pull
template-pull
```

### 2. Review Promjene Prije Push-a

```bash
# Provjeri što će biti push-ano
template-status

# Ili detaljno
template-diff

# Tek onda push
template-push
```

### 3. Ne Push-uj Project-Specific Promjene

**NE push-uj:**
- Promjene u `project_context.md`
- Promjene u `lib/`, `test/`, itd.
- Project-specific konfiguracije

**Push-uj samo:**
- Dokumentaciju (`docs/`)
- Cursor rules (`.cursor/rules/`)
- Utility scripts (`.cursor/tools/`)
- Cursor config (`.cursorrules`, `.cursorignore`)

### 4. Backup Prije Većih Promjena

```bash
# Backup project-specific files
cp .cursor/notepads/project_context.md .cursor/notepads/project_context.md.backup

# Napravi promjene
# ...

# Restore ako treba
cp .cursor/notepads/project_context.md.backup .cursor/notepads/project_context.md
```

## 🐛 Troubleshooting

### Problem: "Template remote not configured"

**Rješenje:**
```bash
bash .cursor/tools/template-sync-setup.sh
```

### Problem: "Permission denied" pri push-u

**Rješenje:**
- Provjeri da imaš write access na `flutter-cursor-template` repo
- Provjeri GitHub credentials:
  ```bash
  git config --global user.name
  git config --global user.email
  ```

### Problem: Merge konflikti

**Rješenje:**
1. Resolve konflikte ručno
2. Commit
3. Restore project-specific files ako treba

### Problem: Push-ao project-specific fajlove

**Rješenje:**
1. Revert commit na template repo-u
2. Koristi `template-push.sh` koji automatski filtrira fajlove

## 📚 Related Documents

- **Template Repo:** https://github.com/adiomas/flutter-cursor-template
- **REUSABLE_SETUP.md** - Kako koristiti template za nove projekte
- **UPDATE_SYSTEM.md** - Update workflow za template

---

**Sada možeš sinkronizirati dokumentaciju između projekta i template repo-a! 🎉**

