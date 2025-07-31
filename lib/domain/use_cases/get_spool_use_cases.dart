import '../entities/spool.dart';
import '../value_objects/spool_uid.dart';

/// Use case for retrieving spool information
/// Part of the Domain Layer: orchestrates spool retrieval business logic
abstract class GetSpoolUseCase {
  /// Get a spool by its unique identifier
  Future<Spool?> execute(SpoolUid uid);
}

/// Use case for getting all spools
abstract class GetAllSpoolsUseCase {
  /// Get all spools with optional filtering
  Future<List<Spool>> execute({
    String? materialType,
    String? manufacturer,
    String? color,
    bool? isNearlyEmpty,
  });
}

/// Use case for getting nearly empty spools
abstract class GetNearlyEmptySpoolsUseCase {
  /// Get all spools that are nearly empty
  Future<List<Spool>> execute();
}