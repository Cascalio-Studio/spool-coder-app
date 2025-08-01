import '../../domain/entities/spool_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/value_objects/material_type.dart';
import '../datasources/profile_data_source.dart';

/// Implementation of the SpoolProfileRepository
/// Part of the Data Layer: bridges domain interface with data sources
class SpoolProfileRepositoryImpl implements SpoolProfileRepository {
  final ProfileDataSource _dataSource;

  const SpoolProfileRepositoryImpl({
    required ProfileDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<List<SpoolProfile>> getAllProfiles() async {
    return await _dataSource.getAllProfiles();
  }

  @override
  Future<List<SpoolProfile>> getProfilesByMaterial(MaterialType materialType) async {
    return await _dataSource.getProfilesByMaterial(materialType);
  }

  @override
  Future<SpoolProfile?> getProfile({
    required String manufacturer,
    required MaterialType materialType,
  }) async {
    return await _dataSource.getProfile(
      manufacturer: manufacturer,
      materialType: materialType,
    );
  }

  @override
  Future<void> saveProfile(SpoolProfile profile) async {
    await _dataSource.saveProfile(profile);
  }

  @override
  Future<void> updateProfile(SpoolProfile profile) async {
    await _dataSource.updateProfile(profile);
  }

  @override
  Future<void> deleteProfile(String profileId) async {
    await _dataSource.deleteProfile(profileId);
  }

  @override
  Future<SpoolProfile?> getDefaultProfile(MaterialType materialType) async {
    return await _dataSource.getDefaultProfile(materialType);
  }

  @override
  Future<void> importProfiles(List<SpoolProfile> profiles) async {
    await _dataSource.importProfiles(profiles);
  }

  @override
  Future<List<SpoolProfile>> exportProfiles() async {
    return await _dataSource.exportProfiles();
  }
}