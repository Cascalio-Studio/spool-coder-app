import 'package:test/test.dart';
import '../../../lib/domain/value_objects/temperature_profile.dart';

void main() {
  group('TemperatureProfile', () {
    test('should create temperature profile from RFID Block 6 data', () {
      // Example from Bambu Lab RFID documentation
      // 3700 0800 0100 2D00 DC00 DC00 (hex) = 55°C, 8h, type 1, 45°C, 220°C, 220°C
      final blockData = [0x37, 0x00, 0x08, 0x00, 0x01, 0x00, 0x2D, 0x00, 0xDC, 0x00, 0xDC, 0x00];
      
      final profile = TemperatureProfile.fromRfidBlock6(blockData);
      
      expect(profile.dryingTemperature, equals(55));
      expect(profile.dryingTimeHours, equals(8));
      expect(profile.bedTemperatureType, equals(1));
      expect(profile.bedTemperature, equals(45));
      expect(profile.maxHotendTemperature, equals(220));
      expect(profile.minHotendTemperature, equals(220));
    });

    test('should calculate recommended hotend temperature as average', () {
      const profile = TemperatureProfile(
        minHotendTemperature: 200,
        maxHotendTemperature: 240,
      );
      
      expect(profile.recommendedHotendTemperature, equals(220));
    });

    test('should detect when drying is needed', () {
      const profileNeedsDrying = TemperatureProfile(
        dryingTemperature: 55,
        dryingTimeHours: 8,
      );
      
      const profileNoDrying = TemperatureProfile(
        dryingTemperature: 0,
        dryingTimeHours: 0,
      );
      
      expect(profileNeedsDrying.needsDrying, isTrue);
      expect(profileNoDrying.needsDrying, isFalse);
    });

    test('should validate temperature ranges', () {
      const validProfile = TemperatureProfile(
        dryingTemperature: 55,
        bedTemperature: 60,
        minHotendTemperature: 200,
        maxHotendTemperature: 220,
      );
      
      const invalidProfile = TemperatureProfile(
        dryingTemperature: 150, // Too high
        bedTemperature: -10, // Too low
        minHotendTemperature: 500, // Too high
        maxHotendTemperature: 100, // Too low for max
      );
      
      expect(validProfile.isValid, isTrue);
      expect(invalidProfile.isValid, isFalse);
    });

    test('should create copy with updated values', () {
      const original = TemperatureProfile(
        dryingTemperature: 55,
        bedTemperature: 60,
      );
      
      final updated = original.copyWith(
        dryingTemperature: 65,
        dryingTimeHours: 12,
      );
      
      expect(updated.dryingTemperature, equals(65));
      expect(updated.dryingTimeHours, equals(12));
      expect(updated.bedTemperature, equals(60)); // Unchanged
    });

    test('should have meaningful string representation', () {
      const profile = TemperatureProfile(
        minHotendTemperature: 200,
        maxHotendTemperature: 220,
        bedTemperature: 60,
        dryingTemperature: 55,
        dryingTimeHours: 8,
      );
      
      final description = profile.toString();
      expect(description, contains('Hotend: 210°C'));
      expect(description, contains('Bed: 60°C'));
      expect(description, contains('Dry: 55°C/8h'));
    });

    test('should handle equality correctly', () {
      const profile1 = TemperatureProfile(
        dryingTemperature: 55,
        bedTemperature: 60,
      );
      
      const profile2 = TemperatureProfile(
        dryingTemperature: 55,
        bedTemperature: 60,
      );
      
      const profile3 = TemperatureProfile(
        dryingTemperature: 65,
        bedTemperature: 60,
      );
      
      expect(profile1, equals(profile2));
      expect(profile1, isNot(equals(profile3)));
    });
  });
}