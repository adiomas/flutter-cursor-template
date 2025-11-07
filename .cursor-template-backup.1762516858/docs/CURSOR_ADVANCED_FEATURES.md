# Cursor Advanced Features - Maximizing AI Power

> **Elite AI integration features for maximum productivity**

## 🎯 Overview

This guide covers **all advanced Cursor features** that dramatically improve AI output quality and development speed.

---

## 📌 @-Symbols (Context References)

Use @ symbols to add specific context to your prompts.

### @Docs - Official Documentation

Access up-to-date API references and guides:

```
@Docs Flutter how to create custom widgets?
@Docs Supabase authentication with Flutter
@Docs Riverpod best practices for state management
```

**When to use:**
- Need current API information
- Framework-specific patterns
- Official best practices

### @Files - Specific File Context

Reference specific files:

```
@lib/features/boats/data/repositories/boat_repository.dart 
Add filtering by price range
```

**When to use:**
- Editing existing files
- Need file-specific context
- Comparing implementations

### @Codebase - Entire Project Context

Search entire codebase:

```
@Codebase Where is authentication handled?
@Codebase Find all uses of BaseNotifier pattern
@Codebase Show me how errors are handled
```

**When to use:**
- Understanding project structure
- Finding patterns across codebase
- Refactoring decisions

### @Folder - Directory Context

Reference entire folders:

```
@lib/features/boats/ Refactor to use new error handling
@lib/theme/ Update color scheme to match new design
```

**When to use:**
- Feature-wide changes
- Module refactoring
- Consistency updates

### @Git - Version Control Context

Reference git changes:

```
@Git Review my last commit
@Git What changed in the last 5 commits?
@Git Compare current branch with main
```

**When to use:**
- Code reviews
- Understanding recent changes
- Debugging regressions

### @Web - Web Search

Search the web for current information:

```
@Web Latest Flutter 3.16 features
@Web Supabase realtime best practices 2025
@Web Flutter performance optimization techniques
```

**When to use:**
- Need current information
- Framework updates
- New packages/libraries

---

## 📝 Notepads - Reusable Context

Notepads store reusable context that AI can reference.

### Location

```
.cursor/notepads/
├── project_context.md        ← Project overview
├── api_patterns.md           ← API conventions
├── common_issues.md          ← Known issues & solutions
└── design_decisions.md       ← Architecture decisions
```

### Usage

```
@project_context.md Add new boat booking feature

@api_patterns.md Implement new endpoint following conventions

@common_issues.md Fix the network timeout issue
```

### Best Practices

**Create notepads for:**
- Project-specific conventions
- Repeated patterns
- Common workflows
- Architecture decisions
- API contracts
- Design guidelines

**Example notepad structure:**

```markdown
# API Patterns

## Authentication
All API calls must include auth token in header:
`Authorization: Bearer {token}`

## Error Responses
All errors follow this format:
{
  "error": {
    "code": "ERROR_CODE",
    "message": "User-friendly message in Croatian"
  }
}

## Pagination
Use limit/offset pattern:
`?limit=20&offset=0`
```

---

## 🎛️ .cursor/rules/ - Nested Project Rules

Advanced rule system for granular control.

### Structure

```
.cursor/rules/
├── flutter_feature.md         ← Feature implementation rules
├── supabase_integration.md    ← Supabase patterns
├── design_system.md            ← UI/UX rules
├── testing.md                  ← Test patterns
└── performance.md              ← Performance standards
```

### Rule Format

```markdown
---
description: Short description of rule
globs:
  - lib/features/**/*.dart      # When to apply this rule
  - lib/common/**/*.dart
alwaysApply: false               # Or true for global rules
---

# Rule Content

Detailed instructions and patterns...

## Code Examples

\```dart
// Example code
\```

## References

@docs/relevant_doc.md
@docs/templates/template.dart
```

### Rule Types

#### 1. Always Apply Rules

```markdown
---
description: Global coding standards
alwaysApply: true
---

- Always use const constructors
- Never use hardcoded strings
- Follow Flutter style guide
```

#### 2. Auto-Attached Rules (Glob Patterns)

```markdown
---
description: Repository patterns
globs:
  - lib/features/**/repositories/*.dart
alwaysApply: false
---

All repositories must:
- Return Either<Failure, T>
- Handle network errors
- Include retry logic
```

#### 3. Agent Requested Rules

```markdown
---
description: Performance optimization patterns
alwaysApply: false
---

AI will automatically load this when:
- Performance issue detected
- Large list rendering
- Image loading optimization needed
```

#### 4. Manual Rules

```markdown
---
description: Specific migration patterns
alwaysApply: false
---

Use @migration_patterns.md when migrating old code
```

---

## 🧠 Memories - Long-Term Context

Cursor can remember project-specific information across sessions.

### Enabling Memories

```
Cursor Settings > Beta > Memories
```

### How It Works

AI automatically stores and recalls:
- Architecture decisions
- Coding preferences
- Project conventions
- Common workflows
- Debugging solutions

### Example Usage

First conversation:
```
User: Why do we use BaseNotifier instead of StateNotifier?
AI: BaseNotifier provides [explanation]
[Memory saved: Project uses BaseNotifier pattern]
```

Later conversation:
```
User: Add new feature for boats
AI: [Automatically uses BaseNotifier without asking]
```

### Manual Memory Management

Create `.cursor/memories/` files:

```markdown
# Project Memories

## Architecture
- We use clean architecture with feature-first structure
- BaseNotifier for all state management
- Either pattern for error handling

## Conventions
- All user-facing text in Croatian
- Error messages must be user-friendly
- Always include loading/error/empty states

## Performance
- Use ListView.builder for lists
- Always cache images
- Pagination for >50 items

## Known Issues
- Supabase timeout on slow connections → Add retry logic
- Image upload fails >5MB → Resize before upload
```

---

## 🎨 Long Context Chat

Enable massive context windows for complex tasks.

### Enable Feature

```
Cursor Settings > Beta > Long Context Chat
```

### Toggle Modes

Press `Ctrl/⌘ + .` to toggle:
- **Normal Chat**: ~20K tokens
- **Long Context**: Up to 500K tokens (gemini-1.5-flash-500k)

### When to Use

**Normal Chat:**
- Quick questions
- Simple edits
- Fast responses needed

**Long Context:**
- Multi-file refactoring
- Architecture planning
- Complex feature implementation
- Reviewing large codebases

### Best Models for Long Context

```
gemini-1.5-flash-500k    → 500K tokens
claude-3-sonnet-200k     → 200K tokens
claude-3.5-sonnet-200k   → 200K tokens
gpt-4o-128k              → 128K tokens
```

---

## 🎼 Composer Mode - Multi-File Editing

Edit multiple files simultaneously.

### Access

```
Ctrl/⌘ + I  → Opens Composer
```

### Features

- Edit multiple files at once
- See changes across files
- Accept/reject per file
- Maintain context across edits

### Usage Example

```
Refactor authentication system:
- Move auth logic from pages to notifier
- Update all pages to use new notifier
- Add loading states to login page
- Update error messages to Croatian
```

Composer will:
1. Identify all affected files
2. Show changes side-by-side
3. Let you accept/reject per file
4. Maintain consistency across changes

---

## 🔍 AI Review - Code Review Automation

Automated code review with AI.

### Access

```
Command Palette > Cursor: AI Review
```

### Review Options

**1. Review Working State**
```
Reviews uncommitted changes
```

**2. Review Diff with Main**
```
Reviews diff between current branch and main
```

**3. Review Last Commit**
```
Reviews last commit changes
```

### Custom Review Instructions

Add to `.cursorrules`:

```markdown
## Code Review Focus

When reviewing code, focus on:

1. **Architecture Compliance**
   - Clean architecture followed?
   - Proper layer separation?
   - BaseNotifier pattern used?

2. **Error Handling**
   - Either pattern used?
   - User-friendly messages?
   - Network errors handled?

3. **Performance**
   - Const constructors?
   - Unnecessary rebuilds?
   - List optimization?

4. **Design System**
   - No hardcoded colors?
   - Proper text styles?
   - Consistent spacing?

5. **Croatian Language**
   - All user text in Croatian?
   - Proper grammar?
   - Professional tone?
```

---

## ⚙️ Cursor Settings Optimization

### Recommended Settings

```json
{
  // Chat Settings
  "cursor.chat.alwaysSearchTheWeb": false,  // Enable only when needed
  "cursor.chat.autoScroll": true,
  "cursor.chat.defaultToNoContext": false,  // Use full context
  
  // Tab Settings
  "cursor.tab.enabled": true,
  "cursor.tab.partialAccepts": true,  // Accept word-by-word
  
  // Model Settings
  "cursor.models.default": "claude-3.5-sonnet",  // Best for Flutter
  "cursor.models.longContext": "gemini-1.5-flash-500k",  // For large contexts
  
  // Beta Features
  "cursor.beta.longContextChat": true,
  "cursor.beta.memories": true,
  "cursor.beta.composer": true,
  
  // Performance
  "cursor.general.disableHttp2": false,  // Enable unless proxy issues
}
```

### Model Selection Strategy

**For Different Tasks:**

```yaml
Quick Edits:
  model: cursor-small
  speed: Fastest
  cost: Free

Complex Features:
  model: claude-3.5-sonnet
  speed: Fast
  quality: Excellent

Large Refactoring:
  model: gemini-1.5-flash-500k
  context: 500K tokens
  use: Long context mode

Code Generation:
  model: gpt-4o
  quality: High
  cost: Moderate
```

---

## 🛠️ MCP (Model Context Protocol) Integration

Enhanced AI capabilities through MCP servers.

### Setup MCP Servers

Create `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your_token"
      }
    }
  }
}
```

### Available MCP Servers

**1. Context7** - Up-to-date documentation
```
@Docs requests powered by Context7
Always current framework docs
```

**2. GitHub** - Repository integration
```
Search issues, PRs, code
Create issues from chat
Review PRs
```

**3. Custom MCP Servers**
```
Create project-specific tools
Integrate with your APIs
Custom workflows
```

---

## 🚀 Advanced Workflows

### 1. Feature Implementation Workflow

```
Step 1: Set Context
@project_context.md @docs/07_FEATURE_TEMPLATE.md

Step 2: Describe Feature
"Treba mi booking system za brodove"

Step 3: Review Plan
AI shows implementation plan → You approve

Step 4: Implementation
AI creates all files following templates

Step 5: Review
Use AI Review to verify quality

Step 6: Test
Request tests: "Add tests for booking repository"
```

### 2. Bug Fix Workflow

```
Step 1: Describe Issue
"App crashuje pri uploadanju velike slike"

Step 2: AI Analyzes
@Codebase Find image upload code
AI identifies issue

Step 3: Solution
AI proposes fix with explanation

Step 4: Apply & Test
Accept changes, verify fix works

Step 5: Add Prevention
"Add validation for image size"
```

### 3. Refactoring Workflow

```
Step 1: Long Context Mode
Enable for large refactoring

Step 2: Describe Goal
"Refactor auth to use new BaseNotifier pattern"

Step 3: Composer Mode
Open Composer for multi-file edit

Step 4: Review Changes
See all changes across files

Step 5: Accept & Verify
Accept changes, run tests
```

---

## 📊 Performance Optimization Tips

### 1. Context Management

**Minimize Token Usage:**
```
- Use .cursorignore to exclude unnecessary files
- Reference specific files instead of @Codebase
- Clear old chat history
- Use notepads for repeated context
```

**Maximize Relevance:**
```
- Use @ symbols for specific context
- Load rules only when needed
- Enable memories for auto-context
- Use long context only when needed
```

### 2. Model Selection

```yaml
Task: Quick edit
Model: cursor-small
Reason: Fast, free, sufficient

Task: Complex feature
Model: claude-3.5-sonnet
Reason: Best for Flutter/Dart

Task: Large refactoring
Model: gemini-1.5-flash-500k
Reason: Massive context window

Task: Code generation
Model: gpt-4o
Reason: High quality output
```

### 3. Rule Optimization

```markdown
# ❌ Bad: Always apply heavy rule
---
alwaysApply: true
---
[10KB of detailed patterns]

# ✅ Good: Targeted rule
---
description: Repository patterns
globs:
  - lib/**/repositories/*.dart
alwaysApply: false
---
[Only load when needed]
```

---

## 🎯 Best Practices Summary

### DO's ✅

1. **Use @-symbols** for specific context
2. **Create notepads** for repeated patterns
3. **Enable memories** for auto-context
4. **Use .cursorignore** to reduce noise
5. **Create nested rules** for granular control
6. **Enable long context** for complex tasks
7. **Use Composer** for multi-file edits
8. **Set up MCP servers** for enhanced capabilities
9. **Choose right model** for the task
10. **Use AI Review** before committing

### DON'Ts ❌

1. **Don't** overload with unnecessary context
2. **Don't** use alwaysApply for everything
3. **Don't** ignore .cursorignore
4. **Don't** use long context for simple tasks
5. **Don't** forget to clear old chats
6. **Don't** hardcode when you can use notepads
7. **Don't** skip model selection
8. **Don't** ignore MCP capabilities
9. **Don't** forget about Composer mode
10. **Don't** skip AI Review

---

## 🚀 Quick Reference

### Keyboard Shortcuts

```
Ctrl/⌘ + L          → Toggle AI pane
Ctrl/⌘ + K          → Inline edit
Ctrl/⌘ + I          → Composer mode
Ctrl/⌘ + Shift + E  → AI fix (on error)
Ctrl/⌘ + .          → Toggle chat modes
Ctrl/⌘ + Alt/Opt + L → Chat history
```

### @-Symbols

```
@Docs         → Official documentation
@Files        → Specific files
@Codebase     → Entire project
@Folder       → Directory context
@Git          → Version control
@Web          → Web search
@notepad.md   → Custom notepads
```

### File Locations

```
/.cursorrules              → Main AI config
/.cursorignore            → Exclude from context
/.cursor/rules/           → Nested rules
/.cursor/notepads/        → Reusable context
/.cursor/memories/        → Long-term memory
~/.cursor/mcp.json        → MCP servers
```

---

**Master these features for 10x faster development!** 🚀

