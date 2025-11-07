# Navigation Flow Diagram

```mermaid
graph LR
    Splash[Splash Screen]
    Login[Login Page]
    Home[Home Page]
    Features[Features List]
    Details[Feature Details]
    
    Splash -->|Not Authenticated| Login
    Splash -->|Authenticated| Home
    Login -->|Success| Home
    Home -->|Navigate| Features
    Features -->|Select Item| Details
    Details -->|Save| Features
    Details -->|Back| Features
    
    style Splash fill:#f0f0f0
    style Login fill:#ffe1e1
    style Home fill:#e1f5ff
    style Features fill:#e1f5ff
    style Details fill:#e1f5ff
```

## Route Structure

```
/                 → Splash (redirect logic)
/login            → Login Page
/home             → Home Page
/features         → Features List
/features/:id     → Feature Details (existing)
/features/new     → Feature Details (new)
```

## Navigation Methods

- **context.go()**: Replace current route (declarative)
- **context.push()**: Push new route (imperative)
- **context.pop()**: Pop current route

