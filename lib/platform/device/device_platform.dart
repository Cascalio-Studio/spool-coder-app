/// Device platform integration
/// Part of the Platform Layer: handles device/platform-specific device information and capabilities
enum DevicePlatform {
  android,
  ios,
  windows,
  macos,
  linux,
  web,
  unknown,
}

enum BatteryState {
  charging,
  discharging,
  full,
  unknown,
}

class DeviceInfo {
  final String name;
  final DevicePlatform platform;
  final String version;
  final String model;
  final String manufacturer;
  final String identifier;
  final bool isPhysicalDevice;
  
  const DeviceInfo({
    required this.name,
    required this.platform,
    required this.version,
    required this.model,
    required this.manufacturer,
    required this.identifier,
    required this.isPhysicalDevice,
  });
}

class BatteryInfo {
  final int level; // 0-100
  final BatteryState state;
  final bool isLowPowerMode;
  
  const BatteryInfo({
    required this.level,
    required this.state,
    required this.isLowPowerMode,
  });
}

class DeviceCapabilities {
  final bool hasNfc;
  final bool hasBluetooth;
  final bool hasCamera;
  final bool hasFlashlight;
  final bool hasFingerprint;
  final bool hasFaceId;
  final bool hasAccelerometer;
  final bool hasGyroscope;
  final bool hasCompass;
  
  const DeviceCapabilities({
    required this.hasNfc,
    required this.hasBluetooth,
    required this.hasCamera,
    required this.hasFlashlight,
    required this.hasFingerprint,
    required this.hasFaceId,
    required this.hasAccelerometer,
    required this.hasGyroscope,
    required this.hasCompass,
  });
}

abstract class DevicePlatformInterface {
  /// Initialize device platform
  Future<bool> initialize();
  
  /// Get device information
  Future<DeviceInfo> getDeviceInfo();
  
  /// Get battery information
  Future<BatteryInfo> getBatteryInfo();
  
  /// Stream of battery changes
  Stream<BatteryInfo> get batteryStream;
  
  /// Get device capabilities
  Future<DeviceCapabilities> getDeviceCapabilities();
  
  /// Check if device has specific capability
  Future<bool> hasCapability(String capability);
  
  /// Get device orientation
  Future<String> getOrientation();
  
  /// Vibrate device
  Future<void> vibrate({Duration duration = const Duration(milliseconds: 500)});
  
  /// Keep screen awake
  Future<void> keepScreenOn(bool keepOn);
}

/// Platform-specific device implementation
/// This would use platform channels or device info plugins for device operations
class DevicePlatformImpl implements DevicePlatformInterface {
  final DeviceInfo _deviceInfo;
  BatteryInfo _batteryInfo;
  final DeviceCapabilities _capabilities;

  DevicePlatformImpl({
    DeviceInfo? deviceInfo,
    BatteryInfo? batteryInfo,
    DeviceCapabilities? capabilities,
    bool randomize = false,
  })  : _deviceInfo = deviceInfo ?? _generateMockDeviceInfo(randomize),
        _batteryInfo = batteryInfo ?? _generateMockBatteryInfo(randomize),
        _capabilities = capabilities ?? _generateMockDeviceCapabilities(randomize);

  static DeviceInfo _generateMockDeviceInfo(bool randomize) {
    if (!randomize) {
      return const DeviceInfo(
        name: 'Mock Device',
        platform: DevicePlatform.android,
        version: '13.0',
        model: 'Mock Model',
        manufacturer: 'Mock Inc',
        identifier: 'mock-device-id',
        isPhysicalDevice: true,
      );
    }
    final platforms = DevicePlatform.values;
    final rand = Random();
    return DeviceInfo(
      name: 'Device${rand.nextInt(1000)}',
      platform: platforms[rand.nextInt(platforms.length)],
      version: '${rand.nextInt(15) + 1}.${rand.nextInt(10)}',
      model: 'Model${rand.nextInt(100)}',
      manufacturer: 'Manufacturer${rand.nextInt(50)}',
      identifier: 'id-${rand.nextInt(100000)}',
      isPhysicalDevice: rand.nextBool(),
    );
  }

  static BatteryInfo _generateMockBatteryInfo(bool randomize) {
    if (!randomize) {
      return const BatteryInfo(
        level: 85,
        state: BatteryState.discharging,
        isLowPowerMode: false,
      );
    }
    final rand = Random();
    final states = BatteryState.values;
    return BatteryInfo(
      level: rand.nextInt(101),
      state: states[rand.nextInt(states.length)],
      isLowPowerMode: rand.nextBool(),
    );
  }

  static DeviceCapabilities _generateMockDeviceCapabilities(bool randomize) {
    if (!randomize) {
      return const DeviceCapabilities(
        hasNfc: true,
        hasBluetooth: true,
        hasCamera: true,
        hasFlashlight: true,
        hasFingerprint: true,
        hasFaceId: false,
        hasAccelerometer: true,
        hasGyroscope: true,
        hasCompass: true,
      );
    }
    final rand = Random();
    return DeviceCapabilities(
      hasNfc: rand.nextBool(),
      hasBluetooth: rand.nextBool(),
      hasCamera: rand.nextBool(),
      hasFlashlight: rand.nextBool(),
      hasFingerprint: rand.nextBool(),
      hasFaceId: rand.nextBool(),
      hasAccelerometer: rand.nextBool(),
      hasGyroscope: rand.nextBool(),
      hasCompass: rand.nextBool(),
    );
  }
  
  @override
  Future<bool> initialize() async {
    // In a real implementation, this would:
    // - Setup platform channels for device info
    // - Initialize device info plugins
    // - Start battery monitoring
    return true;
  }
  
  @override
  Future<DeviceInfo> getDeviceInfo() async {
    // In a real implementation, this would get actual device info
    return _deviceInfo;
  }
  
  @override
  Future<BatteryInfo> getBatteryInfo() async {
    // In a real implementation, this would get actual battery info
    return _batteryInfo;
  }
  
  @override
  Stream<BatteryInfo> get batteryStream {
    // In a real implementation, this would provide battery updates
    return Stream.periodic(
      const Duration(minutes: 1),
      (_) => _batteryInfo,
    );
  }
  
  @override
  Future<DeviceCapabilities> getDeviceCapabilities() async {
    // In a real implementation, this would check actual device capabilities
    return _capabilities;
  }
  
  @override
  Future<bool> hasCapability(String capability) async {
    // In a real implementation, this would check specific capability
    switch (capability.toLowerCase()) {
      case 'nfc':
        return _capabilities.hasNfc;
      case 'bluetooth':
        return _capabilities.hasBluetooth;
      case 'camera':
        return _capabilities.hasCamera;
      default:
        return false;
    }
  }
  
  @override
  Future<String> getOrientation() async {
    // In a real implementation, this would get device orientation
    return 'portrait';
  }
  
  @override
  Future<void> vibrate({Duration duration = const Duration(milliseconds: 500)}) async {
    // In a real implementation, this would vibrate the device
    // Mock implementation does nothing
  }
  
  @override
  Future<void> keepScreenOn(bool keepOn) async {
    // In a real implementation, this would control screen wake lock
    // Mock implementation does nothing
  }
}