import '../../domain/entities/spool.dart';
import '../../domain/value_objects/spool_uid.dart';
import '../../domain/value_objects/material_type.dart';
import '../../domain/value_objects/spool_color.dart';
import '../../domain/value_objects/filament_length.dart';

/// NFC data source for reading/writing spool data
/// Part of the Data Layer: handles specific data source operations
abstract class NfcDataSource {
  /// Initialize NFC capabilities
  Future<void> initialize();
  
  /// Check if NFC is available and enabled
  Future<bool> isNfcAvailable();
  
  /// Scan for NFC tags/spools
  Future<Spool> scanSpool();
  
  /// Write spool data to NFC tag
  Future<void> writeSpool(Spool spool);
  
  /// Dispose of NFC resources
  Future<void> dispose();
}

/// Mock implementation for development/testing
class MockNfcDataSource implements NfcDataSource {
  @override
  Future<void> initialize() async {
    // Mock initialization
  }
  
  @override
  Future<bool> isNfcAvailable() async {
    return true; // Mock as available
  }
  
  @override
  Future<Spool> scanSpool() async {
    // Mock scan delay
    await Future.delayed(const Duration(seconds: 2));
    
    return Spool(
      uid: SpoolUid('NFC_MOCK_123'),
      materialType: MaterialType.petg,
      manufacturer: 'BambuLab',
      color: SpoolColor.named('Blue'),
      netLength: FilamentLength.meters(1000.0),
      remainingLength: FilamentLength.meters(650.0),
      filamentDiameter: 1.75,
      spoolWeight: 250.0,
      createdAt: DateTime.now(),
    );
  }
  
  @override
  Future<void> writeSpool(Spool spool) async {
    // Mock write delay
    await Future.delayed(const Duration(seconds: 1));
  }
  
  @override
  Future<void> dispose() async {
    // Mock cleanup
  }
}