import '../../domain/entities/spool.dart';
import '../../domain/entities/spool_profile.dart';
import '../../domain/value_objects/spool_uid.dart';
import '../../domain/value_objects/material_type.dart';
import '../../domain/value_objects/spool_color.dart';
import '../../domain/value_objects/filament_length.dart';
import '../../domain/value_objects/temperature_profile.dart';
import '../../domain/value_objects/production_info.dart';
import '../../domain/value_objects/rfid_data.dart';
import '../models/data_models.dart';

/// Mapper for converting between Spool domain entity and SpoolDto
/// Part of the Data Layer: handles entity/DTO conversion
class SpoolMapper {
  /// Convert Spool domain entity to SpoolDto
  static SpoolDto toDto(Spool spool) {
    return SpoolDto(
      uid: spool.uid.value,
      materialType: spool.materialType.value,
      manufacturer: spool.manufacturer,
      color: spool.color.name,
      netLength: spool.netLength.meters,
      remainingLength: spool.remainingLength.meters,
      isWriteProtected: spool.isWriteProtected,
      filamentDiameter: spool.filamentDiameter,
      spoolWeight: spool.spoolWeight,
      manufactureDate: spool.manufactureDate?.toIso8601String(),
      expiryDate: spool.expiryDate?.toIso8601String(),
      batchNumber: spool.batchNumber,
      notes: spool.notes,
      createdAt: spool.createdAt.toIso8601String(),
      updatedAt: spool.updatedAt?.toIso8601String(),
      nozzleDiameter: spool.nozzleDiameter,
      trayUid: spool.trayUid,
      spoolWidth: spool.spoolWidth,
      isRfidScanned: spool.isRfidScanned,
      temperatureProfile: spool.temperatureProfile != null
          ? TemperatureProfileMapper.toDto(spool.temperatureProfile!)
          : null,
      productionInfo: spool.productionInfo != null
          ? ProductionInfoMapper.toDto(spool.productionInfo!)
          : null,
    );
  }

  /// Convert SpoolDto to Spool domain entity
  static Spool fromDto(SpoolDto dto) {
    return Spool(
      uid: SpoolUid(dto.uid),
      materialType: MaterialTypeMapper.fromString(dto.materialType),
      manufacturer: dto.manufacturer,
      color: SpoolColorMapper.fromString(dto.color),
      netLength: FilamentLength.meters(dto.netLength),
      remainingLength: FilamentLength.meters(dto.remainingLength),
      isWriteProtected: dto.isWriteProtected,
      filamentDiameter: dto.filamentDiameter,
      spoolWeight: dto.spoolWeight,
      manufactureDate: dto.manufactureDate != null
          ? DateTime.parse(dto.manufactureDate!)
          : null,
      expiryDate: dto.expiryDate != null
          ? DateTime.parse(dto.expiryDate!)
          : null,
      batchNumber: dto.batchNumber,
      notes: dto.notes,
      createdAt: DateTime.parse(dto.createdAt),
      updatedAt: dto.updatedAt != null
          ? DateTime.parse(dto.updatedAt!)
          : null,
      nozzleDiameter: dto.nozzleDiameter,
      trayUid: dto.trayUid,
      spoolWidth: dto.spoolWidth,
      isRfidScanned: dto.isRfidScanned,
      temperatureProfile: dto.temperatureProfile != null
          ? TemperatureProfileMapper.fromDto(dto.temperatureProfile!)
          : null,
      productionInfo: dto.productionInfo != null
          ? ProductionInfoMapper.fromDto(dto.productionInfo!)
          : null,
    );
  }

  /// Convert list of Spool entities to list of DTOs
  static List<SpoolDto> toDtoList(List<Spool> spools) {
    return spools.map((spool) => toDto(spool)).toList();
  }

  /// Convert list of DTOs to list of Spool entities
  static List<Spool> fromDtoList(List<SpoolDto> dtos) {
    return dtos.map((dto) => fromDto(dto)).toList();
  }
}

/// Mapper for converting between SpoolProfile domain entity and SpoolProfileDto
class SpoolProfileMapper {
  /// Convert SpoolProfile domain entity to SpoolProfileDto
  static SpoolProfileDto toDto(SpoolProfile profile) {
    return SpoolProfileDto(
      id: profile.id,
      name: profile.name,
      manufacturer: profile.manufacturer,
      materialType: profile.materialType.value,
      color: profile.defaultColor?.name ?? 'Unknown',
      netLength: profile.standardLength?.meters ?? 0.0,
      filamentDiameter: profile.filamentDiameter ?? 1.75,
      spoolWeight: profile.spoolWeight,
      temperatureProfile: profile.printTemperature != null
          ? TemperatureProfileDto(
              minHotendTemperature: profile.printTemperature,
              maxHotendTemperature: profile.printTemperature,
              bedTemperature: profile.bedTemperature,
            )
          : null,
      createdAt: profile.createdAt.toIso8601String(),
      updatedAt: profile.updatedAt?.toIso8601String(),
    );
  }

  /// Convert SpoolProfileDto to SpoolProfile domain entity
  static SpoolProfile fromDto(SpoolProfileDto dto) {
    return SpoolProfile(
      id: dto.id,
      name: dto.name,
      manufacturer: dto.manufacturer,
      materialType: MaterialTypeMapper.fromString(dto.materialType),
      defaultColor: SpoolColorMapper.fromString(dto.color),
      standardLength: FilamentLength.meters(dto.netLength),
      filamentDiameter: dto.filamentDiameter,
      spoolWeight: dto.spoolWeight,
      printTemperature: dto.temperatureProfile?.minHotendTemperature,
      bedTemperature: dto.temperatureProfile?.bedTemperature,
      createdAt: DateTime.parse(dto.createdAt),
      updatedAt: dto.updatedAt != null
          ? DateTime.parse(dto.updatedAt!)
          : null,
    );
  }

  /// Convert list of SpoolProfile entities to list of DTOs
  static List<SpoolProfileDto> toDtoList(List<SpoolProfile> profiles) {
    return profiles.map((profile) => toDto(profile)).toList();
  }

  /// Convert list of DTOs to list of SpoolProfile entities
  static List<SpoolProfile> fromDtoList(List<SpoolProfileDto> dtos) {
    return dtos.map((dto) => fromDto(dto)).toList();
  }
}

/// Mapper for converting between TemperatureProfile value object and TemperatureProfileDto
class TemperatureProfileMapper {
  /// Convert TemperatureProfile value object to TemperatureProfileDto
  static TemperatureProfileDto toDto(TemperatureProfile profile) {
    return TemperatureProfileDto(
      dryingTemperature: profile.dryingTemperature,
      dryingTimeHours: profile.dryingTimeHours,
      bedTemperature: profile.bedTemperature,
      minHotendTemperature: profile.minHotendTemperature,
      maxHotendTemperature: profile.maxHotendTemperature,
      bedTemperatureType: profile.bedTemperatureType,
    );
  }

  /// Convert TemperatureProfileDto to TemperatureProfile value object
  static TemperatureProfile fromDto(TemperatureProfileDto dto) {
    return TemperatureProfile(
      dryingTemperature: dto.dryingTemperature,
      dryingTimeHours: dto.dryingTimeHours,
      bedTemperature: dto.bedTemperature,
      minHotendTemperature: dto.minHotendTemperature,
      maxHotendTemperature: dto.maxHotendTemperature,
      bedTemperatureType: dto.bedTemperatureType,
    );
  }
}

/// Mapper for converting between ProductionInfo value object and ProductionInfoDto
class ProductionInfoMapper {
  /// Convert ProductionInfo value object to ProductionInfoDto
  static ProductionInfoDto toDto(ProductionInfo info) {
    return ProductionInfoDto(
      productionDateTime: info.productionDateTime?.toIso8601String(),
      batchId: info.batchId,
      trayInfoIndex: info.trayInfoIndex,
      materialId: info.materialId,
    );
  }

  /// Convert ProductionInfoDto to ProductionInfo value object
  static ProductionInfo fromDto(ProductionInfoDto dto) {
    return ProductionInfo(
      productionDateTime: dto.productionDateTime != null
          ? DateTime.parse(dto.productionDateTime!)
          : null,
      batchId: dto.batchId,
      trayInfoIndex: dto.trayInfoIndex,
      materialId: dto.materialId,
    );
  }
}

/// Mapper for converting between RfidData value object and RfidDataDto
class RfidDataMapper {
  /// Convert RfidData value object to RfidDataDto
  static RfidDataDto toDto(RfidData data) {
    return RfidDataDto(
      uid: data.uid,
      materialType: data.filamentType ?? 'Unknown',
      color: data.color?.name ?? 'Unknown',
      netLength: data.filamentLength?.meters ?? 0.0,
      temperatureProfile: data.temperatureProfile != null
          ? TemperatureProfileDto(
              minHotendTemperature: data.temperatureProfile!.minHotendTemperature,
              maxHotendTemperature: data.temperatureProfile!.maxHotendTemperature,
              bedTemperature: data.temperatureProfile!.bedTemperature,
            )
          : TemperatureProfileDto(
              minHotendTemperature: 180,
              maxHotendTemperature: 220,
              bedTemperature: 60,
            ),
      productionInfo: data.productionInfo != null
          ? ProductionInfoMapper.toDto(data.productionInfo!)
          : ProductionInfoDto(
              productionDateTime: DateTime.now().toIso8601String(),
              batchId: 'Unknown',
              trayInfoIndex: '0',
              materialId: 'Unknown',
            ),
    );
  }

  /// Convert RfidDataDto to RfidData value object
  static RfidData fromDto(RfidDataDto dto) {
    return RfidData(
      uid: dto.uid,
      scanTime: DateTime.now(), // Required parameter
      filamentType: dto.materialType,
      color: SpoolColorMapper.fromString(dto.color),
      filamentLength: FilamentLength.meters(dto.netLength),
      temperatureProfile: TemperatureProfile(
        minHotendTemperature: dto.temperatureProfile.minHotendTemperature,
        maxHotendTemperature: dto.temperatureProfile.maxHotendTemperature,
        bedTemperature: dto.temperatureProfile.bedTemperature,
      ),
      productionInfo: ProductionInfoMapper.fromDto(dto.productionInfo),
    );
  }
}

/// Mapper for MaterialType value object
class MaterialTypeMapper {
  /// Convert MaterialType to string
  static String toStringValue(MaterialType materialType) {
    return materialType.value;
  }

  /// Convert string to MaterialType
  static MaterialType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PLA':
        return MaterialType.pla;
      case 'PETG':
        return MaterialType.petg;
      case 'ABS':
        return MaterialType.abs;
      case 'TPU':
        return MaterialType.tpu;
      case 'WOOD':
        return MaterialType.wood;
      case 'CARBON':
      case 'CARBON_FIBER':
        return MaterialType.carbon;
      case 'PLA_BASIC':
        return MaterialType.plaBasic;
      case 'PLA_MATTE':
        return MaterialType.plaMatte;
      case 'PLA_SILK':
        return MaterialType.plaSilk;
      default:
        return MaterialType.pla; // Default fallback
    }
  }
}

/// Mapper for SpoolColor value object
class SpoolColorMapper {
  /// Convert SpoolColor to string
  static String toStringValue(SpoolColor color) {
    return color.name;
  }

  /// Convert string to SpoolColor
  static SpoolColor fromString(String value) {
    return SpoolColor.named(value);
  }

  /// Convert SpoolColor to hex string
  static String? toHex(SpoolColor color) {
    return color.hexCode;
  }

  /// Convert hex string to SpoolColor
  static SpoolColor fromHex(String name, String hexCode) {
    return SpoolColor.hex(name, hexCode);
  }

  /// Convert SpoolColor to RGB values
  static Map<String, int>? toRgb(SpoolColor color) {
    if (color.rgbRed != null && color.rgbGreen != null && color.rgbBlue != null) {
      return {
        'red': color.rgbRed!,
        'green': color.rgbGreen!,
        'blue': color.rgbBlue!,
      };
    }
    return null;
  }

  /// Convert RGB values to SpoolColor
  static SpoolColor fromRgb(String name, int red, int green, int blue) {
    return SpoolColor.rgb(name, red, green, blue);
  }
}

/// Mapper for FilamentLength value object
class FilamentLengthMapper {
  /// Convert FilamentLength to meters (double)
  static double toMeters(FilamentLength length) {
    return length.meters;
  }

  /// Convert meters (double) to FilamentLength
  static FilamentLength fromMeters(double meters) {
    return FilamentLength.meters(meters);
  }

  /// Convert FilamentLength to feet (double)
  static double toFeet(FilamentLength length) {
    return length.feet;
  }

  /// Convert feet (double) to FilamentLength
  static FilamentLength fromFeet(double feet) {
    return FilamentLength.feet(feet);
  }

  /// Convert FilamentLength to grams (double) with density
  static double toGrams(FilamentLength length, double density) {
    // Simple approximation: assume 1.75mm diameter filament
    // Volume = π * (diameter/2)² * length
    const diameter = 1.75; // mm
    final radius = diameter / 2;
    final volumeCm3 = 3.14159 * radius * radius * length.meters / 10; // Convert to cm³
    return volumeCm3 * density;
  }

  /// Convert grams to FilamentLength with density
  static FilamentLength fromGrams(double grams, double density) {
    // Reverse calculation
    const diameter = 1.75; // mm
    final radius = diameter / 2;
    final volumeCm3 = grams / density;
    final lengthMeters = volumeCm3 * 10 / (3.14159 * radius * radius);
    return FilamentLength.meters(lengthMeters);
  }
}

/// Generic mapper utility functions
class MapperUtils {
  /// Safely parse DateTime from string
  static DateTime? parseDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return null;
    
    try {
      return DateTime.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  /// Format DateTime to ISO 8601 string
  static String? formatDateTime(DateTime? dateTime) {
    return dateTime?.toIso8601String();
  }

  /// Safely parse double from dynamic value
  static double? parseDouble(dynamic value) {
    if (value == null) return null;
    
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return null;
      }
    }
    
    return null;
  }

  /// Safely parse int from dynamic value
  static int? parseInt(dynamic value) {
    if (value == null) return null;
    
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        return null;
      }
    }
    
    return null;
  }

  /// Safely parse bool from dynamic value
  static bool parseBool(dynamic value, {bool defaultValue = false}) {
    if (value == null) return defaultValue;
    
    if (value is bool) return value;
    if (value is String) {
      final lower = value.toLowerCase();
      return lower == 'true' || lower == '1' || lower == 'yes';
    }
    if (value is int) return value != 0;
    
    return defaultValue;
  }

  /// Safely get string from dynamic value
  static String getString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    return value.toString();
  }

  /// Convert map to typed map safely
  static Map<String, T> toTypedMap<T>(dynamic value) {
    if (value is Map<String, T>) return value;
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val as T));
    }
    return <String, T>{};
  }

  /// Convert list to typed list safely
  static List<T> toTypedList<T>(dynamic value) {
    if (value is List<T>) return value;
    if (value is List) {
      return value.cast<T>();
    }
    return <T>[];
  }
}