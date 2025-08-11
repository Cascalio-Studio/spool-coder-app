// BACKUP FILE - COMMENTED OUT TO PREVENT COMPILATION ERRORS
// This file contains an old implementation that's incompatible with current APIs
// The active implementation is in lib/data/datasources/nfc/platform_nfc_data_source.dart

/*
import 'dart:async';
import 'dart:typed_data';
import 'package:nfc_manager/nfc_manager.dart';
import '../../domain/entities/spool.dart';
import '../../domain/value_objects/spool_uid.dart';
import '../../domain/value_objects/material_type.dart';
import '../../domain/value_objects/spool_color.dart';
import '../../domain/value_objects/filament_length.dart';
import 'nfc_data_source.dart';

/// Platform-specific NFC data source implementation using nfc_manager
/// Part of the Data Layer: handles real NFC hardware operations
class PlatformNfcDataSource implements NfcDataSource {
  static const int _timeoutDuration = 30; // seconds
  
  @override
  Future<void> initialize() async {
    // NFC Manager handles initialization automatically
    // This method is kept for interface compliance
  }
  
  @override
  Future<bool> isNfcAvailable() async {
    return await NfcManager.instance.isAvailable();
  }
  
  @override
  Future<Spool> scanSpool() async {
    final completer = Completer<Spool>();
    
    try {
      // Check if NFC is available
      final isAvailable = await isNfcAvailable();
      if (!isAvailable) {
        throw Exception('NFC is not available on this device');
      }
      
      // Start NFC session with default polling options
      await NfcManager.instance.startSession(
        pollingOptions: const {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
        },
        onDiscovered: (NfcTag tag) async {
          try {
            final spoolData = await _readSpoolFromTag(tag);
            completer.complete(spoolData);
          } catch (e) {
            completer.completeError(e);
          } finally {
            // Stop the session after reading
            await NfcManager.instance.stopSession();
          }
        },
      );
      
      // Wait for the result with timeout
      return await completer.future.timeout(
        Duration(seconds: _timeoutDuration),
        onTimeout: () {
          NfcManager.instance.stopSession();
          throw TimeoutException('NFC scan timeout', Duration(seconds: _timeoutDuration));
        },
      );
    } catch (e) {
      await NfcManager.instance.stopSession();
      rethrow;
    }
  }
  
  @override
  Future<void> writeSpool(Spool spool) async {
    final completer = Completer<void>();
    
    try {
      // Check if NFC is available
      final isAvailable = await isNfcAvailable();
      if (!isAvailable) {
        throw Exception('NFC is not available on this device');
      }
      
      // Start NFC session for writing with default polling options
      await NfcManager.instance.startSession(
        pollingOptions: const {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
        },
        onDiscovered: (NfcTag tag) async {
          try {
            await _writeSpoolToTag(tag, spool);
            completer.complete();
          } catch (e) {
            completer.completeError(e);
          } finally {
            // Stop the session after writing
            await NfcManager.instance.stopSession();
          }
        },
      );
      
      // Wait for the result with timeout
      return await completer.future.timeout(
        Duration(seconds: _timeoutDuration),
        onTimeout: () {
          NfcManager.instance.stopSession();
          throw TimeoutException('NFC write timeout', Duration(seconds: _timeoutDuration));
        },
      );
    } catch (e) {
      await NfcManager.instance.stopSession();
      rethrow;
    }
  }

  @override
  Future<void> dispose() async {
    await NfcManager.instance.stopSession();
  }
  
  /// Read spool data from an NFC tag
  Future<Spool> _readSpoolFromTag(NfcTag tag) async {
    try {
      // Get NDEF from tag
      final ndef = Ndef.from(tag);
      if (ndef == null) {
        throw Exception('Tag is not NDEF formatted');
      }
      
      // Read NDEF message
      final ndefMessage = await ndef.read();
      if (ndefMessage == null || ndefMessage.records.isEmpty) {
        throw Exception('No NDEF data found on tag');
      }
      
      // Find BambuLab record
      for (final record in ndefMessage.records) {
        if (record.typeNameFormat == NdefTypeNameFormat.media &&
            record.type.isNotEmpty) {
          final mimeType = String.fromCharCodes(record.type);
          if (mimeType == 'application/bambulab') {
            return _parseBambuLabData(record.payload, tag);
          }
        }
      }
      
      throw Exception('No BambuLab spool data found on tag');
    } catch (e) {
      throw Exception('Error reading NFC tag: $e');
    }
  }
  
  /// Parse BambuLab spool data from NDEF payload
  Spool _parseBambuLabData(Uint8List payload, NfcTag tag) {
    try {
      // Convert payload to string for parsing
      final dataString = String.fromCharCodes(payload);
      
      // Parse BambuLab format (simplified parsing)
      // Expected format: "material_type:color:remaining_length"
      final parts = dataString.split(':');
      if (parts.length < 3) {
        throw Exception('Invalid BambuLab data format');
      }
      
      // Extract material type
      final materialTypeStr = parts[0];
      MaterialType materialType;
      try {
        materialType = MaterialType.values.firstWhere(
          (type) => type.name.toLowerCase() == materialTypeStr.toLowerCase(),
        );
      } catch (e) {
        // Default to PLA if unknown
        materialType = MaterialType.pla;
      }
      
      // Extract color
      final colorStr = parts[1];
      SpoolColor color;
      try {
        color = SpoolColor.values.firstWhere(
          (c) => c.name.toLowerCase() == colorStr.toLowerCase(),
        );
      } catch (e) {
        // Default to white if unknown
        color = SpoolColor.white;
      }
      
      // Extract remaining length
      final lengthStr = parts[2];
      final length = double.tryParse(lengthStr) ?? 0.0;
      
      // Generate UID from tag identifier
      final uid = _generateUidFromTag(tag);
      
      return Spool(
        uid: uid,
        materialType: materialType,
        color: color,
        remainingLength: FilamentLength(length),
        manufacturer: 'BambuLab',
        productName: 'RFID Spool',
        weight: 1000.0, // Default weight in grams
        diameter: 1.75, // Default diameter in mm
      );
    } catch (e) {
      throw Exception('Error parsing BambuLab data: $e');
    }
  }
  
  /// Generate UID from NFC tag
  SpoolUid _generateUidFromTag(NfcTag tag) {
    try {
      // Try to get identifier from different tag types
      Uint8List? identifier;
      
      // Check for different NFC technologies
      if (tag.data.containsKey('nfca')) {
        final nfcaData = tag.data['nfca'] as Map<String, dynamic>?;
        identifier = nfcaData?['identifier'] as Uint8List?;
      } else if (tag.data.containsKey('nfcb')) {
        final nfcbData = tag.data['nfcb'] as Map<String, dynamic>?;
        identifier = nfcbData?['identifier'] as Uint8List?;
      } else if (tag.data.containsKey('nfcf')) {
        final nfcfData = tag.data['nfcf'] as Map<String, dynamic>?;
        identifier = nfcfData?['identifier'] as Uint8List?;
      } else if (tag.data.containsKey('nfcv')) {
        final nfcvData = tag.data['nfcv'] as Map<String, dynamic>?;
        identifier = nfcvData?['identifier'] as Uint8List?;
      }
      
      if (identifier != null && identifier.isNotEmpty) {
        // Convert bytes to hex string
        final hexString = identifier.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
        return SpoolUid(hexString);
      } else {
        // Fallback to timestamp-based UID
        return SpoolUid(DateTime.now().millisecondsSinceEpoch.toString());
      }
    } catch (e) {
      // Fallback to timestamp-based UID
      return SpoolUid(DateTime.now().millisecondsSinceEpoch.toString());
    }
  }
  
  /// Write spool data to an NFC tag
  Future<void> _writeSpoolToTag(NfcTag tag, Spool spool) async {
    try {
      // Get NDEF from tag
      final ndef = Ndef.from(tag);
      if (ndef == null) {
        throw Exception('Tag is not NDEF formatted');
      }
      
      // Check if tag is writable
      if (!ndef.isWritable) {
        throw Exception('Tag is not writable');
      }
      
      // Create BambuLab data payload
      final payload = _createBambuLabPayload(spool);
      
      // Create NDEF record
      final record = NdefRecord.createMime('application/bambulab', payload);
      final message = NdefMessage([record]);
      
      // Write to tag
      await ndef.write(message);
    } catch (e) {
      throw Exception('Error writing to NFC tag: $e');
    }
  }
  
  /// Create BambuLab payload from spool data
  Uint8List _createBambuLabPayload(Spool spool) {
    // Create BambuLab format: "material_type:color:remaining_length"
    final dataString = '${spool.materialType.name}:${spool.color.name}:${spool.remainingLength.value}';
    return Uint8List.fromList(dataString.codeUnits);
  }
}
*/
