/// Value object representing color with validation
/// Part of the Domain Layer: encapsulates business rules for spool colors
class SpoolColor {
  final String name;
  final String? hexCode;
  final int? rgbRed;
  final int? rgbGreen;
  final int? rgbBlue;

  const SpoolColor._({
    required this.name,
    this.hexCode,
    this.rgbRed,
    this.rgbGreen,
    this.rgbBlue,
  });

  /// Create a color with name only
  factory SpoolColor.named(String name) {
    if (name.isEmpty) {
      throw ArgumentError('Color name cannot be empty');
    }
    return SpoolColor._(name: name.trim());
  }

  /// Create a color with hex code
  factory SpoolColor.hex(String name, String hexCode) {
    if (name.isEmpty) {
      throw ArgumentError('Color name cannot be empty');
    }
    
    final cleanHex = hexCode.replaceAll('#', '').toUpperCase();
    if (!RegExp(r'^[0-9A-F]{6}$').hasMatch(cleanHex)) {
      throw ArgumentError('Invalid hex color code: $hexCode');
    }
    
    return SpoolColor._(
      name: name.trim(),
      hexCode: '#$cleanHex',
    );
  }

  /// Create a color with RGB values
  factory SpoolColor.rgb(String name, int red, int green, int blue) {
    if (name.isEmpty) {
      throw ArgumentError('Color name cannot be empty');
    }
    
    if (red < 0 || red > 255 || green < 0 || green > 255 || blue < 0 || blue > 255) {
      throw ArgumentError('RGB values must be between 0 and 255');
    }
    
    final hexCode = '#${red.toRadixString(16).padLeft(2, '0')}'
        '${green.toRadixString(16).padLeft(2, '0')}'
        '${blue.toRadixString(16).padLeft(2, '0')}'.toUpperCase();
    
    return SpoolColor._(
      name: name.trim(),
      hexCode: hexCode,
      rgbRed: red,
      rgbGreen: green,
      rgbBlue: blue,
    );
  }

  /// Common predefined colors
  static const SpoolColor black = SpoolColor._(name: 'Black', hexCode: '#000000');
  static const SpoolColor white = SpoolColor._(name: 'White', hexCode: '#FFFFFF');
  static const SpoolColor red = SpoolColor._(name: 'Red', hexCode: '#FF0000');
  static const SpoolColor green = SpoolColor._(name: 'Green', hexCode: '#00FF00');
  static const SpoolColor blue = SpoolColor._(name: 'Blue', hexCode: '#0000FF');
  static const SpoolColor yellow = SpoolColor._(name: 'Yellow', hexCode: '#FFFF00');
  static const SpoolColor orange = SpoolColor._(name: 'Orange', hexCode: '#FFA500');
  static const SpoolColor purple = SpoolColor._(name: 'Purple', hexCode: '#800080');
  static const SpoolColor gray = SpoolColor._(name: 'Gray', hexCode: '#808080');
  static const SpoolColor transparent = SpoolColor._(name: 'Transparent');

  static const List<SpoolColor> commonColors = [
    black, white, red, green, blue, yellow, orange, purple, gray, transparent,
  ];

  /// Check if color has color information (hex/RGB)
  bool get hasColorData => hexCode != null;

  /// Get RGB values if available
  List<int>? get rgbValues {
    if (rgbRed != null && rgbGreen != null && rgbBlue != null) {
      return [rgbRed!, rgbGreen!, rgbBlue!];
    }
    
    if (hexCode != null) {
      final hex = hexCode!.replaceAll('#', '');
      return [
        int.parse(hex.substring(0, 2), radix: 16),
        int.parse(hex.substring(2, 4), radix: 16),
        int.parse(hex.substring(4, 6), radix: 16),
      ];
    }
    
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpoolColor &&
          runtimeType == other.runtimeType &&
          name.toLowerCase() == other.name.toLowerCase() &&
          hexCode == other.hexCode;

  @override
  int get hashCode => name.toLowerCase().hashCode ^ (hexCode?.hashCode ?? 0);

  @override
  String toString() => hexCode != null ? '$name ($hexCode)' : name;
}