import '../../domain/value_objects/filament_length.dart';
import '../../domain/value_objects/material_type.dart';

/// Abstract data source for spool profile operations
/// Part of the Data Layer: defines contract for profile data persistence
abstract class ProfileDataSource {
  /// Initialize the data source
  Future<void> initialize();

  /// Check if data source is available
  Future<bool> isAvailable();

  /// Get all available profiles
  Future<List<SpoolProfile>> getAllProfiles();

  /// Get profiles for specific material type
  Future<List<SpoolProfile>> getProfilesByMaterial(MaterialType materialType);

  /// Get specific profile by manufacturer and material
  Future<SpoolProfile?> getProfile({
    required String manufacturer,
    required MaterialType materialType,
  });

  /// Save new profile
  Future<void> saveProfile(SpoolProfile profile);

  /// Update existing profile
  Future<void> updateProfile(SpoolProfile profile);

  /// Delete profile by ID
  Future<void> deleteProfile(String profileId);

  /// Get default profile for material type
  Future<SpoolProfile?> getDefaultProfile(MaterialType materialType);

  /// Import multiple profiles
  Future<void> importProfiles(List<SpoolProfile> profiles);

  /// Export all profiles
  Future<List<SpoolProfile>> exportProfiles();

  /// Dispose resources
  Future<void> dispose();
}

/// Local profile data source implementation
/// Part of the Data Layer: handles local storage of profiles
class LocalProfileDataSource extends ProfileDataSource {
  final Map<String, Map<String, dynamic>> _profiles = {};
  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    // In a real implementation, this would load from local storage
    // For now, add some default profiles
    await _loadDefaultProfiles();
    _isInitialized = true;
  }

  @override
  Future<bool> isAvailable() async {
    return _isInitialized;
  }

  @override
  Future<List<SpoolProfile>> getAllProfiles() async {
    if (!_isInitialized) await initialize();
    
    return _profiles.values
        .map((data) => _mapToProfile(data))
        .toList();
  }

  @override
  Future<List<SpoolProfile>> getProfilesByMaterial(MaterialType materialType) async {
    final allProfiles = await getAllProfiles();
    return allProfiles
        .where((profile) => profile.materialType.value == materialType.value)
        .toList();
  }

  @override
  Future<SpoolProfile?> getProfile({
    required String manufacturer,
    required MaterialType materialType,
  }) async {
    final allProfiles = await getAllProfiles();
    
    try {
      return allProfiles.firstWhere(
        (profile) => 
          profile.manufacturer.toLowerCase() == manufacturer.toLowerCase() &&
          profile.materialType.value == materialType.value,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveProfile(SpoolProfile profile) async {
    if (!_isInitialized) await initialize();
    
    final data = _profileToMap(profile);
    _profiles[profile.id] = data;
  }

  @override
  Future<void> updateProfile(SpoolProfile profile) async {
    if (!_isInitialized) await initialize();
    
    if (!_profiles.containsKey(profile.id)) {
      throw ArgumentError('Profile not found: ${profile.id}');
    }
    
    final data = _profileToMap(profile);
    data['updatedAt'] = DateTime.now().toIso8601String();
    _profiles[profile.id] = data;
  }

  @override
  Future<void> deleteProfile(String profileId) async {
    if (!_isInitialized) await initialize();
    
    _profiles.remove(profileId);
  }

  @override
  Future<SpoolProfile?> getDefaultProfile(MaterialType materialType) async {
    final profiles = await getProfilesByMaterial(materialType);
    
    // Return the first profile for the material type, or create a default
    if (profiles.isNotEmpty) {
      return profiles.first;
    }
    
    // Create a basic default profile
    return SpoolProfile(
      id: 'default_${materialType.value.toLowerCase()}',
      name: 'Default ${materialType.displayName}',
      manufacturer: 'Generic',
      materialType: materialType,
      color: ProfileSpoolColor.named('Unknown'),
      netLength: FilamentLength.meters(1000.0),
      filamentDiameter: 1.75,
      spoolWeight: 250.0,
      temperatureProfile: TemperatureProfile(
        minHotendTemperature: materialType.printTemperature ?? 200,
        maxHotendTemperature: (materialType.printTemperature ?? 200) + 20,
        bedTemperature: materialType.bedTemperature ?? 60,
      ),
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> importProfiles(List<SpoolProfile> profiles) async {
    if (!_isInitialized) await initialize();
    
    for (final profile in profiles) {
      await saveProfile(profile);
    }
  }

  @override
  Future<List<SpoolProfile>> exportProfiles() async {
    return await getAllProfiles();
  }

  @override
  Future<void> dispose() async {
    _profiles.clear();
    _isInitialized = false;
  }

  /// Load default profiles for common materials
  Future<void> _loadDefaultProfiles() async {
    final defaultProfiles = [
      {
        'id': 'bambu_pla_basic',
        'name': 'BambuLab PLA Basic',
        'manufacturer': 'BambuLab',
        'materialType': 'PLA',
        'color': 'White',
        'netLength': 1000.0,
        'filamentDiameter': 1.75,
        'spoolWeight': 250.0,
        'minHotendTemp': 190,
        'maxHotendTemp': 220,
        'bedTemp': 35,
        'createdAt': DateTime.now().toIso8601String(),
      },
      {
        'id': 'bambu_petg_basic',
        'name': 'BambuLab PETG Basic',
        'manufacturer': 'BambuLab',
        'materialType': 'PETG',
        'color': 'Clear',
        'netLength': 1000.0,
        'filamentDiameter': 1.75,
        'spoolWeight': 250.0,
        'minHotendTemp': 230,
        'maxHotendTemp': 260,
        'bedTemp': 70,
        'createdAt': DateTime.now().toIso8601String(),
      },
    ];

    for (final profileData in defaultProfiles) {
      _profiles[profileData['id'] as String] = profileData;
    }
  }

  /// Convert profile to map for storage
  Map<String, dynamic> _profileToMap(SpoolProfile profile) {
    return {
      'id': profile.id,
      'name': profile.name,
      'manufacturer': profile.manufacturer,
      'materialType': profile.materialType.value,
      'color': profile.color.name,
      'netLength': profile.netLength.meters,
      'filamentDiameter': profile.filamentDiameter,
      'spoolWeight': profile.spoolWeight,
      'minHotendTemp': profile.temperatureProfile?.minHotendTemperature,
      'maxHotendTemp': profile.temperatureProfile?.maxHotendTemperature,
      'bedTemp': profile.temperatureProfile?.bedTemperature,
      'createdAt': profile.createdAt.toIso8601String(),
      'updatedAt': profile.updatedAt?.toIso8601String(),
    };
  }

  /// Convert map to profile entity
  SpoolProfile _mapToProfile(Map<String, dynamic> data) {
    return SpoolProfile(
      id: data['id'],
      name: data['name'],
      manufacturer: data['manufacturer'],
      materialType: _parseMaterialType(data['materialType']),
      color: _parseColor(data['color']),
      netLength: FilamentLength.meters(data['netLength'] ?? 1000.0),
      filamentDiameter: data['filamentDiameter'] ?? 1.75,
      spoolWeight: data['spoolWeight']?.toDouble(),
      temperatureProfile: TemperatureProfile(
        minHotendTemperature: data['minHotendTemp'],
        maxHotendTemperature: data['maxHotendTemp'],
        bedTemperature: data['bedTemp'],
      ),
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : null,
    );
  }

  /// Parse material type from string
  MaterialType _parseMaterialType(String value) {
    switch (value.toUpperCase()) {
      case 'PLA':
        return MaterialType.pla;
      case 'PETG':
        return MaterialType.petg;
      case 'ABS':
        return MaterialType.abs;
      case 'TPU':
        return MaterialType.tpu;
      default:
        return MaterialType.pla;
    }
  }

  /// Parse color from string
  ProfileSpoolColor _parseColor(String value) {
    return ProfileSpoolColor.named(value);
  }
}

// Import statements for domain objects - these would be actual imports in real implementation
class ProfileSpoolColor {
  final String name;
  const ProfileSpoolColor._(this.name);
  
  static ProfileSpoolColor named(String name) => ProfileSpoolColor._(name);
}


class TemperatureProfile {
  final int? minHotendTemperature;
  final int? maxHotendTemperature;
  final int? bedTemperature;
  
  const TemperatureProfile({
    this.minHotendTemperature,
    this.maxHotendTemperature,
    this.bedTemperature,
  });
}

class SpoolProfile {
  final String id;
  final String name;
  final String manufacturer;
  final MaterialType materialType;
  final ProfileSpoolColor color;
  final FilamentLength netLength;
  final double filamentDiameter;
  final double? spoolWeight;
  final TemperatureProfile? temperatureProfile;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SpoolProfile({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.materialType,
    required this.color,
    required this.netLength,
    required this.filamentDiameter,
    this.spoolWeight,
    this.temperatureProfile,
    required this.createdAt,
    this.updatedAt,
  });
}