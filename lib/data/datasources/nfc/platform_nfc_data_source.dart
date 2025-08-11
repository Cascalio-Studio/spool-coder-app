import 'dart:async';

import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager_ndef/nfc_manager_ndef.dart';

import '../../../core/errors/failures.dart';
import '../../../domain/entities/nfc_scan_result.dart';
import '../../../domain/value_objects/rfid_data.dart';
import '../../../domain/parsers/bambu_ndef_parser.dart';
import 'nfc_data_source.dart';

/// Platform-specific NFC data source implementation using nfc_manager
/// Optimized for Samsung Galaxy S20 Ultra and Bambu Lab RFID tags
class PlatformNfcDataSource implements NfcDataSource {
  final StreamController<NfcScanResult> _scanController = StreamController.broadcast();
  bool _isScanning = false;
  Timer? _timeoutTimer;

  @override
  Stream<NfcScanResult> get scanResults => _scanController.stream;

  @override
  Future<bool> isNfcAvailable() async {
    try {
      return await NfcManager.instance.isAvailable();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isNfcEnabled() async {
    // For simplicity, we assume NFC is enabled if it's available
    // In production, you could add more sophisticated checking
    return await isNfcAvailable();
  }

  @override
  Future<void> startScanning({Duration? timeout}) async {
    if (_isScanning) {
      throw const NfcFailure('NFC scanning is already in progress');
    }

    try {
      final isAvailable = await isNfcAvailable();
      if (!isAvailable) {
        throw const NfcFailure('NFC is not available on this device');
      }

      _isScanning = true;
      _scanController.add(const NfcScanResult.scanning());

      // Set up timeout if specified
      if (timeout != null) {
        _timeoutTimer = Timer(timeout, () {
          if (_isScanning) {
            stopScanning();
            _scanController.add(const NfcScanResult.error('Scan timeout'));
          }
        });
      }

      // Start NFC session with polling options optimized for RFID tags
      await NfcManager.instance.startSession(
        onDiscovered: _handleTagDiscovered,
        pollingOptions: {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
          NfcPollingOption.iso18092,
        },
      );

    } catch (e) {
      _isScanning = false;
      _timeoutTimer?.cancel();
      
      if (e is NfcFailure) {
        _scanController.add(NfcScanResult.error(e.message));
      } else {
        _scanController.add(NfcScanResult.error('Failed to start NFC scanning: $e'));
      }
    }
  }

  @override
  Future<void> stopScanning() async {
    if (!_isScanning) return;

    _isScanning = false;
    _timeoutTimer?.cancel();
    _timeoutTimer = null;

    try {
      await NfcManager.instance.stopSession();
    } catch (e) {
      // Log error but don't throw as we're stopping anyway
      // Error stopping NFC session
    }
  }

  Future<void> _handleTagDiscovered(NfcTag tag) async {
    try {
      _scanController.add(const NfcScanResult.reading());
      
      // Read tag data using a simplified approach
      final rfidData = await _readRfidData(tag);
      
      if (rfidData != null) {
        _scanController.add(NfcScanResult.success(rfidData));
      } else {
        _scanController.add(const NfcScanResult.error('Could not read RFID data from tag'));
      }

      // Stop scanning after successful read
      await stopScanning();

    } catch (e) {
      _scanController.add(NfcScanResult.error('Error reading tag: $e'));
      await stopScanning();
    }
  }

  Future<RfidData?> _readRfidData(NfcTag tag) async {
    try {
      // Try NDEF first (Bambu Lab writes NDEF MIME record)
      final ndef = Ndef.from(tag);
      if (ndef != null) {
        final message = await ndef.read();
        if (message != null && message.records.isNotEmpty) {
          for (final record in message.records) {
            // Decode type (may be MIME like 'application/bambulab')
            final typeStr = record.type.isNotEmpty
                ? String.fromCharCodes(record.type)
                : '';

            // Prefer explicit Bambu MIME types when present
            if (typeStr == 'application/bambulab' || typeStr == 'application/x-bambu' || typeStr.contains('bambu')) {
              final uid = await _extractUid(tag);
              final parsed = BambuNdefParser.parsePayload(record.payload, uidHint: uid);
              return parsed;
            }

            // Otherwise, try to parse heuristically from payload
            if (record.payload.isNotEmpty) {
              final uid = await _extractUid(tag);
              final parsed = BambuNdefParser.parsePayload(record.payload, uidHint: uid);
              return parsed;
            }
          }
        }
      }

      // As a fallback, build minimal RfidData with UID only
      final uid = await _extractUid(tag);
      return RfidData(
        uid: uid,
        scanTime: DateTime.now(),
      );
      
    } catch (e) {
      // Error reading RFID data
      return null;
    }
  }

  Future<String> _extractUid(NfcTag tag) async {
    try {
      // If possible, derive a stable UID from NDEF content (type + payload)
      final ndef = Ndef.from(tag);
      if (ndef != null) {
        final msg = await ndef.read();
        if (msg != null && msg.records.isNotEmpty) {
          final bytes = <int>[];
          for (final r in msg.records) {
            if (r.type.isNotEmpty) bytes.addAll(r.type);
            if (r.payload.isNotEmpty) bytes.addAll(r.payload);
          }
          if (bytes.isNotEmpty) {
            final fp = _fnv1a64(bytes);
            return fp;
          }
        }
      }

      // If identifier is not accessible, generate deterministic hash of tag string
      final tagStr = tag.toString();
      final tagHash = tagStr.hashCode.abs();
      return 'TAG_${tagHash.toRadixString(16).toUpperCase().padLeft(8, '0')}';
      
    } catch (e) {
  // Fallback on errors
  final tagStr = tag.toString();
  final tagHash = tagStr.hashCode.abs();
  return 'TAG_${tagHash.toRadixString(16).toUpperCase().padLeft(8, '0')}';
    }
  }

  // 64-bit FNV-1a hash, returned as 16-char upper hex
  String _fnv1a64(List<int> data) {
    // 64-bit constants
    const int fnv64Prime = 0x00000100000001B3; // 1099511628211
    const int fnv64Offset = 0xcbf29ce484222325; // 14695981039346656037
    int hash = fnv64Offset;
    for (final b in data) {
      hash ^= (b & 0xff);
      // 64-bit multiply with wrap-around
      hash = (hash * fnv64Prime) & 0xFFFFFFFFFFFFFFFF;
    }
    final hex = hash.toRadixString(16).toUpperCase().padLeft(16, '0');
    return hex;
  }

  @override
  void dispose() {
    stopScanning();
    _scanController.close();
  }
}
