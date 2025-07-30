# Domain Layer

This layer contains the core business logic and is the heart of the application.

## Structure

- **entities/**: Core business objects and value objects
- **use_cases/**: Application-specific business rules and operations
- **services/**: Domain services for complex business operations

## Responsibilities

- Define business entities and their rules
- Implement use cases (application business logic)
- Define repository contracts (interfaces)
- Validate business rules
- Coordinate complex business operations

## Guidelines

- No external dependencies (Flutter, platform-specific code)
- Pure Dart code only
- Define clear interfaces for external dependencies
- Keep entities simple and focused
- Use cases should be small and focused on single operations

## Key Files

- `entities/spool.dart` - Core Spool business entity
- `use_cases/scan_spool_use_case.dart` - Business logic for scanning spools

## Dependencies

- None (pure Dart)
- Other domain layer components only