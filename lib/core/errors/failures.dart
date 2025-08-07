/// Represents a failure in the application
abstract class Failure {
  final String message;
  final String? details;
  
  const Failure(this.message, {this.details});
  
  @override
  String toString() => 'Failure: $message${details != null ? ' ($details)' : ''}';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && 
           other.message == message && 
           other.details == details;
  }
  
  @override
  int get hashCode => message.hashCode ^ details.hashCode;
}

/// General application failure
class GeneralFailure extends Failure {
  const GeneralFailure(super.message, {super.details});
}

/// NFC specific failures
class NfcFailure extends Failure {
  const NfcFailure(super.message, {super.details});
}

/// RFID specific failures
class RfidFailure extends Failure {
  const RfidFailure(super.message, {super.details});
}

/// Network related failures
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.details});
}

/// Storage related failures
class StorageFailure extends Failure {
  const StorageFailure(super.message, {super.details});
}

/// Permission related failures
class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.details});
}

/// Hardware related failures
class HardwareFailure extends Failure {
  const HardwareFailure(super.message, {super.details});
}
