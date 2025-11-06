# Flutter Cursor Elite Template

Elite Cursor setup za Flutter projekte s Context7 integracijom.

## Quick Start

# Opcija 1: Iz lokalne kopije
cp -r ~/flutter-cursor-template/.cursor .
cp ~/flutter-cursor-template/.cursorrules .
cp ~/flutter-cursor-template/.cursorignore .
cp -r ~/flutter-cursor-template/docs .

# Opcija 2: Iz Git-a
git clone https://github.com/tvoj-username/flutter-cursor-template.git .cursor-tmp
cp -r .cursor-tmp/.cursor .cursor-tmp/.cursorrules .cursor-tmp/.cursorignore .
cp -r .cursor-tmp/docs .
rm -rf .cursor-tmp

# Update project context
nano .cursor/notepads/project_context.md## Sadrži

- Context7 integration (@Docs auto-loading)
- Auto-apply rules (flutter_feature, supabase_integration, performance)
- Workflow shortcuts (crud, auth, realtime, upload)
- Complete documentation i templates

## Version

1.0.0 - Initial release
