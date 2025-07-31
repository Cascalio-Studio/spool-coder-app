import '../entities/spool.dart';
import '../repositories/spool_repository.dart';

/// Use case for writing/programming spool data
/// Part of the Domain Layer: orchestrates spool writing business logic
abstract class WriteSpoolUseCase {
  /// Write spool data to physical spool using specified method
  Future<void> execute(Spool spool, ScanMethod method);
}

/// Use case for updating spool data in storage
abstract class UpdateSpoolUseCase {
  /// Update spool data in local storage
  Future<void> execute(Spool spool);
}

/// Use case for saving new spool data
abstract class SaveSpoolUseCase {
  /// Save new spool data to storage
  Future<void> execute(Spool spool);
}