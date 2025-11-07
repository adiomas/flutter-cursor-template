# Reusable Cursor Setup - Za Sve Buduće Projekte

> **Kako prenijeti ovaj elite setup na svaki novi Flutter projekt**

## 🎯 Problem i Rješenje

**Problem:** Svaki put pri novom projektu moraš ručno kopirati sve konfiguracije.

**Rješenje:** Kreirati **template repozitorij** ili **setup script** koji automatski postavlja sve.

---

## 📦 Opcija 1: Template Repozitorij (PREPORUČENO)

### Kreiranje Template Repo

```bash
# 1. Kreiraj novi repozitorij na GitHubu
# Nazovi ga: flutter-cursor-template

# 2. Kopiraj samo konfiguracijske fajlove (ne cijeli projekt)
mkdir flutter-cursor-template
cd flutter-cursor-template

# 3. Kopiraj cursor konfiguracije
cp -r /path/to/current/project/.cursor .
cp /path/to/current/project/.cursorrules .
cp /path/to/current/project/.cursorignore .

# 4. Kopiraj docs folder
cp -r /path/to/current/project/docs .

# 5. Kreiraj README
cat > README.md << 'EOF'
# Flutter Cursor Elite Template

Elite Cursor setup za Flutter development sa:
- Context7 integration
- Auto-loading dokumentacije
- Nested rules
- Workflow shortcuts
- Production-ready templates

## Quick Start

```bash
# Clone template
git clone https://github.com/yourusername/flutter-cursor-template.git

# Copy files to your new Flutter project
cd your-new-flutter-project
cp -r ../flutter-cursor-template/.cursor .
cp ../flutter-cursor-template/.cursorrules .
cp ../flutter-cursor-template/.cursorignore .
cp -r ../flutter-cursor-template/docs .

# Update project_context.md with new project details
nano .cursor/notepads/project_context.md

# Open in Cursor
cursor .
```

## Što Sadrži

- `.cursorrules` - AI agent configuration sa Context7
- `.cursorignore` - Optimizirano za brzinu
- `.cursor/rules/` - Auto-apply rules
- `.cursor/notepads/` - Reusable context
- `docs/` - Sva dokumentacija i templates

EOF

# 6. Git init i push
git init
git add .
git commit -m "Initial flutter cursor template"
git remote add origin https://github.com/yourusername/flutter-cursor-template.git
git push -u origin main
```

### Korištenje Template-a

**Za svaki novi projekt:**

```bash
# 1. Kreiraj Flutter projekt
flutter create my_new_app
cd my_new_app

# 2. Kloniraj template pored projekta
cd ..
git clone https://github.com/yourusername/flutter-cursor-template.git

# 3. Kopiraj sve konfiguracije
cd my_new_app
cp -r ../flutter-cursor-template/.cursor .
cp ../flutter-cursor-template/.cursorrules .
cp ../flutter-cursor-template/.cursorignore .
cp -r ../flutter-cursor-template/docs .

# 4. Updataj project_context.md
nano .cursor/notepads/project_context.md
# Promijeni:
# - Project name
# - Project description
# - Tech stack (ako različit)
# - Existing features

# 5. Otvori u Cursoru
cursor .

# 6. Ready! Sve je konfigurirano!
```

**Vrijeme: ~2 minute**

---

## 📦 Opcija 2: Automatski Setup Script

Kreira script koji automatski postavlja sve.

### Kreiranje Scripta

```bash
# Kreiraj setup script
cat > setup-cursor-elite.sh << 'EOF'
#!/bin/bash

# Flutter Cursor Elite Setup Script
# Usage: ./setup-cursor-elite.sh

echo "🚀 Flutter Cursor Elite Setup"
echo "==============================="

# Check if we're in a Flutter project
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Not a Flutter project (pubspec.yaml not found)"
    exit 1
fi

# URLs to raw files from your template repo
TEMPLATE_REPO="https://raw.githubusercontent.com/yourusername/flutter-cursor-template/main"

echo "📥 Downloading configurations..."

# Create directories
mkdir -p .cursor/rules
mkdir -p .cursor/notepads
mkdir -p docs/templates
mkdir -p docs/checklists
mkdir -p docs/diagrams
mkdir -p docs/examples

# Download .cursorrules
curl -s "$TEMPLATE_REPO/.cursorrules" -o .cursorrules
echo "✓ .cursorrules"

# Download .cursorignore
curl -s "$TEMPLATE_REPO/.cursorignore" -o .cursorignore
echo "✓ .cursorignore"

# Download .cursor/rules/
curl -s "$TEMPLATE_REPO/.cursor/rules/flutter_feature.md" -o .cursor/rules/flutter_feature.md
curl -s "$TEMPLATE_REPO/.cursor/rules/supabase_integration.md" -o .cursor/rules/supabase_integration.md
curl -s "$TEMPLATE_REPO/.cursor/rules/performance_optimization.md" -o .cursor/rules/performance_optimization.md
echo "✓ .cursor/rules/"

# Download .cursor/notepads/
curl -s "$TEMPLATE_REPO/.cursor/notepads/project_context.md" -o .cursor/notepads/project_context.md
curl -s "$TEMPLATE_REPO/.cursor/notepads/workflow_shortcuts.md" -o .cursor/notepads/workflow_shortcuts.md
curl -s "$TEMPLATE_REPO/.cursor/notepads/context7_patterns.md" -o .cursor/notepads/context7_patterns.md
echo "✓ .cursor/notepads/"

# Download docs (samo ključne)
curl -s "$TEMPLATE_REPO/docs/CURSOR_QUICK_ACTIONS.md" -o docs/CURSOR_QUICK_ACTIONS.md
curl -s "$TEMPLATE_REPO/docs/07_FEATURE_TEMPLATE.md" -o docs/07_FEATURE_TEMPLATE.md
# ... add more as needed

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit .cursor/notepads/project_context.md with your project details"
echo "2. Open in Cursor: cursor ."
echo "3. Start building with 'crud [entity]', 'auth', etc."
echo ""
echo "🚀 Happy coding!"

EOF

# Make executable
chmod +x setup-cursor-elite.sh
```

### Korištenje Scripta

```bash
# 1. Kreiraj Flutter projekt
flutter create my_new_app
cd my_new_app

# 2. Download i pokreni script
curl -s https://raw.githubusercontent.com/yourusername/flutter-cursor-template/main/setup-cursor-elite.sh -o setup-cursor-elite.sh
chmod +x setup-cursor-elite.sh
./setup-cursor-elite.sh

# 3. Updataj project context
nano .cursor/notepads/project_context.md

# 4. Otvori u Cursoru
cursor .
```

**Vrijeme: ~1 minuta**

---

## 📦 Opcija 3: NPM Package (Najlakše)

Objavi kao npm package za instant setup.

### Kreiranje Package

```bash
mkdir cursor-elite-flutter
cd cursor-elite-flutter

# Kreiraj package.json
cat > package.json << 'EOF'
{
  "name": "cursor-elite-flutter",
  "version": "1.0.0",
  "description": "Elite Cursor setup for Flutter development",
  "bin": {
    "cursor-elite-setup": "./bin/setup.js"
  },
  "keywords": ["cursor", "flutter", "ai", "development"],
  "author": "Your Name",
  "license": "MIT"
}
EOF

# Kreiraj bin/setup.js
mkdir bin
cat > bin/setup.js << 'EOF'
#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const https = require('https');

console.log('🚀 Flutter Cursor Elite Setup\n');

// Check if pubspec.yaml exists
if (!fs.existsSync('pubspec.yaml')) {
    console.error('❌ Not a Flutter project (pubspec.yaml not found)');
    process.exit(1);
}

// Download function
function download(url, dest) {
    return new Promise((resolve, reject) => {
        https.get(url, (res) => {
            const file = fs.createWriteStream(dest);
            res.pipe(file);
            file.on('finish', () => {
                file.close();
                resolve();
            });
        }).on('error', reject);
    });
}

// Main setup
async function setup() {
    const baseUrl = 'https://raw.githubusercontent.com/yourusername/flutter-cursor-template/main';
    
    // Create directories
    fs.mkdirSync('.cursor/rules', { recursive: true });
    fs.mkdirSync('.cursor/notepads', { recursive: true });
    fs.mkdirSync('docs', { recursive: true });
    
    try {
        await download(`${baseUrl}/.cursorrules`, '.cursorrules');
        console.log('✓ .cursorrules');
        
        await download(`${baseUrl}/.cursorignore`, '.cursorignore');
        console.log('✓ .cursorignore');
        
        // ... download all files
        
        console.log('\n✅ Setup complete!');
        console.log('\nNext steps:');
        console.log('1. Edit .cursor/notepads/project_context.md');
        console.log('2. Open in Cursor: cursor .');
        console.log('3. Start building!\n');
    } catch (error) {
        console.error('❌ Setup failed:', error.message);
        process.exit(1);
    }
}

setup();
EOF

chmod +x bin/setup.js

# Publish to npm
npm publish
```

### Korištenje Package

```bash
# 1. Kreiraj Flutter projekt
flutter create my_new_app
cd my_new_app

# 2. Run setup
npx cursor-elite-flutter

# 3. Update context
nano .cursor/notepads/project_context.md

# 4. Start coding
cursor .
```

**Vrijeme: ~30 sekundi**

---

## 🎯 Što Prenijeti

### Obavezno (Core Setup)

```
.cursorrules                          ← AI configuration
.cursorignore                         ← Performance
.cursor/
  rules/
    flutter_feature.md               ← Feature patterns
    supabase_integration.md          ← DB patterns
    performance_optimization.md      ← Performance rules
  notepads/
    project_context.md               ← Project info (EDIT PER PROJECT)
    workflow_shortcuts.md            ← Quick commands
    context7_patterns.md             ← Context7 patterns
```

### Preporučeno (Full Setup)

```
docs/
  07_FEATURE_TEMPLATE.md             ← Feature guide
  11_DESIGN_SYSTEM.md                ← Design patterns
  CURSOR_QUICK_ACTIONS.md            ← Quick reference
  templates/
    *.dart                           ← Code templates
  checklists/
    feature_implementation_checklist.md
```

### Opcionalno (Project-Specific)

```
docs/
  01-06, 08-10, 12-27                ← Additional guides
  diagrams/                          ← Architecture diagrams
  examples/                          ← Examples
```

---

## 🔄 Održavanje Template-a

### Kada Dodati Nove Featuere

```bash
# 1. Dodaj u main projektu
cd your-main-project
# ... make improvements ...

# 2. Kopiraj u template
cd ../flutter-cursor-template
cp ../your-main-project/.cursorrules .
cp -r ../your-main-project/.cursor .
cp -r ../your-main-project/docs .

# 3. Commit i push
git add .
git commit -m "Update: added XYZ feature"
git push

# 4. Update version (ako npm package)
npm version patch
npm publish
```

### Verzioniranje

```
v1.0.0 - Initial release
v1.1.0 - Added performance_optimization.md
v1.2.0 - Enhanced Context7 patterns
v2.0.0 - Major .cursorrules refactor
```

---

## 💡 Best Practices

### 1. Template Updates

```bash
# Periodically update template with improvements
cd flutter-cursor-template
git pull  # Get latest from your template

# In your project
cp -r ../flutter-cursor-template/.cursor .
# Keep your project_context.md!
```

### 2. Project-Specific Customization

**Ne mijenjaj template fajlove direktno u projektu!**

Umjesto:
```bash
# ❌ BAD
nano .cursor/rules/flutter_feature.md  # Changes lost on update
```

Koristi:
```bash
# ✅ GOOD
# Edit project_context.md for project-specific info
nano .cursor/notepads/project_context.md

# Or create project-specific rule
nano .cursor/rules/my_project_specific.md
```

### 3. Verzija u README

U svakom projektu, dodaj u README:

```markdown
## Cursor Setup

This project uses [Flutter Cursor Elite Template](https://github.com/yourusername/flutter-cursor-template) v1.2.0

To update:
```bash
cd path/to/flutter-cursor-template
git pull
cd -
cp -r path/to/flutter-cursor-template/.cursor .
# Keep your project_context.md!
```
```

---

## 🚀 Moja Preporuka

**Za tebe:**

1. **Kreiraj GitHub Template Repo** (flutter-cursor-template)
   - Push sve `.cursor/`, `.cursorrules`, `.cursorignore`, `docs/`
   - Enable "Template repository" u settings

2. **Za novi projekt:**
   ```bash
   # Use GitHub template
   gh repo create my-new-app --template yourusername/flutter-cursor-template
   
   # Ili clone + copy
   flutter create my-new-app
   cd my-new-app
   git clone https://github.com/yourusername/flutter-cursor-template.git .cursor-template
   cp -r .cursor-template/.cursor .
   cp .cursor-template/.cursorrules .
   cp .cursor-template/.cursorignore .
   cp -r .cursor-template/docs .
   rm -rf .cursor-template
   
   # Edit project context
   nano .cursor/notepads/project_context.md
   
   # Ready!
   cursor .
   ```

3. **Održavanje:**
   - Kada dodaš novi feature ili poboljšanje
   - Update flutter-cursor-template repo
   - Svi budući projekti dobiju nove featuere

**Benefit:**
- Setup novi projekt: **< 2 minute**
- Svi projekti isti standard
- Lako update-ati sve projekte
- Možeš share sa teamom

---

## 📊 Comparison

| Method | Setup Time | Maintenance | Best For |
|--------|-----------|-------------|----------|
| **Manual Copy** | 5-10 min | Hard | Quick test |
| **Template Repo** | 2 min | Easy | Most projects ⭐ |
| **Setup Script** | 1 min | Medium | Automation |
| **NPM Package** | 30 sec | Easy | Public sharing |

---

## ✅ Setup Checklist

Nakon setup-a u novom projektu:

```
□ .cursorrules copied
□ .cursorignore copied  
□ .cursor/rules/ copied
□ .cursor/notepads/ copied
□ docs/ copied (at least CURSOR_QUICK_ACTIONS.md)
□ project_context.md updated with new project info
□ Tested: cursor . opens project
□ Tested: @project_context.md works
□ Tested: @Docs Flutter works (Context7)
□ Tested: Quick command like "crud test" works
```

---

**Rezultat: Elite Cursor setup u svakom projektu za < 2 minute!** 🚀

**Questions?**
- Check template repo README
- Review CURSOR_QUICK_ACTIONS.md
- Test with simple "crud test" command

