/// Value object representing different material types for 3D printing filaments
/// Part of the Domain Layer: encapsulates business rules for material types
class MaterialType {
  final String value;
  final String displayName;
  final double? defaultDensity; // g/cm³
  final int? printTemperature; // °C
  final int? bedTemperature; // °C

  const MaterialType._({
    required this.value,
    required this.displayName,
    this.defaultDensity,
    this.printTemperature,
    this.bedTemperature,
  });

  // Common material types
  static const MaterialType pla = MaterialType._(
    value: 'PLA',
    displayName: 'PLA (Polylactic Acid)',
    defaultDensity: 1.24,
    printTemperature: 200,
    bedTemperature: 60,
  );

  static const MaterialType abs = MaterialType._(
    value: 'ABS',
    displayName: 'ABS (Acrylonitrile Butadiene Styrene)',
    defaultDensity: 1.04,
    printTemperature: 250,
    bedTemperature: 80,
  );

  static const MaterialType petg = MaterialType._(
    value: 'PETG',
    displayName: 'PETG (Polyethylene Terephthalate Glycol)',
    defaultDensity: 1.27,
    printTemperature: 230,
    bedTemperature: 70,
  );

  static const MaterialType tpu = MaterialType._(
    value: 'TPU',
    displayName: 'TPU (Thermoplastic Polyurethane)',
    defaultDensity: 1.2,
    printTemperature: 225,
    bedTemperature: 50,
  );

  static const MaterialType wood = MaterialType._(
    value: 'WOOD',
    displayName: 'Wood Filled PLA',
    defaultDensity: 1.15,
    printTemperature: 190,
    bedTemperature: 60,
  );

  static const MaterialType carbon = MaterialType._(
    value: 'CARBON',
    displayName: 'Carbon Fiber Filled',
    defaultDensity: 1.3,
    printTemperature: 260,
    bedTemperature: 80,
  );

  // Bambu Lab specific material variants (based on RFID Tag Guide)
  static const MaterialType plaBasic = MaterialType._(
    value: 'PLA_BASIC',
    displayName: 'PLA Basic',
    defaultDensity: 1.24,
    printTemperature: 220,
    bedTemperature: 45,
  );

  static const MaterialType plaMatte = MaterialType._(
    value: 'PLA_MATTE',
    displayName: 'PLA Matte',
    defaultDensity: 1.24,
    printTemperature: 220,
    bedTemperature: 45,
  );

  static const MaterialType plaSilk = MaterialType._(
    value: 'PLA_SILK',
    displayName: 'PLA Silk',
    defaultDensity: 1.24,
    printTemperature: 220,
    bedTemperature: 45,
  );

  static const MaterialType plaGalaxy = MaterialType._(
    value: 'PLA_GALAXY',
    displayName: 'PLA Galaxy',
    defaultDensity: 1.24,
    printTemperature: 220,
    bedTemperature: 45,
  );

  static const MaterialType plaSparkle = MaterialType._(
    value: 'PLA_SPARKLE',
    displayName: 'PLA Sparkle',
    defaultDensity: 1.24,
    printTemperature: 220,
    bedTemperature: 45,
  );

  static const MaterialType plaCf = MaterialType._(
    value: 'PLA_CF',
    displayName: 'PLA-CF (Carbon Fiber)',
    defaultDensity: 1.3,
    printTemperature: 260,
    bedTemperature: 60,
  );

  static const MaterialType supportPla = MaterialType._(
    value: 'SUPPORT_PLA',
    displayName: 'Support for PLA',
    defaultDensity: 1.24,
    printTemperature: 220,
    bedTemperature: 45,
  );

  static const MaterialType petgBasic = MaterialType._(
    value: 'PETG_BASIC',
    displayName: 'PETG Basic',
    defaultDensity: 1.27,
    printTemperature: 250,
    bedTemperature: 70,
  );

  static const List<MaterialType> commonTypes = [
    pla,
    abs,
    petg,
    tpu,
    wood,
    carbon,
  ];

  /// Bambu Lab specific material variants
  static const List<MaterialType> bambuLabTypes = [
    plaBasic,
    plaMatte,
    plaSilk,
    plaGalaxy,
    plaSparkle,
    plaCf,
    supportPla,
    petgBasic,
  ];

  /// All material types including Bambu Lab variants
  static const List<MaterialType> allTypes = [
    ...commonTypes,
    ...bambuLabTypes,
  ];

  /// Create a custom material type
  factory MaterialType.custom({
    required String value,
    required String displayName,
    double? defaultDensity,
    int? printTemperature,
    int? bedTemperature,
  }) {
    if (value.isEmpty || displayName.isEmpty) {
      throw ArgumentError('Material type value and display name cannot be empty');
    }
    return MaterialType._(
      value: value.toUpperCase(),
      displayName: displayName,
      defaultDensity: defaultDensity,
      printTemperature: printTemperature,
      bedTemperature: bedTemperature,
    );
  }

  /// Create from string value with Bambu Lab variant support
  factory MaterialType.fromString(String value) {
    final upperValue = value.toUpperCase();
    
    // Check all types including Bambu Lab variants
    for (final type in allTypes) {
      if (type.value == upperValue) {
        return type;
      }
    }
    
    // Check for RFID detailed type mapping
    return _fromDetailedType(value) ?? 
           MaterialType.custom(value: upperValue, displayName: value);
  }

  /// Create from RFID detailed filament type string
  factory MaterialType.fromRfidDetailedType(String detailedType) {
    return _fromDetailedType(detailedType) ?? 
           MaterialType.custom(
             value: detailedType.toUpperCase().replaceAll(' ', '_'),
             displayName: detailedType,
           );
  }

  /// Internal helper to map RFID detailed types to MaterialType instances
  static MaterialType? _fromDetailedType(String detailedType) {
    final normalized = detailedType.toLowerCase().trim();
    
    switch (normalized) {
      case 'pla basic':
        return plaBasic;
      case 'pla matte':
        return plaMatte;
      case 'pla silk':
        return plaSilk;
      case 'pla galaxy':
        return plaGalaxy;
      case 'pla sparkle':
        return plaSparkle;
      case 'pla-cf':
      case 'pla tough':
        return plaCf;
      case 'support for pla':
      case 'support w':
        return supportPla;
      case 'petg basic':
        return petgBasic;
      default:
        return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaterialType &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => displayName;
}