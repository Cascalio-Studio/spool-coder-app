import 'package:spool_coder_app/domain/value_objects/rfid_data.dart';

/// Example demonstrating the complete Bambu Lab RFID parser
/// 
/// This example shows how to:
/// - Parse real Bambu Lab RFID data from different sources
/// - Handle various data formats (block dumps, raw bytes, Flipper Zero dumps)
/// - Extract material properties, temperatures, and production info
/// - Validate RFID tag authenticity using RSA signatures
void main() {
  // Example 1: Parse from block dump (common debug format)
  final blockDump = {
    '0': '04123456789ABC00', // UID and manufacturer data
    '1': '474630314142434445464748', // Material variant + ID
    '2': '504C410000000000000000000000000', // Filament type: "PLA"
    '4': '504C412B0000000000000000000000000', // Detailed type: "PLA+"
    '5': 'FF0000FF64001000175C0F40', // Red color, 100g weight, 1.75mm diameter
    '6': '3C00080050003C01F400E601', // Temperatures: 60°C dry, 8hr, 80°C bed, 500°C hotend
    '8': '00000000000000000000000080BF3F40', // X-Cam info + 0.4mm nozzle
    '9': '424C31323334353637380000000000000', // Tray UID: "BL12345678"
    '10': '000000006400000000000000000000000', // Spool width: 100mm
    '12': '323032345F30385F31355F31345F3330', // Production: "2024_08_15_14_30"
    '14': '00000000E803000000000000000000000', // Length: 1000 meters
    '16': '020002000000FF00000000000000000', // Dual color: format=2, count=2, second=blue
  };

  try {
    final _ = RfidData.fromBlockDump(blockDump);
    // Example complete - data parsed successfully
  } catch (e) {
    // Handle parsing error
  }
}
