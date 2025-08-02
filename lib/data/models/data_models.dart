/// Data models for external data serialization and API communication
/// Part of the Data Layer: handles data transformation between external formats and domain entities
library;

/// Data Transfer Object for Spool data
/// Used for API communication and serialization
class SpoolDto {
  final String uid;
  final String materialType;
  final String manufacturer;
  final String color;
  final double netLength;
  final double remainingLength;
  final bool isWriteProtected;
  final double? filamentDiameter;
  final double? spoolWeight;
  final String? manufactureDate;
  final String? expiryDate;
  final String? batchNumber;
  final String? notes;
  final String createdAt;
  final String? updatedAt;
  final double? nozzleDiameter;
  final String? trayUid;
  final double? spoolWidth;
  final bool isRfidScanned;
  final TemperatureProfileDto? temperatureProfile;
  final ProductionInfoDto? productionInfo;

  const SpoolDto({
    required this.uid,
    required this.materialType,
    required this.manufacturer,
    required this.color,
    required this.netLength,
    required this.remainingLength,
    this.isWriteProtected = false,
    this.filamentDiameter,
    this.spoolWeight,
    this.manufactureDate,
    this.expiryDate,
    this.batchNumber,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.nozzleDiameter,
    this.trayUid,
    this.spoolWidth,
    this.isRfidScanned = false,
    this.temperatureProfile,
    this.productionInfo,
  });

  /// Create from JSON map
  factory SpoolDto.fromJson(Map<String, dynamic> json) {
    return SpoolDto(
      uid: json['uid'] as String,
      materialType: json['materialType'] as String,
      manufacturer: json['manufacturer'] as String,
      color: json['color'] as String,
      netLength: (json['netLength'] as num).toDouble(),
      remainingLength: (json['remainingLength'] as num).toDouble(),
      isWriteProtected: json['isWriteProtected'] as bool? ?? false,
      filamentDiameter: (json['filamentDiameter'] as num?)?.toDouble(),
      spoolWeight: (json['spoolWeight'] as num?)?.toDouble(),
      manufactureDate: json['manufactureDate'] as String?,
      expiryDate: json['expiryDate'] as String?,
      batchNumber: json['batchNumber'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
      nozzleDiameter: (json['nozzleDiameter'] as num?)?.toDouble(),
      trayUid: json['trayUid'] as String?,
      spoolWidth: (json['spoolWidth'] as num?)?.toDouble(),
      isRfidScanned: json['isRfidScanned'] as bool? ?? false,
      temperatureProfile: json['temperatureProfile'] != null
          ? TemperatureProfileDto.fromJson(json['temperatureProfile'] as Map<String, dynamic>)
          : null,
      productionInfo: json['productionInfo'] != null
          ? ProductionInfoDto.fromJson(json['productionInfo'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'materialType': materialType,
      'manufacturer': manufacturer,
      'color': color,
      'netLength': netLength,
      'remainingLength': remainingLength,
      'isWriteProtected': isWriteProtected,
      'filamentDiameter': filamentDiameter,
      'spoolWeight': spoolWeight,
      'manufactureDate': manufactureDate,
      'expiryDate': expiryDate,
      'batchNumber': batchNumber,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'nozzleDiameter': nozzleDiameter,
      'trayUid': trayUid,
      'spoolWidth': spoolWidth,
      'isRfidScanned': isRfidScanned,
      'temperatureProfile': temperatureProfile?.toJson(),
      'productionInfo': productionInfo?.toJson(),
    };
  }
}

/// Data Transfer Object for Spool Profile data
class SpoolProfileDto {
  final String id;
  final String name;
  final String manufacturer;
  final String materialType;
  final String color;
  final double netLength;
  final double filamentDiameter;
  final double? spoolWeight;
  final TemperatureProfileDto? temperatureProfile;
  final String createdAt;
  final String? updatedAt;

  const SpoolProfileDto({
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

  factory SpoolProfileDto.fromJson(Map<String, dynamic> json) {
    return SpoolProfileDto(
      id: json['id'] as String,
      name: json['name'] as String,
      manufacturer: json['manufacturer'] as String,
      materialType: json['materialType'] as String,
      color: json['color'] as String,
      netLength: (json['netLength'] as num).toDouble(),
      filamentDiameter: (json['filamentDiameter'] as num).toDouble(),
      spoolWeight: (json['spoolWeight'] as num?)?.toDouble(),
      temperatureProfile: json['temperatureProfile'] != null
          ? TemperatureProfileDto.fromJson(json['temperatureProfile'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'manufacturer': manufacturer,
      'materialType': materialType,
      'color': color,
      'netLength': netLength,
      'filamentDiameter': filamentDiameter,
      'spoolWeight': spoolWeight,
      'temperatureProfile': temperatureProfile?.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

/// Data Transfer Object for Temperature Profile data
class TemperatureProfileDto {
  final int? dryingTemperature;
  final int? dryingTimeHours;
  final int? bedTemperature;
  final int? minHotendTemperature;
  final int? maxHotendTemperature;
  final int? bedTemperatureType;

  const TemperatureProfileDto({
    this.dryingTemperature,
    this.dryingTimeHours,
    this.bedTemperature,
    this.minHotendTemperature,
    this.maxHotendTemperature,
    this.bedTemperatureType,
  });

  factory TemperatureProfileDto.fromJson(Map<String, dynamic> json) {
    return TemperatureProfileDto(
      dryingTemperature: json['dryingTemperature'] as int?,
      dryingTimeHours: json['dryingTimeHours'] as int?,
      bedTemperature: json['bedTemperature'] as int?,
      minHotendTemperature: json['minHotendTemperature'] as int?,
      maxHotendTemperature: json['maxHotendTemperature'] as int?,
      bedTemperatureType: json['bedTemperatureType'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dryingTemperature': dryingTemperature,
      'dryingTimeHours': dryingTimeHours,
      'bedTemperature': bedTemperature,
      'minHotendTemperature': minHotendTemperature,
      'maxHotendTemperature': maxHotendTemperature,
      'bedTemperatureType': bedTemperatureType,
    };
  }
}

/// Data Transfer Object for Production Info data
class ProductionInfoDto {
  final String? productionDateTime;
  final String? batchId;
  final String? trayInfoIndex;
  final String? materialId;

  const ProductionInfoDto({
    this.productionDateTime,
    this.batchId,
    this.trayInfoIndex,
    this.materialId,
  });

  factory ProductionInfoDto.fromJson(Map<String, dynamic> json) {
    return ProductionInfoDto(
      productionDateTime: json['productionDateTime'] as String?,
      batchId: json['batchId'] as String?,
      trayInfoIndex: json['trayInfoIndex'] as String?,
      materialId: json['materialId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productionDateTime': productionDateTime,
      'batchId': batchId,
      'trayInfoIndex': trayInfoIndex,
      'materialId': materialId,
    };
  }
}

/// Data Transfer Object for RFID data
class RfidDataDto {
  final String uid;
  final String materialType;
  final String color;
  final double netLength;
  final TemperatureProfileDto temperatureProfile;
  final ProductionInfoDto productionInfo;

  const RfidDataDto({
    required this.uid,
    required this.materialType,
    required this.color,
    required this.netLength,
    required this.temperatureProfile,
    required this.productionInfo,
  });

  factory RfidDataDto.fromJson(Map<String, dynamic> json) {
    return RfidDataDto(
      uid: json['uid'] as String,
      materialType: json['materialType'] as String,
      color: json['color'] as String,
      netLength: (json['netLength'] as num).toDouble(),
      temperatureProfile: TemperatureProfileDto.fromJson(
        json['temperatureProfile'] as Map<String, dynamic>
      ),
      productionInfo: ProductionInfoDto.fromJson(
        json['productionInfo'] as Map<String, dynamic>
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'materialType': materialType,
      'color': color,
      'netLength': netLength,
      'temperatureProfile': temperatureProfile.toJson(),
      'productionInfo': productionInfo.toJson(),
    };
  }
}