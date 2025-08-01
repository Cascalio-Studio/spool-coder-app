// Example usage of the domain layer
// This file demonstrates how to use the enhanced domain layer components

import 'package:spool_coder_app/domain/domain.dart';

void main() {
  // ignore: avoid_print
  print('=== Spool Coder App Domain Layer Examples ===\n');

  // Example 1: Creating value objects
  // ignore: avoid_print
  print('1. Creating Value Objects:');
  
  // Create a validated spool UID
  final uid = SpoolUid('BAMBU_PLA_RED_001');
  // ignore: avoid_print
  print('   Spool UID: $uid');
  
  // Create material type
  final material = MaterialType.pla;
  // ignore: avoid_print
  print('   Material: ${material.displayName} (${material.printTemperature}°C)');
  
  // Create color with hex code
  final color = SpoolColor.hex('Bright Red', '#FF3300');
  // ignore: avoid_print
  print('   Color: $color');
  
  // Create length measurements
  final netLength = FilamentLength.meters(1000.0);
  final remainingLength = FilamentLength.meters(750.0);
  // ignore: avoid_print
  print('   Net Length: ${netLength.format()}');
  // ignore: avoid_print
  print('   Remaining: ${remainingLength.format()}\n');

  // Example 2: Creating a spool entity
  // ignore: avoid_print
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
  
  // ignore: avoid_print
  print('   $spool');
  // ignore: avoid_print
  print('   Usage: ${spool.usagePercentage.toStringAsFixed(1)}%');
  // ignore: avoid_print
  print('   Used: ${spool.usedLength.format()}');
  // ignore: avoid_print
  print('   Nearly Empty: ${spool.isNearlyEmpty}');
  // ignore: avoid_print
  print('   Can Write: ${spool.canWrite}\n');

  // Example 3: Creating a spool profile
  // ignore: avoid_print
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
  
  // ignore: avoid_print
  print('   Profile: ${profile.displayName}');
  // ignore: avoid_print
  print('   Complete: ${profile.isComplete}');
  // ignore: avoid_print
  print('   Diameter: ${profile.filamentDiameter}mm');
  // ignore: avoid_print
  print('   Print Temp: ${profile.printTemperature}°C\n');

  // Example 4: Demonstrating value object operations
  // ignore: avoid_print
  print('4. Value Object Operations:');
  
  // Length calculations
  final halfLength = netLength / 2;
  final doubleLength = netLength * 2;
  // ignore: avoid_print
  print('   Half length: ${halfLength.format()}');
  // ignore: avoid_print
  print('   Double length: ${doubleLength.format()}');
  
  // Length comparisons
  // ignore: avoid_print
  print('   Remaining > Half: ${remainingLength > halfLength}');
  // ignore: avoid_print
  print('   Is nearly empty: ${remainingLength < (netLength * 0.1)}\n');

  // Example 5: Custom material type
  // ignore: avoid_print
  print('5. Custom Material Type:');
  
  final woodPla = MaterialType.custom(
    value: 'WOOD_PLA',
    displayName: 'Wood Filled PLA',
    defaultDensity: 1.15,
    printTemperature: 190,
    bedTemperature: 60,
  );
  
  // ignore: avoid_print
  print('   Custom Material: ${woodPla.displayName}');
  // ignore: avoid_print
  print('   Density: ${woodPla.defaultDensity}g/cm³');
  // ignore: avoid_print
  print('   Print Temp: ${woodPla.printTemperature}°C\n');

  // Example 6: Error handling
  // ignore: avoid_print
  print('6. Error Handling Examples:');
  
  try {
    // This will throw an exception
    SpoolUid('');
  } catch (e) {
    // ignore: avoid_print
    print('   Caught invalid UID error: $e');
  }
  
  try {
    // This will throw an exception
    FilamentLength.meters(-100);
  } catch (e) {
    // ignore: avoid_print
    print('   Caught negative length error: $e');
  }
  
  try {
    // This will throw an exception
    SpoolColor.hex('Red', 'invalid');
  } catch (e) {
    // ignore: avoid_print
    print('   Caught invalid hex color error: $e');
  }

  // ignore: avoid_print
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
    
    // ignore: avoid_print
    print('Use case interfaces ready for implementation in application layer');
  }
}

// Example service usage (these would have concrete implementations)
class ExampleServiceUsage {
  void demonstrateServices() {
    // ignore: avoid_print
    print('Domain services ready for implementation:');
    // ignore: avoid_print
    print('- SpoolValidationService: Comprehensive validation logic');
    // ignore: avoid_print
    print('- SpoolCalculationService: Usage statistics and predictions');
    // ignore: avoid_print
    print('- SpoolOrchestrationService: Complex workflows');
  }
}