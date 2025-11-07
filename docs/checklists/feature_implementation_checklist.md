# Feature Implementation Checklist

Use this checklist when implementing a new feature to ensure completeness.

## Planning

- [ ] Feature requirements documented
- [ ] Database schema designed
- [ ] API endpoints defined (if needed)
- [ ] UI mockups/wireframes created
- [ ] Acceptance criteria defined

## Data Layer

- [ ] Model created with JSON serialization
- [ ] Model includes `toDomain()` method
- [ ] Model includes `fromDomain()` factory
- [ ] Repository interface defined
- [ ] Repository implementation created
- [ ] All CRUD operations implemented
- [ ] Error handling implemented
- [ ] Repository provider created
- [ ] `build_runner` executed successfully

## Domain Layer

- [ ] Entity created with Equatable
- [ ] Business logic methods added to entity
- [ ] `copyWith` method implemented
- [ ] `empty()` factory created (if needed)
- [ ] List notifier created
- [ ] Single item notifier created
- [ ] State transitions handled (Loading/Data/Error)
- [ ] Notifier providers created
- [ ] `prepareForBuild` implemented

## Presentation Layer

- [ ] List page created
- [ ] Details/Edit page created
- [ ] Loading shimmer widget created
- [ ] Empty state widget created
- [ ] List item widget created
- [ ] Form widgets created (if needed)
- [ ] Error handling in UI
- [ ] Loading states shown
- [ ] Success/error snackbars implemented
- [ ] Pull-to-refresh implemented
- [ ] Navigation configured

## Routes

- [ ] Routes added to router configuration
- [ ] Route names defined as constants
- [ ] Path parameters configured (if needed)
- [ ] Navigation tested

## Testing

- [ ] Repository unit tests written
- [ ] Notifier unit tests written
- [ ] Widget tests for key components
- [ ] Integration test for main flow
- [ ] All tests passing

## Code Quality

- [ ] No linter warnings
- [ ] Code formatted (`dart format`)
- [ ] Imports organized
- [ ] Unused code removed
- [ ] Comments added for complex logic
- [ ] Constants extracted (no magic values)

## Accessibility

- [ ] Semantic labels added
- [ ] Sufficient color contrast
- [ ] Touch targets >= 44x44pt
- [ ] Screen reader tested
- [ ] Keyboard navigation works

## Performance

- [ ] `const` constructors used where possible
- [ ] No unnecessary rebuilds
- [ ] Images optimized
- [ ] List uses builder pattern
- [ ] No memory leaks (controllers disposed)

## Documentation

- [ ] Feature documented in README (if needed)
- [ ] API changes documented
- [ ] Breaking changes noted
- [ ] Migration guide written (if needed)

## Final Checks

- [ ] Feature works on iOS
- [ ] Feature works on Android
- [ ] Feature works on Web (if applicable)
- [ ] Tested on different screen sizes
- [ ] Tested in dark mode
- [ ] Tested with slow network
- [ ] Tested offline functionality (if applicable)
- [ ] No console errors
- [ ] Build succeeds
- [ ] Ready for code review

---

**Total:** ~40 checklist items for complete feature implementation

