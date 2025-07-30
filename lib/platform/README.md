# Platform Layer

This layer handles device and platform-specific integrations, particularly hardware communication.

## Structure

- **nfc/**: NFC hardware integration and protocols
- **usb/**: USB device communication
- **bluetooth/**: Bluetooth Low Energy integration

## Responsibilities

- Provide platform-specific hardware implementations
- Handle platform channels and native code integration
- Manage hardware permissions and capabilities
- Abstract platform differences
- Handle low-level hardware protocols

## Guidelines

- Use platform channels for native code integration
- Handle platform-specific permissions properly
- Provide clear error handling for hardware failures
- Abstract platform differences behind clean interfaces
- Keep implementations focused on single hardware types

## Key Files

- `nfc/nfc_platform.dart` - NFC hardware platform interface

## Dependencies

- Core layer (errors, utilities)
- Platform channels and native code
- Hardware-specific packages and plugins