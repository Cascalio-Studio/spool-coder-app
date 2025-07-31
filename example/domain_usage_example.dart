// Example usage of the domain layer
// This file demonstrates how to use the enhanced domain layer components

import '../lib/domain/domain.dart';

void main() {
  print('=== Spool Coder App Domain Layer Examples ===\n');

  // Example 1: Creating value objects
  print('1. Creating Value Objects:');
  
  // Create a validated spool UID
  final uid = SpoolUid('BAMBU_PLA_RED_001');
  print('   Spool UID: $uid');
  
  // Create material type
  final material = MaterialType.pla;
  print('   Material: ${material.displayName} (${material.printTemperature}°C)');
  
  // Create color with hex code
  final color = SpoolColor.hex('Bright Red', '#FF3300');
  print('   Color: $color');
  
  // Create length measurements
  final netLength = FilamentLength.meters(1000.0);
  final remainingLength = FilamentLength.meters(750.0);
  print('   Net Length: ${netLength.format()}');
  print('   Remaining: ${remainingLength.format()}\n');

  // Example 2: Creating a spool entity
  print('2. Creating Spool Entity:');
  
  final spool = Spool(
    uid: uid,
    materialType: material,
    manufacturer: 'BambuLab',
    color: color,
    netLength: netLength,
    remainingLength: remainingLength,
    filamentDiameter: 1.75,
    spoolWeight: 250.0,
    batchNumber: 'B2024001',
    createdAt: DateTime.now(),
  );
  
  print('   $spool');
  print('   Usage: ${spool.usagePercentage.toStringAsFixed(1)}%');
  print('   Used: ${spool.usedLength.format()}');
  print('   Nearly Empty: ${spool.isNearlyEmpty}');
  print('   Can Write: ${spool.canWrite}\n');

  // Example 3: Creating a spool profile
  print('3. Creating Spool Profile:');
  
  final profile = SpoolProfile(
    id: 'bambu_pla_standard',
    name: 'Standard PLA',
    manufacturer: 'BambuLab',
    materialType: MaterialType.pla,
    defaultColor: SpoolColor.named('Natural'),
    standardLength: FilamentLength.meters(1000.0),
    filamentDiameter: 1.75,
    spoolDiameter: 200.0,
    spoolWidth: 70.0,
    spoolWeight: 250.0,
    printTemperature: 200,
    bedTemperature: 60,
    printSpeed: 50,
    notes: 'Standard PLA profile for general purpose printing',
    createdAt: DateTime.now(),
  );
  
  print('   Profile: ${profile.displayName}');
  print('   Complete: ${profile.isComplete}');
  print('   Diameter: ${profile.filamentDiameter}mm');
  print('   Print Temp: ${profile.printTemperature}°C\n');

  // Example 4: Demonstrating value object operations
  print('4. Value Object Operations:');
  
  // Length calculations
  final halfLength = netLength / 2;
  final doubleLength = netLength * 2;
  print('   Half length: ${halfLength.format()}');
  print('   Double length: ${doubleLength.format()}');
  
  // Length comparisons
  print('   Remaining > Half: ${remainingLength > halfLength}');
  print('   Is nearly empty: ${remainingLength < (netLength * 0.1)}\n');

  // Example 5: Custom material type
  print('5. Custom Material Type:');
  
  final woodPla = MaterialType.custom(
    value: 'WOOD_PLA',
    displayName: 'Wood Filled PLA',
    defaultDensity: 1.15,
    printTemperature: 190,
    bedTemperature: 60,
  );
  
  print('   Custom Material: ${woodPla.displayName}');
  print('   Density: ${woodPla.defaultDensity}g/cm³');
  print('   Print Temp: ${woodPla.printTemperature}°C\n');

  // Example 6: Error handling
  print('6. Error Handling Examples:');
  
  try {
    // This will throw an exception
    SpoolUid('');
  } catch (e) {
    print('   Caught invalid UID error: $e');
  }
  
  try {
    // This will throw an exception
    FilamentLength.meters(-100);
  } catch (e) {
    print('   Caught negative length error: $e');
  }
  
  try {
    // This will throw an exception
    SpoolColor.hex('Red', 'invalid');
  } catch (e) {
    print('   Caught invalid hex color error: $e');
  }

  print('\n=== Examples Complete ===');
}

// Example repository implementation interfaces (would be implemented in data layer)
class ExampleUseCaseInterfaces {
  // These demonstrate how use cases would be used
  
  void demonstrateUseCases() async {
    // Example of how use cases would be used in the application
    
    // Scanning a spool
    // final spool = await scanSpoolUseCase.execute(ScanMethod.nfc);
    
    // Getting all spools
    // final allSpools = await getAllSpoolsUseCase.execute();
    
    // Searching spools
    // final plaSpools = await searchSpoolsUseCase.execute(materialType: 'PLA');
    
    // Managing profiles
    // final profiles = await getSpoolProfilesUseCase.execute();
    
    print('Use case interfaces ready for implementation in application layer');
  }
}

// Example service usage (these would have concrete implementations)
class ExampleServiceUsage {
  void demonstrateServices() {
    print('Domain services ready for implementation:');
    print('- SpoolValidationService: Comprehensive validation logic');
    print('- SpoolCalculationService: Usage statistics and predictions');
    print('- SpoolOrchestrationService: Complex workflows');
  }
}