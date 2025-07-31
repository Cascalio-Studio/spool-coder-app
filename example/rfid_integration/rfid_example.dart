import '../../lib/domain/domain.dart';

/// Example demonstrating Bambu Lab RFID integration
/// Based on real RFID data from Bambu-Research-Group/RFID-Tag-Guide
void main() {
  print('=== Bambu Lab RFID Integration Example ===\n');

  // Real RFID data from Bambu Lab PLA Basic spool
  final realRfidBlocks = {
    '0': '75886B1D8B080400034339DB5B5E0A90',
    '1': '4130302D413000004746413030000000',
    '2': '504C4100000000000000000000000000',
    '4': '504C4120426173696300000000000000',
    '5': 'FF6A13FFFA0000000000E03F00000000',
    '6': '3700080001002D00DC00DC0000000000',
    '8': '8813100EE803E8039A99193FCDCC4C3E',
    '9': 'D7AC3B89A16B47C4B061728044E1F2D5',
    '10': '00000000E11900000000000000000000',
    '12': '323032325F31305F31355F30385F3236',
    '13': '36303932323032000000000000000000',
    '14': '00000000520000000000000000000000',
    // RSA signature blocks would be 40-63 in real scenario
  };

  // Parse RFID data from block dump
  print('1. Parsing RFID Data from Block Dump');
  print('=====================================');
  final rfidData = RfidData.fromBlockDump(realRfidBlocks);
  
  print('UID: ${rfidData.uid}');
  print('Material Type: ${rfidData.filamentType}');
  print('Detailed Type: ${rfidData.detailedFilamentType}');
  print('Description: ${rfidData.description}');
  print('Is Genuine Bambu Lab: ${rfidData.isGenuineBambuLab}');
  print('Is Complete: ${rfidData.isComplete}');
  print('');

  // Create Spool from RFID data
  print('2. Creating Spool Entity from RFID Data');
  print('========================================');
  final spool = Spool.fromRfidData(rfidData);
  
  print('Spool UID: ${spool.uid}');
  print('Material: ${spool.materialType.displayName}');
  print('Manufacturer: ${spool.manufacturer}');
  print('Color: ${spool.color}');
  print('Net Length: ${spool.netLength.format()}');
  print('Is RFID Scanned: ${spool.isRfidScanned}');
  print('');

  // Temperature and printing recommendations
  print('3. Temperature Profile and Recommendations');
  print('==========================================');
  if (spool.temperatureProfile != null) {
    final tempProfile = spool.temperatureProfile!;
    print('Temperature Profile: $tempProfile');
    print('Recommended Print Temp: ${spool.recommendedPrintTemperature}°C');
    print('Recommended Bed Temp: ${spool.recommendedBedTemperature}°C');
    print('Needs Drying: ${spool.needsDrying}');
    if (spool.needsDrying) {
      print('Drying Instructions: ${spool.dryingInstructions}');
    }
  }
  print('');

  // Production information
  print('4. Production Information');
  print('=========================');
  if (spool.productionInfo != null) {
    final prodInfo = spool.productionInfo!;
    print('Production Info: $prodInfo');
    print('Production Age: ${spool.productionAge}');
    print('Is Fresh Production: ${spool.isFreshProduction}');
    print('Is Old Production: ${spool.isOldProduction}');
  }
  print('');

  // Business logic examples
  print('5. Spool Business Logic');
  print('=======================');
  print('Usage Percentage: ${spool.usagePercentage.toStringAsFixed(1)}%');
  print('Is Nearly Empty: ${spool.isNearlyEmpty}');
  print('Is Empty: ${spool.isEmpty}');
  print('Used Length: ${spool.usedLength.format()}');
  print('Nozzle Compatibility: ${spool.nozzleCompatibility}');
  print('');

  // RFID Service validation and recommendations
  print('6. RFID Service Analysis');
  print('========================');
  final rfidService = SpoolRfidService();
  
  final validationIssues = rfidService.validateRfidData(rfidData);
  print('Validation Issues: ${validationIssues.isEmpty ? 'None' : validationIssues.join(', ')}');
  
  final warnings = rfidService.analyzeForWarnings(rfidData);
  print('Warnings: ${warnings.isEmpty ? 'None' : warnings.join(', ')}');
  
  final recommendations = rfidService.generatePrintingRecommendations(rfidData);
  print('Printing Recommendations:');
  recommendations.forEach((key, value) {
    print('  $key: $value');
  });
  print('');

  // Material type variations
  print('7. Bambu Lab Material Types');
  print('===========================');
  print('All Bambu Lab Material Types:');
  for (final material in MaterialType.bambuLabTypes) {
    print('  ${material.value}: ${material.displayName}');
  }
  print('');

  // RFID-specific material identification
  print('8. Material Identification from RFID');
  print('====================================');
  final identifiedMaterial = MaterialType.fromRfidDetailedType('PLA Basic');
  print('Identified Material: ${identifiedMaterial.displayName}');
  print('Material Value: ${identifiedMaterial.value}');
  print('Default Density: ${identifiedMaterial.defaultDensity}g/cm³');
  print('Print Temperature: ${identifiedMaterial.printTemperature}°C');
  print('Bed Temperature: ${identifiedMaterial.bedTemperature}°C');
  print('');

  // Spool updates with RFID data
  print('9. Updating Spool with New RFID Scan');
  print('====================================');
  final updatedRfidData = rfidData.copyWith(
    scanTime: DateTime.now(),
  );
  
  final updatedSpool = spool.copyWith(
    rfidData: updatedRfidData,
    remainingLength: FilamentLength.meters(60.0), // Updated usage
    updatedAt: DateTime.now(),
  );
  
  print('Original Usage: ${spool.usagePercentage.toStringAsFixed(1)}%');
  print('Updated Usage: ${updatedSpool.usagePercentage.toStringAsFixed(1)}%');
  print('Change in Usage: ${(updatedSpool.usagePercentage - spool.usagePercentage).toStringAsFixed(1)}%');
  print('');

  print('=== RFID Integration Example Complete ===');
}