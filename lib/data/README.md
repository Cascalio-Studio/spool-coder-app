# Data Layer

This layer handles data access and implements repository contracts defined in the domain layer.

## Structure

- **repositories/**: Implementation of domain repository interfaces
- **datasources/**: External data access (local storage, hardware interfaces)
- **services/**: API and sync services for remote data operations
- **models/**: Data transfer objects and serialization logic
- **mappers/**: Entity/DTO conversion utilities

## Responsibilities

- Implement repository contracts from domain layer
- Handle data transformation between external formats and domain entities
- Manage data caching and persistence
- Abstract external data sources
- Handle network and hardware communication

## Key Components

### Repositories
- `SpoolRepositoryImpl` - Manages spool data operations
- `SpoolProfileRepositoryImpl` - Manages spool profile templates  
- `RfidReaderRepositoryImpl` - Handles RFID hardware operations
- `RfidDataRepositoryImpl` - Manages RFID scan data persistence
- `RfidTagLibraryRepositoryImpl` - Manages RFID tag patterns and material identification

### Data Sources
- `SpoolDataSource` - Abstract interface for spool data access
- `LocalSpoolDataSource` - Local storage implementation
- `RemoteSpoolDataSource` - Remote API implementation
- `HybridSpoolDataSource` - Combines local and remote with sync
- `ProfileDataSource` - Profile data access interface
- `RfidReaderDataSource` - RFID hardware interface
- `RfidDataStorage` - RFID data persistence interface

### Services
- `ApiService` - HTTP API communication
- `SpoolApiService` - Spool-specific API operations
- `SyncService` - Bidirectional data synchronization

### Models & Mappers
- `SpoolDto`, `SpoolProfileDto`, `RfidDataDto` - Data transfer objects
- `SpoolMapper`, `SpoolProfileMapper` - Entity/DTO conversion
- `MaterialTypeMapper`, `SpoolColorMapper` - Value object mappers

## Usage

### Quick Start

```dart
import 'package:spool_coder_app/data/data.dart';

// Initialize for development (local storage only)
final config = DataLayerConfig.development();
final repositories = await DataLayerInitializer.initialize(config);

// Access repositories
final spoolRepo = repositories.spoolRepository;
final profileRepo = repositories.profileRepository;
```

### Production Setup

```dart
// Initialize for production (hybrid with API sync)
final config = DataLayerConfig.production(
  apiBaseUrl: 'https://api.bambulab.com',
  apiKey: 'your-api-key',
);
final repositories = await DataLayerInitializer.initialize(config);
```

### Repository Usage

```dart
// Get all spools
final spools = await spoolRepo.getAllSpools();

// Search spools
final nearlyEmpty = await spoolRepo.searchSpools(isNearlyEmpty: true);

// Get spool profiles
final profiles = await profileRepo.getAllProfiles();
final plaProfiles = await profileRepo.getProfilesByMaterial(MaterialType.pla);

// RFID operations
final isAvailable = await rfidReaderRepo.isReaderAvailable();
if (isAvailable) {
  await rfidReaderRepo.initialize();
  final tags = await rfidReaderRepo.scanForTags();
  final rfidData = await rfidReaderRepo.readTag(tags.first);
}
```

### Custom Configuration

```dart
final config = DataLayerConfig(
  defaultDataSourceType: DataSourceType.hybrid,
  apiBaseUrl: 'https://your-api.com',
  enableCaching: true,
  enableSync: true,
  syncInterval: Duration(minutes: 30),
);
```

## Data Source Types

- **Local**: Uses device storage only (SQLite, SharedPreferences, etc.)
- **Remote**: Uses API server only (requires network connection)  
- **Hybrid**: Combines local and remote with automatic synchronization

## Guidelines

- Implement domain repository interfaces
- Transform external data to domain entities using mappers
- Handle errors and exceptions appropriately
- Cache data when appropriate for offline access
- Keep data sources focused and single-purpose

## Dependencies

- Domain layer (entities, repository interfaces)
- Platform layer (hardware integrations)
- Core layer (utilities, errors)
- External packages for data persistence

## Testing

```dart
// Run data layer tests
flutter test test/data/

// Run specific test files
flutter test test/data/data_models_test.dart
flutter test test/data/data_layer_integration_test.dart
```

## Implementation Notes

- All repositories are implemented with dependency injection in mind
- Data sources use the abstract factory pattern for flexibility
- DTOs provide clean serialization boundaries
- Mappers handle safe conversion between external and domain data
- Factory classes simplify setup and configuration
- Mock implementations are provided for development and testing