import '../../domain/entities/spool.dart';

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
    
    return const Spool(
      uid: 'NFC_MOCK_123',
      materialType: 'PETG',
      manufacturer: 'BambuLab',
      color: 'Blue',
      netLength: 1000.0,
      remainingLength: 650.0,
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