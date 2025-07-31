# Bambu Lab RFID Integration

This document describes the comprehensive RFID integration implemented in the spool-coder-app domain layer, based on research from the [Bambu-Research-Group/RFID-Tag-Guide](https://github.com/Bambu-Research-Group/RFID-Tag-Guide) repository.

## Overview

The RFID integration enables the app to read, parse, and utilize data from Bambu Lab RFID tags, providing rich metadata about filament spools including material types, temperature profiles, production information, and printing recommendations.

## Architecture

### Value Objects

#### RfidData
Represents complete RFID tag data parsed from Bambu Lab format:
- **UID**: Unique tag identifier (Block 0)
- **Material Information**: Basic and detailed filament types (Blocks 2, 4)
- **Physical Properties**: Color, weight, diameter (Block 5)
- **Temperature Profile**: Drying, bed, and hotend temperatures (Block 6)
- **Manufacturing Data**: Production date, batch info, material IDs (Blocks 1, 12, 13)
- **RSA Signature**: Digital authenticity verification (Blocks 40-63)

```dart
// Parse RFID data from Proxmark3 hex dump
final rfidData = RfidData.fromBlockDump({
  '0': '75886B1D8B080400034339DB5B5E0A90',
  '2': '504C4100000000000000000000000000', // "PLA"
  '4': '504C4120426173696300000000000000', // "PLA Basic"
  // ... additional blocks
});
```

#### TemperatureProfile
Structured temperature settings extracted from RFID Block 6:
- Drying temperature and time
- Bed temperature and type
- Min/max hotend temperatures
- Built-in validation and recommendations

```dart
final tempProfile = TemperatureProfile.fromRfidBlock6(blockData);
print('Recommended: ${tempProfile.recommendedHotendTemperature}°C');
print('Needs drying: ${tempProfile.needsDrying}');
```

#### ProductionInfo
Manufacturing metadata from RFID Blocks 1, 12, 13:
- Production date/time parsing
- Material ID validation (Bambu format: GF prefix)
- Tray variant information
- Age calculations and freshness indicators

### Enhanced Material Types

Extended MaterialType with Bambu Lab specific variants:
- **PLA Basic, PLA Matte, PLA Silk, PLA Galaxy, PLA Sparkle**
- **PLA-CF (Carbon Fiber), Support PLA, PETG Basic**
- RFID-aware material identification from detailed type strings

```dart
// Automatic material detection from RFID data
final material = MaterialType.fromRfidDetailedType('PLA Basic');
print(material.displayName); // "PLA Basic"
print(material.printTemperature); // 220°C
```

### Enhanced Spool Entity

#### RFID Integration
- `Spool.fromRfidData()` factory constructor
- Complete RFID metadata storage
- Temperature profile integration
- Production information embedding

```dart
// Create spool from RFID scan
final spool = Spool.fromRfidData(rfidData);
print('Material: ${spool.materialType.displayName}');
print('Print temp: ${spool.recommendedPrintTemperature}°C');
print('Age: ${spool.productionAge}');
```

#### Enhanced Business Logic
- Genuine Bambu Lab detection via RSA signatures
- Temperature recommendations from RFID data
- Drying requirement detection
- Production freshness indicators
- Nozzle compatibility information

### Domain Services

#### SpoolRfidService
Comprehensive RFID business logic:

```dart
final rfidService = SpoolRfidService();

// Validate RFID data integrity
final issues = rfidService.validateRfidData(rfidData);

// Generate printing recommendations
final recommendations = rfidService.generatePrintingRecommendations(rfidData);

// Analyze for warnings
final warnings = rfidService.analyzeForWarnings(rfidData);

// Check material compatibility
final isCompatible = rfidService.isMaterialCompatible(rfidData, expectedType);
```

### Repository Contracts

#### RfidReaderRepository
Hardware integration interface:
- RFID reader connection management
- Tag scanning and reading
- Real-time tag presence detection
- Automatic scan streaming

#### RfidDataRepository
Data persistence and caching:
- RFID scan history storage
- Offline data caching
- Scan comparison and tampering detection
- Export/import functionality

#### RfidTagLibraryRepository
Tag pattern library:
- Known tag pattern database
- Material identification by signature
- Temperature profile templates
- RSA signature validation

### Use Cases

#### RFID Scanning Operations
- `ScanRfidTagUseCase`: Direct hardware scanning
- `ParseRfidDataUseCase`: Data parsing from external sources
- `IdentifySpoolFromRfidUseCase`: Spool matching and updates

#### Material and Printing
- `VerifyMaterialFromRfidUseCase`: Material verification
- `GenerateRfidRecommendationsUseCase`: Printing recommendations
- `ArchiveRfidDataUseCase`: Scan history management

## Real-World Integration

### Supported RFID Readers
- **Proxmark3**: Complete integration with hex dump parsing
- **Flipper Zero**: NFC/RFID compatibility
- **Generic NFC readers**: Basic tag identification

### Data Sources
- Direct hardware scanning
- Proxmark3 dump files (.json, .bin)
- Manual hex block entry
- Imported tag libraries

### Bambu Lab Compatibility
- Complete RFID data structure support
- RSA signature verification
- Material type identification
- Temperature profile extraction
- Production metadata parsing

## Usage Examples

### Basic RFID Scanning
```dart
// Scan and create spool
final spool = await scanRfidUseCase.scanAndCreateSpool(tagId);
print('Scanned: ${spool.rfidData?.description}');
```

### Temperature Recommendations
```dart
// Get printing recommendations
final recommendations = await generateRecommendationsUseCase
    .generatePrintingRecommendations(rfidData);

print('Hotend: ${recommendations['hotend_temperature']}°C');
print('Bed: ${recommendations['bed_temperature']}°C');

if (recommendations['drying_required'] == true) {
  print('Dry at ${recommendations['drying_temperature']}°C '
        'for ${recommendations['drying_hours']} hours');
}
```

### Material Verification
```dart
// Verify material compatibility
final isCompatible = await verifyMaterialUseCase
    .verifyMaterialType(rfidData, 'PLA_BASIC');

if (!isCompatible) {
  print('Warning: Material mismatch detected');
}
```

### Scan History
```dart
// Archive scan for future reference
await archiveUseCase.archiveScanData(spoolId, rfidData);

// Compare scans for changes
final history = await archiveUseCase.getScanHistory(spoolId);
final changes = await archiveUseCase.compareScanData(
  history.first, 
  history.last
);
```

## Error Handling

### RFID-Specific Exceptions
- `RfidScanException`: Hardware scanning failures
- `RfidDataParsingException`: Data format issues
- `RfidHardwareException`: Device connectivity problems
- `RfidValidationException`: Data integrity failures
- `RfidSignatureException`: Authentication failures

### Validation and Recovery
- Automatic data validation with detailed error reporting
- Graceful degradation for incomplete RFID data
- Fallback to manual entry when hardware unavailable
- Cached data usage for offline scenarios

## Testing

### Unit Tests
- Complete value object validation
- RFID data parsing verification
- Temperature profile calculations
- Material type identification
- Business logic validation

### Integration Tests
- End-to-end RFID scanning simulation
- Spool creation from RFID data
- Recommendation generation
- Error handling scenarios

### Example Data
All tests use real Bambu Lab RFID data from the research repository, ensuring compatibility with actual hardware scenarios.

## Future Enhancements

### Planned Features
- **Custom Tag Support**: Open-source RFID tag format
- **AMS Integration**: Direct AMS communication
- **Multi-Manufacturer Support**: Creality, Prusa, etc.
- **Tag Writing**: Update usage data to compatible tags
- **Advanced Analytics**: Usage patterns and recommendations

### Hardware Expansion
- **Built-in NFC**: Mobile device integration
- **USB RFID Readers**: Plug-and-play support
- **Wireless Scanning**: Bluetooth/WiFi readers
- **Printer Integration**: Direct printer RFID access

## Contributing

When extending RFID functionality:

1. **Follow Standards**: Use documented RFID tag formats
2. **Maintain Compatibility**: Preserve existing Bambu Lab support
3. **Add Tests**: Include comprehensive test coverage
4. **Document Changes**: Update this documentation
5. **Validate Hardware**: Test with real RFID readers

The RFID integration provides a solid foundation for comprehensive filament management with real-world hardware compatibility and rich metadata support.