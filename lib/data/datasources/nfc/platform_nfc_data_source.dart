import 'dart:async';

import 'package:nfc_manager/nfc_manager.dart';

import '../../../core/errors/failures.dart';
import '../../../domain/entities/nfc_scan_result.dart';
import '../../../domain/value_objects/rfid_data.dart';
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
      // Create a simplified RFID data structure using available tag information
      final uid = await _extractUid(tag);
      
      // For now, create a basic RFID data structure
      // In production, this would implement the full Bambu Lab RFID parsing
      return RfidData(
        uid: uid,
        scanTime: DateTime.now(),
        filamentType: 'PLA', // Default, would be parsed from actual data
        detailedFilamentType: 'PLA Basic', // Default, would be parsed from actual data
        // Other fields can be added as the parsing logic is implemented
      );
      
    } catch (e) {
      // Error reading RFID data
      return null;
    }
  }

  Future<String> _extractUid(NfcTag tag) async {
    try {
      String uid = '';
      
      // Debug: Log the tag structure to understand what's available
      final tagStr = tag.toString();
      print('=== DEBUG: NFC Tag Structure ===');
      print('Tag toString(): $tagStr');
      print('Tag runtime type: ${tag.runtimeType}');
      print('=====================================');
      
      // Method 1: Look for identifier pattern in the tag string representation
      final identifierRegex = RegExp(r'identifier:\s*\[([^\]]+)\]', caseSensitive: false);
      final match = identifierRegex.firstMatch(tagStr);
      
      if (match != null) {
        final identifierStr = match.group(1)!;
        print('DEBUG: Found identifier string: $identifierStr');
        // Parse the identifier bytes and format as hex
        final bytes = identifierStr.split(',').map((s) => int.tryParse(s.trim()) ?? 0).toList();
        uid = bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(':').toUpperCase();
        print('DEBUG: UID from identifier: $uid');
        return uid;
      } else {
        print('DEBUG: No identifier pattern found in tag string');
      }
      
      // Method 2: Try to find hex patterns that could be UIDs
      final hexPatterns = [
        RegExp(r'([0-9a-fA-F]{2}[:\s,]){3,7}[0-9a-fA-F]{2}'), // Standard hex with separators
        RegExp(r'[0-9a-fA-F]{6,16}'), // Continuous hex string
        RegExp(r'uid[:\s]*([0-9a-fA-F\s:,]+)', caseSensitive: false), // UID field
      ];
      
      for (final pattern in hexPatterns) {
        final hexMatch = pattern.firstMatch(tagStr);
        if (hexMatch != null) {
          String hexStr = hexMatch.group(1) ?? hexMatch.group(0)!;
          print('DEBUG: Found hex pattern: $hexStr');
          
          // Clean up and format
          hexStr = hexStr.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');
          if (hexStr.length >= 6 && hexStr.length <= 20) {
            // Format as standard UID
            final pairs = <String>[];
            for (int i = 0; i < hexStr.length && pairs.length < 10; i += 2) {
              if (i + 1 < hexStr.length) {
                pairs.add(hexStr.substring(i, i + 2));
              }
            }
            uid = pairs.join(':').toUpperCase();
            print('DEBUG: UID from hex pattern: $uid');
            return uid;
          }
        }
      }
      
      // Method 3: Create a deterministic UID based on the full tag string
      // This should be consistent for the same tag but different for different tags
      final tagHash = tagStr.hashCode.abs();
      final tagLength = tagStr.length;
      final combinedHash = (tagHash * 31 + tagLength * 17).abs();
      uid = 'TAG_${combinedHash.toRadixString(16).toUpperCase().padLeft(8, '0')}';
      print('DEBUG: Using fallback UID from tag hash: $uid (hash: $tagHash, length: $tagLength)');
      
      return uid;
      
    } catch (e) {
      print('DEBUG: Error in _extractUid: $e');
      // Error extracting UID - create a fallback
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return 'ERROR_${timestamp.toRadixString(16).toUpperCase()}';
    }
  }

  @override
  void dispose() {
    stopScanning();
    _scanController.close();
  }
}
