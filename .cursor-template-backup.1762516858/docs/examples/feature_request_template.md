# Feature Request Template

Koristi ovaj template za strukturirane zahtjeve. AI će automatski transformirati u implementaciju.

## Option 1: Jednostavno (Najbrže)

Samo napiši prirodno:

```
Treba mi feature za upravljanje task-ovima.
Korisnik može dodavati, editirati, brisati i označiti kao gotovo.
Task ima: naziv, opis, prioritet (low/medium/high), due date
```

**AI automatski prepoznaje i implementira!**

---

## Option 2: Strukturirano (Detaljno)

### Basic Info

```yaml
feature_name: tasks
description: Task management system
type: CRUD  # ili: read-only, custom
```

### Database Schema

```yaml
table: tasks
fields:
  - name: title
    type: text
    required: true
    validation: min 3 chars
    
  - name: description
    type: text
    required: false
    
  - name: priority
    type: enum
    values: [low, medium, high]
    default: medium
    
  - name: completed
    type: boolean
    default: false
    
  - name: due_date
    type: timestamptz
    required: false
    
  - name: user_id
    type: uuid
    fk: users.id
    required: true
```

### Operations

```yaml
operations:
  - list:
      filters: [priority, completed, due_date]
      sorting: [created_at, due_date, priority]
      search: [title, description]
      
  - details:
      params: [id]
      
  - create:
      required_fields: [title, user_id]
      
  - update:
      editable_fields: [title, description, priority, due_date, completed]
      
  - delete:
      confirm: true
      message: "Delete this task?"
```

### Business Rules

```yaml
rules:
  - "User can only see their own tasks"
  - "Cannot set due_date in the past"
  - "Title must be unique per user"
  - "High priority tasks shown first"
  - "Completed tasks go to bottom of list"
```

### UI Requirements

```yaml
pages:
  - tasks_list:
      features:
        - Pull to refresh
        - Filter by priority
        - Filter by completed
        - Search bar
        - Floating action button (add new)
        - Empty state
        
  - task_details:
      features:
        - Edit mode
        - Delete button (with confirmation)
        - Mark as completed toggle
        - Date picker for due_date
        - Priority dropdown
        - Cancel button
        - Save button
        
widgets:
  - task_list_item:
      shows:
        - Title (strike-through if completed)
        - Priority indicator (colored bar)
        - Due date (red if overdue)
        - Checkbox for completed
```

### Additional Features

```yaml
features:
  - notifications:
      - "Task due tomorrow" (24h before)
      - "Task overdue" (on due date)
      
  - statistics:
      - Total tasks
      - Completed tasks %
      - Overdue tasks count
      
  - export:
      - Export to CSV
      - Share via email
```

---

## Option 3: By Example (Najlakše)

```
Napravi isto kao Products feature, ali za Tasks.
Task ima: title, description, priority, due_date
Bez categories, ali dodaj 'completed' boolean.
```

**AI će kopirati strukturu Products feature i prilagoditi!**

---

## Real Examples

### Example 1: Simple

```
Notifications feature:
- User vidi svoje notifikacije
- Mark as read
- Delete notification
- Bell icon s brojem neprочitanih
```

### Example 2: Detailed

```yaml
feature_name: bookings
description: Boat booking system

database:
  table: bookings
  fields:
    - boat_id: uuid (FK boats)
    - user_id: uuid (FK users)
    - start_date: date
    - end_date: date
    - guest_count: integer
    - total_price: decimal
    - status: enum(pending, confirmed, cancelled)

operations:
  - list: My bookings (filter by status)
  - create: New booking
  - details: View booking
  - cancel: Cancel booking (only if > 48h before start)

rules:
  - "Cannot book same boat for overlapping dates"
  - "Guest count <= boat capacity"
  - "Can cancel only if start_date - now > 48h"
  - "Total price = boat.price_per_day * number_of_days"

ui:
  - Boats list (with availability indicator)
  - Booking form (date range picker, guest count)
  - My bookings list
  - Booking details (with cancel option)
```

### Example 3: Migration/Refactor

```
Refactor existing Comments feature:
- Currently all in one file
- Split to clean architecture (data/domain/presentation)
- Add proper error handling
- Add loading states
- Follow 07_FEATURE_TEMPLATE.md
```

---

## Tips

1. **Start Simple** - AI može dodati detalje kasnije
2. **Mention Business Rules** - Važno za validaciju
3. **Reference Existing** - "Kao X feature ali..."
4. **Ask for Plan** - "Daj mi plan prvo"

---

## Samo Napiši Što Trebaš!

AI će automatski:
- ✅ Čitati `07_FEATURE_TEMPLATE.md`
- ✅ Koristiti template iz `templates/`
- ✅ Slijediti `04_CLEAN_ARCHITECTURE.md`
- ✅ Primijeniti `05_STATE_MANAGEMENT.md`
- ✅ Dodati `06_ERROR_HANDLING.md`
- ✅ Stilizirati prema `11_DESIGN_SYSTEM.md`
- ✅ Implementirati sve kompletan feature

**Kreni! 🚀**

