# Core Layer

This layer contains shared utilities and cross-cutting concerns used throughout the application.

## Structure

- **constants/**: Application-wide constants and configuration
- **utils/**: Shared utility functions and helpers
- **errors/**: Common exception classes and error handling

## Responsibilities

- Provide shared constants and configuration
- Offer utility functions used across layers
- Define common exception types
- Handle cross-cutting concerns (logging, validation)

## Guidelines

- Keep utilities pure and stateless
- Define clear exception hierarchies
- Avoid layer-specific logic
- Make constants easily maintainable
- Ensure utilities are well-tested

## Key Files

- `constants/app_constants.dart` - Application configuration constants
- `errors/exceptions.dart` - Common exception classes
- `utils/spool_utils.dart` - Spool-related utility functions

## Dependencies

- None (pure Dart utilities)
- Used by all other layers