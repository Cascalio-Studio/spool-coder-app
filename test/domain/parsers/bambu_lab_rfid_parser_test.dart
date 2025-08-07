import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:spool_coder_app/domain/parsers/bambu_lab_rfid_parser.dart';
import 'package:spool_coder_app/core/errors/failures.dart';

void main() {
  group('BambuLabRfidParser Tests', () {
    
    test('should parse valid block dump correctly', () {
      // Sample data based on Bambu Lab RFID format
      final Map<String, String> sampleBlocks = {
        '0': '04A1B2C3DE4F8000E1100600810200F0', // UID + manufacturer data
        '1': '504C41000000000047464E5420000000', // Material variant + ID: "PLA" + "GFNT"
        '2': '504C412D42617369630000000000000', // Filament type: "PLA-Basic"
        '4': '504C412D4261736963205265640000000', // Detailed type: "PLA-Basic Red"
        '5': 'FF0000800A00000041200000000000000', // Red color + 10g weight + 1.75mm diameter
        '6': '28001800000050003200640000000000', // Temps: 40°C dry, 24h, 80°C bed, 190-220°C hotend
        '8': '58436D496E666F000000000000000070', // X-Cam info + 0.4mm nozzle
        '9': '4241540000000000000000000000000', // Tray UID: "BAT"
        '10': 'FFFFFFFFA00F0000FFFFFFFFFFFFFFFFFF', // Spool width: 40mm
        '12': '323032345F30385F31355F31305F3330', // Date: "2024_08_15_10_30"
        '14': 'FFFFFFFFC8000000FFFFFFFFFFFFFFFF', // Length: 200 meters
        '16': '020002000080FF00FFFFFFFFFFFFFFFF', // Multi-color: format 2, 2 colors, blue secondary
      };

      final result = BambuLabRfidParser.parseFromBlockDump(sampleBlocks);

      expect(result.uid, equals('04A1B2C3'));
      expect(result.filamentType, equals('PLA-Basic'));
      expect(result.detailedFilamentType, equals('PLA-Basic Red'));
      expect(result.color?.name, equals('RFID Color'));
      expect(result.spoolWeight, equals(10.0));
      expect(result.filamentDiameter, equals(1.75));
      expect(result.temperatureProfile?.dryingTemperature, equals(40));
      expect(result.temperatureProfile?.dryingTimeHours, equals(24));
      expect(result.temperatureProfile?.bedTemperature, equals(80));
      expect(result.temperatureProfile?.minHotendTemperature, equals(190));
      expect(result.temperatureProfile?.maxHotendTemperature, equals(220));
      expect(result.nozzleDiameter, equals(0.4));
      expect(result.trayUid, equals('BAT'));
      expect(result.spoolWidth, equals(40.0));
      expect(result.productionInfo?.productionDateTime?.year, equals(2024));
      expect(result.productionInfo?.productionDateTime?.month, equals(8));
      expect(result.productionInfo?.productionDateTime?.day, equals(15));
      expect(result.filamentLength?.meters, equals(200.0));
    });

    test('should handle empty/invalid blocks gracefully', () {
      final Map<String, String> emptyBlocks = {
        '0': '00000000000000000000000000000000',
        '1': '00000000000000000000000000000000',
      };

      final result = BambuLabRfidParser.parseFromBlockDump(emptyBlocks);

      expect(result.uid, equals('00000000'));
      expect(result.filamentType, isNull);
      expect(result.color, isNull);
      expect(result.temperatureProfile, isNull);
    });

    test('should parse from raw bytes correctly', () {
      // Create a 1024-byte array with sample data
      final bytes = Uint8List(1024);
      
      // Block 0: UID
      bytes[0] = 0x04;
      bytes[1] = 0xA1;
      bytes[2] = 0xB2;
      bytes[3] = 0xC3;
      
      // Block 2 (offset 32): Filament type "PLA"
      bytes[32] = 0x50; // P
      bytes[33] = 0x4C; // L
      bytes[34] = 0x41; // A

      final result = BambuLabRfidParser.parseFromBytes(bytes);

      expect(result.uid, equals('04A1B2C3'));
      expect(result.filamentType, equals('PLA'));
    });

    test('should throw RfidFailure for invalid byte length', () {
      final invalidBytes = Uint8List(100); // Wrong length

      expect(
        () => BambuLabRfidParser.parseFromBytes(invalidBytes),
        throwsA(isA<RfidFailure>()),
      );
    });

    test('should parse Flipper Zero dump format', () {
      const flipperDump = '''
Filetype: Flipper NFC device
Version: 4
Device type: NTAG213
UID: 04 A1 B2 C3 DE 4F 80
ATQA: 00 44
SAK: 00
Data format version: 2
MIFARE Classic type: 1K
Data:
Block 0: 04 A1 B2 C3 DE 4F 80 00 E1 10 06 00 81 02 00 F0
Block 1: 50 4C 41 00 00 00 00 00 47 46 4E 54 20 00 00 00
Block 2: 50 4C 41 2D 42 61 73 69 63 00 00 00 00 00 00 00
''';

      final result = BambuLabRfidParser.parseFromFlipperDump(flipperDump);

      expect(result.uid, equals('04A1B2C3'));
      expect(result.filamentType, equals('PLA-Basic'));
    });

    test('should parse temperature profile correctly', () {
      final Map<String, String> tempBlocks = {
        '0': '04A1B2C3DE4F8000E1100600810200F0',
        '6': '28001800000050003C00DC00000000000', // 40°C, 24h, 80°C bed, 60-220°C hotend
      };

      final result = BambuLabRfidParser.parseFromBlockDump(tempBlocks);

      expect(result.temperatureProfile?.dryingTemperature, equals(40));
      expect(result.temperatureProfile?.dryingTimeHours, equals(24));
      expect(result.temperatureProfile?.bedTemperature, equals(80));
      expect(result.temperatureProfile?.minHotendTemperature, equals(60));
      expect(result.temperatureProfile?.maxHotendTemperature, equals(220));
    });

    test('should parse multi-color spools correctly', () {
      final Map<String, String> colorBlocks = {
        '0': '04A1B2C3DE4F8000E1100600810200F0',
        '5': 'FF000080000000000000000000000000', // Red primary color
        '16': '020002000080FF00FFFFFFFFFFFFFFFF', // Blue secondary color
      };

      final result = BambuLabRfidParser.parseFromBlockDump(colorBlocks);

      expect(result.color?.name, contains('/'));
      expect(result.color?.name, contains('RFID Color'));
      expect(result.color?.name, contains('RFID Second Color'));
    });

    test('should parse production date correctly', () {
      final Map<String, String> dateBlocks = {
        '0': '04A1B2C3DE4F8000E1100600810200F0',
        '12': '323032345F30385F31355F31305F3330', // "2024_08_15_10_30"
      };

      final result = BambuLabRfidParser.parseFromBlockDump(dateBlocks);

      expect(result.productionInfo?.productionDateTime?.year, equals(2024));
      expect(result.productionInfo?.productionDateTime?.month, equals(8));
      expect(result.productionInfo?.productionDateTime?.day, equals(15));
      expect(result.productionInfo?.productionDateTime?.hour, equals(10));
      expect(result.productionInfo?.productionDateTime?.minute, equals(30));
    });

    test('should handle hex string conversion correctly', () {
      final Map<String, String> hexBlocks = {
        '0': '04 A1 B2 C3 DE 4F 80 00 E1 10 06 00 81 02 00 F0', // With spaces
        '2': '504c412d4261736963000000000000000', // Lowercase hex
      };

      final result = BambuLabRfidParser.parseFromBlockDump(hexBlocks);

      expect(result.uid, equals('04A1B2C3'));
      expect(result.filamentType, equals('PLA-Basic'));
    });

    test('should parse float values correctly', () {
      final Map<String, String> floatBlocks = {
        '0': '04A1B2C3DE4F8000E1100600810200F0',
        '5': '00000000000000000000E03F00000000', // 1.75 as IEEE 754 float
        '8': '58436D496E666F00000000000000CDCC', // 0.4 as IEEE 754 float
      };

      final result = BambuLabRfidParser.parseFromBlockDump(floatBlocks);

      expect(result.filamentDiameter, closeTo(1.75, 0.01));
      expect(result.nozzleDiameter, closeTo(0.4, 0.01));
    });
  });
}
