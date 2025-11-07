# Context7 Integration Patterns

Use @context7_patterns.md for Context7-enhanced development.

## Real-Time Documentation Workflow

### Before Every Implementation

```typescript
Step 1: User describes feature
Step 2: AI identifies frameworks needed
Step 3: AI loads @Docs for each framework
Step 4: AI loads project templates
Step 5: AI implements with combined knowledge
```

### Framework Detection

```yaml
Flutter Widgets:
  Keywords: widget, UI, layout, screen, page
  Auto-Load: @Docs Flutter [widget_type]

Supabase Operations:
  Keywords: database, query, auth, storage, realtime
  Auto-Load: @Docs Supabase Flutter [operation]

State Management:
  Keywords: state, notifier, provider
  Auto-Load: @Docs riverpod [pattern]

Performance:
  Keywords: performance, optimize, slow, lag
  Auto-Load: @Docs Flutter performance optimization
```

## Context7-Enhanced Debugging

### Error Resolution Pattern

```
1. User reports error
2. AI loads @Docs for error type
3. AI checks @docs/26_TROUBLESHOOTING.md
4. AI searches @Codebase for similar issues
5. AI applies fix with explanation
```

**Example:**
```
Error: "Late initialization error in BaseNotifier"

AI Process:
→ @Docs riverpod initialization patterns
→ @docs/05_STATE_MANAGEMENT.md
→ @Codebase search for similar BaseNotifier usage
→ Fix: Add prepareForBuild() call
```

### Performance Analysis Pattern

```
1. User mentions performance issue
2. AI loads @Docs Flutter performance
3. AI analyzes code patterns
4. AI applies optimizations
5. AI explains improvements
```

**Example:**
```
"Boats list is slow"

AI Process:
→ @Docs Flutter ListView.builder
→ @Docs Flutter const constructors
→ Analyzes current list implementation
→ Applies: ListView.builder + const + caching
→ Explains: "Reduced rebuilds by 90%"
```

## Multi-Source Context Assembly

### Complete Feature Implementation

```yaml
Sources Combined:
  1. @Docs Flutter - Latest widget patterns
  2. @Docs Supabase - Current API methods
  3. @project_context.md - Project conventions
  4. @docs/templates/ - Code templates
  5. @.cursor/rules/ - Auto-apply patterns
  6. @Codebase - Existing similar code

Result: Production-ready code with:
  - Latest best practices
  - Project standards applied
  - Consistent with existing code
  - Fully tested and documented
```

### Example: Chat Feature

```
User: "Treba mi chat s realtime updates"

AI Auto-Loads:
✓ @Docs Supabase realtime subscriptions
✓ @Docs Supabase storage (for media)
✓ @Docs Flutter ListView performance
✓ @project_context.md
✓ @docs/07_FEATURE_TEMPLATE.md
✓ @.cursor/rules/flutter_feature.md
✓ @.cursor/rules/supabase_integration.md

AI Creates:
→ Database schema (messages, chats tables)
→ RLS policies
→ Realtime subscription logic
→ ChatModel + ChatEntity
→ ChatRepository with streaming
→ ChatsListNotifier + ChatNotifier
→ ChatsListPage + ChatPage
→ MessageBubble + MessageInput widgets
→ Image upload integration
→ All error handling
→ All loading states
→ Croatian error messages
→ Design system applied

Time: ~3 minutes
Quality: Production-ready
```

## Advanced Patterns

### Context Layering Strategy

**Layer 1: Always Load**
```
@project_context.md
@.cursor/rules/ (glob-matched)
```

**Layer 2: Intent-Based**
```
if (CRUD) → @docs/07_FEATURE_TEMPLATE.md
if (auth) → @Docs Supabase authentication
if (performance) → @Docs Flutter performance
```

**Layer 3: Specific Context**
```
@Docs [specific query based on exact need]
@Codebase [search for similar patterns]
```

### Context7 + Long Context Mode

For complex multi-file refactoring:

```
1. Enable Long Context (Cmd + .)
2. Load context:
   @Docs Supabase [new patterns]
   @Codebase [current implementation]
3. Request refactoring
4. AI processes 500K tokens
5. Use Composer (Cmd + I) to review all changes
```

**Example:**
```
[Cmd + .] 
@Docs Supabase Flutter authentication latest patterns
@Codebase auth

"Refactor entire auth system to use new Supabase v2 patterns"

→ AI analyzes all auth-related files
→ Updates to latest patterns from @Docs
→ Shows all changes in Composer
→ Maintains project standards
```

### Context7 + Memories

Over time, AI learns:
- Your coding style
- Project patterns
- Common workflows
- Preferred solutions

**First Session:**
```
User: "Implement boat booking"
AI: Loads all context, creates feature
```

**Later Sessions:**
```
User: "Implement car rental booking"
AI: Remembers boat booking patterns
   → Applies same architecture
   → Uses similar UI patterns
   → Faster implementation
```

## Best Practices

### DO ✅

1. **Combine Sources**
   ```
   @Docs Flutter ListView @project_context.md optimize boats list
   → Latest patterns + project standards
   ```

2. **Use Specific Queries**
   ```
   @Docs Supabase realtime subscriptions with error handling
   → Targeted, relevant docs
   ```

3. **Layer Context Progressively**
   ```
   Start: @project_context.md
   Add: @Docs for specific frameworks
   Refine: @Codebase for existing patterns
   ```

### DON'T ❌

1. **Overload Context**
   ```
   ❌ Loading 10 different @Docs at once
   ✅ Load specific docs for current task
   ```

2. **Forget Project Context**
   ```
   ❌ @Docs Flutter only
   ✅ @Docs Flutter + @project_context.md
   ```

3. **Skip Verification**
   ```
   After implementation, verify:
   - All layers present
   - Design system used
   - Error handling complete
   - Croatian messages
   ```

## Quick Reference

| Task | Context to Load |
|------|----------------|
| New CRUD Feature | @project_context.md @Docs Supabase @workflow_shortcuts.md |
| Fix Bug | @Docs [error type] @docs/26_TROUBLESHOOTING.md |
| Optimize Code | @Docs Flutter performance @.cursor/rules/performance_optimization.md |
| Refactor Multi-File | [Cmd + .] @Docs [new patterns] @Codebase |
| Learn Pattern | @Docs [topic] @Codebase [similar code] |

## Success Indicators

✅ Zero manual doc searches  
✅ Consistent code quality  
✅ Latest framework patterns  
✅ Project standards applied  
✅ Fast implementation  
✅ Production-ready code  

**Result: 10-25x faster development with elite quality!** 🚀

