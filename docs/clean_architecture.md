# Spool Coder App Architecture

## Overview

The Spool Coder App is a Flutter application designed to read, analyze, and program BambuLab 3D printer filament spools using NFC, USB, and Bluetooth technologies. The application follows a clean architecture pattern with clear separation of concerns across four distinct layers.

## Architecture Layers

### 1. Presentation Layer (`lib/presentation/`)

**Responsibility**: User interface and interaction logic

**Components**:
- **Screens** (`screens/`): Full-page UI components (HomeScreen, ScanScreen, etc.)
- **Widgets** (`widgets/`): Reusable UI components (buttons, dialogs, cards)
- **Navigation** (`navigation/`): App routing and navigation logic

**Key Principles**:
- Handles user input and displays data
- Communicates with Domain layer through use cases
- Contains no business logic
- Platform-agnostic UI code

### 2. Domain Layer (`lib/domain/`)

**Responsibility**: Business logic, use cases, and core entities

**Components**:
- **Entities** (`entities/`): Core business objects (Spool, ScanSession)
- **Use Cases** (`use_cases/`): Application-specific business rules
- **Services** (`services/`): Domain services for complex business operations

**Key Principles**:
- Contains pure business logic
- Independent of external frameworks
- Defines contracts for data access (repository interfaces)
- No dependencies on other layers

### 3. Data Layer (`lib/data/`)

**Responsibility**: Data sources, repositories, and API integration

**Components**:
- **Repositories** (`repositories/`): Implementation of domain contracts
- **Data Sources** (`datasources/`): External data access (NFC, USB, local storage)
- **Models** (`models/`): Data transfer objects and serialization

**Key Principles**:
- Implements repository interfaces from domain layer
- Handles data transformation between external formats and domain entities
- Manages caching and data persistence
- Abstracts external data sources

### 4. Platform Layer (`lib/platform/`)

**Responsibility**: Device and platform-specific integrations

**Components**:
- **NFC** (`nfc/`): NFC hardware integration and protocols
- **USB** (`usb/`): USB device communication
- **Bluetooth** (`bluetooth/`): Bluetooth Low Energy integration

**Key Principles**:
- Provides platform-specific implementations
- Uses platform channels and FFI for native code integration
- Handles hardware permissions and capabilities
- Abstracts platform differences

### 5. Core Layer (`lib/core/`)

**Responsibility**: Shared utilities and cross-cutting concerns

**Components**:
- **Constants** (`constants/`): Application-wide constants
- **Utils** (`utils/`): Shared utility functions
- **Errors** (`errors/`): Common exception classes

## Data Flow

```
Presentation Layer (UI)
        ↓
Domain Layer (Business Logic)
        ↓
Data Layer (Repository Implementation)
        ↓
Platform Layer (Hardware Integration)
```

## Dependency Direction

Dependencies flow inward toward the domain layer:
- Presentation → Domain
- Data → Domain  
- Platform → Data
- Core ← All layers

## Key Benefits

1. **Separation of Concerns**: Each layer has a single, well-defined responsibility
2. **Testability**: Business logic is isolated and easily testable
3. **Maintainability**: Changes in one layer don't affect others
4. **Scalability**: New features can be added without disrupting existing code
5. **Platform Independence**: Core business logic is reusable across platforms

## Technology Stack

- **Flutter SDK**: Cross-platform UI framework
- **Dart**: Programming language
- **Platform Channels**: Native code integration
- **Repository Pattern**: Data access abstraction
- **Clean Architecture**: Overall architectural pattern

## Getting Started

1. **Presentation Layer**: Start with UI screens and widgets
2. **Domain Layer**: Define entities and use cases for your business logic
3. **Data Layer**: Implement repositories and data sources
4. **Platform Layer**: Add platform-specific hardware integrations

Each layer should be developed and tested independently, following the dependency rules outlined above.