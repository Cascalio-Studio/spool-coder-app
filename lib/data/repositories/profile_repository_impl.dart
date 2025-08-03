import '../../domain/entities/spool_profile.dart' as domain;
import '../../domain/repositories/profile_repository.dart';
import '../../domain/value_objects/material_type.dart';
import '../datasources/profile_data_source.dart' as data;
import '../mappers/entity_mappers.dart';

/// Implementation of the SpoolProfileRepository
/// Part of the Data Layer: bridges domain interface with data sources
class SpoolProfileRepositoryImpl implements SpoolProfileRepository {
  final data.ProfileDataSource _dataSource;

  const SpoolProfileRepositoryImpl({
    required data.ProfileDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<List<domain.SpoolProfile>> getAllProfiles() async {
    final dataProfiles = await _dataSource.getAllProfiles();
    return dataProfiles.map((profile) => _convertToDomainEntity(profile)).toList();
  }

  @override
  Future<List<domain.SpoolProfile>> getProfilesByMaterial(MaterialType materialType) async {
    final dataProfiles = await _dataSource.getProfilesByMaterial(materialType);
    return dataProfiles.map((profile) => _convertToDomainEntity(profile)).toList();
  }

  @override
  Future<domain.SpoolProfile?> getProfile({
    required String manufacturer,
    required MaterialType materialType,
  }) async {
    final dataProfile = await _dataSource.getProfile(
      manufacturer: manufacturer,
      materialType: materialType,
    );
    return dataProfile != null ? _convertToDomainEntity(dataProfile) : null;
  }

  @override
  Future<void> saveProfile(domain.SpoolProfile profile) async {
    final dataProfile = _convertToDataEntity(profile);
    await _dataSource.saveProfile(dataProfile);
  }

  @override
  Future<void> updateProfile(domain.SpoolProfile profile) async {
    final dataProfile = _convertToDataEntity(profile);
    await _dataSource.updateProfile(dataProfile);
  }

  @override
  Future<void> deleteProfile(String profileId) async {
    await _dataSource.deleteProfile(profileId);
  }

  @override
  Future<domain.SpoolProfile?> getDefaultProfile(MaterialType materialType) async {
    final dataProfile = await _dataSource.getDefaultProfile(materialType);
    return dataProfile != null ? _convertToDomainEntity(dataProfile) : null;
  }

  @override
  Future<void> importProfiles(List<domain.SpoolProfile> profiles) async {
    final dataProfiles = profiles.map((profile) => _convertToDataEntity(profile)).toList();
    await _dataSource.importProfiles(dataProfiles);
  }

  @override
  Future<List<domain.SpoolProfile>> exportProfiles() async {
    final dataProfiles = await _dataSource.exportProfiles();
    return dataProfiles.map((profile) => _convertToDomainEntity(profile)).toList();
  }

  /// Convert data source SpoolProfile to domain SpoolProfile
  domain.SpoolProfile _convertToDomainEntity(data.SpoolProfile dataProfile) {
    return domain.SpoolProfile(
      id: dataProfile.id,
      name: dataProfile.name,
      manufacturer: dataProfile.manufacturer,
      materialType: dataProfile.materialType,
      defaultColor: SpoolColorMapper.fromString(dataProfile.color.name),
      standardLength: dataProfile.netLength,
      filamentDiameter: dataProfile.filamentDiameter,
      spoolWeight: dataProfile.spoolWeight,
      printTemperature: dataProfile.temperatureProfile?.minHotendTemperature,
      bedTemperature: dataProfile.temperatureProfile?.bedTemperature,
      createdAt: dataProfile.createdAt,
      updatedAt: dataProfile.updatedAt,
    );
  }

  /// Convert domain SpoolProfile to data source SpoolProfile
  data.SpoolProfile _convertToDataEntity(domain.SpoolProfile domainProfile) {
    return data.SpoolProfile(
      id: domainProfile.id,
      name: domainProfile.name,
      manufacturer: domainProfile.manufacturer,
      materialType: domainProfile.materialType,
      color: data.ProfileSpoolColor.named(domainProfile.defaultColor?.name ?? 'Unknown'),
      netLength: domainProfile.standardLength!,
      filamentDiameter: domainProfile.filamentDiameter ?? 1.75,
      spoolWeight: domainProfile.spoolWeight,
      temperatureProfile: (domainProfile.printTemperature != null || domainProfile.bedTemperature != null)
          ? data.TemperatureProfile(
              minHotendTemperature: domainProfile.printTemperature,
              maxHotendTemperature: domainProfile.printTemperature,
              bedTemperature: domainProfile.bedTemperature,
            )
          : null,
      createdAt: domainProfile.createdAt,
      updatedAt: domainProfile.updatedAt,
    );
  }
}