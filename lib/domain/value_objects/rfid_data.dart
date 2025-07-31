import 'spool_color.dart';
import 'temperature_profile.dart';
import 'production_info.dart';
import 'filament_length.dart';

/// Value object representing complete RFID tag data from Bambu Lab spools
/// Based on Bambu-Research-Group/RFID-Tag-Guide specifications
/// Part of the Domain Layer: encapsulates RFID business rules and parsing
class RfidData {
  final String uid; // 4-byte hex string from Block 0
  final String? filamentType; // Block 2: Basic material type
  final String? detailedFilamentType; // Block 4: Detailed material variant
  final SpoolColor? color; // Block 5: RGBA color
  final double? spoolWeight; // Block 5: Weight in grams
  final double? filamentDiameter; // Block 5: Diameter in mm
  final TemperatureProfile? temperatureProfile; // Block 6: Temperature settings
  final double? nozzleDiameter; // Block 8: Compatible nozzle diameter
  final String? trayUid; // Block 9: Tray identifier
  final double? spoolWidth; // Block 10: Physical spool width
  final ProductionInfo? productionInfo; // Blocks 1, 12, 13: Manufacturing data
  final FilamentLength? filamentLength; // Block 14: Total length
  final List<int>? xCamInfo; // Block 8: X-Cam compatibility data
  final List<int>? rsaSignature; // Blocks 40-63: Digital signature
  final DateTime scanTime; // When this RFID data was read

  const RfidData({
    required this.uid,
    this.filamentType,
    this.detailedFilamentType,
    this.color,
    this.spoolWeight,
    this.filamentDiameter,
    this.temperatureProfile,
    this.nozzleDiameter,
    this.trayUid,
    this.spoolWidth,
    this.productionInfo,
    this.filamentLength,
    this.xCamInfo,
    this.rsaSignature,
    required this.scanTime,
  });

  /// Create from complete RFID block dump (64 blocks of 16 bytes each)
  factory RfidData.fromBlockDump(Map<String, String> blocks) {
    final uid = _extractUid(blocks['0']);
    final scanTime = DateTime.now();

    // Parse individual blocks
    final filamentType = _parseStringBlock(blocks['2']);
    final detailedFilamentType = _parseStringBlock(blocks['4']);
    
    // Block 5: Color, weight, diameter
    SpoolColor? color;
    double? spoolWeight;
    double? filamentDiameter;
    if (blocks['5'] != null) {
      final block5Data = _hexToBytes(blocks['5']!);
      if (block5Data.length >= 12) {
        // RGBA color (4 bytes)
        final colorBytes = block5Data.sublist(0, 4);
        if (colorBytes.any((b) => b != 0)) {
          color = SpoolColor.rgb(
            'RFID Color',
            colorBytes[0],
            colorBytes[1],
            colorBytes[2],
          );
          // Note: Alpha value (colorBytes[3]) is not handled by SpoolColor.rgb()
          // If alpha is critical, consider extending SpoolColor to support RGBA.
        }
        
        // Spool weight (2 bytes, little-endian)
        spoolWeight = _uint16LE(block5Data, 4).toDouble();
        
        // Filament diameter (8 bytes, little-endian float)
        filamentDiameter = _floatLE(block5Data, 8);
      }
    }

    // Block 6: Temperature profile
    TemperatureProfile? temperatureProfile;
    if (blocks['6'] != null) {
      final block6Data = _hexToBytes(blocks['6']!);
      temperatureProfile = TemperatureProfile.fromRfidBlock6(block6Data);
    }

    // Block 8: X-Cam info and nozzle diameter
    List<int>? xCamInfo;
    double? nozzleDiameter;
    if (blocks['8'] != null) {
      final block8Data = _hexToBytes(blocks['8']!);
      if (block8Data.length >= 16) {
        xCamInfo = block8Data.sublist(0, 12);
        nozzleDiameter = _floatLE(block8Data, 12);
      }
    }

    // Block 9: Tray UID
    final trayUid = _parseStringBlock(blocks['9']);

    // Block 10: Spool width
    double? spoolWidth;
    if (blocks['10'] != null) {
      final block10Data = _hexToBytes(blocks['10']!);
      if (block10Data.length >= 6) {
        final widthRaw = _uint16LE(block10Data, 4);
        spoolWidth = widthRaw / 100.0; // Convert from mm*100 to mm
      }
    }

    // Production info from blocks 1, 12, 13
    ProductionInfo? productionInfo;
    if (blocks['1'] != null || blocks['12'] != null) {
      ProductionInfo? block1Info;
      ProductionInfo? block12Info;
      
      if (blocks['1'] != null) {
        final block1Data = _hexToBytes(blocks['1']!);
        block1Info = ProductionInfo.fromRfidBlock1(block1Data);
      }
      
      if (blocks['12'] != null) {
        final block12Data = _hexToBytes(blocks['12']!);
        block12Info = ProductionInfo.fromRfidBlock12(block12Data);
      }

      if (block1Info != null && block12Info != null) {
        productionInfo = block1Info.combineWith(block12Info);
      } else {
        productionInfo = block1Info ?? block12Info;
      }
    }

    // Block 14: Filament length
    FilamentLength? filamentLength;
    if (blocks['14'] != null) {
      final block14Data = _hexToBytes(blocks['14']!);
      if (block14Data.length >= 6) {
        final lengthMeters = _uint16LE(block14Data, 4).toDouble();
        if (lengthMeters > 0) {
          filamentLength = FilamentLength.meters(lengthMeters);
        }
      }
    }

    // RSA Signature (blocks 40-63)
    List<int>? rsaSignature;
    final signatureBlocks = <int>[];
    for (int i = 40; i <= 63; i++) {
      if (blocks[i.toString()] != null) {
        signatureBlocks.addAll(_hexToBytes(blocks[i.toString()]!));
      }
    }
    if (signatureBlocks.isNotEmpty) {
      rsaSignature = signatureBlocks;
    }

    return RfidData(
      uid: uid,
      filamentType: filamentType,
      detailedFilamentType: detailedFilamentType,
      color: color,
      spoolWeight: spoolWeight,
      filamentDiameter: filamentDiameter,
      temperatureProfile: temperatureProfile,
      nozzleDiameter: nozzleDiameter,
      trayUid: trayUid,
      spoolWidth: spoolWidth,
      productionInfo: productionInfo,
      filamentLength: filamentLength,
      xCamInfo: xCamInfo,
      rsaSignature: rsaSignature,
      scanTime: scanTime,
    );
  }

  /// Extract UID from Block 0 (first 4 bytes)
  static String _extractUid(String? block0) {
    if (block0 == null || block0.length < 8) return 'UNKNOWN';
    return block0.substring(0, 8).toUpperCase();
  }

  /// Parse string from block data, trimming null bytes
  static String? _parseStringBlock(String? blockHex) {
    if (blockHex == null) return null;
    final bytes = _hexToBytes(blockHex);
    final chars = bytes.where((b) => b != 0).toList();
    if (chars.isEmpty) return null;
    return String.fromCharCodes(chars).trim();
  }

  /// Convert hex string to byte array
  static List<int> _hexToBytes(String hex) {
    final bytes = <int>[];
    for (int i = 0; i < hex.length; i += 2) {
      if (i + 1 < hex.length) {
        bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
      }
    }
    return bytes;
  }

  /// Read little-endian uint16 from byte array
  static int _uint16LE(List<int> data, int offset) {
    if (offset + 1 >= data.length) return 0;
    return data[offset] | (data[offset + 1] << 8);
  }

  /// Read little-endian float from byte array
  static double _floatLE(List<int> data, int offset) {
    if (offset + 3 >= data.length) return 0.0;
    // This is a simplified float parsing - in a real implementation,
    // you'd need proper IEEE 754 float parsing
    final raw = data[offset] | 
                (data[offset + 1] << 8) | 
                (data[offset + 2] << 16) | 
                (data[offset + 3] << 24);
    return raw.toDouble();
  }

  /// Check if this RFID data represents a genuine Bambu Lab spool
  bool get isGenuineBambuLab => rsaSignature != null && rsaSignature!.isNotEmpty;

  /// Check if the filament data appears complete and valid
  bool get isComplete {
    return uid.isNotEmpty &&
           filamentType != null &&
           detailedFilamentType != null &&
           temperatureProfile != null &&
           productionInfo != null;
  }

  /// Get a human-readable description of the spool
  String get description {
    final parts = <String>[];
    if (detailedFilamentType != null) {
      parts.add(detailedFilamentType!);
    } else if (filamentType != null) {
      parts.add(filamentType!);
    }
    
    if (color != null) {
      parts.add(color!.name);
    }
    
    if (spoolWeight != null) {
      parts.add('${spoolWeight!.toInt()}g');
    }
    
    return parts.join(' ');
  }

  /// Create a copy with updated values
  RfidData copyWith({
    String? uid,
    String? filamentType,
    String? detailedFilamentType,
    SpoolColor? color,
    double? spoolWeight,
    double? filamentDiameter,
    TemperatureProfile? temperatureProfile,
    double? nozzleDiameter,
    String? trayUid,
    double? spoolWidth,
    ProductionInfo? productionInfo,
    FilamentLength? filamentLength,
    List<int>? xCamInfo,
    List<int>? rsaSignature,
    DateTime? scanTime,
  }) {
    return RfidData(
      uid: uid ?? this.uid,
      filamentType: filamentType ?? this.filamentType,
      detailedFilamentType: detailedFilamentType ?? this.detailedFilamentType,
      color: color ?? this.color,
      spoolWeight: spoolWeight ?? this.spoolWeight,
      filamentDiameter: filamentDiameter ?? this.filamentDiameter,
      temperatureProfile: temperatureProfile ?? this.temperatureProfile,
      nozzleDiameter: nozzleDiameter ?? this.nozzleDiameter,
      trayUid: trayUid ?? this.trayUid,
      spoolWidth: spoolWidth ?? this.spoolWidth,
      productionInfo: productionInfo ?? this.productionInfo,
      filamentLength: filamentLength ?? this.filamentLength,
      xCamInfo: xCamInfo ?? this.xCamInfo,
      rsaSignature: rsaSignature ?? this.rsaSignature,
      scanTime: scanTime ?? this.scanTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RfidData &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          scanTime == other.scanTime;

  @override
  int get hashCode => Object.hash(uid, scanTime);

  @override
  String toString() {
    return 'RfidData(uid: $uid, ${description}, scanned: ${scanTime.toIso8601String().substring(0, 19)})';
  }
}