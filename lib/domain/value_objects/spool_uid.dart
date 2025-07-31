/// Value object representing spool unique identifier with validation
/// Part of the Domain Layer: encapsulates business rules for spool IDs
class SpoolUid {
  final String _value;

  const SpoolUid._(this._value);

  /// Create a UID from string with validation
  factory SpoolUid(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Spool UID cannot be empty');
    }
    
    if (trimmed.length < 3) {
      throw ArgumentError('Spool UID must be at least 3 characters long');
    }
    
    if (trimmed.length > 128) {
      throw ArgumentError('Spool UID cannot be longer than 128 characters');
    }
    
    // Allow alphanumeric, hyphens, underscores, and dots
    if (!RegExp(r'^[a-zA-Z0-9\-_.]+$').hasMatch(trimmed)) {
      throw ArgumentError('Spool UID contains invalid characters. Only alphanumeric, hyphens, underscores, and dots are allowed');
    }
    
    return SpoolUid._(trimmed);
  }

  /// Generate a random UID (for testing/mock purposes)
  factory SpoolUid.generate({String prefix = 'SPOOL'}) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return SpoolUid('${prefix}_${timestamp}_$random');
  }

  /// Get the raw value
  String get value => _value;

  /// Check if UID follows a specific pattern (e.g., manufacturer format)
  bool get isBambuLabFormat => RegExp(r'^[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}$').hasMatch(_value);
  bool get isGenericFormat => RegExp(r'^[A-Z0-9_-]+$').hasMatch(_value);
  bool get isTestFormat => _value.startsWith('TEST_') || _value.startsWith('MOCK_');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpoolUid &&
          runtimeType == other.runtimeType &&
          _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => _value;
}