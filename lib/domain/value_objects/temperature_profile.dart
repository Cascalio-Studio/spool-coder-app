/// Value object representing temperature settings for 3D printing materials
/// Based on Bambu Lab RFID tag specifications
/// Part of the Domain Layer: encapsulates temperature business rules
class TemperatureProfile {
  final int? dryingTemperature; // °C
  final int? dryingTimeHours; // hours
  final int? bedTemperature; // °C
  final int? minHotendTemperature; // °C
  final int? maxHotendTemperature; // °C
  final int? bedTemperatureType; // Internal Bambu type identifier

  const TemperatureProfile({
    this.dryingTemperature,
    this.dryingTimeHours,
    this.bedTemperature,
    this.minHotendTemperature,
    this.maxHotendTemperature,
    this.bedTemperatureType,
  });

  /// Create from RFID Block 6 data (temperature block)
  /// Format: AA AA BB BB CC CC DD DD EE EE FF FF (little endian uint16)
  factory TemperatureProfile.fromRfidBlock6(List<int> blockData) {
    if (blockData.length < 12) {
      throw ArgumentError('Block 6 data must be at least 12 bytes');
    }

    return TemperatureProfile(
      dryingTemperature: _uint16LE(blockData, 0),
      dryingTimeHours: _uint16LE(blockData, 2),
      bedTemperatureType: _uint16LE(blockData, 4),
      bedTemperature: _uint16LE(blockData, 6),
      maxHotendTemperature: _uint16LE(blockData, 8),
      minHotendTemperature: _uint16LE(blockData, 10),
    );
  }

  /// Helper to read little-endian uint16 from byte array
  static int _uint16LE(List<int> data, int offset) {
    if (offset + 1 >= data.length) return 0;
    return data[offset] | (data[offset + 1] << 8);
  }

  /// Get recommended hotend temperature (average of min/max)
  int? get recommendedHotendTemperature {
    if (minHotendTemperature == null || maxHotendTemperature == null) {
      return null;
    }
    return ((minHotendTemperature! + maxHotendTemperature!) / 2).round();
  }

  /// Check if material needs drying
  bool get needsDrying => 
      dryingTemperature != null && 
      dryingTemperature! > 0 && 
      dryingTimeHours != null && 
      dryingTimeHours! > 0;

  /// Validate temperature settings are reasonable
  bool get isValid {
    // Basic sanity checks
    if (dryingTemperature != null && (dryingTemperature! < 0 || dryingTemperature! > 100)) {
      return false;
    }
    if (bedTemperature != null && (bedTemperature! < 0 || bedTemperature! > 150)) {
      return false;
    }
    if (minHotendTemperature != null && (minHotendTemperature! < 150 || minHotendTemperature! > 350)) {
      return false;
    }
    if (maxHotendTemperature != null && (maxHotendTemperature! < 150 || maxHotendTemperature! > 350)) {
      return false;
    }
    if (minHotendTemperature != null && maxHotendTemperature != null && 
        minHotendTemperature! > maxHotendTemperature!) {
      return false;
    }
    return true;
  }

  /// Create a copy with updated values
  TemperatureProfile copyWith({
    int? dryingTemperature,
    int? dryingTimeHours,
    int? bedTemperature,
    int? minHotendTemperature,
    int? maxHotendTemperature,
    int? bedTemperatureType,
  }) {
    return TemperatureProfile(
      dryingTemperature: dryingTemperature ?? this.dryingTemperature,
      dryingTimeHours: dryingTimeHours ?? this.dryingTimeHours,
      bedTemperature: bedTemperature ?? this.bedTemperature,
      minHotendTemperature: minHotendTemperature ?? this.minHotendTemperature,
      maxHotendTemperature: maxHotendTemperature ?? this.maxHotendTemperature,
      bedTemperatureType: bedTemperatureType ?? this.bedTemperatureType,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TemperatureProfile &&
          runtimeType == other.runtimeType &&
          dryingTemperature == other.dryingTemperature &&
          dryingTimeHours == other.dryingTimeHours &&
          bedTemperature == other.bedTemperature &&
          minHotendTemperature == other.minHotendTemperature &&
          maxHotendTemperature == other.maxHotendTemperature &&
          bedTemperatureType == other.bedTemperatureType;

  @override
  int get hashCode => Object.hash(
        dryingTemperature,
        dryingTimeHours,
        bedTemperature,
        minHotendTemperature,
        maxHotendTemperature,
        bedTemperatureType,
      );

  @override
  String toString() {
    final parts = <String>[];
    if (recommendedHotendTemperature != null) {
      parts.add('Hotend: $recommendedHotendTemperature°C');
    }
    if (bedTemperature != null) {
      parts.add('Bed: $bedTemperature°C');
    }
    if (needsDrying) {
      parts.add('Dry: $dryingTemperature°C/${dryingTimeHours}h');
    }
    return parts.isEmpty ? 'No temperature profile' : parts.join(', ');
  }
}