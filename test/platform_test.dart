import 'package:flutter_test/flutter_test.dart';
import 'package:spool_coder_app/platform/storage/storage_platform.dart';
import 'package:spool_coder_app/platform/network/network_platform.dart';
import 'package:spool_coder_app/platform/permissions/permissions_platform.dart';
import 'package:spool_coder_app/platform/device/device_platform.dart';
import 'package:spool_coder_app/platform/nfc/nfc_platform.dart';

void main() {
  group('Platform Layer Tests', () {
    group('Storage Platform', () {
      late StoragePlatformInterface storage;

      setUp(() {
        storage = StoragePlatformImpl();
      });

      test('should initialize successfully', () async {
        final result = await storage.initialize();
        expect(result, isTrue);
      });

      test('should store and retrieve data', () async {
        await storage.initialize();
        await storage.store('test_key', 'test_value');
        
        final result = await storage.retrieve('test_key');
        expect(result, 'test_value');
      });

      test('should check if key exists', () async {
        await storage.initialize();
        await storage.store('test_key', 'test_value');
        
        final exists = await storage.exists('test_key');
        expect(exists, isTrue);
        
        final notExists = await storage.exists('non_existent');
        expect(notExists, isFalse);
      });
    });

    group('Network Platform', () {
      late NetworkPlatformInterface network;

      setUp(() {
        network = NetworkPlatformImpl();
      });

      test('should initialize successfully', () async {
        final result = await network.initialize();
        expect(result, isTrue);
      });

      test('should have connection by default', () async {
        await network.initialize();
        final hasConnection = await network.hasConnection;
        expect(hasConnection, isTrue);
      });

      test('should get network info', () async {
        await network.initialize();
        final info = await network.getNetworkInfo();
        
        expect(info.type, NetworkType.wifi);
        expect(info.status, NetworkStatus.connected);
        expect(info.ssid, isNotNull);
      });
    });

    group('Permissions Platform', () {
      late PermissionsPlatformInterface permissions;

      setUp(() {
        permissions = PermissionsPlatformImpl();
      });

      test('should initialize successfully', () async {
        final result = await permissions.initialize();
        expect(result, isTrue);
      });

      test('should request permission', () async {
        await permissions.initialize();
        final result = await permissions.requestPermission(PermissionType.camera);
        
        expect(result.type, PermissionType.camera);
        expect(result.status, PermissionStatus.granted);
      });

      test('should check all permissions status', () async {
        await permissions.initialize();
        final allStatus = await permissions.getAllPermissionsStatus();
        
        expect(allStatus, isA<Map<PermissionType, PermissionStatus>>());
        expect(allStatus.containsKey(PermissionType.camera), isTrue);
      });
    });

    group('Device Platform', () {
      late DevicePlatformInterface device;

      setUp(() {
        device = DevicePlatformImpl();
      });

      test('should initialize successfully', () async {
        final result = await device.initialize();
        expect(result, isTrue);
      });

      test('should get device info', () async {
        await device.initialize();
        final info = await device.getDeviceInfo();
        
        expect(info.name, isNotNull);
        expect(info.platform, isA<DevicePlatform>());
        expect(info.version, isNotNull);
      });

      test('should get battery info', () async {
        await device.initialize();
        final battery = await device.getBatteryInfo();
        
        expect(battery.level, inInclusiveRange(0, 100));
        expect(battery.state, isA<BatteryState>());
      });

      test('should get device capabilities', () async {
        await device.initialize();
        final capabilities = await device.getDeviceCapabilities();
        
        expect(capabilities, isA<DeviceCapabilities>());
        expect(capabilities.hasNfc, isA<bool>());
        expect(capabilities.hasBluetooth, isA<bool>());
      });
    });

    group('NFC Platform', () {
      late NfcPlatformInterface nfc;

      setUp(() {
        nfc = NfcPlatformImpl();
      });

      test('should initialize successfully', () async {
        final result = await nfc.initialize();
        expect(result, isTrue);
      });

      test('should be supported by default', () async {
        await nfc.initialize();
        expect(nfc.isSupported, isTrue);
      });

      test('should be enabled by default', () async {
        await nfc.initialize();
        final isEnabled = await nfc.isEnabled;
        expect(isEnabled, isTrue);
      });
    });
  });
}