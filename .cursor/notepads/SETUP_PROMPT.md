# AI Setup Prompt Template

Copy and customize this prompt for new projects:

---

**SETUP FLUTTER PROJECT**

Project Details:
- Name: [PROJECT_NAME]
- Description: [PROJECT_DESCRIPTION]
- Main Features: [e.g., auth, booking, chat]

Setup Task:
1. Clone https://github.com/adiomas/flutter-cursor-template.git to .cursor-tmp
2. Copy all configs (.cursor/, .cursorrules, .cursorignore, docs/)
3. Update .cursor/notepads/project_context.md:
  Project Name: [PROJECT_NAME]
Description: [PROJECT_DESCRIPTION]
Existing Features: [] 
4. Remove .cursor-tmp
5. Show setup summary
6. Suggest first features to implement based on description

Load context: @project_context.md @workflow_shortcuts.md

Execute now!

---

