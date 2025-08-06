import 'dart:typed_data';
import 'dart:convert';
import '../value_objects/rfid_data.dart';
import '../value_objects/spool_color.dart';
import '../value_objects/temperature_profile.dart';
import '../value_objects/production_info.dart';
import '../value_objects/filament_length.dart';
import '../../core/errors/failures.dart';

/// Bambu Lab RFID Tag Parser
/// 
/// Implements the complete Bambu Lab RFID format specification from
/// https://github.com/Bambu-Research-Group/RFID-Tag-Guide
/// 
/// This parser handles:
/// - 64-block MIFARE 1K structure (1024 bytes total)
/// - Little-endian data encoding
/// - Complete block-by-block parsing per official specification
/// - RSA signature verification (structure only, not cryptographic validation)
/// - Material identification and temperature profiles
/// - Production metadata and quality validation
class BambuLabRfidParser {
  static const int bytesPerBlock = 16;
  static const int totalBlocks = 64;
  static const int totalBytes = totalBlocks * bytesPerBlock;
  
  /// Important blocks that contain actual data (excluding MIFARE encryption blocks)
  static const List<int> importantBlocks = [0, 1, 2, 4, 5, 6, 8, 9, 10, 12, 13, 14, 16, 17];
  
  /// MIFARE encryption key blocks (every 4th block starting from 3)
  static const List<int> mifareKeyBlocks = [3, 7, 11, 15, 19, 23, 27, 31, 35, 39];
  
  /// RSA signature blocks (40-63)
  static final List<int> rsaSignatureBlocks = List.generate(24, (i) => 40 + i);

  /// Parse raw bytes from MIFARE 1K dump into RfidData
  /// 
  /// [data] - Raw bytes from RFID tag dump (1024 bytes expected)
  /// Returns parsed RfidData or throws RfidParsingFailure
  static RfidData parseFromBytes(Uint8List data) {
    if (data.length != totalBytes) {
      throw RfidFailure(
        'Invalid tag data length: expected $totalBytes bytes, got ${data.length} bytes'
      );
    }

    // Split data into 16-byte blocks
    final blocks = <List<int>>[];
    for (int i = 0; i < totalBlocks; i++) {
      final start = i * bytesPerBlock;
      final end = start + bytesPerBlock;
      blocks.add(data.sublist(start, end));
    }

    return _parseBlocks(blocks);
  }

  /// Parse from block dump (Map format, often from debugging tools)
  static RfidData parseFromBlockDump(Map<String, String> blockMap) {
    final blocks = List<List<int>>.filled(totalBlocks, []);
    
    for (int i = 0; i < totalBlocks; i++) {
      final blockHex = blockMap[i.toString()];
      if (blockHex != null) {
        blocks[i] = _hexToBytes(blockHex);
      } else {
        blocks[i] = List<int>.filled(bytesPerBlock, 0);
      }
    }

    return _parseBlocks(blocks);
  }

  /// Parse from Flipper Zero NFC dump format
  static RfidData parseFromFlipperDump(String flipperData) {
    // Strip Flipper NFC headers and metadata
    final lines = flipperData.split('\n');
    final dataLines = lines.where((line) => 
      line.contains('Block') && line.contains(':')).toList();
    
    final blockMap = <String, String>{};
    for (final line in dataLines) {
      final match = RegExp(r'Block (\d+): ([A-Fa-f0-9\s]+)').firstMatch(line);
      if (match != null) {
        final blockNum = match.group(1)!;
        final blockData = match.group(2)!.replaceAll(' ', '');
        blockMap[blockNum] = blockData;
      }
    }

    return parseFromBlockDump(blockMap);
  }

  /// Core parsing logic that processes the 64 blocks according to Bambu Lab specification
  static RfidData _parseBlocks(List<List<int>> blocks) {
    final warnings = <String>[];

    // Validate important blocks aren't completely blank
    for (final blockNum in importantBlocks) {
      if (blockNum < blocks.length && _isBlockBlank(blocks[blockNum])) {
        warnings.add('Block $blockNum is blank - this may indicate read errors');
      }
    }

    try {
      // Block 0: UID and Tag Manufacturer Data (Read-only)
      final uid = _parseUid(blocks[0]);

      // Block 1: Tray Info Index (Material Variant ID + Material ID)
      final block1Info = _parseBlock1(blocks[1]);

      // Block 2: Filament Type
      final filamentType = _parseStringFromBlock(blocks[2]);

      // Block 4: Detailed Filament Type
      final detailedFilamentType = _parseStringFromBlock(blocks[4]);

      // Block 5: Color, Spool Weight, Filament Diameter
      final block5Data = _parseBlock5(blocks[5]);

      // Block 6: Temperature Profile
      final temperatureProfile = _parseBlock6(blocks[6]);

      // Block 8: X Cam Info + Nozzle Diameter
      final block8Data = _parseBlock8(blocks[8]);

      // Block 9: Tray UID
      final trayUid = _parseStringFromBlock(blocks[9]);

      // Block 10: Spool Width
      final spoolWidth = _parseBlock10(blocks[10]);

      // Block 12: Production Date/Time
      final productionDate = _parseBlock12(blocks[12]);

      // Block 13: Short Production Date/Time (alternative format)
      final shortProductionDate = _parseStringFromBlock(blocks[13]);

      // Block 14: Filament Length
      final filamentLength = _parseBlock14(blocks[14]);

      // Block 16: Extra Color Info
      final extraColorInfo = _parseBlock16(blocks[16]);

      // Block 17: Unknown data (kept for future compatibility)
      // final block17Data = blocks[17];

      // Combine production info from blocks 1 and 12
      final combinedProductionInfo = _combineProductionInfo(
        block1Info, productionDate, shortProductionDate
      );

      // RSA Signature (blocks 40-63)
      final rsaSignature = _parseRsaSignature(blocks);

      // Handle multi-color spools
      SpoolColor? finalColor = block5Data.color;
      if (extraColorInfo != null && extraColorInfo.colorCount > 1) {
        finalColor = _combineColors(block5Data.color, extraColorInfo.secondColor);
      }

      return RfidData(
        uid: uid,
        filamentType: filamentType,
        detailedFilamentType: detailedFilamentType,
        color: finalColor,
        spoolWeight: block5Data.spoolWeight,
        filamentDiameter: block5Data.filamentDiameter,
        temperatureProfile: temperatureProfile,
        nozzleDiameter: block8Data.nozzleDiameter,
        trayUid: trayUid,
        spoolWidth: spoolWidth,
        productionInfo: combinedProductionInfo,
        filamentLength: filamentLength,
        xCamInfo: block8Data.xCamInfo,
        rsaSignature: rsaSignature,
        scanTime: DateTime.now(),
      );

    } catch (e) {
      throw RfidFailure(
        'Failed to parse Bambu Lab RFID data: $e'
      );
    }
  }

  /// Parse Block 0: UID and Tag Manufacturer Data
  static String _parseUid(List<int> block0) {
    if (block0.length < 4) return 'UNKNOWN';
    return block0.sublist(0, 4).map((b) => b.toRadixString(16).padLeft(2, '0')).join().toUpperCase();
  }

  /// Parse Block 1: Tray Info Index
  static ({String? variantId, String? materialId}) _parseBlock1(List<int> block1) {
    if (block1.length < 16) return (variantId: null, materialId: null);
    
    // First 8 bytes: Material Variant ID
    final variantBytes = block1.sublist(0, 8).where((b) => b != 0).toList();
    final variantId = variantBytes.isNotEmpty ? String.fromCharCodes(variantBytes).trim() : null;
    
    // Last 8 bytes: Material ID
    final materialBytes = block1.sublist(8, 16).where((b) => b != 0).toList();
    final materialId = materialBytes.isNotEmpty ? String.fromCharCodes(materialBytes).trim() : null;
    
    return (variantId: variantId, materialId: materialId);
  }

  /// Parse Block 5: Color, Spool Weight, Filament Diameter
  static ({SpoolColor? color, double? spoolWeight, double? filamentDiameter}) _parseBlock5(List<int> block5) {
    if (block5.length < 16) return (color: null, spoolWeight: null, filamentDiameter: null);

    // Bytes 0-3: RGBA Color
    SpoolColor? color;
    if (block5.sublist(0, 4).any((b) => b != 0)) {
      color = SpoolColor.rgb(
        'RFID Color',
        block5[0], // R
        block5[1], // G  
        block5[2], // B
        // Note: block5[3] is Alpha, not handled by SpoolColor.rgb()
      );
    }

    // Bytes 4-5: Spool Weight (little-endian uint16)
    final spoolWeight = _readUint16LE(block5, 4).toDouble();

    // Bytes 8-11: Filament Diameter (little-endian float32)
    final filamentDiameter = _readFloat32LE(block5, 8);

    return (
      color: color,
      spoolWeight: spoolWeight > 0 ? spoolWeight : null,
      filamentDiameter: filamentDiameter > 0 ? filamentDiameter : null,
    );
  }

  /// Parse Block 6: Temperature Profile
  static TemperatureProfile? _parseBlock6(List<int> block6) {
    if (block6.length < 12) return null;

    final dryingTemp = _readUint16LE(block6, 0);
    final dryingTime = _readUint16LE(block6, 2);
    final bedTempType = _readUint16LE(block6, 4);
    final bedTemp = _readUint16LE(block6, 6);
    final maxHotendTemp = _readUint16LE(block6, 8);
    final minHotendTemp = _readUint16LE(block6, 10);

    return TemperatureProfile(
      dryingTemperature: dryingTemp > 0 ? dryingTemp : null,
      dryingTimeHours: dryingTime > 0 ? dryingTime : null,
      bedTemperature: bedTemp > 0 ? bedTemp : null,
      minHotendTemperature: minHotendTemp > 0 ? minHotendTemp : null,
      maxHotendTemperature: maxHotendTemp > 0 ? maxHotendTemp : null,
      bedTemperatureType: bedTempType,
    );
  }

  /// Parse Block 8: X Cam Info + Nozzle Diameter
  static ({List<int>? xCamInfo, double? nozzleDiameter}) _parseBlock8(List<int> block8) {
    if (block8.length < 16) return (xCamInfo: null, nozzleDiameter: null);

    // Bytes 0-11: X Cam Info
    final xCamInfo = block8.sublist(0, 12);

    // Bytes 12-15: Nozzle Diameter (little-endian float32)
    final nozzleDiameter = _readFloat32LE(block8, 12);

    return (
      xCamInfo: xCamInfo.any((b) => b != 0) ? xCamInfo : null,
      nozzleDiameter: nozzleDiameter > 0 ? nozzleDiameter : null,
    );
  }

  /// Parse Block 10: Spool Width
  static double? _parseBlock10(List<int> block10) {
    if (block10.length < 6) return null;
    
    // Bytes 4-5: Spool Width in mm*100 (little-endian uint16)
    final widthRaw = _readUint16LE(block10, 4);
    return widthRaw > 0 ? widthRaw / 100.0 : null;
  }

  /// Parse Block 12: Production Date/Time  
  static DateTime? _parseBlock12(List<int> block12) {
    final dateString = _parseStringFromBlock(block12);
    if (dateString == null) return null;

    try {
      // Format: "YYYY_MM_DD_HH_MM" (ASCII)
      final parts = dateString.split('_');
      if (parts.length >= 5) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final day = int.parse(parts[2]);
        final hour = int.parse(parts[3]);
        final minute = int.parse(parts[4]);
        
        return DateTime(year, month, day, hour, minute);
      }
    } catch (e) {
      // Failed to parse date
    }
    return null;
  }

  /// Parse Block 14: Filament Length
  static FilamentLength? _parseBlock14(List<int> block14) {
    if (block14.length < 6) return null;
    
    // Bytes 4-5: Length in meters (little-endian uint16)
    final lengthMeters = _readUint16LE(block14, 4);
    return lengthMeters > 0 ? FilamentLength.meters(lengthMeters.toDouble()) : null;
  }

  /// Parse Block 16: Extra Color Info
  static ({int colorCount, SpoolColor? secondColor})? _parseBlock16(List<int> block16) {
    if (block16.length < 8) return null;

    // Bytes 0-1: Format Identifier (little-endian uint16)
    final formatId = _readUint16LE(block16, 0);
    if (formatId != 0x0002) return null; // Only process if format ID indicates color info

    // Bytes 2-3: Color Count (little-endian uint16)
    final colorCount = _readUint16LE(block16, 2);

    // Bytes 4-7: Second color in reverse ABGR format
    SpoolColor? secondColor;
    if (colorCount > 1 && block16.sublist(4, 8).any((b) => b != 0)) {
      // ABGR format - reverse byte order
      final b = block16[6];
      final g = block16[5];
      final r = block16[4];
      
      secondColor = SpoolColor.rgb('RFID Second Color', r, g, b);
    }

    return (colorCount: colorCount, secondColor: secondColor);
  }

  /// Parse RSA Signature from blocks 40-63
  static List<int>? _parseRsaSignature(List<List<int>> blocks) {
    final signatureBytes = <int>[];
    
    for (int i = 40; i <= 63; i++) {
      if (i < blocks.length) {
        signatureBytes.addAll(blocks[i]);
      }
    }

    return signatureBytes.any((b) => b != 0) ? signatureBytes : null;
  }

  /// Combine production info from multiple blocks
  static ProductionInfo? _combineProductionInfo(
    ({String? variantId, String? materialId}) block1Info,
    DateTime? productionDate,
    String? shortProductionDate,
  ) {
    if (block1Info.variantId == null && 
        block1Info.materialId == null && 
        productionDate == null && 
        shortProductionDate == null) {
      return null;
    }

    return ProductionInfo(
      materialId: block1Info.materialId,
      trayInfoIndex: block1Info.variantId,
      productionDateTime: productionDate,
      batchId: shortProductionDate,
    );
  }

  /// Combine multiple colors for dual-color spools
  static SpoolColor? _combineColors(SpoolColor? primary, SpoolColor? secondary) {
    if (primary == null) return secondary;
    if (secondary == null) return primary;
    
    final primaryRgb = primary.rgbValues;
    final secondaryRgb = secondary.rgbValues;
    
    if (primaryRgb != null && secondaryRgb != null) {
      // Average the RGB values
      final avgRed = ((primaryRgb[0] + secondaryRgb[0]) / 2).round();
      final avgGreen = ((primaryRgb[1] + secondaryRgb[1]) / 2).round();
      final avgBlue = ((primaryRgb[2] + secondaryRgb[2]) / 2).round();
      
      return SpoolColor.rgb(
        '${primary.name} / ${secondary.name}',
        avgRed,
        avgGreen,
        avgBlue,
      );
    }
    
    // Fallback to name combination
    return SpoolColor.named('${primary.name} / ${secondary.name}');
  }

  /// Parse string from block, removing null bytes
  static String? _parseStringFromBlock(List<int> block) {
    final validBytes = block.where((b) => b != 0).toList();
    if (validBytes.isEmpty) return null;
    
    try {
      return utf8.decode(validBytes).trim();
    } catch (e) {
      // Fallback to ASCII if UTF-8 fails
      return String.fromCharCodes(validBytes).trim();
    }
  }

  /// Check if block is completely blank (all zeros)
  static bool _isBlockBlank(List<int> block) {
    return block.every((b) => b == 0);
  }

  /// Read little-endian uint16 from bytes
  static int _readUint16LE(List<int> data, int offset) {
    if (offset + 1 >= data.length) return 0;
    return data[offset] | (data[offset + 1] << 8);
  }

  /// Read little-endian float32 from bytes (IEEE 754)
  static double _readFloat32LE(List<int> data, int offset) {
    if (offset + 3 >= data.length) return 0.0;
    
    final bytes = Uint8List(4);
    bytes[0] = data[offset];
    bytes[1] = data[offset + 1];
    bytes[2] = data[offset + 2];
    bytes[3] = data[offset + 3];
    
    final byteData = ByteData.view(bytes.buffer);
    return byteData.getFloat32(0, Endian.little);
  }

  /// Convert hex string to bytes
  static List<int> _hexToBytes(String hex) {
    final cleanHex = hex.replaceAll(RegExp(r'[^0-9A-Fa-f]'), '');
    final bytes = <int>[];
    
    for (int i = 0; i < cleanHex.length; i += 2) {
      if (i + 1 < cleanHex.length) {
        bytes.add(int.parse(cleanHex.substring(i, i + 2), radix: 16));
      }
    }
    
    return bytes;
  }
}
