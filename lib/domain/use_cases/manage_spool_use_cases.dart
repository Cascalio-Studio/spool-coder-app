import '../entities/spool.dart';
import '../value_objects/spool_uid.dart';

/// Use case for deleting spools
/// Part of the Domain Layer: orchestrates spool deletion business logic
abstract class DeleteSpoolUseCase {
  /// Delete a spool by its unique identifier
  Future<void> execute(SpoolUid uid);
}

/// Use case for validating spool data
abstract class ValidateSpoolUseCase {
  /// Validate spool data integrity
  Future<bool> execute(SpoolUid uid);
}

/// Use case for searching spools
abstract class SearchSpoolsUseCase {
  /// Search spools by query string and optional filters
  Future<List<Spool>> execute({
    String? query,
    String? materialType,
    String? manufacturer,
    String? color,
    bool? isNearlyEmpty,
  });
}