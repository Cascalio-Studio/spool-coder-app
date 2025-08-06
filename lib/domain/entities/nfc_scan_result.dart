import '../value_objects/rfid_data.dart';

/// Represents the result of an NFC scan operation
/// This is an immutable value object that holds the state and data of NFC scanning
sealed class NfcScanResult {
  const NfcScanResult();

  /// Initial idle state
  const factory NfcScanResult.idle() = NfcScanIdle;
  
  /// Scanning in progress
  const factory NfcScanResult.scanning() = NfcScanScanning;
  
  /// Tag detected and reading
  const factory NfcScanResult.reading() = NfcScanReading;
  
  /// Successfully scanned and parsed RFID data
  const factory NfcScanResult.success(RfidData rfidData) = NfcScanSuccess;
  
  /// Error occurred during scanning
  const factory NfcScanResult.error(String message) = NfcScanError;
  
  /// Pattern matching helpers
  T when<T>({
    required T Function() idle,
    required T Function() scanning,
    required T Function() reading,
    required T Function(RfidData rfidData) success,
    required T Function(String message) error,
  }) {
    return switch (this) {
      NfcScanIdle() => idle(),
      NfcScanScanning() => scanning(),
      NfcScanReading() => reading(),
      NfcScanSuccess(:final rfidData) => success(rfidData),
      NfcScanError(:final message) => error(message),
    };
  }
  
  T maybeWhen<T>({
    T Function()? idle,
    T Function()? scanning,
    T Function()? reading,
    T Function(RfidData rfidData)? success,
    T Function(String message)? error,
    required T Function() orElse,
  }) {
    return switch (this) {
      NfcScanIdle() => idle?.call() ?? orElse(),
      NfcScanScanning() => scanning?.call() ?? orElse(),
      NfcScanReading() => reading?.call() ?? orElse(),
      NfcScanSuccess(:final rfidData) => success?.call(rfidData) ?? orElse(),
      NfcScanError(:final message) => error?.call(message) ?? orElse(),
    };
  }
}

/// Idle state - ready to start scanning
final class NfcScanIdle extends NfcScanResult {
  const NfcScanIdle();
  
  @override
  bool operator ==(Object other) => other is NfcScanIdle;
  
  @override
  int get hashCode => 0;
}

/// Scanning state - actively looking for NFC tags
final class NfcScanScanning extends NfcScanResult {
  const NfcScanScanning();
  
  @override
  bool operator ==(Object other) => other is NfcScanScanning;
  
  @override
  int get hashCode => 1;
}

/// Reading state - tag detected, reading data
final class NfcScanReading extends NfcScanResult {
  const NfcScanReading();
  
  @override
  bool operator ==(Object other) => other is NfcScanReading;
  
  @override
  int get hashCode => 2;
}

/// Success state - successfully scanned and parsed RFID data
final class NfcScanSuccess extends NfcScanResult {
  final RfidData rfidData;
  
  const NfcScanSuccess(this.rfidData);
  
  @override
  bool operator ==(Object other) {
    return other is NfcScanSuccess && other.rfidData == rfidData;
  }
  
  @override
  int get hashCode => rfidData.hashCode;
}

/// Error state - something went wrong during scanning
final class NfcScanError extends NfcScanResult {
  final String message;
  
  const NfcScanError(this.message);
  
  @override
  bool operator ==(Object other) {
    return other is NfcScanError && other.message == message;
  }
  
  @override
  int get hashCode => message.hashCode;
}
