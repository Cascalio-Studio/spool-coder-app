import '../value_objects/spool_uid.dart';
import '../value_objects/material_type.dart';
import '../value_objects/spool_color.dart';
import '../value_objects/filament_length.dart';
import '../value_objects/temperature_profile.dart';
import '../value_objects/production_info.dart';
import '../value_objects/rfid_data.dart';

/// Spool entity - core business object with RFID integration
/// Part of the Domain Layer: represents business logic and rules
class Spool {
  final SpoolUid uid;
  final MaterialType materialType;
  final String manufacturer;
  final SpoolColor color;
  final FilamentLength netLength;
  final FilamentLength remainingLength;
  final bool isWriteProtected;
  final double? filamentDiameter; // mm
  final double? spoolWeight; // grams
  final DateTime? manufactureDate;
  final DateTime? expiryDate;
  final String? batchNumber;
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  // RFID-specific fields
  final RfidData? rfidData; // Complete RFID tag information
  final TemperatureProfile? temperatureProfile; // Printing temperature settings
  final ProductionInfo? productionInfo; // Manufacturing details
  final double? nozzleDiameter; // Compatible nozzle diameter
  final String? trayUid; // AMS tray identifier
  final double? spoolWidth; // Physical spool width in mm
  final bool isRfidScanned; // Whether this spool was created from RFID scan

  const Spool({
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
    this.rfidData,
    this.temperatureProfile,
    this.productionInfo,
    this.nozzleDiameter,
    this.trayUid,
    this.spoolWidth,
    this.isRfidScanned = false,
  });

  /// Create a Spool from RFID scan data
  factory Spool.fromRfidData(RfidData rfidData, {FilamentLength? remainingLength}) {
    // Determine material type from RFID data
    MaterialType materialType = MaterialType.pla; // Default fallback
    if (rfidData.detailedFilamentType != null) {
      materialType = MaterialType.fromRfidDetailedType(rfidData.detailedFilamentType!);
    } else if (rfidData.filamentType != null) {
      materialType = MaterialType.fromString(rfidData.filamentType!);
    }

    // Create SpoolUid from RFID UID
    final spoolUid = SpoolUid(rfidData.uid);

    // Determine manufacturer (assume Bambu Lab if has genuine signature)
    final manufacturer = rfidData.isGenuineBambuLab ? 'Bambu Lab' : 'Unknown';

    // Use color from RFID or create default
    final color = rfidData.color ?? SpoolColor.named('Unknown');

    // Use filament length from RFID or create default
    final netLength = rfidData.filamentLength ?? FilamentLength.meters(250.0);
    final remaining = remainingLength ?? netLength; // Assume full if not specified

    // Production date from RFID data
    final manufactureDate = rfidData.productionInfo?.productionDateTime;

    return Spool(
      uid: spoolUid,
      materialType: materialType,
      manufacturer: manufacturer,
      color: color,
      netLength: netLength,
      remainingLength: remaining,
      filamentDiameter: rfidData.filamentDiameter,
      spoolWeight: rfidData.spoolWeight,
      manufactureDate: manufactureDate,
      createdAt: DateTime.now(),
      rfidData: rfidData,
      temperatureProfile: rfidData.temperatureProfile,
      productionInfo: rfidData.productionInfo,
      nozzleDiameter: rfidData.nozzleDiameter,
      trayUid: rfidData.trayUid,
      spoolWidth: rfidData.spoolWidth,
      isRfidScanned: true,
    );
  }

  /// Create a copy with updated values
  Spool copyWith({
    SpoolUid? uid,
    MaterialType? materialType,
    String? manufacturer,
    SpoolColor? color,
    FilamentLength? netLength,
    FilamentLength? remainingLength,
    bool? isWriteProtected,
    double? filamentDiameter,
    double? spoolWeight,
    DateTime? manufactureDate,
    DateTime? expiryDate,
    String? batchNumber,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    RfidData? rfidData,
    TemperatureProfile? temperatureProfile,
    ProductionInfo? productionInfo,
    double? nozzleDiameter,
    String? trayUid,
    double? spoolWidth,
    bool? isRfidScanned,
  }) {
    return Spool(
      uid: uid ?? this.uid,
      materialType: materialType ?? this.materialType,
      manufacturer: manufacturer ?? this.manufacturer,
      color: color ?? this.color,
      netLength: netLength ?? this.netLength,
      remainingLength: remainingLength ?? this.remainingLength,
      isWriteProtected: isWriteProtected ?? this.isWriteProtected,
      filamentDiameter: filamentDiameter ?? this.filamentDiameter,
      spoolWeight: spoolWeight ?? this.spoolWeight,
      manufactureDate: manufactureDate ?? this.manufactureDate,
      expiryDate: expiryDate ?? this.expiryDate,
      batchNumber: batchNumber ?? this.batchNumber,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      rfidData: rfidData ?? this.rfidData,
      temperatureProfile: temperatureProfile ?? this.temperatureProfile,
      productionInfo: productionInfo ?? this.productionInfo,
      nozzleDiameter: nozzleDiameter ?? this.nozzleDiameter,
      trayUid: trayUid ?? this.trayUid,
      spoolWidth: spoolWidth ?? this.spoolWidth,
      isRfidScanned: isRfidScanned ?? this.isRfidScanned,
    );
  }

  /// Calculate usage percentage
  double get usagePercentage {
    if (netLength.meters <= 0) return 0;
    return ((netLength.meters - remainingLength.meters) / netLength.meters) * 100;
  }

  /// Check if spool is nearly empty (less than 10% remaining)
  bool get isNearlyEmpty => remainingLength.meters < (netLength.meters * 0.1);

  /// Check if spool is empty
  bool get isEmpty => remainingLength.isEmpty;

  /// Check if spool is expired
  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  /// Check if spool is new (recently created)
  bool get isNew {
    final daysSinceCreation = DateTime.now().difference(createdAt).inDays;
    return daysSinceCreation <= 7;
  }

  /// Get used length
  FilamentLength get usedLength => netLength - remainingLength;

  /// Check if spool can be written to
  bool get canWrite => !isWriteProtected;

  /// Check if this is a genuine Bambu Lab spool (has valid RSA signature)
  bool get isGenuineBambuLab => rfidData?.isGenuineBambuLab ?? false;

  /// Check if RFID data is complete and valid
  bool get hasCompleteRfidData => rfidData?.isComplete ?? false;

  /// Check if filament is from recent production (based on RFID production info)
  bool get isFreshProduction => productionInfo?.isFresh ?? false;

  /// Check if filament production is old (might affect quality)
  bool get isOldProduction => productionInfo?.isOld ?? false;

  /// Get temperature recommendation for printing
  int? get recommendedPrintTemperature => 
      temperatureProfile?.recommendedHotendTemperature ?? 
      materialType.printTemperature;

  /// Get bed temperature recommendation
  int? get recommendedBedTemperature => 
      temperatureProfile?.bedTemperature ?? 
      materialType.bedTemperature;

  /// Check if filament needs drying before use
  bool get needsDrying => temperatureProfile?.needsDrying ?? false;

  /// Get drying instructions if available
  String? get dryingInstructions {
    if (!needsDrying) return null;
    final temp = temperatureProfile?.dryingTemperature;
    final hours = temperatureProfile?.dryingTimeHours;
    if (temp != null && hours != null) {
      return 'Dry at $temp°C for $hours hours';
    }
    return null;
  }

  /// Get nozzle compatibility information
  String get nozzleCompatibility {
    if (nozzleDiameter != null) {
      return '${nozzleDiameter}mm nozzle recommended';
    }
    return 'Standard nozzle compatible';
  }

  /// Get production age description from RFID data
  String get productionAge => productionInfo?.ageDescription ?? 'Unknown age';

  /// Check if spool is assigned to a specific AMS tray
  bool get isAssignedToTray => trayUid != null && trayUid!.isNotEmpty;

  /// Calculate estimated print time remaining (rough estimate in hours)
  double? estimatePrintTimeRemaining({double printSpeed = 50.0}) {
    if (filamentDiameter == null) return null;
    
    // Very rough estimation based on filament length and print speed
    // This is a simplified calculation and would need more sophisticated logic in real app
    final volumeRemaining = remainingLength.millimeters * 
        (3.14159 * (filamentDiameter! / 2) * (filamentDiameter! / 2));
    return volumeRemaining / (printSpeed * 60 * 60); // Convert to hours
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Spool &&
          runtimeType == other.runtimeType &&
          uid == other.uid;

  @override
  int get hashCode => uid.hashCode;

  @override
  String toString() {
    return 'Spool(uid: $uid, material: ${materialType.value}, color: ${color.name}, remaining: ${remainingLength.format()}/${netLength.format()})';
  }
}