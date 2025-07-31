/// Value object representing measurement of filament length with validation
/// Part of the Domain Layer: encapsulates business rules for measurements
class FilamentLength {
  final double _meters;

  const FilamentLength._(this._meters);

  /// Create from meters
  factory FilamentLength.meters(double meters) {
    if (meters < 0) {
      throw ArgumentError('Length cannot be negative: $meters meters');
    }
    if (meters > 10000) {
      throw ArgumentError('Length is unrealistically large: $meters meters');
    }
    return FilamentLength._(meters);
  }

  /// Create from millimeters
  factory FilamentLength.millimeters(double millimeters) {
    return FilamentLength.meters(millimeters / 1000);
  }

  /// Create from feet
  factory FilamentLength.feet(double feet) {
    return FilamentLength.meters(feet * 0.3048);
  }

  /// Create from inches
  factory FilamentLength.inches(double inches) {
    return FilamentLength.meters(inches * 0.0254);
  }

  /// Get length in meters
  double get meters => _meters;

  /// Get length in millimeters
  double get millimeters => _meters * 1000;

  /// Get length in feet
  double get feet => _meters / 0.3048;

  /// Get length in inches
  double get inches => _meters / 0.0254;

  /// Check if length is empty
  bool get isEmpty => _meters == 0;

  /// Check if length is nearly empty (less than 1 meter)
  bool get isNearlyEmpty => _meters < 1.0;

  /// Add another length
  FilamentLength operator +(FilamentLength other) {
    return FilamentLength._(_meters + other._meters);
  }

  /// Subtract another length
  FilamentLength operator -(FilamentLength other) {
    final result = _meters - other._meters;
    if (result < 0) {
      throw ArgumentError('Result would be negative length');
    }
    return FilamentLength._(result);
  }

  /// Multiply by a factor
  FilamentLength operator *(double factor) {
    if (factor < 0) {
      throw ArgumentError('Factor cannot be negative: $factor');
    }
    return FilamentLength._(_meters * factor);
  }

  /// Divide by a factor
  FilamentLength operator /(double factor) {
    if (factor <= 0) {
      throw ArgumentError('Factor must be positive: $factor');
    }
    return FilamentLength._(_meters / factor);
  }

  /// Compare lengths
  bool operator >(FilamentLength other) => _meters > other._meters;
  bool operator <(FilamentLength other) => _meters < other._meters;
  bool operator >=(FilamentLength other) => _meters >= other._meters;
  bool operator <=(FilamentLength other) => _meters <= other._meters;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilamentLength &&
          runtimeType == other.runtimeType &&
          (_meters - other._meters).abs() < 0.001; // Account for floating point precision

  @override
  int get hashCode => _meters.hashCode;

  @override
  String toString() => '${_meters.toStringAsFixed(2)}m';

  /// Format with specific precision
  String toStringWithPrecision(int decimals) => 
      '${_meters.toStringAsFixed(decimals)}m';

  /// Format in preferred unit
  String format({String unit = 'm'}) {
    switch (unit.toLowerCase()) {
      case 'm':
      case 'meters':
        return '${_meters.toStringAsFixed(2)}m';
      case 'mm':
      case 'millimeters':
        return '${millimeters.toStringAsFixed(0)}mm';
      case 'ft':
      case 'feet':
        return '${feet.toStringAsFixed(2)}ft';
      case 'in':
      case 'inches':
        return '${inches.toStringAsFixed(1)}in';
      default:
        return toString();
    }
  }
}