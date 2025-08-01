import 'package:spool_coder_app/domain/domain.dart';

/// Comprehensive RFID workflow example
/// Demonstrates complete integration from scan to usage
void main() async {
  // ignore: avoid_print
  // ignore: avoid_print`n  print('=== Complete Bambu Lab RFID Workflow ===\n');

  // Simulate a complete RFID workflow
  await demonstrateRfidWorkflow();
}

Future<void> demonstrateRfidWorkflow() async {
  // Step 1: Simulate RFID scanning
  // ignore: avoid_print
  // ignore: avoid_print`n  print('Step 1: RFID Tag Scanning');
  // ignore: avoid_print
  // ignore: avoid_print`n  print('==========================');
  
  // Real Bambu Lab PLA Basic RFID data
  final rfidBlocks = {
    '0': '75886B1D8B080400034339DB5B5E0A90',   // UID: 75886B1D
    '1': '4130302D413000004746413030000000',   // Variant: A30-A0, Material: GFA30
    '2': '504C4100000000000000000000000000',   // Type: PLA
    '4': '504C4120426173696300000000000000',   // Detailed: PLA Basic  
    '5': 'FF6A13FFFA0000000000E03F00000000',   // Color: FF6A13FF, Weight: 250g
    '6': '3700080001002D00DC00DC0000000000',   // Temps: 55°C/8h, bed 45°C, hotend 220°C
    '8': '8813100EE803E8039A99193FCDCC4C3E',   // X-Cam info, nozzle diameter
    '9': 'D7AC3B89A16B47C4B061728044E1F2D5',   // Tray UID
    '10': '00000000E11900000000000000000000',  // Spool width: 66.25mm  
    '12': '323032325F31305F31355F30385F3236', // Production: 2022_10_15_08_26
    '13': '36303932323032000000000000000000', // Short date: 609220_2
    '14': '00000000520000000000000000000000', // Length: 82 meters
  };

  // Parse the RFID data
  final rfidData = RfidData.fromBlockDump(rfidBlocks);
  // ignore: avoid_print
  // ignore: avoid_print`n  print('✓ RFID tag scanned successfully');
  // ignore: avoid_print
  // ignore: avoid_print`n  print('  UID: ${rfidData.uid}');
  // ignore: avoid_print
  // ignore: avoid_print`n  print('  Material: ${rfidData.detailedFilamentType}');
  // ignore: avoid_print
  // ignore: avoid_print`n  print('  Production: ${rfidData.productionInfo?.productionDateTime}');
  // ignore: avoid_print
  // ignore: avoid_print`n  print('');

  // Step 2: Validate RFID data
  // ignore: avoid_print
  // ignore: avoid_print`n  print('Step 2: RFID Data Validation');
  // ignore: avoid_print
  // ignore: avoid_print`n  print('=============================');
  
  final rfidService = SpoolRfidService();
  final validationIssues = rfidService.validateRfidData(rfidData);
  
  if (validationIssues.isEmpty) {
    // ignore: avoid_print
    // ignore: avoid_print`n    print('✓ RFID data validation passed');
  } else {
    // ignore: avoid_print
    // ignore: avoid_print`n    print('⚠ Validation issues found:');
    for (final issue in validationIssues) {
      // ignore: avoid_print
      // ignore: avoid_print`n      print('  - $issue');
    }
  }
  
  // Check for warnings
  final warnings = rfidService.analyzeForWarnings(rfidData);
  if (warnings.isNotEmpty) {
    // ignore: avoid_print
    // ignore: avoid_print`n    print('⚠ Warnings:');
    for (final warning in warnings) {
      // ignore: avoid_print
      // ignore: avoid_print`n      print('  - $warning');
    }
  }
  // ignore: avoid_print
  // ignore: avoid_print`n  print('');

  // Step 3: Create Spool from RFID data
  // ignore: avoid_print
  // ignore: avoid_print`n  print('Step 3: Spool Entity Creation');
  // ignore: avoid_print
  // ignore: avoid_print`n  print('==============================');
  
  final spool = Spool.fromRfidData(rfidData);
  // ignore: avoid_print`n  print('✓ Spool created from RFID data');
  // ignore: avoid_print`n  print('  Spool UID: ${spool.uid}');
  // ignore: avoid_print`n  print('  Material: ${spool.materialType.displayName}');
  // ignore: avoid_print`n  print('  Manufacturer: ${spool.manufacturer}');
  // ignore: avoid_print`n  print('  Color: ${spool.color}');
  // ignore: avoid_print`n  print('  Net Length: ${spool.netLength.format()}');
  // ignore: avoid_print`n  print('  Is RFID Scanned: ${spool.isRfidScanned}');
  // ignore: avoid_print`n  print('  Production Age: ${spool.productionAge}');
  // ignore: avoid_print`n  print('');

  // Step 4: Generate printing recommendations
  // ignore: avoid_print`n  print('Step 4: Printing Recommendations');
  // ignore: avoid_print`n  print('=================================');
  
  final recommendations = rfidService.generatePrintingRecommendations(rfidData);
  // ignore: avoid_print`n  print('✓ Recommendations generated:');
  
  // Temperature settings
  if (recommendations.containsKey('hotend_temperature')) {
    // ignore: avoid_print`n    print('  🌡️  Hotend Temperature: ${recommendations['hotend_temperature']}°C');
  }
  if (recommendations.containsKey('bed_temperature')) {
    // ignore: avoid_print`n    print('  🛏️  Bed Temperature: ${recommendations['bed_temperature']}°C');
  }
  
  // Drying requirements
  if (recommendations['drying_required'] == true) {
    // ignore: avoid_print`n    print('  🔥 Drying Required: ${recommendations['drying_temperature']}°C for ${recommendations['drying_hours']} hours');
  }
  
  // Material-specific info
  if (recommendations.containsKey('material_type')) {
    // ignore: avoid_print`n    print('  🧵 Material: ${recommendations['material_type']}');
  }
  if (recommendations.containsKey('recommended_nozzle')) {
    // ignore: avoid_print`n    print('  🔧 Nozzle: ${recommendations['recommended_nozzle']}');
  }
  
  // Freshness status
  if (recommendations.containsKey('freshness_status')) {
    // ignore: avoid_print`n    print('  📅 Freshness: ${recommendations['freshness_status']}');
  }
  // ignore: avoid_print`n  print('');

  // Step 5: Usage tracking simulation
  // ignore: avoid_print`n  print('Step 5: Usage Tracking');
  // ignore: avoid_print`n  print('======================');
  
  // Simulate printing usage
  final usedAmount = FilamentLength.meters(22.0); // Used 22 meters
  final remainingLength = spool.netLength - usedAmount;
  
  final updatedSpool = spool.copyWith(
    remainingLength: remainingLength,
    updatedAt: DateTime.now(),
  );
  
  // ignore: avoid_print`n  print('✓ Usage updated');
  // ignore: avoid_print`n  print('  Original Length: ${spool.netLength.format()}');
  // ignore: avoid_print`n  print('  Used Amount: ${usedAmount.format()}');
  // ignore: avoid_print`n  print('  Remaining: ${updatedSpool.remainingLength.format()}');
  // ignore: avoid_print`n  print('  Usage Percentage: ${updatedSpool.usagePercentage.toStringAsFixed(1)}%');
  // ignore: avoid_print`n  print('  Is Nearly Empty: ${updatedSpool.isNearlyEmpty}');
  // ignore: avoid_print`n  print('');

  // Step 6: Material compatibility check
  // ignore: avoid_print`n  print('Step 6: Material Compatibility');
  // ignore: avoid_print`n  print('===============================');
  
  // Check compatibility with expected material
  final expectedMaterial = MaterialType.plaBasic;
  final isCompatible = rfidService.isMaterialCompatible(rfidData, expectedMaterial);
  
  // ignore: avoid_print`n  print('✓ Compatibility check completed');
  // ignore: avoid_print`n  print('  Expected: ${expectedMaterial.displayName}');
  // ignore: avoid_print`n  print('  RFID Material: ${rfidData.detailedFilamentType}');
  // ignore: avoid_print`n  print('  Compatible: ${isCompatible ? '✅ Yes' : '❌ No'}');
  // ignore: avoid_print`n  print('');

  // Step 7: Cost estimation (if available)
  // ignore: avoid_print`n  print('Step 7: Cost Analysis');
  // ignore: avoid_print`n  print('=====================');
  
  final spoolCost = 25.99; // Example cost
  final costPerGram = rfidService.estimateCostPerGram(rfidData, totalSpoolCost: spoolCost);
  
  if (costPerGram != null) {
    final usedCost = (usedAmount.meters * rfidData.spoolWeight! / spool.netLength.meters) * costPerGram;
    // ignore: avoid_print`n    print('✓ Cost analysis completed');
    // ignore: avoid_print`n    print('  Total Spool Cost: \$${spoolCost.toStringAsFixed(2)}');
    // ignore: avoid_print`n    print('  Cost per Gram: \$${costPerGram.toStringAsFixed(3)}');
    // ignore: avoid_print`n    print('  Used Material Cost: \$${usedCost.toStringAsFixed(2)}');
  } else {
    // ignore: avoid_print`n    print('❌ Cost analysis unavailable (missing weight data)');
  }
  // ignore: avoid_print`n  print('');

  // Step 8: Maintenance recommendations
  // ignore: avoid_print`n  print('Step 8: Maintenance Recommendations');
  // ignore: avoid_print`n  print('====================================');
  
  final maintenanceRecommendations = <String>[];
  
  // Check material-specific maintenance needs
  if (spool.materialType == MaterialType.plaCf) {
    maintenanceRecommendations.add('Check nozzle wear regularly due to abrasive carbon fiber');
    maintenanceRecommendations.add('Use hardened steel nozzle for best results');
  }
  
  // Check age-based recommendations
  if (spool.isOldProduction) {
    maintenanceRecommendations.add('Check filament quality - material is over 2 years old');
    maintenanceRecommendations.add('Consider longer drying time if moisture absorbed');
  }
  
  // Check usage-based recommendations
  if (updatedSpool.isNearlyEmpty) {
    maintenanceRecommendations.add('Spool is nearly empty - prepare replacement');
  }
  
  if (maintenanceRecommendations.isNotEmpty) {
    // ignore: avoid_print`n    print('🔧 Maintenance recommendations:');
    for (final recommendation in maintenanceRecommendations) {
      // ignore: avoid_print`n      print('  - $recommendation');
    }
  } else {
    // ignore: avoid_print`n    print('✓ No special maintenance required');
  }
  // ignore: avoid_print`n  print('');

  // Step 9: Summary and next steps
  // ignore: avoid_print`n  print('Step 9: Workflow Summary');
  // ignore: avoid_print`n  print('========================');
  
  // ignore: avoid_print`n  print('✅ RFID workflow completed successfully');
  // ignore: avoid_print`n  print('');
  // ignore: avoid_print`n  print('Summary:');
  // ignore: avoid_print`n  print('  • Material: ${spool.materialType.displayName}');
  // ignore: avoid_print`n  print('  • Status: ${updatedSpool.usagePercentage.toStringAsFixed(1)}% used');
  // ignore: avoid_print`n  print('  • Quality: ${spool.isFreshProduction ? 'Fresh' : spool.isOldProduction ? 'Aged' : 'Standard'}');
  // ignore: avoid_print`n  print('  • Compatibility: ${isCompatible ? 'Verified' : 'Mismatch'}');
  // ignore: avoid_print`n  print('  • Recommendations: ${recommendations.length} generated');
  // ignore: avoid_print`n  print('  • Maintenance: ${maintenanceRecommendations.length} items');
  // ignore: avoid_print`n  print('');
  
  // ignore: avoid_print`n  print('Next Steps:');
  // ignore: avoid_print`n  print('  1. Store spool data in repository');
  // ignore: avoid_print`n  print('  2. Set up automatic usage tracking');
  // ignore: avoid_print`n  print('  3. Configure printer with recommended settings');
  // ignore: avoid_print`n  print('  4. Schedule maintenance as needed');
  // ignore: avoid_print`n  print('  5. Monitor filament quality over time');
  // ignore: avoid_print`n  print('');
  
  // ignore: avoid_print`n  print('=== RFID Workflow Complete ===');
}
