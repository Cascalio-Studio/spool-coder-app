# Platform Layer

This layer handles device and platform-specific integrations, particularly hardware communication and system APIs.

## Structure

- **nfc/**: NFC hardware integration and protocols
- **storage/**: Platform-specific storage and persistence
- **network/**: Network connectivity and communication
- **permissions/**: System permissions management
- **device/**: Device information and capabilities
- **usb/**: USB device communication (planned)
- **bluetooth/**: Bluetooth Low Energy integration (planned)

## Responsibilities

- Provide platform-specific hardware implementations
- Handle platform channels and native code integration
- Manage hardware permissions and capabilities
- Abstract platform differences
- Handle low-level hardware protocols
- Provide system information and device capabilities
- Manage network connectivity and status
- Handle data storage and persistence

## Guidelines

- Use platform channels for native code integration
- Handle platform-specific permissions properly
- Provide clear error handling for hardware failures
- Abstract platform differences behind clean interfaces
- Keep implementations focused on single hardware types
- Follow consistent interface patterns across all platform APIs
- Provide mock implementations for testing and development

## Key Files

- `nfc/nfc_platform.dart` - NFC hardware platform interface
- `storage/storage_platform.dart` - Storage and persistence platform interface
- `network/network_platform.dart` - Network connectivity platform interface
- `permissions/permissions_platform.dart` - System permissions platform interface
- `device/device_platform.dart` - Device information platform interface

## Dependencies

- Core layer (errors, utilities)
- Platform channels and native code
- Hardware-specific packages and plugins
- Get_it for dependency injection