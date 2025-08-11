import 'dart:convert';
import 'dart:typed_data';

import '../value_objects/rfid_data.dart';
import '../value_objects/spool_color.dart';
import '../value_objects/temperature_profile.dart';
import '../value_objects/production_info.dart';
import '../value_objects/filament_length.dart';
import 'bambu_lab_rfid_parser.dart';

/// Parser for Bambu Lab NDEF payloads.
/// Attempts multiple formats:
/// - Raw MIFARE 1K dump (1024 bytes) -> forwarded to BambuLabRfidParser
/// - JSON payload with known fields
/// - Simple colon-separated format: material:color:remaining_length
class BambuNdefParser {
  static RfidData parsePayload(Uint8List payload, {String? uidHint}) {
    // 1) Raw 1024-byte dump
    if (payload.length == BambuLabRfidParser.totalBytes) {
      return BambuLabRfidParser.parseFromBytes(payload);
    }

    // Convert to string for heuristic parsing
    final asString = _safeDecode(payload);

    // 2) Try JSON
    final jsonResult = _tryParseJson(asString);
    if (jsonResult != null) {
      return _rfidFromJson(jsonResult, uidHint: uidHint);
    }

    // 3) Try colon-separated minimal format
    final colon = _tryParseColonSeparated(asString);
    if (colon != null) {
      return _rfidFromColon(colon, uidHint: uidHint);
    }

    // 4) Fallback minimal mapping
    return RfidData(
      uid: uidHint ?? 'UNKNOWN',
      filamentType: _extractMaterial(asString),
      detailedFilamentType: null,
      color: null,
      filamentLength: null,
      temperatureProfile: null,
      productionInfo: null,
      scanTime: DateTime.now(),
    );
  }

  static String _safeDecode(Uint8List bytes) {
    try {
      return utf8.decode(bytes).trim();
    } catch (_) {
      return String.fromCharCodes(bytes).trim();
    }
  }

  static Map<String, dynamic>? _tryParseJson(String s) {
    final trimmed = s.trim();
    if (!(trimmed.startsWith('{') && trimmed.endsWith('}'))) return null;
    try {
      final obj = json.decode(trimmed);
      if (obj is Map<String, dynamic>) return obj;
    } catch (_) {}
    return null;
  }

  static RfidData _rfidFromJson(Map<String, dynamic> j, {String? uidHint}) {
    // Common keys we expect
    final material = (j['material'] ?? j['filament'] ?? j['type'])?.toString();
    final detailed = j['variant']?.toString() ?? j['detailedType']?.toString();
    final colorName = j['color']?.toString();
    final colorHex = j['color_hex']?.toString();
    final lengthMeters = _toDouble(j['length_m'] ?? j['remaining_length_m'] ?? j['length']);
    final weight = _toDouble(j['weight_g'] ?? j['spool_weight_g']);
    final diameter = _toDouble(j['diameter_mm'] ?? j['filament_diameter_mm']);

    SpoolColor? color;
    if (colorHex is String && colorHex.isNotEmpty) {
      color = SpoolColor.hex('RFID Color', colorHex);
    } else if (colorName is String && colorName.isNotEmpty) {
      color = SpoolColor.named(colorName);
    }

    TemperatureProfile? temp;
    if (j.containsKey('temp')) {
      final t = j['temp'];
      if (t is Map) {
        temp = TemperatureProfile(
          dryingTemperature: _toInt(t['drying_c']),
          dryingTimeHours: _toInt(t['drying_h']),
          bedTemperature: _toInt(t['bed_c']),
          minHotendTemperature: _toInt(t['min_nozzle_c']),
          maxHotendTemperature: _toInt(t['max_nozzle_c']),
          bedTemperatureType: _toInt(t['bed_type']) ?? 0,
        );
      }
    }

    ProductionInfo? prod;
    if (j.containsKey('production')) {
      final p = j['production'];
      if (p is Map) {
        prod = ProductionInfo(
          materialId: p['material_id']?.toString(),
          trayInfoIndex: p['variant_id']?.toString(),
          productionDateTime: null,
          batchId: p['batch']?.toString(),
        );
      }
    }

    return RfidData(
      uid: j['uid']?.toString() ?? uidHint ?? 'UNKNOWN',
      filamentType: material,
      detailedFilamentType: detailed,
      color: color,
      filamentLength: lengthMeters != null ? FilamentLength.meters(lengthMeters) : null,
      spoolWeight: weight,
      filamentDiameter: diameter,
      temperatureProfile: temp,
      productionInfo: prod,
      scanTime: DateTime.now(),
    );
  }

  static ({String material, String color, double length})? _tryParseColonSeparated(String s) {
    final parts = s.split(':');
    if (parts.length < 3) return null;
    final material = parts[0].trim();
    final color = parts[1].trim();
    final length = double.tryParse(parts[2].trim()) ?? 0.0;
    return (material: material, color: color, length: length);
  }

  static RfidData _rfidFromColon(({String material, String color, double length}) data, {String? uidHint}) {
    return RfidData(
      uid: uidHint ?? 'UNKNOWN',
      filamentType: data.material,
      detailedFilamentType: null,
      color: SpoolColor.named(data.color),
      filamentLength: FilamentLength.meters(data.length),
      scanTime: DateTime.now(),
    );
  }

  static String? _extractMaterial(String s) {
    final m = RegExp(r'(PLA\+?|PETG|ABS|ASA|TPU)', caseSensitive: false).firstMatch(s);
    return m?.group(0)?.toUpperCase();
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
    
  }
  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }
}
