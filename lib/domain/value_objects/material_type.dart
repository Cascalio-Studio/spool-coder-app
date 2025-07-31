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

  static const List<MaterialType> commonTypes = [
    pla,
    abs,
    petg,
    tpu,
    wood,
    carbon,
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

  /// Create from string value
  factory MaterialType.fromString(String value) {
    final upperValue = value.toUpperCase();
    for (final type in commonTypes) {
      if (type.value == upperValue) {
        return type;
      }
    }
    return MaterialType.custom(value: upperValue, displayName: value);
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