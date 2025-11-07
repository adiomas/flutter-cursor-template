# Accessibility

Build inclusive apps that work for everyone - screen readers, keyboard navigation, and more.

## WCAG 2.1 AA Compliance

### Contrast Ratios
- Normal text: 4.5:1
- Large text (18pt+): 3:1
- UI components: 3:1

### Touch Targets
- Minimum: 44x44pt (iOS) or 48x48dp (Android)
- Spacing: 8pt minimum

## Semantic Labels

```dart
// ❌ BAD
IconButton(
  icon: Icon(Icons.delete),
  onPressed: onDelete,
)

// ✅ GOOD
Semantics(
  label: 'Delete item',
  button: true,
  enabled: true,
  child: IconButton(
    icon: Icon(Icons.delete),
    onPressed: onDelete,
    tooltip: 'Delete item',
  ),
)
```

## Form Accessibility

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Email',
    hintText: 'Enter your email',
    semanticCounterText: 'Email input field',
  ),
)
```

## Screen Reader Support

```dart
Semantics(
  label: 'Profile picture',
  image: true,
  child: CircleAvatar(
    backgroundImage: NetworkImage(url),
  ),
)

// Exclude decorative images
ExcludeSemantics(
  child: Icon(Icons.arrow_forward),
)
```

## Focus Management

```dart
class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  
  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          focusNode: _emailFocus,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            _passwordFocus.requestFocus();
          },
        ),
        TextField(
          focusNode: _passwordFocus,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
```

## Testing Accessibility

```dart
testWidgets('button has semantic label', (tester) async {
  await tester.pumpWidget(MyButton());
  
  final semantics = tester.getSemantics(find.byType(MyButton));
  expect(semantics.label, 'Submit');
});
```

## Best Practices

### ✅ Do
- Add semantic labels
- Test with screen readers
- Support keyboard navigation
- Use sufficient contrast
- Provide large touch targets

### ❌ Don't
- Don't rely on color alone
- Don't skip semantic labels
- Don't ignore focus management
- Don't use small touch targets

---

**Your app is now accessible to everyone!**

