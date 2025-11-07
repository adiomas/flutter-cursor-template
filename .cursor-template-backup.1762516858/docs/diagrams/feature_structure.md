# Feature Structure Diagram

```mermaid
graph TD
    subgraph "Feature Module"
        subgraph "data/"
            Models[models/]
            ModelFile[feature_model.dart]
            Repos[repositories/]
            RepoFile[feature_repository.dart]
        end
        
        subgraph "domain/"
            Entities[entities/]
            EntityFile[feature_entity.dart]
            Notifiers[notifiers/]
            NotifierFile[feature_notifier.dart]
        end
        
        subgraph "presentation/"
            Pages[pages/]
            PageFile[feature_page.dart]
            Widgets[widgets/]
            WidgetFile[feature_widget.dart]
        end
    end
    
    Models --> ModelFile
    Repos --> RepoFile
    Entities --> EntityFile
    Notifiers --> NotifierFile
    Pages --> PageFile
    Widgets --> WidgetFile
    
    RepoFile -.implements.-> EntityFile
    NotifierFile -.uses.-> RepoFile
    NotifierFile -.manages.-> EntityFile
    PageFile -.watches.-> NotifierFile
    WidgetFile -.displays.-> EntityFile
    
    style Models fill:#f0f0f0
    style Repos fill:#f0f0f0
    style Entities fill:#fff4e1
    style Notifiers fill:#fff4e1
    style Pages fill:#e1f5ff
    style Widgets fill:#e1f5ff
```

## Standard Feature Structure

```
features/
└── feature_name/
    ├── data/
    │   ├── models/
    │   │   └── feature_model.dart
    │   └── repositories/
    │       └── feature_repository.dart
    ├── domain/
    │   ├── entities/
    │   │   └── feature_entity.dart
    │   └── notifiers/
    │       ├── feature_notifier.dart
    │       └── feature_list_notifier.dart
    └── presentation/
        ├── pages/
        │   ├── feature_page.dart
        │   └── feature_details_page.dart
        └── widgets/
            └── feature_list_item.dart
```

