# Quick Start - AI-Powered Development

> **"Samo napiši što trebaš, AI radi sve ostalo"**

## 📖 Learn More

**Want to understand how it works?** → Read **[HOW_IT_WORKS.md](HOW_IT_WORKS.md)**

---

## Kako Radi

### 1. Ti Napišeš Zahtjev (Jednostavno)

Piši prirodno, na hrvatskom ili engleskom:

```
Treba mi feature za upravljanje task-ovima.
Korisnik može dodavati, editirati i brisati task-ove.
Svaki task ima naziv, opis, prioritet (low/medium/high) i due date.
```

### 2. AI Automatski Prepoznaje

AI će:
- ✅ Prepoznati da trebaš CRUD feature
- ✅ Pročitati `07_FEATURE_TEMPLATE.md`
- ✅ Koristiti template iz `templates/`
- ✅ Pratiti `04_CLEAN_ARCHITECTURE.md` pattern
- ✅ Primijeniti `05_STATE_MANAGEMENT.md` pristup

### 3. AI Implementira

Dobio bi:
```
✅ Database schema (SQL)
✅ Model (task_model.dart)
✅ Entity (task_entity.dart)
✅ Repository (task_repository.dart)
✅ Notifiers (task_notifier.dart, tasks_list_notifier.dart)
✅ Pages (tasks_page.dart, task_details_page.dart)
✅ Widgets (task_list_item.dart)
✅ Routes configuration
```

## Načini Korištenja

### Opcija 1: Direktno u Chat (Najbrže)

Samo napiši zahtjev:

**Ti:**
```
Treba mi lista proizvoda s filtriranjem po kategorijama.
Proizvod ima ime, cijenu, opis, sliku i kategoriju.
```

**AI radi:**
1. Čita `07_FEATURE_TEMPLATE.md`
2. Koristi `templates/model_template.dart`
3. Kreira sve potrebne fajlove
4. Slijedi clean architecture
5. Dodaje error handling i loading states

### Opcija 2: Feature Request Template (Strukturirano)

Koristi `examples/feature_request_template.md`:

```yaml
feature: products
description: Product management with filtering
operations:
  - list (with filters)
  - details
  - create
  - edit
  - delete
fields:
  - name: string (required)
  - price: decimal (required)
  - description: text (optional)
  - image_url: string (optional)
  - category_id: uuid (required, FK)
business_rules:
  - Price must be > 0
  - Name min 3 characters
  - Image max 5MB
```

**AI automatski:**
- Kreira validaciju prema business rules
- Dodaje proper error messages
- Implementira sve operacije
- Slijedi sve best practices iz dokumentacije

### Opcija 3: Po Fazama (Kontrolirano)

**Faza 1 - Plan:**
```
Ti: Planiram feature za narudžbe. Što sve trebam?

AI: Analiziram prema dokumentaciji...
- Database: orders, order_items tables
- Relations: user_id, product_id
- Pages: Orders list, Order details
- Business logic: Calculate total, validate stock
- Estimated: ~45 min

Prihvaćaš plan?
```

**Faza 2 - Implementacija:**
```
Ti: Da, kreni!

AI: [Kreira sve fajlove prema 07_FEATURE_TEMPLATE.md]
```

## AI Prepoznavanje Konteksta

### Automatski Čita Dokumentaciju

Kada kažeš:
- **"Treba mi feature..."** → Čita `07_FEATURE_TEMPLATE.md`
- **"Kako napraviti state..."** → Čita `05_STATE_MANAGEMENT.md`
- **"Zašto app sporo radi..."** → Čita `15_PERFORMANCE_OPTIMIZATION.md`
- **"Kako deploati na iOS..."** → Čita `20_IOS_CONFIGURATION.md`
- **"Build error..."** → Čita `26_TROUBLESHOOTING.md`

### Automatski Koristi Template

```
Ti: Nova feature za komentare

AI automatski:
1. Čita: 07_FEATURE_TEMPLATE.md
2. Koristi: templates/repository_template.dart
3. Koristi: templates/notifier_template.dart
4. Koristi: templates/model_template.dart
5. Koristi: templates/entity_template.dart
6. Koristi: templates/page_template.dart
7. Koristi: checklists/feature_implementation_checklist.md
8. Slijedi: 04_CLEAN_ARCHITECTURE.md
9. Primjenjuje: 06_ERROR_HANDLING.md
10. Dodaje: 11_DESIGN_SYSTEM.md styling
```

## Primjeri Transformacije Zahtjeva

### Primjer 1: Jednostavan Zahtjev

**Ti napišeš:**
```
Napraviti notifications feature
```

**AI transformira u:**
```yaml
feature: notifications
type: CRUD
tables:
  - notifications (id, user_id, title, message, read, created_at)
operations:
  - list (unread first)
  - mark as read
  - delete
ui:
  - Notification bell icon s badge (unread count)
  - Dropdown list
  - Mark all as read button
architecture:
  - NotificationModel + Entity
  - NotificationRepository
  - NotificationsListNotifier
  - NotificationBadgeNotifier
  - NotificationsDropdown widget
```

**AI odmah implementira sve** prema `07_FEATURE_TEMPLATE.md`

### Primjer 2: Kompleksan Zahtjev

**Ti napišeš:**
```
Booking system za brodove.
User može:
- Vidjeti dostupne brodove
- Filtirati po datumu i lokaciji
- Rezervirati brod (s odabirom datuma, broja gostiju)
- Vidjeti svoje rezervacije
- Otkazati rezervaciju (ako je > 48h unaprijed)

Validacija:
- Ne može rezervirati isti brod za isti datum
- Broj gostiju ne smije preći kapacitet broda
```

**AI automatski kreira:**

```
✅ Database Schema:
   - bookings table
   - availability check function
   - RLS policies

✅ Models & Entities:
   - BookingModel + BookingEntity
   - AvailabilityModel
   - Business logic za validaciju

✅ Repositories:
   - BookingRepository s availability checks
   - Boat availability queries

✅ Notifiers:
   - BookingsListNotifier
   - BookingNotifier (create/edit)
   - AvailabilityNotifier

✅ Pages:
   - Boats list (s availability)
   - Booking form
   - My bookings
   - Booking details

✅ Widgets:
   - Date range picker
   - Guest count selector
   - Availability indicator
   - Cancellation dialog (48h check)

✅ Error Handling:
   - "Boat not available for selected dates"
   - "Guest count exceeds boat capacity"
   - "Cannot cancel within 48 hours"
```

### Primjer 3: Bug Fix

**Ti napišeš:**
```
App crashuje kada nema internet connection
```

**AI radi:**
1. Čita `26_TROUBLESHOOTING.md`
2. Čita `06_ERROR_HANDLING.md`
3. Analizira kod
4. Dodaje offline handling:
   - Network error detection
   - User-friendly error messages
   - Retry logic
   - Cached data fallback
5. Testira scenario

### Primjer 4: Optimizacija

**Ti napišeš:**
```
Lista proizvoda laguje pri scrollanju
```

**AI radi:**
1. Čita `15_PERFORMANCE_OPTIMIZATION.md`
2. Analizira kod
3. Primjenjuje:
   - ListView.builder (ako već nije)
   - const constructors
   - Image caching
   - RepaintBoundary
   - Keys za list items
4. Profila prije/poslije

## Smart Context Detection

AI automatski detektira:

| Tvoj Zahtjev | AI Čita | AI Koristi |
|--------------|---------|------------|
| "Nova feature..." | 07_FEATURE_TEMPLATE.md | Sve template iz templates/ |
| "Kako testirati..." | 14_TESTING_STRATEGY.md | test_template.dart |
| "Setup iOS..." | 20_IOS_CONFIGURATION.md | iOS configs |
| "Dodati analytics..." | 19_MONITORING_ANALYTICS.md | Firebase setup |
| "App je spora..." | 15_PERFORMANCE_OPTIMIZATION.md | Optimization patterns |
| "Build error..." | 26_TROUBLESHOOTING.md | Solutions |

## Best Practices Za Zahtjeve

### ✅ Dobro (AI lako razumije)

```
Treba mi feature za ratings.
User može rate-ati proizvod (1-5 zvjezdica) i ostaviti komentar.
Prikazati average rating i broj reviews.
```

```
Dodati dark mode support.
```

```
Optimizirati loading time - trenutno traje 5+ sekundi.
```

### ⚠️ Može Bolje (Nedovoljno konteksta)

```
Napravi nešto za reviews
→ Bolje: "Feature za product reviews s ratings i komentarima"
```

```
App ne radi
→ Bolje: "App crashuje na login screenu kada unesem email"
```

## Workflow Primjer

### Dan 1: Nova Feature

**09:00 - Ti napišeš:**
```
Treba mi dashboard s metrics:
- Total prodaja (ovaj mjesec)
- Broj novih korisnika
- Top 5 proizvoda
- Line chart prodaje (7 dana)
```

**09:02 - AI kreira:**
- Dashboard database queries
- Analytics repository
- Dashboard notifier
- Dashboard page s metric cards
- Chart widget integration

**09:30 - Ready za test**

### Dan 2: Bug Fix

**10:00 - Ti napišeš:**
```
Kada user brise proizvod, ostaju orphaned slike u storage
```

**10:01 - AI:**
- Čita storage pattern iz `09_DATA_LAYER.md`
- Dodaje storage cleanup u delete metodu
- Dodaje try-catch za edge cases
- Testira flow

**10:15 - Fixed**

### Dan 3: Optimizacija

**14:00 - Ti napišeš:**
```
Product list treba pagination, previše je slow s 1000+ items
```

**14:01 - AI:**
- Čita pagination pattern iz `09_DATA_LAYER.md`
- Implementira paginated query
- Dodaje infinite scroll
- Dodaje loading indicator

**14:45 - Optimized**

## Napredne Mogućnosti

### 1. Combo Zahtjev

```
Treba mi authentication + authorization.
Roles: Admin, Manager, User
Admin vidi sve, Manager svoj tim, User samo svoje.
```

**AI radi:**
- Auth feature (login, register, logout)
- Role-based access control
- RLS policies u Supabase
- Route guards
- UI conditional rendering

### 2. Refactoring

```
Refaktoriraj User feature prema clean architecture.
Trenutno je sve u jednom fajlu.
```

**AI radi:**
- Splituje u layers (data/domain/presentation)
- Kreira model, entity, repository, notifier
- Migrira logiku
- Update testove

### 3. Migration

```
Migrirati sa Provider na Riverpod
```

**AI radi:**
- Čita `05_STATE_MANAGEMENT.md`
- Konvertira sve provider u Riverpod
- Update all widgets
- Testira

## Tips Za Maksimalnu Efikasnost

### 1. Budi Specifičan Gdje Treba

✅ **"Booking system za brodove s date range picker"**  
umjesto  
❌ **"Booking"**

### 2. Spomeni Business Rules

✅ **"User može otkazati rezervaciju samo 48h unaprijed"**  
(AI će dodati validaciju)

### 3. Koristi Existing Patterns Ako Znaš

✅ **"Kao Products feature ali za Services"**  
(AI će kopirati strukturu)

### 4. Pitaj Za Plan Ako Nesiguran

```
Trebam booking system - što sve trebam? Daj mi plan.
```

AI će dati:
- Database schema
- File structure
- Estimate vremena
- Dependencies

## Zaključak

**Jednostavno napiši što trebaš - AI radi sve ostalo.**

AI će:
1. ✅ Pročitati relevantnu dokumentaciju
2. ✅ Koristiti template
3. ✅ Primijeniti best practices
4. ✅ Slijediti clean architecture
5. ✅ Dodati error handling
6. ✅ Dodati loading states
7. ✅ Stilizirati prema design systemu
8. ✅ Dodati accessibility
9. ✅ Napisati testove (ako zatražiš)

**Sada samo napiši što trebaš i kreni! 🚀**

---

## Što Dalje?

- **Novi feature:** Samo napiši što trebaš
- **Bug fix:** Opiši problem
- **Optimizacija:** Kaži što laguje
- **Setup:** Pitaj "Kako setup X?"
- **Pitanje:** "Kako najbolje implementirati X?"

**AI će automatski naći pravu dokumentaciju i implementirati prema best practices!**
