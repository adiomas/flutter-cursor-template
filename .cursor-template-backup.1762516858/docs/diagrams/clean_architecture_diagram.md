# Clean Architecture Diagram

```mermaid
graph TB
    subgraph "Presentation Layer"
        Pages[Pages/Screens]
        Widgets[Widgets]
    end
    
    subgraph "Domain Layer"
        Entities[Entities]
        Notifiers[Notifiers/State]
        Providers[Providers]
    end
    
    subgraph "Data Layer"
        Models[Models]
        Repositories[Repositories]
        Services[Services]
    end
    
    subgraph "External"
        API[Supabase API]
        LocalDB[Local Storage]
    end
    
    Pages --> Notifiers
    Widgets --> Notifiers
    Notifiers --> Entities
    Notifiers --> Repositories
    Notifiers --> Providers
    Repositories --> Models
    Repositories --> Services
    Models --> Entities
    Services --> API
    Services --> LocalDB
    
    style Pages fill:#e1f5ff
    style Widgets fill:#e1f5ff
    style Entities fill:#fff4e1
    style Notifiers fill:#fff4e1
    style Providers fill:#fff4e1
    style Models fill:#f0f0f0
    style Repositories fill:#f0f0f0
    style Services fill:#f0f0f0
```

## Dependency Rule

Dependencies flow **inward**: Presentation → Domain → Data

- **Presentation** depends on Domain
- **Domain** defines interfaces, Data implements them
- **Data** never imports Presentation
- **Domain** never imports Data or Presentation

