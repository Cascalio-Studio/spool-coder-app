import '../value_objects/spool_uid.dart';
import '../value_objects/material_type.dart';
import '../value_objects/spool_color.dart';
import '../value_objects/filament_length.dart';

/// Spool entity - core business object
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
  });

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