/// Base exception for all application errors
abstract class AppException implements Exception {
  final String message;
  final String? details;
  
  const AppException(this.message, {this.details});
  
  @override
  String toString() => 'AppException: $message${details != null ? ' ($details)' : ''}';
}

/// Domain layer exceptions
class DomainException extends AppException {
  const DomainException(super.message, {super.details});
}

/// Data layer exceptions
class DataException extends AppException {
  const DataException(super.message, {super.details});
}

/// Platform layer exceptions
class PlatformException extends AppException {
  const PlatformException(super.message, {super.details});
}

/// NFC specific exceptions
class NfcException extends PlatformException {
  const NfcException(super.message, {super.details});
}

/// USB specific exceptions
class UsbException extends PlatformException {
  const UsbException(super.message, {super.details});
}

/// Bluetooth specific exceptions
class BluetoothException extends PlatformException {
  const BluetoothException(super.message, {super.details});
}