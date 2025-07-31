import '../../lib/domain/domain.dart';

/// Comprehensive RFID workflow example
/// Demonstrates complete integration from scan to usage
void main() async {
  print('=== Complete Bambu Lab RFID Workflow ===\n');

  // Simulate a complete RFID workflow
  await demonstrateRfidWorkflow();
}

Future<void> demonstrateRfidWorkflow() async {
  // Step 1: Simulate RFID scanning
  print('Step 1: RFID Tag Scanning');
  print('==========================');
  
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
  print('✓ RFID tag scanned successfully');
  print('  UID: ${rfidData.uid}');
  print('  Material: ${rfidData.detailedFilamentType}');
  print('  Production: ${rfidData.productionInfo?.productionDateTime}');
  print('');

  // Step 2: Validate RFID data
  print('Step 2: RFID Data Validation');
  print('=============================');
  
  final rfidService = SpoolRfidService();
  final validationIssues = rfidService.validateRfidData(rfidData);
  
  if (validationIssues.isEmpty) {
    print('✓ RFID data validation passed');
  } else {
    print('⚠ Validation issues found:');
    for (final issue in validationIssues) {
      print('  - $issue');
    }
  }
  
  // Check for warnings
  final warnings = rfidService.analyzeForWarnings(rfidData);
  if (warnings.isNotEmpty) {
    print('⚠ Warnings:');
    for (final warning in warnings) {
      print('  - $warning');
    }
  }
  print('');

  // Step 3: Create Spool from RFID data
  print('Step 3: Spool Entity Creation');
  print('==============================');
  
  final spool = Spool.fromRfidData(rfidData);
  print('✓ Spool created from RFID data');
  print('  Spool UID: ${spool.uid}');
  print('  Material: ${spool.materialType.displayName}');
  print('  Manufacturer: ${spool.manufacturer}');
  print('  Color: ${spool.color}');
  print('  Net Length: ${spool.netLength.format()}');
  print('  Is RFID Scanned: ${spool.isRfidScanned}');
  print('  Production Age: ${spool.productionAge}');
  print('');

  // Step 4: Generate printing recommendations
  print('Step 4: Printing Recommendations');
  print('=================================');
  
  final recommendations = rfidService.generatePrintingRecommendations(rfidData);
  print('✓ Recommendations generated:');
  
  // Temperature settings
  if (recommendations.containsKey('hotend_temperature')) {
    print('  🌡️  Hotend Temperature: ${recommendations['hotend_temperature']}°C');
  }
  if (recommendations.containsKey('bed_temperature')) {
    print('  🛏️  Bed Temperature: ${recommendations['bed_temperature']}°C');
  }
  
  // Drying requirements
  if (recommendations['drying_required'] == true) {
    print('  🔥 Drying Required: ${recommendations['drying_temperature']}°C for ${recommendations['drying_hours']} hours');
  }
  
  // Material-specific info
  if (recommendations.containsKey('material_type')) {
    print('  🧵 Material: ${recommendations['material_type']}');
  }
  if (recommendations.containsKey('recommended_nozzle')) {
    print('  🔧 Nozzle: ${recommendations['recommended_nozzle']}');
  }
  
  // Freshness status
  if (recommendations.containsKey('freshness_status')) {
    print('  📅 Freshness: ${recommendations['freshness_status']}');
  }
  print('');

  // Step 5: Usage tracking simulation
  print('Step 5: Usage Tracking');
  print('======================');
  
  // Simulate printing usage
  final usedAmount = FilamentLength.meters(22.0); // Used 22 meters
  final remainingLength = spool.netLength - usedAmount;
  
  final updatedSpool = spool.copyWith(
    remainingLength: remainingLength,
    updatedAt: DateTime.now(),
  );
  
  print('✓ Usage updated');
  print('  Original Length: ${spool.netLength.format()}');
  print('  Used Amount: ${usedAmount.format()}');
  print('  Remaining: ${updatedSpool.remainingLength.format()}');
  print('  Usage Percentage: ${updatedSpool.usagePercentage.toStringAsFixed(1)}%');
  print('  Is Nearly Empty: ${updatedSpool.isNearlyEmpty}');
  print('');

  // Step 6: Material compatibility check
  print('Step 6: Material Compatibility');
  print('===============================');
  
  // Check compatibility with expected material
  final expectedMaterial = MaterialType.plaBasic;
  final isCompatible = rfidService.isMaterialCompatible(rfidData, expectedMaterial);
  
  print('✓ Compatibility check completed');
  print('  Expected: ${expectedMaterial.displayName}');
  print('  RFID Material: ${rfidData.detailedFilamentType}');
  print('  Compatible: ${isCompatible ? '✅ Yes' : '❌ No'}');
  print('');

  // Step 7: Cost estimation (if available)
  print('Step 7: Cost Analysis');
  print('=====================');
  
  final spoolCost = 25.99; // Example cost
  final costPerGram = rfidService.estimateCostPerGram(rfidData, totalSpoolCost: spoolCost);
  
  if (costPerGram != null) {
    final usedCost = (usedAmount.meters * rfidData.spoolWeight! / spool.netLength.meters) * costPerGram;
    print('✓ Cost analysis completed');
    print('  Total Spool Cost: \$${spoolCost.toStringAsFixed(2)}');
    print('  Cost per Gram: \$${costPerGram.toStringAsFixed(3)}');
    print('  Used Material Cost: \$${usedCost.toStringAsFixed(2)}');
  } else {
    print('❌ Cost analysis unavailable (missing weight data)');
  }
  print('');

  // Step 8: Maintenance recommendations
  print('Step 8: Maintenance Recommendations');
  print('====================================');
  
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
    print('🔧 Maintenance recommendations:');
    for (final recommendation in maintenanceRecommendations) {
      print('  - $recommendation');
    }
  } else {
    print('✓ No special maintenance required');
  }
  print('');

  // Step 9: Summary and next steps
  print('Step 9: Workflow Summary');
  print('========================');
  
  print('✅ RFID workflow completed successfully');
  print('');
  print('Summary:');
  print('  • Material: ${spool.materialType.displayName}');
  print('  • Status: ${updatedSpool.usagePercentage.toStringAsFixed(1)}% used');
  print('  • Quality: ${spool.isFreshProduction ? 'Fresh' : spool.isOldProduction ? 'Aged' : 'Standard'}');
  print('  • Compatibility: ${isCompatible ? 'Verified' : 'Mismatch'}');
  print('  • Recommendations: ${recommendations.length} generated');
  print('  • Maintenance: ${maintenanceRecommendations.length} items');
  print('');
  
  print('Next Steps:');
  print('  1. Store spool data in repository');
  print('  2. Set up automatic usage tracking');
  print('  3. Configure printer with recommended settings');
  print('  4. Schedule maintenance as needed');
  print('  5. Monitor filament quality over time');
  print('');
  
  print('=== RFID Workflow Complete ===');
}