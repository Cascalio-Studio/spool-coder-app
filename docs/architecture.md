# Spool Coder App Architecture

## Overview

The Spool Coder App is a Flutter application designed to read, analyze, and program BambuLab 3D printer filament spools using NFC, USB, and Bluetooth technologies. The application follows a clean architecture pattern with clear separation of concerns across four distinct layers.

## Architecture Principles

- **Local-First**: The app works fully offline by default
- **Optional Backend**: Backend integration can be enabled/disabled at runtime
- **Clean Architecture**: Clear separation of concerns with dependency inversion
- **Platform Independence**: Core business logic is reusable across platforms
- **Type Safety**: Strong typing prevents invalid data at compile time

## Architecture Layers

### 1. Presentation Layer (`lib/presentation/`)

**Responsibility**: User interface and interaction logic

**Components**:
- **Screens** (`screens/`): Full-page UI components
  - `HomeScreen`: Dashboard with spool overview and quick actions
  - `ScanScreen`: NFC/USB/BLE scanning interface with real-time feedback
  - `SpoolDetailScreen`: Detailed spool metadata and editing capabilities
  - `SettingsScreen`: User preferences and app configuration
  
- **Widgets** (`widgets/`): Reusable UI components
  - Custom dialogs, progress indicators, themed buttons
  - Spool cards, action cards, navigation components
  
- **Navigation** (`routes/`): App routing using GoRouter
  - Declarative routing with type-safe navigation
  - Deep linking support for shared spool data

**Key Principles**:
- Handles user input and displays data
- Communicates with Domain layer through use cases
- Contains no business logic
- Platform-agnostic UI code

**State Management**: Provider/Riverpod for reactive state updates

### 2. Domain Layer (`lib/domain/`)

**Responsibility**: Business logic, use cases, and core entities

**Components**:
- **Entities** (`entities/`): Core business objects
  - `Spool`: Complete spool information with validation
  - `ScanSession`: Scanning operation metadata
  - `NfcScanResult`: Type-safe scanning state management
  
- **Use Cases** (`use_cases/`): Application-specific business rules
  - `NfcScanUseCase`: NFC scanning orchestration
  - `SpoolManagementUseCase`: Spool CRUD operations
  - `SettingsUseCase`: User preference management
  
- **Value Objects** (`value_objects/`): Domain-specific types
  - `RfidData`: Parsed RFID tag information
  - `MaterialType`: Filament material specifications
  - `TemperatureProfile`: Printing temperature settings
  
- **Repositories** (interfaces): Data access contracts
  - `SpoolRepository`: Spool data persistence
  - `SettingsRepository`: User preferences storage

**Key Principles**:
- Pure Dart implementation (no external dependencies)
- Immutable design with comprehensive validation
- Rich domain model with embedded business logic
- Dependency inversion with repository interfaces

### 3. Data Layer (`lib/data/`)

**Responsibility**: Data access, caching, and external service integration

**Components**:
- **Repositories** (`repositories/`): Repository implementations
  - Local storage using Hive/SQLite
  - Optional cloud synchronization
  - Caching strategies for performance
  
- **Data Sources** (`datasources/`): External data access
  - `NfcDataSource`: Hardware NFC integration
  - `LocalDataSource`: Device storage access
  - `RemoteDataSource`: Optional backend API
  
- **Models** (`models/`): Data transfer objects
  - JSON serialization/deserialization
  - Database entity mappings

**Key Principles**:
- Implements domain repository interfaces
- Handles data transformation between external formats and domain entities
- Manages caching and data persistence
- Abstracts external data sources

### 4. Platform Layer (`lib/platform/`)

**Responsibility**: Device and platform-specific integrations

**Components**:
- **NFC** (`nfc/`): NFC hardware integration
  - MIFARE/NTAG compatibility using `nfc_manager`
  - Tag detection, read/write operations
  - Authentication and security handling
  
- **USB** (`usb/`): USB device communication
  - Serial protocol implementation
  - Device discovery and permission handling
  
- **Bluetooth** (`bluetooth/`): BLE integration (future)
  - Service/characteristic discovery
  - Connection management

**Key Principles**:
- Provides platform-specific implementations
- Uses platform channels and FFI for native code integration
- Handles hardware permissions and capabilities
- Abstracts platform differences

### 5. Core Layer (`lib/core/`)

**Responsibility**: Shared utilities and cross-cutting concerns

**Components**:
- **Configuration** (`config/`): App configuration and feature flags
- **Constants** (`constants/`): Application-wide constants
- **Dependency Injection** (`di/`): Service locator setup
- **Errors** (`errors/`): Common exception and failure classes
- **Utils** (`utils/`): Shared utility functions
- **Widgets** (`widgets/`): Common UI components

## Data Flow

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
│  │  Entities   │  │ Use Cases   │  │   Value Objects     │  │
│  │             │  │             │  │                     │  │
│  │ • Spool     │  │ • NfcScan   │  │ • RfidData          │  │
│  │ • Session   │  │ • Settings  │  │ • MaterialType      │  │
│  │ • Result    │  │ • Spool Mgmt│  │ • Temperature       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │Repositories │  │Data Sources │  │      Models         │  │
│  │             │  │             │  │                     │  │
│  │ • SpoolRepo │  │ • NfcSource │  │ • DTOs              │  │
│  │ • Settings  │  │ • LocalDB   │  │ • JSON Models       │  │
│  │ • History   │  │ • RemoteAPI │  │ • DB Entities       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                    PLATFORM LAYER                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │     NFC     │  │     USB     │  │     Bluetooth       │  │
│  │             │  │             │  │                     │  │
│  │ • MIFARE    │  │ • Serial    │  │ • BLE Services      │  │
│  │ • NTAG      │  │ • Permissions│  │ • Characteristics   │  │
│  │ • Security  │  │ • Discovery │  │ • Connection Mgmt   │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Dependency Direction

Dependencies flow inward toward the domain layer:
- **Presentation** → **Domain**
- **Data** → **Domain**  
- **Platform** → **Data**
- **Core** ← **All layers**

This ensures the domain layer remains pure and testable.

## Key Features

### RFID Integration
- **Complete Bambu Lab RFID Support**: Parse all standard fields
- **Material Recognition**: PLA, PETG, ABS, etc. with properties
- **Temperature Profiles**: Optimal printing temperatures
- **Production Metadata**: Manufacturing date, batch info
- **Security**: RSA signature verification for authenticity

### Hardware Support
- **NFC**: Optimized for Samsung Galaxy S20 Ultra and Bambu Lab tags
- **USB**: Serial communication for direct device access
- **Bluetooth**: BLE integration for wireless connectivity
- **Multi-platform**: Consistent behavior across Android/iOS

### User Experience
- **Offline-First**: Full functionality without internet
- **Real-time Scanning**: Live feedback during NFC operations
- **Material Database**: Comprehensive filament specifications
- **Internationalization**: 5 languages (EN, DE, FR, ES, IT)
- **Accessibility**: High contrast themes and font scaling

## Technology Stack

- **Flutter SDK**: Cross-platform UI framework
- **Dart 3.x**: Programming language with null safety
- **nfc_manager**: NFC hardware integration
- **GetIt**: Dependency injection
- **GoRouter**: Type-safe navigation
- **Hive/SQLite**: Local data persistence
- **SharedPreferences**: Settings storage

## Security & Safety

- **Data Validation**: All inputs validated before hardware operations
- **Confirmation Dialogs**: Required for all write/program actions
- **Permission Handling**: Proper NFC and storage permissions
- **Error Recovery**: Graceful handling of hardware failures
- **Logging**: Comprehensive logging for debugging

## Testing Strategy

- **Unit Tests**: Domain logic, value objects, use cases
- **Integration Tests**: Repository implementations, data flow
- **Widget Tests**: UI components and user interactions
- **Platform Tests**: Hardware mocking and protocol simulation

## Future Extensions

- **Cloud Synchronization**: Optional backend for data sync
- **Advanced Analytics**: Usage patterns and material tracking
- **Desktop Support**: Flutter Desktop for larger screens
- **Additional Protocols**: Support for more spool types

This architecture ensures a maintainable, scalable, and reliable application that provides excellent user experience while maintaining code quality and testability.
