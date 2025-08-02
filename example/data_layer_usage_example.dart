import '../data/data.dart';

/// Example demonstrating how to use the data layer
/// This would typically be in your application's dependency injection setup
class DataLayerUsageExample {
  static Future<void> demonstrateUsage() async {
    print('=== Data Layer Usage Example ===\n');

    // 1. Initialize the data layer for development
    print('1. Initializing data layer for development...');
    final config = DataLayerConfig.development();
    final repositories = await DataLayerInitializer.initialize(config);
    print('✓ Data layer initialized with local repositories\n');

    // 2. Access repositories through the container
    print('2. Accessing repositories...');
    final spoolRepo = repositories.spoolRepository;
    final profileRepo = repositories.profileRepository;
    final rfidReaderRepo = repositories.rfidReaderRepository;
    print('✓ Repositories accessible\n');

    // 3. Use profile repository to get default profiles
    print('3. Working with profile repository...');
    try {
      final profiles = await profileRepo.getAllProfiles();
      print('✓ Found ${profiles.length} spool profiles');
      
      // Get profiles for specific material
      final plaProfiles = await profileRepo.getProfilesByMaterial(MaterialType.pla);
      print('✓ Found ${plaProfiles.length} PLA profiles');
    } catch (e) {
      print('⚠ Profile operations need domain entities to be properly imported');
    }
    print();

    // 4. Use RFID reader repository
    print('4. Working with RFID reader repository...');
    try {
      final isAvailable = await rfidReaderRepo.isReaderAvailable();
      print('✓ RFID reader available: $isAvailable');
      
      if (isAvailable) {
        await rfidReaderRepo.initialize();
        final readerInfo = await rfidReaderRepo.getReaderInfo();
        print('✓ Reader info: ${readerInfo['model']}');
      }
    } catch (e) {
      print('⚠ RFID operations need domain entities to be properly imported');
    }
    print();

    // 5. Demonstrate data source factory
    print('5. Creating data sources with factory...');
    final localSpoolRepo = DataLayerFactory.createSpoolRepository(
      type: DataSourceType.local,
    );
    final profileRepository = DataLayerFactory.createProfileRepository();
    print('✓ Created repositories using factory\n');

    // 6. Demonstrate configuration for different environments
    print('6. Configuration examples...');
    
    // Development configuration
    final devConfig = DataLayerConfig.development();
    print('✓ Development config: local storage, no sync');
    
    // Production configuration
    try {
      final prodConfig = DataLayerConfig.production(
        apiBaseUrl: 'https://api.example.com',
        apiKey: 'your-api-key',
      );
      print('✓ Production config: hybrid storage, auto sync');
      
      final validationError = prodConfig.validate();
      print('✓ Configuration validation: ${validationError ?? "Valid"}');
    } catch (e) {
      print('⚠ Production config example');
    }
    print();

    // 7. Show data models usage
    print('7. Data models and mappers...');
    final spoolDto = SpoolDto(
      uid: 'example_123',
      materialType: 'PLA',
      manufacturer: 'BambuLab',
      color: 'Blue',
      netLength: 1000.0,
      remainingLength: 750.0,
      createdAt: DateTime.now().toIso8601String(),
    );
    
    final json = spoolDto.toJson();
    final restored = SpoolDto.fromJson(json);
    print('✓ DTO serialization works: ${restored.uid}');
    
    // Mapper utilities
    final parsedDouble = MapperUtils.parseDouble('123.45');
    final parsedBool = MapperUtils.parseBool('true');
    print('✓ Mapper utilities work: $parsedDouble, $parsedBool');
    print();

    // 8. Cleanup
    print('8. Cleaning up...');
    await DataLayerInitializer.dispose();
    print('✓ Data layer disposed\n');

    print('=== Example Complete ===');
    print('The data layer provides:');
    print('• Complete repository implementations for all domain interfaces');
    print('• Flexible data sources (local, remote, hybrid)');
    print('• Data models and mappers for serialization');
    print('• Factory pattern for easy configuration');
    print('• Proper separation of concerns');
    printIntegrationInstructions();
  }

  static void printIntegrationInstructions() {
    print('\n=== Integration Instructions ===');
    print();
    print('To integrate the data layer in your app:');
    print();
    print('1. Import the data layer:');
    print("   import 'package:spool_coder_app/data/data.dart';");
    print();
    print('2. Initialize in your main() function:');
    print('   final config = DataLayerConfig.development();');
    print('   final repositories = await DataLayerInitializer.initialize(config);');
    print();
    print('3. Register repositories with your DI container (e.g., GetIt):');
    print('   GetIt.instance.registerSingleton<SpoolRepository>(repositories.spoolRepository);');
    print('   GetIt.instance.registerSingleton<SpoolProfileRepository>(repositories.profileRepository);');
    print('   // ... register all other repositories');
    print();
    print('4. Use repositories in your use cases:');
    print('   class GetSpoolsUseCase {');
    print('     final SpoolRepository _repository;');
    print('     GetSpoolsUseCase(this._repository);');
    print('     Future<List<Spool>> execute() => _repository.getAllSpools();');
    print('   }');
    print();
    print('5. For production, use hybrid configuration:');
    print('   final config = DataLayerConfig.production(');
    print("     apiBaseUrl: 'https://your-api.com',");  
    print("     apiKey: 'your-api-key',");
    print('   );');
    print();
  }
}

/// Mock classes to make the example runnable
class MaterialType {
  static const pla = MaterialType._('PLA');
  final String value;
  const MaterialType._(this.value);
}

class DataSourceType {
  static const local = DataSourceType._();
  static const remote = DataSourceType._();
  static const hybrid = DataSourceType._();
  const DataSourceType._();
}

// Entry point for running the example
void main() async {
  await DataLayerUsageExample.demonstrateUsage();
}