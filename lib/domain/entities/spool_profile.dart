import '../value_objects/material_type.dart';
import '../value_objects/spool_color.dart';
import '../value_objects/filament_length.dart';

/// Spool profile entity - represents a template or configuration for spools
/// Part of the Domain Layer: encapsulates spool template business logic
class SpoolProfile {
  final String id;
  final String name;
  final String manufacturer;
  final MaterialType materialType;
  final SpoolColor? defaultColor;
  final FilamentLength? standardLength;
  final double? filamentDiameter; // mm
  final double? spoolDiameter; // mm
  final double? spoolWidth; // mm
  final double? spoolWeight; // grams (empty spool)
  final int? printTemperature; // °C
  final int? bedTemperature; // °C
  final int? printSpeed; // mm/s
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const SpoolProfile({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.materialType,
    this.defaultColor,
    this.standardLength,
    this.filamentDiameter,
    this.spoolDiameter,
    this.spoolWidth,
    this.spoolWeight,
    this.printTemperature,
    this.bedTemperature,
    this.printSpeed,
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  /// Create a copy with updated values
  SpoolProfile copyWith({
    String? id,
    String? name,
    String? manufacturer,
    MaterialType? materialType,
    SpoolColor? defaultColor,
    FilamentLength? standardLength,
    double? filamentDiameter,
    double? spoolDiameter,
    double? spoolWidth,
    double? spoolWeight,
    int? printTemperature,
    int? bedTemperature,
    int? printSpeed,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SpoolProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      manufacturer: manufacturer ?? this.manufacturer,
      materialType: materialType ?? this.materialType,
      defaultColor: defaultColor ?? this.defaultColor,
      standardLength: standardLength ?? this.standardLength,
      filamentDiameter: filamentDiameter ?? this.filamentDiameter,
      spoolDiameter: spoolDiameter ?? this.spoolDiameter,
      spoolWidth: spoolWidth ?? this.spoolWidth,
      spoolWeight: spoolWeight ?? this.spoolWeight,
      printTemperature: printTemperature ?? this.printTemperature,
      bedTemperature: bedTemperature ?? this.bedTemperature,
      printSpeed: printSpeed ?? this.printSpeed,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Check if profile is complete (has all essential data)
  bool get isComplete {
    return name.isNotEmpty &&
        manufacturer.isNotEmpty &&
        filamentDiameter != null &&
        printTemperature != null;
  }

  /// Get display name combining manufacturer and material
  String get displayName => '$manufacturer $name (${materialType.value})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpoolProfile &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => displayName;
}