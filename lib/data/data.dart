/// Data Layer - Main Export File
/// 
/// This layer handles data access and implements repository contracts 
/// defined in the domain layer.
/// 
/// Responsibilities:
/// - Implement repository contracts from domain layer
/// - Handle data transformation between external formats and domain entities
/// - Manage data caching and persistence
/// - Abstract external data sources
/// - Handle network and hardware communication
library data_layer;

// Export repositories
export 'repositories/repositories.dart';

// Export data sources
export 'datasources/datasources.dart';

// Export services
export 'services/services.dart';

// Export models
export 'models/models.dart';

// Export mappers
export 'mappers/mappers.dart';

// Export factory and configuration
export 'data_layer_factory.dart';