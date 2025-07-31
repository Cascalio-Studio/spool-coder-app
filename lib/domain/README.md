# Domain Layer

This layer contains the core business logic and is the heart of the application. It implements clean architecture principles with a focus on maintainability, testability, and clear separation of concerns.

## Architecture Overview

The domain layer is completely independent of external frameworks, UI, and data storage implementations. It defines contracts (interfaces) that other layers must implement, ensuring loose coupling and high testability.

## Structure

### 📁 entities/
Core business objects that encapsulate business rules and logic.

- **`spool.dart`** - Main Spool entity with comprehensive business logic
- **`spool_profile.dart`** - Spool profile/template entity for different spool types

### 📁 value_objects/
Immutable objects that represent domain concepts with built-in validation.

- **`spool_uid.dart`** - Unique identifier with validation rules
- **`material_type.dart`** - Strongly-typed material types (PLA, ABS, PETG, etc.)
- **`spool_color.dart`** - Color representation with hex/RGB support
- **`filament_length.dart`** - Length measurements with unit conversions

### 📁 repositories/
Interfaces that define contracts for data access without implementation details.

- **`spool_repository.dart`** - Contract for spool data operations
- **`profile_repository.dart`** - Contract for profile management

### 📁 use_cases/
Application-specific business rules and operations. Each use case represents a single business operation.

- **`scan_spool_use_case.dart`** - Spool scanning operations
- **`get_spool_use_cases.dart`** - Spool retrieval operations
- **`save_spool_use_cases.dart`** - Spool persistence operations
- **`manage_spool_use_cases.dart`** - Spool management operations
- **`profile_use_cases.dart`** - Profile management operations

### 📁 services/
Domain services for complex business operations that don't naturally fit in entities.

- **`spool_validation_service.dart`** - Comprehensive validation logic
- **`spool_calculation_service.dart`** - Usage statistics and predictions
- **`spool_orchestration_service.dart`** - Complex workflows and operations

### 📁 exceptions/
Domain-specific exceptions that represent business rule violations.

- **`domain_exceptions.dart`** - All domain-specific exceptions

## Key Features

### 🛡️ Type Safety
- Strong typing with value objects prevents invalid data
- Comprehensive validation at the domain level
- Clear error handling with domain-specific exceptions

### 🔧 Business Logic
- Encapsulated business rules within entities
- Complex calculations in dedicated services
- Validation rules enforced at the domain level

### 🎯 Clean Architecture
- No external dependencies (pure Dart)
- Interfaces define contracts for external systems
- Dependency inversion principle applied throughout

### 📊 Rich Domain Model
- Comprehensive spool modeling with usage tracking
- Profile system for different spool types
- Statistical analysis and predictions

## Usage Examples

### Creating Value Objects
```dart
// Create strongly-typed material
final material = MaterialType.pla;
final customMaterial = MaterialType.custom(
  value: 'WOOD_PLA',
  displayName: 'Wood Filled PLA',
  defaultDensity: 1.15,
);

// Create validated colors
final color = SpoolColor.hex('Bright Red', '#FF0000');
final namedColor = SpoolColor.named('Transparent');

// Create measurements with validation
final length = FilamentLength.meters(1000.0);
final remaining = FilamentLength.meters(750.0);

// Create unique identifiers
final uid = SpoolUid('BAMBU_A1_MINI_PLA_RED_001');
```

### Working with Entities
```dart
// Create a spool with business logic
final spool = Spool(
  uid: SpoolUid('SAMPLE_123'),
  materialType: MaterialType.pla,
  manufacturer: 'BambuLab',
  color: SpoolColor.red,
  netLength: FilamentLength.meters(1000.0),
  remainingLength: FilamentLength.meters(750.0),
  createdAt: DateTime.now(),
);

// Use business logic
print('Usage: ${spool.usagePercentage}%');
print('Is nearly empty: ${spool.isNearlyEmpty}');
print('Used: ${spool.usedLength.format()}');

// Update spool data
final updatedSpool = spool.copyWith(
  remainingLength: FilamentLength.meters(500.0),
  updatedAt: DateTime.now(),
);
```

### Using Use Cases
```dart
// Dependency injection would provide concrete implementations
abstract class ScanSpoolUseCase {
  Future<Spool> execute(ScanMethod method);
}

// Usage in application layer
final scannedSpool = await scanSpoolUseCase.execute(ScanMethod.nfc);
```

## Business Rules

### Spool Validation Rules
- UID must be unique and follow format requirements
- Remaining length cannot exceed net length
- Material type must be valid
- Colors can have hex codes or names

### Profile Management
- Profiles must have complete material information
- Default profiles for common materials
- Custom profiles for specialized filaments

### Usage Tracking
- Automatic calculation of usage percentages
- Near-empty warnings at 10% remaining
- Expiry date tracking for materials

## Testing Strategy

The domain layer is designed for comprehensive testing:

- **Unit Tests**: All entities, value objects, and services
- **Business Rule Tests**: Validation and constraint testing
- **Edge Case Tests**: Boundary conditions and error scenarios
- **Integration Tests**: Use case workflows

## Dependencies

- **None** - Pure Dart implementation
- **Internal**: Only references other domain layer components
- **External**: Defines interfaces for data and presentation layers

## Extension Points

The domain layer can be extended with:

- Additional material types and properties
- New calculation algorithms
- Enhanced validation rules
- Additional spool metadata
- Custom business workflows

## Migration and Versioning

When extending the domain layer:

1. Add new value objects for type safety
2. Extend entities with copyWith methods
3. Create new use cases for new operations
4. Add validation rules to services
5. Update repository contracts as needed

The domain layer serves as the stable core of the application, with all changes carefully considered for backward compatibility and business impact.