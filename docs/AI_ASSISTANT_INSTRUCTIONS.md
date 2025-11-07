# AI Assistant Instructions

> **Za AI:** Ovo su upute kako procesirati zahtjeve koristeći Elite Flutter Framework.

## Workflow kada korisnik napravi zahtjev

### 1. Prepoznaj Tip Zahtjeva

Kada korisnik kaže bilo što tipa:
- "Trebam..."
- "Dodaj..."
- "Kreiraj..."
- "Ispravi..."
- "Želim..."
- "Može li se..."

**→ Automatski aktiviraj ovaj workflow**

### 2. Analiza Zahtjeva (Silent - ne prikazuj korisniku)

```
STEP 1: Identify Intent
- Nova feature?
- Extension postojećeg?
- Bug fix?
- UI change?
- Performance?

STEP 2: Extract Entities
- Feature name (infer if not explicit)
- Affected modules/files
- Data requirements
- UI requirements

STEP 3: Map to Framework
- Koji docs su relevantni? (07_FEATURE_TEMPLATE.md, 04_CLEAN_ARCHITECTURE.md, itd.)
- Koji templates trebam? (repository, notifier, page, widget?)
- Koje fajlove trebam pročitati?
```

### 3. Automatsko Prikupljanje Konteksta

**Bez pitanja korisniku, automatski:**

```python
# 1. Pronađi relevantne fajlove
if "boats" in request:
    read_files = [
        "lib/features/boats/**/*.dart",
        "lib/common/presentation/widgets/*.dart"
    ]

# 2. Provjeri postojeće patterne
codebase_search("How is similar feature implemented?")

# 3. Provjeri database schema
grep("CREATE TABLE") in migrations/

# 4. Provjeri postojeće routes
grep("routeName") in affected_feature/
```

### 4. Kreiraj Plan (Pokaži korisniku)

```markdown
## 🎯 Plan za: [Feature Name]

**Tip:** [Nova feature/Bug fix/etc.]
**Kompleksnost:** [Simple/Medium/Complex]
**Procjena:** [XX minuta]

### Što ću napraviti:
1. [Clear step]
2. [Clear step]
3. [Clear step]

### Fajlovi koje ću kreirati/mijenjati:
- `path/to/file.dart` - [Razlog]
- `path/to/another.dart` - [Razlog]

### Template koji koristim:
- [07_FEATURE_TEMPLATE.md]
- [templates/repository_template.dart]

**Nastavljam s implementacijom?** (da/prilagodi plan)
```

### 5. Implementacija

**Koristi Elite Flutter Framework:**

1. **Data Layer:**
   - Koristi `templates/model_template.dart`
   - Koristi `templates/repository_template.dart`
   - Follow `09_DATA_LAYER.md`

2. **Domain Layer:**
   - Koristi `templates/entity_template.dart`
   - Koristi `templates/notifier_template.dart`
   - Follow `05_STATE_MANAGEMENT.md`

3. **Presentation Layer:**
   - Koristi `templates/page_template.dart`
   - Koristi `templates/widget_template.dart`
   - Follow `10_UI_COMPONENT_LIBRARY.md` i `11_DESIGN_SYSTEM.md`

4. **Testing:**
   - Koristi `templates/test_template.dart`
   - Follow `14_TESTING_STRATEGY.md`

### 6. Verification

Po završetku:

```markdown
## ✅ Implementacija Završena

**Kreirani fajlovi:**
- [Lista fajlova]

**Promijenjeni fajlovi:**
- [Lista fajlova]

**Što testirati:**
1. [Test case]
2. [Test case]

**Next steps:**
- [ ] Run `flutter pub get`
- [ ] Run `dart run build_runner build`
- [ ] Test feature manually
- [ ] Run tests: `flutter test`

**Checklist:** Koristi `checklists/feature_implementation_checklist.md`
```

## Context Resolution Matrix

### Korisnik kaže → AI akcija

| User Input | Auto Detect | Read Files | Use Templates | Docs Reference |
|------------|-------------|------------|---------------|----------------|
| "Nova stranica za X" | Page creation | Related pages | page, widget | 07, 10 |
| "Dodaj polje u formu" | UI extension | Form files | widget | 10, 11 |
| "API za X" | Repository | Similar repos | repository, model | 09 |
| "Bug u X" | Bug fix | Affected file | - | 26 |
| "Loading state" | UI enhancement | Related page | widget | 10, 12 |
| "Filter po X" | Feature extension | List page | widget | 07 |

## Intelligent File Discovery

### Automatski pronađi relevantne fajlove:

```python
def discover_relevant_files(request):
    """Automatski pronađi koje fajlove treba pročitati"""
    
    # Extract feature name
    feature = extract_feature_name(request)
    
    files_to_read = []
    
    # 1. Check if feature exists
    if exists(f"lib/features/{feature}/"):
        files_to_read.extend(glob(f"lib/features/{feature}/**/*.dart"))
    
    # 2. Check similar patterns
    similar = codebase_search(f"Similar implementation to {request}")
    files_to_read.extend(similar.files)
    
    # 3. Check dependencies
    if "database" in request or "API" in request:
        files_to_read.append("lib/common/data/supabase_service.dart")
    
    if "navigation" in request:
        files_to_read.append("lib/common/domain/router/routes.dart")
    
    if "form" in request:
        files_to_read.extend(glob("lib/common/presentation/widgets/*input*.dart"))
    
    return files_to_read
```

## Response Templates

### Za novu feature:

```
Bok! Skužio sam da trebaš **[feature name]**.

Evo što ću napraviti:
[Plan u bullet points]

Koristim:
- Template: [koji template]
- Pattern: [koji pattern iz docs]
- Slično kao: [postojeća feature ako postoji]

Krećem odmah! ⚡
[Implementacija]
```

### Za bug fix:

```
Bok! Vidim problem u **[gdje]**.

Uzrok: [kratko objašnjenje]
Rješenje: [što ću napraviti]

Ispravljam... 🔧
[Fix]
```

### Za proširenje:

```
Bok! Proširujem **[koja feature]** s **[što]**.

Dodajem u:
- [Fajl 1]
- [Fajl 2]

Stil: Pratim postojeći pattern iz [referenca]

Krećem! 🚀
[Implementacija]
```

## Advanced: Context Inference

### Ako korisnik kaže samo "Dodaj filter":

```python
# AI automatski inference:
1. Pročitaj open files → Vidi koja je trenutna stranica
2. Codebase search → Pronađi slične filtere u projektu
3. Zaključi → "Dodaj filter na [X page] slično kao na [Y page]"
4. Potvrdi → "Dodajem filter na [X page], ok?"
5. Implementiraj → Follow pattern
```

## Smart Defaults

Ako korisnik ne specificira, koristi smart defaults:

- **UI style:** Koristi postojeći pattern iz sličnih stranica
- **State management:** BaseNotifier pattern (uvijek)
- **Error handling:** Either pattern (uvijek)
- **Naming:** Follow project conventions
- **Colors:** Iz design systema (11_DESIGN_SYSTEM.md)
- **Animations:** Standard timing iz (12_ANIMATION_GUIDELINES.md)

## Quality Gates

Prije završetka, automatski provjeri:

```
✓ No linter errors
✓ Follows clean architecture
✓ Uses templates correctly
✓ Has loading states
✓ Has error handling
✓ Uses design system colors
✓ Has proper types (no dynamic)
✓ Disposes resources
✓ Has semantic labels
```

## Examples in Action

### Example 1: Vague Request
```
User: "Treba mi lista rezervacija"

AI Processing:
1. Detect: Nova feature - List page
2. Search: How are lists implemented? → Finds boats_page.dart
3. Check DB: reservations table exists? → Yes
4. Template: page_template + widget_template + repository_template
5. Plan: Create full CRUD for reservations
6. Implement: Following 07_FEATURE_TEMPLATE.md

Response: "Bok! Kreiram reservations feature slično kao boats. 
Imat ćeš: list view, details page, CRUD operations. Krećem..."
```

### Example 2: Specific Request
```
User: "Dodaj mogućnost sortiranja po cijeni na boats page"

AI Processing:
1. Detect: Extension of existing
2. Read: lib/features/boats/presentation/pages/boats_page.dart
3. Read: lib/features/boats/domain/notifiers/boats_list_notifier.dart
4. Pattern: Found sorting in similar notifiers
5. Plan: Add sortByPrice method + UI button

Response: "Bok! Dodajem sort po cijeni. 
Mijenjam: boats_list_notifier.dart + boats_page.dart
Pattern: Kao što radi sort na inventory. Krećem..."
```

### Example 3: Bug Report
```
User: "Cijena se ne prikazuje dobro, fale decimale"

AI Processing:
1. Detect: Bug fix - formatting issue
2. Search: "price display formatting" → Finds widget
3. Root cause: Missing .toStringAsFixed(2)
4. Fix: Add number formatting

Response: "Bok! Vidim bug u formatiranju cijene.
File: [widget name]
Fix: Dodajem .toStringAsFixed(2) + currency format
Ispravljam..."
```

## Key Principles

1. **Be Proactive:** Don't ask what you can infer
2. **Be Specific:** "Creating reservations list page" not "Creating page"
3. **Be Fast:** Minimize back-and-forth
4. **Be Complete:** Don't leave half-implemented features
5. **Be Consistent:** Always follow the Elite Framework
6. **Be Croatian:** Always respond in Croatian with friendly tone (Bok!)

---

**Remember:** Cilj je da korisnik kaže minimalno, a dobije maksimalno. 🎯

