import 'package:spool_coder_app/domain/domain.dart';

/// Example demonstrating Bambu Lab RFID integration
/// Based on real RFID data from Bambu-Research-Group/RFID-Tag-Guide
void main() {
  // ignore: avoid_print
  // ignore: avoid_print`n  print('=== Bambu Lab RFID Integration Example ===\n');

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
  // ignore: avoid_print`n  print('1. Parsing RFID Data from Block Dump');
  // ignore: avoid_print`n  print('=====================================');
  final rfidData = RfidData.fromBlockDump(realRfidBlocks);
  
  // ignore: avoid_print`n  print('UID: ${rfidData.uid}');
  // ignore: avoid_print`n  print('Material Type: ${rfidData.filamentType}');
  // ignore: avoid_print`n  print('Detailed Type: ${rfidData.detailedFilamentType}');
  // ignore: avoid_print`n  print('Description: ${rfidData.description}');
  // ignore: avoid_print`n  print('Is Genuine Bambu Lab: ${rfidData.isGenuineBambuLab}');
  // ignore: avoid_print`n  print('Is Complete: ${rfidData.isComplete}');
  // ignore: avoid_print`n  print('');

  // Create Spool from RFID data
  // ignore: avoid_print`n  print('2. Creating Spool Entity from RFID Data');
  // ignore: avoid_print`n  print('========================================');
  final spool = Spool.fromRfidData(rfidData);
  
  // ignore: avoid_print`n  print('Spool UID: ${spool.uid}');
  // ignore: avoid_print`n  print('Material: ${spool.materialType.displayName}');
  // ignore: avoid_print`n  print('Manufacturer: ${spool.manufacturer}');
  // ignore: avoid_print`n  print('Color: ${spool.color}');
  // ignore: avoid_print`n  print('Net Length: ${spool.netLength.format()}');
  // ignore: avoid_print`n  print('Is RFID Scanned: ${spool.isRfidScanned}');
  // ignore: avoid_print`n  print('');

  // Temperature and printing recommendations
  // ignore: avoid_print`n  print('3. Temperature Profile and Recommendations');
  // ignore: avoid_print`n  print('==========================================');
  if (spool.temperatureProfile != null) {
    // Optional: process temperature profile if needed
  }
  // ignore: avoid_print`n  print('');

  // Production information
  // ignore: avoid_print`n  print('4. Production Information');
  // ignore: avoid_print`n  print('=========================');
  if (spool.productionInfo != null) {
    // Optional: process production info if needed
  }
  // ignore: avoid_print`n  print('');

  // Business logic examples
  // ignore: avoid_print`n  print('5. Spool Business Logic');
  // ignore: avoid_print`n  print('=======================');
  // ignore: avoid_print`n  print('Usage Percentage: ${spool.usagePercentage.toStringAsFixed(1)}%');
  // ignore: avoid_print`n  print('Is Nearly Empty: ${spool.isNearlyEmpty}');
  // ignore: avoid_print`n  print('Is Empty: ${spool.isEmpty}');
  // ignore: avoid_print`n  print('Used Length: ${spool.usedLength.format()}');
  // ignore: avoid_print`n  print('Nozzle Compatibility: ${spool.nozzleCompatibility}');
  // ignore: avoid_print`n  print('');

  // RFID Service validation and recommendations
  // ignore: avoid_print`n  print('6. RFID Service Analysis');
  // ignore: avoid_print`n  print('========================');
  final rfidService = SpoolRfidService();
  
  // Validate RFID data
  rfidService.validateRfidData(rfidData);
  
  // Analyze for warnings
  rfidService.analyzeForWarnings(rfidData);
  
  final recommendations = rfidService.generatePrintingRecommendations(rfidData);
  // ignore: avoid_print`n  print('Printing Recommendations:');
  recommendations.forEach((key, value) {
    // ignore: avoid_print`n    print('  $key: $value');
  });
  // ignore: avoid_print`n  print('');

  // Material type variations
  // ignore: avoid_print`n  print('7. Bambu Lab Material Types');
  // ignore: avoid_print`n  print('===========================');
  // ignore: avoid_print`n  print('All Bambu Lab Material Types:');
  // Iterate all Bambu Lab material types if needed
  // ignore: avoid_print`n  print('');

  // RFID-specific material identification
  // ignore: avoid_print`n  print('8. Material Identification from RFID');
  // ignore: avoid_print`n  print('====================================');
  // Identify material from RFID if needed
  // ignore: avoid_print`n  print('');

  // Spool updates with RFID data
  // ignore: avoid_print`n  print('9. Updating Spool with New RFID Scan');
  // ignore: avoid_print`n  print('====================================');
  // Update RFID data and spool as needed
  

  // ignore: avoid_print`n  print('=== RFID Integration Example Complete ===');
}
