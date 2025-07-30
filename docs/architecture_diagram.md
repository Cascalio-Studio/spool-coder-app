# Architecture Diagram

## Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Screens   │  │   Widgets   │  │     Navigation      │  │
│  │             │  │             │  │                     │  │
│  │ • HomeScreen│  │ • Dialogs   │  │ • App Router        │  │
│  │ • ScanScreen│  │ • Cards     │  │ • Route Guards      │  │
│  │ • Settings  │  │ • Buttons   │  │ • Deep Linking      │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Entities   │  │ Use Cases   │  │      Services       │  │
│  │             │  │             │  │                     │  │
│  │ • Spool     │  │ • ScanSpool │  │ • ValidationService │  │
│  │ • Session   │  │ • Program   │  │ • SpoolService      │  │
│  │ • User      │  │ • History   │  │ • BackupService     │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │Repositories │  │Data Sources │  │       Models        │  │
│  │             │  │             │  │                     │  │
│  │ • SpoolRepo │  │ • NfcSource │  │ • SpoolModel        │  │
│  │ • HistoryRepo│  │ • UsbSource │  │ • SessionModel      │  │
│  │ • Settings  │  │ • LocalDB   │  │ • ConfigModel       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                     PLATFORM LAYER                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │     NFC     │  │     USB     │  │     Bluetooth       │  │
│  │             │  │             │  │                     │  │
│  │ • NFC API   │  │ • USB API   │  │ • BLE API           │  │
│  │ • Channels  │  │ • Channels  │  │ • Channels          │  │
│  │ • Protocols │  │ • Protocols │  │ • Protocols         │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

```
User Interaction → Presentation → Domain → Data → Platform → Hardware
                     │             │        │       │
                     │             │        │       └─ NFC/USB/BLE
                     │             │        └─ Local Storage
                     │             └─ Business Rules
                     └─ UI Updates
```

## Dependency Direction

```
Presentation ──→ Domain ←── Data ←── Platform
     │                        │
     └────── Core ←───────────┘
```

## Key Principles

1. **Dependency Rule**: Dependencies point inward toward the domain
2. **Interface Segregation**: Layers communicate through interfaces
3. **Single Responsibility**: Each layer has one clear purpose
4. **Testability**: Business logic is isolated and testable