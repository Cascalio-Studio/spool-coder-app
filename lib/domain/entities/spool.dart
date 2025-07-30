/// Spool entity - core business object
/// Part of the Domain Layer: represents business logic and rules
class Spool {
  final String uid;
  final String materialType;
  final String manufacturer;
  final String color;
  final double netLength;
  final double remainingLength;
  final bool isWriteProtected;

  const Spool({
    required this.uid,
    required this.materialType,
    required this.manufacturer,
    required this.color,
    required this.netLength,
    required this.remainingLength,
    this.isWriteProtected = false,
  });

  /// Calculate usage percentage
  double get usagePercentage {
    if (netLength <= 0) return 0;
    return ((netLength - remainingLength) / netLength) * 100;
  }

  /// Check if spool is nearly empty
  bool get isNearlyEmpty => remainingLength < (netLength * 0.1);

  @override
  String toString() {
    return 'Spool(uid: $uid, material: $materialType, color: $color, remaining: ${remainingLength}m/${netLength}m)';
  }
}