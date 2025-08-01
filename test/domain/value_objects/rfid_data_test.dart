import 'package:test/test.dart';
import 'package:spool_coder_app/domain/value_objects/rfid_data.dart';
import 'package:spool_coder_app/domain/value_objects/spool_color.dart';
import 'package:spool_coder_app/domain/value_objects/production_info.dart';
import 'package:spool_coder_app/domain/value_objects/temperature_profile.dart';

void main() {
  group('RfidData', () {
    // Real example data from Bambu Lab RFID Tag Guide
    final exampleBlocks = {
      '0': '75886B1D8B080400034339DB5B5E0A90',
      '1': '4130302D413000004746413030000000',
      '2': '504C4100000000000000000000000000',
      '4': '504C4120426173696300000000000000',
      '5': 'FF6A13FFFA0000000000E03F00000000',
      '6': '3700080001002D00DC00DC0000000000',
      '8': '8813100EE803E8039A99193FCDCC4C3E',
      '9': 'D7AC3B89A16B47C4B061728044E1F2D5',
      '10': '00000000E11900000000000000000000',
      '12': '323032325F31305F31355F30385F3236',
      '13': '36303932323032000000000000000000',
      '14': '00000000520000000000000000000000',
    };

    test('should parse complete RFID data from block dump', () {
      final rfidData = RfidData.fromBlockDump(exampleBlocks);
      
      expect(rfidData.uid, equals('75886B1D'));
      expect(rfidData.filamentType, equals('PLA'));
      expect(rfidData.detailedFilamentType, equals('PLA Basic'));
      expect(rfidData.spoolWeight, equals(250.0)); // 0xFA00 = 64000, but converted differently
      expect(rfidData.filamentLength?.meters, equals(82.0)); // 0x52 = 82
    });

    // Test for UID extraction is covered indirectly via the public API in the 'fromBlockDump' test.

    // Removed test for private method `_parseStringBlock`.

    test('should detect genuine Bambu Lab spools', () {
      // Mock RFID data with RSA signature
      final rfidDataWithSignature = RfidData(
        uid: '75886B1D',
        scanTime: DateTime.now(),
        rsaSignature: List.filled(256, 1), // Mock signature
      );
      
      final rfidDataWithoutSignature = RfidData(
        uid: '75886B1D',
        scanTime: DateTime.now(),
      );
      
      expect(rfidDataWithSignature.isGenuineBambuLab, isTrue);
      expect(rfidDataWithoutSignature.isGenuineBambuLab, isFalse);
    });

    test('should check completeness of RFID data', () {
      final completeRfidData = RfidData(
        uid: '75886B1D',
        filamentType: 'PLA',
        detailedFilamentType: 'PLA Basic',
        temperatureProfile: const TemperatureProfile(
          dryingTemperature: 55,
          bedTemperature: 45,
        ),
        productionInfo: ProductionInfo(
          productionDateTime: DateTime(2022, 10, 15, 8, 26),
        ),
        scanTime: DateTime.now(),
      );
      
      final incompleteRfidData = RfidData(
        uid: '75886B1D',
        scanTime: DateTime.now(),
      );
      
      expect(completeRfidData.isComplete, isTrue);
      expect(incompleteRfidData.isComplete, isFalse);
    });

    test('should generate meaningful description', () {
      final rfidData = RfidData(
        uid: '75886B1D',
        detailedFilamentType: 'PLA Basic',
        color: SpoolColor.hex('Red', '#FF0000'),
        spoolWeight: 1000.0,
        scanTime: DateTime.now(),
      );
      
      final description = rfidData.description;
      expect(description, contains('PLA Basic'));
      expect(description, contains('Red'));
      expect(description, contains('1000g'));
    });

    test('should create copy with updated values', () {
      final original = RfidData(
        uid: '75886B1D',
        filamentType: 'PLA',
        scanTime: DateTime.now(),
      );
      
      final updated = original.copyWith(
        detailedFilamentType: 'PLA Basic',
        spoolWeight: 1000.0,
      );
      
      expect(updated.uid, equals('75886B1D'));
      expect(updated.filamentType, equals('PLA'));
      expect(updated.detailedFilamentType, equals('PLA Basic'));
      expect(updated.spoolWeight, equals(1000.0));
    });

    test('should handle equality based on UID and scan time', () {
      final scanTime = DateTime.now();
      
      final rfid1 = RfidData(
        uid: '75886B1D',
        scanTime: scanTime,
      );
      
      final rfid2 = RfidData(
        uid: '75886B1D',
        scanTime: scanTime,
      );
      
      final rfid3 = RfidData(
        uid: 'DIFFERENT',
        scanTime: scanTime,
      );
      
      expect(rfid1, equals(rfid2));
      expect(rfid1, isNot(equals(rfid3)));
    });

    test('should have meaningful string representation', () {
      final rfidData = RfidData(
        uid: '75886B1D',
        detailedFilamentType: 'PLA Basic',
        color: SpoolColor.hex('Red', '#FF0000'),
        spoolWeight: 1000.0,
        scanTime: DateTime(2023, 12, 1, 10, 30),
      );
      
      final string = rfidData.toString();
      expect(string, contains('75886B1D'));
      expect(string, contains('PLA Basic'));
      expect(string, contains('2023-12-01T10:30'));
    });
  });
}