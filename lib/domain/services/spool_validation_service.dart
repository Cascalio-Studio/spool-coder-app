import '../entities/spool.dart';
import '../entities/spool_profile.dart';
import '../value_objects/material_type.dart';
import '../value_objects/spool_color.dart';
import '../value_objects/filament_length.dart';

/// Domain service for validating spool data against business rules
/// Part of the Domain Layer: encapsulates complex validation logic
abstract class SpoolValidationService {
  /// Validate if spool data is complete and consistent
  ValidationResult validateSpool(Spool spool);

  /// Validate spool against its profile
  ValidationResult validateAgainstProfile(Spool spool, SpoolProfile profile);

  /// Validate if material data is consistent
  ValidationResult validateMaterialData(
    MaterialType materialType,
    SpoolColor color,
    double? filamentDiameter,
  );

  /// Validate length measurements
  ValidationResult validateLengthData(
    FilamentLength netLength,
    FilamentLength remainingLength,
  );
}

/// Result of validation operation
class ValidationResult {
  final bool isValid;
  final List<ValidationError> errors;
  final List<ValidationWarning> warnings;

  const ValidationResult({
    required this.isValid,
    this.errors = const [],
    this.warnings = const [],
  });

  /// Create a successful validation result
  factory ValidationResult.success({List<ValidationWarning> warnings = const []}) {
    return ValidationResult(
      isValid: true,
      warnings: warnings,
    );
  }

  /// Create a failed validation result
  factory ValidationResult.failure(List<ValidationError> errors) {
    return ValidationResult(
      isValid: false,
      errors: errors,
    );
  }

  /// Check if there are any issues (errors or warnings)
  bool get hasIssues => errors.isNotEmpty || warnings.isNotEmpty;
}

/// Validation error details
class ValidationError {
  final String field;
  final String message;
  final dynamic value;

  const ValidationError({
    required this.field,
    required this.message,
    this.value,
  });

  @override
  String toString() => '$field: $message';
}

/// Validation warning details
class ValidationWarning {
  final String field;
  final String message;
  final dynamic value;

  const ValidationWarning({
    required this.field,
    required this.message,
    this.value,
  });

  @override
  String toString() => '$field: $message';
}