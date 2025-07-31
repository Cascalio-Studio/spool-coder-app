import '../entities/spool_profile.dart';
import '../value_objects/material_type.dart';

/// Use case for managing spool profiles
/// Part of the Domain Layer: orchestrates profile management business logic
abstract class GetSpoolProfilesUseCase {
  /// Get all available spool profiles
  Future<List<SpoolProfile>> execute();
}

/// Use case for getting profiles by material type
abstract class GetProfilesByMaterialUseCase {
  /// Get profiles filtered by material type
  Future<List<SpoolProfile>> execute(MaterialType materialType);
}

/// Use case for getting specific profile
abstract class GetSpoolProfileUseCase {
  /// Get profile by manufacturer and material
  Future<SpoolProfile?> execute({
    required String manufacturer,
    required MaterialType materialType,
  });
}

/// Use case for saving spool profiles
abstract class SaveSpoolProfileUseCase {
  /// Save a new spool profile
  Future<void> execute(SpoolProfile profile);
}

/// Use case for updating spool profiles
abstract class UpdateSpoolProfileUseCase {
  /// Update existing spool profile
  Future<void> execute(SpoolProfile profile);
}

/// Use case for deleting spool profiles
abstract class DeleteSpoolProfileUseCase {
  /// Delete a spool profile by ID
  Future<void> execute(String profileId);
}