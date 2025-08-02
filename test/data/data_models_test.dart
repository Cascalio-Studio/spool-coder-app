import 'package:test/test.dart';
import '../../lib/data/models/data_models.dart';
import '../../lib/data/mappers/entity_mappers.dart';

void main() {
  group('Data Models Tests', () {
    test('SpoolDto serialization works correctly', () {
      // Arrange
      final spoolDto = SpoolDto(
        uid: 'test_uid_123',
        materialType: 'PLA',
        manufacturer: 'BambuLab',
        color: 'Blue',
        netLength: 1000.0,
        remainingLength: 750.0,
        createdAt: DateTime.now().toIso8601String(),
      );

      // Act
      final json = spoolDto.toJson();
      final restored = SpoolDto.fromJson(json);

      // Assert
      expect(restored.uid, equals(spoolDto.uid));
      expect(restored.materialType, equals(spoolDto.materialType));
      expect(restored.manufacturer, equals(spoolDto.manufacturer));
      expect(restored.color, equals(spoolDto.color));
      expect(restored.netLength, equals(spoolDto.netLength));
      expect(restored.remainingLength, equals(spoolDto.remainingLength));
    });

    test('SpoolProfileDto serialization works correctly', () {
      // Arrange
      final profileDto = SpoolProfileDto(
        id: 'profile_123',
        name: 'Test Profile',
        manufacturer: 'BambuLab',
        materialType: 'PETG',
        color: 'Red',
        netLength: 1000.0,
        filamentDiameter: 1.75,
        createdAt: DateTime.now().toIso8601String(),
      );

      // Act
      final json = profileDto.toJson();
      final restored = SpoolProfileDto.fromJson(json);

      // Assert
      expect(restored.id, equals(profileDto.id));
      expect(restored.name, equals(profileDto.name));
      expect(restored.manufacturer, equals(profileDto.manufacturer));
      expect(restored.materialType, equals(profileDto.materialType));
      expect(restored.filamentDiameter, equals(profileDto.filamentDiameter));
    });

    test('TemperatureProfileDto serialization works correctly', () {
      // Arrange
      final tempDto = TemperatureProfileDto(
        minHotendTemperature: 190,
        maxHotendTemperature: 220,
        bedTemperature: 60,
        dryingTemperature: 40,
        dryingTimeHours: 4,
      );

      // Act
      final json = tempDto.toJson();
      final restored = TemperatureProfileDto.fromJson(json);

      // Assert
      expect(restored.minHotendTemperature, equals(tempDto.minHotendTemperature));
      expect(restored.maxHotendTemperature, equals(tempDto.maxHotendTemperature));
      expect(restored.bedTemperature, equals(tempDto.bedTemperature));
      expect(restored.dryingTemperature, equals(tempDto.dryingTemperature));
      expect(restored.dryingTimeHours, equals(tempDto.dryingTimeHours));
    });

    test('ProductionInfoDto serialization works correctly', () {
      // Arrange
      final productionDto = ProductionInfoDto(
        productionDateTime: DateTime.now().toIso8601String(),
        batchId: 'BATCH_2024_001',
        materialId: 'MAT_PLA_001',
        trayInfoIndex: 'TRAY_A_01',
      );

      // Act
      final json = productionDto.toJson();
      final restored = ProductionInfoDto.fromJson(json);

      // Assert
      expect(restored.productionDateTime, equals(productionDto.productionDateTime));
      expect(restored.batchId, equals(productionDto.batchId));
      expect(restored.materialId, equals(productionDto.materialId));
      expect(restored.trayInfoIndex, equals(productionDto.trayInfoIndex));
    });

    test('RfidDataDto serialization works correctly', () {
      // Arrange
      final rfidDto = RfidDataDto(
        uid: '04AB1234',
        materialType: 'PLA',
        color: 'Blue',
        netLength: 1000.0,
        temperatureProfile: TemperatureProfileDto(
          minHotendTemperature: 190,
          maxHotendTemperature: 220,
          bedTemperature: 60,
        ),
        productionInfo: ProductionInfoDto(
          batchId: 'BATCH_001',
          materialId: 'MAT_001',
        ),
      );

      // Act
      final json = rfidDto.toJson();
      final restored = RfidDataDto.fromJson(json);

      // Assert
      expect(restored.uid, equals(rfidDto.uid));
      expect(restored.materialType, equals(rfidDto.materialType));
      expect(restored.color, equals(rfidDto.color));
      expect(restored.netLength, equals(rfidDto.netLength));
      expect(restored.temperatureProfile.minHotendTemperature, 
             equals(rfidDto.temperatureProfile.minHotendTemperature));
      expect(restored.productionInfo.batchId, 
             equals(rfidDto.productionInfo.batchId));
    });
  });

  group('Mapper Utility Tests', () {
    test('MaterialTypeMapper works correctly', () {
      // Test string to MaterialType
      expect(MaterialTypeMapper.fromString('PLA'), equals(MaterialType.pla));
      expect(MaterialTypeMapper.fromString('PETG'), equals(MaterialType.petg));
      expect(MaterialTypeMapper.fromString('ABS'), equals(MaterialType.abs));
      expect(MaterialTypeMapper.fromString('TPU'), equals(MaterialType.tpu));
      expect(MaterialTypeMapper.fromString('unknown'), equals(MaterialType.pla)); // Fallback

      // Test MaterialType to string
      expect(MaterialTypeMapper.toString(MaterialType.pla), equals('PLA'));
      expect(MaterialTypeMapper.toString(MaterialType.petg), equals('PETG'));
    });

    test('MapperUtils parseDateTime works correctly', () {
      final now = DateTime.now();
      final isoString = now.toIso8601String();
      
      expect(MapperUtils.parseDateTime(isoString), isNotNull);
      expect(MapperUtils.parseDateTime(null), isNull);
      expect(MapperUtils.parseDateTime(''), isNull);
      expect(MapperUtils.parseDateTime('invalid'), isNull);
    });

    test('MapperUtils parseDouble works correctly', () {
      expect(MapperUtils.parseDouble(123.45), equals(123.45));
      expect(MapperUtils.parseDouble(123), equals(123.0));
      expect(MapperUtils.parseDouble('123.45'), equals(123.45));
      expect(MapperUtils.parseDouble(null), isNull);
      expect(MapperUtils.parseDouble('invalid'), isNull);
    });

    test('MapperUtils parseBool works correctly', () {
      expect(MapperUtils.parseBool(true), isTrue);
      expect(MapperUtils.parseBool(false), isFalse);
      expect(MapperUtils.parseBool('true'), isTrue);
      expect(MapperUtils.parseBool('false'), isFalse);
      expect(MapperUtils.parseBool('1'), isTrue);
      expect(MapperUtils.parseBool('0'), isFalse);
      expect(MapperUtils.parseBool(1), isTrue);
      expect(MapperUtils.parseBool(0), isFalse);
      expect(MapperUtils.parseBool(null), isFalse);
      expect(MapperUtils.parseBool(null, defaultValue: true), isTrue);
    });
  });
}

// Mock classes for testing
class MaterialType {
  final String value;
  const MaterialType._(this.value);
  
  static const MaterialType pla = MaterialType._('PLA');
  static const MaterialType petg = MaterialType._('PETG');
  static const MaterialType abs = MaterialType._('ABS');
  static const MaterialType tpu = MaterialType._('TPU');
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MaterialType && other.value == value;
  }
  
  @override
  int get hashCode => value.hashCode;
}