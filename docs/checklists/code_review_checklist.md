# Code Review Checklist

Use this checklist when reviewing pull requests.

## General

- [ ] Code follows project conventions
- [ ] No unnecessary code changes
- [ ] Commit messages are clear
- [ ] Branch is up to date with main
- [ ] No merge conflicts
- [ ] CI/CD pipeline passes

## Code Quality

- [ ] Code is readable and maintainable
- [ ] No code duplication
- [ ] Functions are small and focused
- [ ] Variable names are descriptive
- [ ] No magic numbers or strings
- [ ] Constants are properly defined
- [ ] No commented-out code

## Architecture

- [ ] Follows clean architecture layers
- [ ] Dependency injection used properly
- [ ] No circular dependencies
- [ ] Separation of concerns maintained
- [ ] Repository pattern followed
- [ ] State management pattern followed

## Error Handling

- [ ] All errors are caught and handled
- [ ] User-friendly error messages
- [ ] Either pattern used in repositories
- [ ] Failure types are appropriate
- [ ] No silent error swallowing
- [ ] Loading states handled
- [ ] Error states shown in UI

## Performance

- [ ] No unnecessary rebuilds
- [ ] `const` constructors used
- [ ] Resources are disposed
- [ ] No memory leaks
- [ ] Images are optimized
- [ ] Lists use builder pattern
- [ ] No blocking operations on main thread

## Testing

- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Integration tests added (if needed)
- [ ] All tests pass
- [ ] Code coverage maintained/improved
- [ ] Edge cases tested

## UI/UX

- [ ] UI matches design mockups
- [ ] Responsive on all screen sizes
- [ ] Works in dark mode
- [ ] Loading states are shown
- [ ] Empty states are handled
- [ ] Error states are handled
- [ ] Animations are smooth
- [ ] Touch targets are adequate

## Accessibility

- [ ] Semantic labels present
- [ ] Color contrast sufficient
- [ ] Screen reader compatible
- [ ] Keyboard navigation works

## Security

- [ ] No sensitive data logged
- [ ] API keys not hardcoded
- [ ] User input validated
- [ ] SQL injection prevented
- [ ] No security vulnerabilities

## Documentation

- [ ] Code is self-documenting
- [ ] Complex logic has comments
- [ ] Public APIs documented
- [ ] README updated (if needed)
- [ ] Breaking changes documented

## Platform Specific

### iOS
- [ ] Builds successfully
- [ ] No warnings
- [ ] Permissions properly requested

### Android
- [ ] Builds successfully
- [ ] No warnings
- [ ] Permissions properly requested

### Web (if applicable)
- [ ] Builds successfully
- [ ] No console errors
- [ ] Responsive layout

## Final Check

- [ ] Manually tested the feature
- [ ] Checked on multiple devices
- [ ] No regressions in existing features
- [ ] Performance is acceptable
- [ ] Ready to merge

---

**Reviewer Signature:** _______________  
**Date:** _______________

