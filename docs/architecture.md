# Flutter App Architecture for BambuLab Spool Coder (Spool-Coder Mobile)

## 1. Overview

A cross-platform mobile application (Flutter/Dart) to:
- Read, analyze, and reprogram BambuLab 3D printer filament spools
- Interface with NFC/USB/Bluetooth hardware for physical spool access
- Provide user-friendly interfaces for spool management, error handling, and activity logging

---

## 2. Layered Architecture

### 2.1. Presentation Layer (UI/UX)

**Responsibilities:**
- User interaction, data visualization, and feedback
- Navigation, input validation, theme, and accessibility

**Components:**
- **Screens**
  - `SplashScreen`: App init, permission checks
  - `HomeScreen`: Scan options, spool list/history, quick actions
  - `SpoolScanScreen`: NFC/USB/BLE scan, progress, and status
  - `SpoolDetailScreen`: Spool metadata, raw/decoded fields, edit buttons
  - `SpoolEditScreen`: Form for changing fields (material, length, vendor, UID, etc.)
  - `ProgramConfirmScreen`: Summary, confirmation dialog for programming
  - `ProgrammingStatusScreen`: Live log, progress bar, error/result
  - `SettingsScreen`: Preferences, hardware settings, developer/debug info
  - `AboutScreen`: App info, legal, open source licenses

- **Widgets**
  - Custom dialogs (alerts, confirmations, errors)
  - List tiles for spools, logs, and actions
  - Progress/status indicators (spinners, bars)
  - Input controls (dropdowns, sliders, toggles)

- **Navigation**
  - Declarative (GoRouter/auto_route)
  - Deep linking (optionally for shared spool links)

- **State Management**
  - Provider/Riverpod/Bloc: app-wide state, spool data, session, hardware status

---

### 2.2. Domain Layer (Business Logic)

**Responsibilities:**
- Core logic, validation, data transformation, and service orchestration

**Components:**
- **Entities/Models**
  - `Spool`: Material, color, length, UID, vendor, checksum, write-protection, etc.
  - `ScanSession`: Timestamp, device, type (NFC/USB), status, error
  - `ProgrammingJob`: Data to write, progress, result

- **Services**
  - `SpoolService`: Data parsing/validation (bytes <-> model), checksums, UID generation
  - `ProgrammingService`: Handles write logic, dry-run, error handling, rollback
  - `HistoryService`: Maintains scan/program history, logs, undo stack
  - `BackupService`: Local/optional cloud backup of spool data

- **Validators**
  - Data integrity: Field length, allowed values, checksums
  - Protocol compliance: NFC tag type, USB/BLE device profile, etc.

---

### 2.3. Data Layer (Hardware/IO, Storage, Platform Integration)

**Responsibilities:**
- Hardware abstraction, protocol implementation, persistent storage

**Components:**

- **Hardware Interfaces**
  - `NfcAdapter`: Scan/read/write, permission management, tag type decoding
    - Plugins: `nfc_manager`, `flutter_nfc_kit`, platform channels for advanced features
    - Handles tag presence, loss, and error scenarios
  - `UsbAdapter`: Device enumeration, connect/read/write
    - Plugins: `usb_serial`, custom channels for protocol-specific IO
    - Handles vendor/product ID, serial protocol, hotplug events
  - `BleAdapter` (optional): BLE discovery, connect, read/write for future-proofing

- **Repository Pattern**
  - `SpoolRepository`: Abstracts hardware (NFC/USB/BLE), provides mock/test sources
  - `HistoryRepository`: Local DB (Hive/SQLite) for scan/program logs
  - `SettingsRepository`: App settings, preferences, cache

- **Platform Channels**
  - Used for advanced or unsupported device features (e.g., low-level NFC/USB)
  - FFI/native code for performance-critical routines (e.g., CRC, parsing)

---

### 2.4. Cross-Cutting Concerns

- **Error Handling**
  - Centralized error classes (hardware, protocol, permission, logic)
  - UI hooks for displaying errors, logs, and actionable suggestions

- **Logging/Telemetry**
  - Local log storage (rotating buffer), export/share feature
  - Analytics (opt-in): Usage, error trends, anonymized

- **Security**
  - Confirm before overwriting/writing spools
  - Data validation before hardware operations
  - Permissions handling with user education

- **Testing**
  - Unit: Services, models, validators
  - Integration: Hardware mocks, protocol simulations, UI flows
  - E2E/manual: Real hardware, all supported platforms

---

## 3. Protocol and Data Mapping

### 3.1. Spool Data Structure

- **Fields:** (based on BambuLab ecosystem)
  - UID
  - Material type
  - Manufacturer
  - Color
  - Net/gross length
  - Remaining length
  - Checksum/CRC
  - Write-protection flag

- **Encoding/Decoding:**
  - Byte buffer <-> Dart model
  - Python logic ported to Dart, using unit-tested parsing/packing routines
  - CRC/checksum validation as per protocol (may use Dart/FFI for performance)

### 3.2. Hardware Protocols

- **NFC**
  - MIFARE/NTAG compatibility
  - Tag detection, sector/block read/write, authentication if needed
  - Tag loss, collision, and retry management

- **USB**
  - Serial protocol (if used), baud rate, framing, vendor/product ID
  - Hotplug, permission, and error handling

- **BLE (optional)**
  - Service/characteristic discovery, connection management

---

## 4. Example Directory Structure

```
/lib
  /core                 # Logging, error handling, utilities
  /models               # Spool, scan session, programming job, errors
  /services             # SpoolService, ProgrammingService, HistoryService
  /adapters             # NfcAdapter, UsbAdapter, BleAdapter
  /repositories         # SpoolRepository, HistoryRepository, SettingsRepository
  /screens              # UI pages (Home, Scan, Detail, Edit, Settings)
  /widgets              # Reusable UI components
  /platform_channels    # Native/FFI integrations
  main.dart

/assets                 # Images, icons, translations, legal
/test                   # Unit, integration, hardware mock tests
```

---

## 5. Technology Stack

- **Flutter (Dart 3.x)**
- **nfc_manager / flutter_nfc_kit**: NFC read/write
- **usb_serial / custom FFI**: USB access
- **provider / riverpod / bloc**: State management
- **hive / sqflite**: Local storage
- **go_router / auto_route**: Navigation
- **logger / crashlytics**: Logging, error reporting

---

## 6. Migration Notes (Python → Dart)

- Port all data structures and protocol logic
  - Use tests to validate exact behavior (parsing, checksums, edge cases)
- Replace blocking IO with async/await patterns
- Implement detailed error mapping (Python exceptions → Dart errors)
- UI/UX: Design for mobile/desktop, with feedback for all hardware operations

---

## 7. Safety Precautions

- All write/program actions require confirmation dialogs
- Data is validated before any hardware operation
- Robust error handling: Tag loss, bad data, permission errors
- Visual status for all operations, with logs for diagnostics

---

## 8. Future Extensions

- Cloud sync for spool history (optional)
- Advanced analytics/reporting (e.g., filament usage over time)
- Cross-platform desktop support (Flutter Desktop)
- Support for additional spool/chip types

---

**This architecture ensures maintainable, scalable, and reliable porting of Python spool-coder to a production-grade Flutter app, supporting robust hardware integration and user experience.**