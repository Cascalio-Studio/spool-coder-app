import '../entities/spool.dart';
import '../repositories/spool_repository.dart';

/// Use case for scanning spools
/// Part of the Domain Layer: orchestrates business logic
abstract class ScanSpoolUseCase {
  /// Scans a spool using the specified method (NFC, USB, Bluetooth)
  Future<Spool> execute(ScanMethod method);
}