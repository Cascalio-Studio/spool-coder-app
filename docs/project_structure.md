# Project Structure

This document explains the folder structure and organization of the Spool Coder App.

## Root Structure

```
lib/
├── core/                   # Shared utilities and cross-cutting concerns
├── presentation/          # UI layer - screens, widgets, navigation
├── domain/               # Business logic layer - entities, use cases
├── data/                 # Data access layer - repositories, data sources
├── platform/             # Platform-specific integrations
└── main.dart            # Application entry point
```

## Layer Details

### Core (`lib/core/`)
Shared utilities used across all layers:
- `constants/` - Application constants
- `utils/` - Utility functions  
- `errors/` - Exception classes

### Presentation (`lib/presentation/`)
User interface and interaction logic:
- `screens/` - Full-page UI components
- `widgets/` - Reusable UI components
- `navigation/` - Routing and navigation

### Domain (`lib/domain/`)
Pure business logic (no external dependencies):
- `entities/` - Core business objects
- `use_cases/` - Application business rules
- `services/` - Domain services

### Data (`lib/data/`)
Data access and external integrations:
- `repositories/` - Implementation of domain repository interfaces
- `datasources/` - External data access (NFC, USB, storage)
- `models/` - Data transfer objects

### Platform (`lib/platform/`)
Platform-specific hardware integrations:
- `nfc/` - NFC hardware communication
- `usb/` - USB device communication  
- `bluetooth/` - Bluetooth integration

## Dependency Rules

1. **Inward Dependencies**: All dependencies point toward the domain layer
2. **No Circular Dependencies**: Layers cannot depend on layers that depend on them
3. **Interface Segregation**: Use abstract interfaces to define contracts between layers
4. **Dependency Inversion**: High-level modules should not depend on low-level modules

## Adding New Features

When adding new features:
1. Start with the **Domain Layer** - define entities and use cases
2. Create **Data Layer** implementations - repositories and data sources
3. Build **Presentation Layer** - screens and widgets
4. Add **Platform Layer** integrations if needed
5. Update **Core** utilities as required

This structure ensures maintainable, testable, and scalable code.