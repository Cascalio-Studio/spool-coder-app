import '../entities/spool_profile.dart';
import '../value_objects/material_type.dart';

/// Repository interface for spool profile operations
/// Part of the Domain Layer: manages spool templates and profiles
abstract class SpoolProfileRepository {
  /// Get all available spool profiles/templates
  Future<List<SpoolProfile>> getAllProfiles();

  /// Get profiles for a specific material type
  Future<List<SpoolProfile>> getProfilesByMaterial(MaterialType materialType);

  /// Get profile by manufacturer and material
  Future<SpoolProfile?> getProfile({
    required String manufacturer,
    required MaterialType materialType,
  });

  /// Save a new spool profile
  Future<void> saveProfile(SpoolProfile profile);

  /// Update existing profile
  Future<void> updateProfile(SpoolProfile profile);

  /// Delete profile
  Future<void> deleteProfile(String profileId);

  /// Get default profile for a material type
  Future<SpoolProfile?> getDefaultProfile(MaterialType materialType);

  /// Import profiles from external source
  Future<void> importProfiles(List<SpoolProfile> profiles);

  /// Export all profiles
  Future<List<SpoolProfile>> exportProfiles();
}