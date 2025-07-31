import 'package:flutter_test/flutter_test.dart';
import 'package:spool_coder_app/domain/domain.dart';

void main() {
  group('Domain Layer Tests', () {
    group('Value Objects', () {
      test('SpoolUid should validate correctly', () {
        // Valid UID
        final validUid = SpoolUid('BAMBU_PLA_RED_001');
        expect(validUid.value, 'BAMBU_PLA_RED_001');

        // Invalid UID should throw
        expect(() => SpoolUid(''), throwsA(isA<ArgumentError>()));
        expect(() => SpoolUid('ab'), throwsA(isA<ArgumentError>()));
      });

      test('MaterialType should work correctly', () {
        // Predefined materials
        expect(MaterialType.pla.value, 'PLA');
        expect(MaterialType.pla.displayName, 'PLA (Polylactic Acid)');
        expect(MaterialType.pla.printTemperature, 200);

        // Custom material
        final custom = MaterialType.custom(
          value: 'WOOD',
          displayName: 'Wood Filled PLA',
          printTemperature: 190,
        );
        expect(custom.value, 'WOOD');
        expect(custom.displayName, 'Wood Filled PLA');
      });

      test('SpoolColor should handle different formats', () {
        // Named color
        final namedColor = SpoolColor.named('Red');
        expect(namedColor.name, 'Red');
        expect(namedColor.hasColorData, false);

        // Hex color
        final hexColor = SpoolColor.hex('Red', '#FF0000');
        expect(hexColor.name, 'Red');
        expect(hexColor.hexCode, '#FF0000');
        expect(hexColor.hasColorData, true);

        // RGB color
        final rgbColor = SpoolColor.rgb('Red', 255, 0, 0);
        expect(rgbColor.name, 'Red');
        expect(rgbColor.hexCode, '#FF0000');
        expect(rgbColor.rgbValues, [255, 0, 0]);
      });

      test('FilamentLength should handle conversions', () {
        final length = FilamentLength.meters(1.0);
        expect(length.meters, 1.0);
        expect(length.millimeters, 1000.0);
        expect(length.toString(), '1.00m');

        // Operations
        final doubled = length * 2;
        expect(doubled.meters, 2.0);

        final sum = length + FilamentLength.meters(0.5);
        expect(sum.meters, 1.5);
      });
    });

    group('Entities', () {
      test('Spool should calculate usage correctly', () {
        final spool = Spool(
          uid: SpoolUid('TEST_001'),
          materialType: MaterialType.pla,
          manufacturer: 'TestBrand',
          color: SpoolColor.named('Red'),
          netLength: FilamentLength.meters(1000.0),
          remainingLength: FilamentLength.meters(750.0),
          createdAt: DateTime.now(),
        );

        expect(spool.usagePercentage, 25.0);
        expect(spool.isNearlyEmpty, false);
        expect(spool.usedLength.meters, 250.0);
      });

      test('Spool should detect nearly empty state', () {
        final nearlyEmpty = Spool(
          uid: SpoolUid('TEST_002'),
          materialType: MaterialType.pla,
          manufacturer: 'TestBrand',
          color: SpoolColor.named('Red'),
          netLength: FilamentLength.meters(1000.0),
          remainingLength: FilamentLength.meters(50.0), // 5% remaining
          createdAt: DateTime.now(),
        );

        expect(nearlyEmpty.isNearlyEmpty, true);
        expect(nearlyEmpty.usagePercentage, 95.0);
      });

      test('SpoolProfile should validate completeness', () {
        final completeProfile = SpoolProfile(
          id: 'profile_001',
          name: 'Standard PLA',
          manufacturer: 'TestBrand',
          materialType: MaterialType.pla,
          filamentDiameter: 1.75,
          printTemperature: 200,
          createdAt: DateTime.now(),
        );

        expect(completeProfile.isComplete, true);
        expect(completeProfile.displayName, 'TestBrand Standard PLA (PLA)');

        final incompleteProfile = SpoolProfile(
          id: 'profile_002',
          name: '',
          manufacturer: 'TestBrand',
          materialType: MaterialType.pla,
          createdAt: DateTime.now(),
        );

        expect(incompleteProfile.isComplete, false);
      });
    });

    group('Exceptions', () {
      test('Domain exceptions should provide proper context', () {
        final scanException = SpoolScanException(
          'Failed to scan spool',
          scanMethod: 'NFC',
          details: 'Device not found',
        );

        expect(scanException.message, 'Failed to scan spool');
        expect(scanException.scanMethod, 'NFC');
        expect(scanException.details, 'Device not found');
        expect(scanException.toString(), contains('SpoolScanException [NFC]'));
      });

      test('Validation exception should include field info', () {
        final validationException = InvalidSpoolDataException(
          'Invalid UID format',
          field: 'uid',
          value: 'ab',
        );

        expect(validationException.field, 'uid');
        expect(validationException.value, 'ab');
        expect(validationException.toString(), contains('InvalidSpoolDataException [uid]'));
      });
    });

    group('Enum Types', () {
      test('ScanMethod should have proper display names', () {
        expect(ScanMethod.nfc.displayName, 'NFC');
        expect(ScanMethod.usb.displayName, 'USB');
        expect(ScanMethod.bluetooth.displayName, 'Bluetooth');
        expect(ScanMethod.manual.displayName, 'Manual Input');
      });

      test('ExportFormat should have proper display names', () {
        expect(ExportFormat.json.displayName, 'JSON');
        expect(ExportFormat.csv.displayName, 'CSV');
        expect(ExportFormat.xml.displayName, 'XML');
        expect(ExportFormat.pdf.displayName, 'PDF');
      });
    });
  });
}