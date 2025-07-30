import '../entities/spool.dart';

/// Use case for scanning spools
/// Part of the Domain Layer: orchestrates business logic
abstract class ScanSpoolUseCase {
  /// Scans a spool using the specified method (NFC, USB, Bluetooth)
  Future<Spool> execute(ScanMethod method);
}

enum ScanMethod {
  nfc,
  usb,
  bluetooth,
}

/// Implementation of the scan spool use case
class ScanSpoolUseCaseImpl implements ScanSpoolUseCase {
  // Dependencies would be injected here (repositories, services)
  
  @override
  Future<Spool> execute(ScanMethod method) async {
    // This would coordinate with the data layer to perform the actual scan
    // For now, returning a mock spool
    await Future.delayed(const Duration(seconds: 1)); // Simulate scan time
    
    return const Spool(
      uid: 'SAMPLE_UID_123',
      materialType: 'PLA',
      manufacturer: 'BambuLab',
      color: 'Red',
      netLength: 1000.0,
      remainingLength: 750.0,
    );
  }
}