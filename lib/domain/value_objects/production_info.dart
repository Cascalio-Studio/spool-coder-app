/// Value object representing production and manufacturing information
/// Based on Bambu Lab RFID tag specifications (Blocks 12-13)
/// Part of the Domain Layer: encapsulates production metadata
class ProductionInfo {
  final DateTime? productionDateTime;
  final String? batchId;
  final String? trayInfoIndex;
  final String? materialId;

  const ProductionInfo({
    this.productionDateTime,
    this.batchId,
    this.trayInfoIndex,
    this.materialId,
  });

  /// Create from RFID Block 12 data (production date/time)
  /// Format: ASCII string "YYYY_MM_DD_HH_MM" (16 bytes)
  factory ProductionInfo.fromRfidBlock12(List<int> blockData) {
    if (blockData.length < 16) {
      throw ArgumentError('Block 12 data must be 16 bytes');
    }

    final dateString = String.fromCharCodes(blockData).trim();
    DateTime? productionDateTime;

    try {
      // Parse format: "2022_10_15_08_26"
      final parts = dateString.split('_');
      if (parts.length >= 5) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        final hour = int.parse(parts[3]);
        final minute = int.parse(parts[4]);
        
        productionDateTime = DateTime(year, month, day, hour, minute);
      }
    } catch (e) {
      // Invalid date format, keep as null
    }

    return ProductionInfo(
      productionDateTime: productionDateTime,
      batchId: dateString.isNotEmpty ? dateString : null,
    );
  }

  /// Create from RFID Block 1 data (tray info index)
  /// Format: 8 bytes variant ID + 8 bytes material ID
  factory ProductionInfo.fromRfidBlock1(List<int> blockData) {
    if (blockData.length < 16) {
      throw ArgumentError('Block 1 data must be 16 bytes');
    }

    final variantId = String.fromCharCodes(blockData.sublist(0, 8)).trim();
    final materialId = String.fromCharCodes(blockData.sublist(8, 16)).trim();

    return ProductionInfo(
      trayInfoIndex: variantId.isNotEmpty ? variantId : null,
      materialId: materialId.isNotEmpty ? materialId : null,
    );
  }

  /// Combine production info from multiple blocks
  ProductionInfo combineWith(ProductionInfo other) {
    return ProductionInfo(
      productionDateTime: productionDateTime ?? other.productionDateTime,
      batchId: batchId ?? other.batchId,
      trayInfoIndex: trayInfoIndex ?? other.trayInfoIndex,
      materialId: materialId ?? other.materialId,
    );
  }

  /// Check if production date indicates fresh filament (< 1 year old)
  bool get isFresh {
    if (productionDateTime == null) return false;
    final age = DateTime.now().difference(productionDateTime!);
    return age.inDays < 365;
  }

  /// Check if filament is very old (> 2 years)
  bool get isOld {
    if (productionDateTime == null) return false;
    final age = DateTime.now().difference(productionDateTime!);
    return age.inDays > 730;
  }

  /// Get age in human-readable format
  String get ageDescription {
    if (productionDateTime == null) return 'Unknown age';
    
    final age = DateTime.now().difference(productionDateTime!);
    if (age.inDays < 30) {
      return '${age.inDays} days old';
    } else if (age.inDays < 365) {
      return '${(age.inDays / 30).round()} months old';
    } else {
      return '${(age.inDays / 365).toStringAsFixed(1)} years old';
    }
  }

  /// Validate Bambu Lab material ID format (should start with "GF")
  bool get hasValidMaterialId {
    return materialId != null && materialId!.startsWith('GF');
  }

  /// Create a copy with updated values
  ProductionInfo copyWith({
    DateTime? productionDateTime,
    String? batchId,
    String? trayInfoIndex,
    String? materialId,
  }) {
    return ProductionInfo(
      productionDateTime: productionDateTime ?? this.productionDateTime,
      batchId: batchId ?? this.batchId,
      trayInfoIndex: trayInfoIndex ?? this.trayInfoIndex,
      materialId: materialId ?? this.materialId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductionInfo &&
          runtimeType == other.runtimeType &&
          productionDateTime == other.productionDateTime &&
          batchId == other.batchId &&
          trayInfoIndex == other.trayInfoIndex &&
          materialId == other.materialId;

  @override
  int get hashCode => Object.hash(
        productionDateTime,
        batchId,
        trayInfoIndex,
        materialId,
      );

  @override
  String toString() {
    final parts = <String>[];
    if (productionDateTime != null) {
      parts.add('Produced: ${productionDateTime!.toIso8601String().substring(0, 10)}');
    }
    if (materialId != null) {
      parts.add('Material ID: $materialId');
    }
    if (trayInfoIndex != null) {
      parts.add('Variant: $trayInfoIndex');
    }
    return parts.isEmpty ? 'No production info' : parts.join(', ');
  }
}