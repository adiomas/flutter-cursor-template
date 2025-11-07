# Workflow Shortcuts - Quick Commands

Use @workflow_shortcuts.md to enable instant features.

## Quick Feature Commands

### "crud [entity]"
Creates complete CRUD feature with:
- Supabase table schema
- Model, Entity, Repository
- BaseNotifier state management
- List + Details pages
- Full error handling

**Example:**
```
crud tasks
→ Creates complete task management feature
```

### "auth"
Creates complete auth system with:
- Supabase Auth integration
- Login/Register/Forgot Password pages
- Route guards (go_router)
- Secure token storage
- Error handling

**Example:**
```
auth
→ Implements full authentication system
```

### "realtime [entity]"
Adds realtime subscriptions:
- Supabase realtime channel
- Stream-based state management
- Auto-updating UI
- Connection state handling

**Example:**
```
realtime chat
→ Creates chat with live message updates
```

### "upload"
Creates upload feature:
- Image picker integration
- Supabase Storage upload
- Progress indicator
- Error handling
- Image optimization

**Example:**
```
upload
→ Implements image/file upload system
```

## Debugging Shortcuts

### "fix [description]"
Analyzes and fixes issues using:
- @Docs for latest solutions
- @docs/26_TROUBLESHOOTING.md
- Similar code from @Codebase

**Example:**
```
fix "auth token expired error"
→ AI diagnoses and fixes with latest Supabase patterns
```

### "optimize [target]"
Optimizes code using:
- @Docs Flutter performance
- Const constructors
- ListView.builder
- Image caching
- Async optimization

**Example:**
```
optimize boats list
→ Applies ListView.builder, const, caching
```

## Code Generation Shortcuts

### "widget [name] [description]"
Creates reusable widget with:
- Design system applied
- Proper documentation
- Example usage

**Example:**
```
widget BoatCard displays boat info with image and details
→ Creates reusable BoatCard widget
```

### "test [target]"
Generates tests for:
- Repository
- Notifier
- Widget
- Integration flow

**Example:**
```
test boat repository
→ Creates complete test suite
```

## Advanced Workflows

### Context7-Enhanced Feature
```
@workflow_shortcuts.md @Docs Supabase realtime crud messages with live updates
→ Complete CRUD + realtime with latest Supabase patterns
```

### Multi-Source Context
```
@project_context.md @workflow_shortcuts.md auth
→ Auth system perfectly matching project standards
```

### Long Context Refactoring
```
[Cmd + .] optimize entire app performance
→ Multi-file optimization with 500K context
```

## Tips

- Combine with @Docs for latest patterns
- Use @project_context.md for project-specific context
- Enable Long Context (Cmd + .) for complex tasks
- Use Composer (Cmd + I) for multi-file edits

