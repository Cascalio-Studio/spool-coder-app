# Data Layer

This layer handles data access and implements repository contracts defined in the domain layer.

## Structure

- **repositories/**: Implementation of domain repository interfaces
- **datasources/**: External data access (local storage, hardware interfaces)
- **models/**: Data transfer objects and serialization logic

## Responsibilities

- Implement repository contracts from domain layer
- Handle data transformation between external formats and domain entities
- Manage data caching and persistence
- Abstract external data sources
- Handle network and hardware communication

## Guidelines

- Implement domain repository interfaces
- Transform external data to domain entities
- Handle errors and exceptions appropriately
- Cache data when appropriate
- Keep data sources focused and single-purpose

## Key Files

- `repositories/spool_repository.dart` - Implementation of spool data access
- `datasources/nfc_data_source.dart` - NFC hardware data access

## Dependencies

- Domain layer (entities, repository interfaces)
- Platform layer (hardware integrations)
- Core layer (utilities, errors)
- External packages for data persistence