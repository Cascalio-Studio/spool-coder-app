/// Base exception class for all domain-related errors
/// Part of the Domain Layer: defines business-specific exceptions
abstract class DomainException implements Exception {
  final String message;
  final String? details;
  final DateTime timestamp;

  DomainException(
    this.message, {
    this.details,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() => 'DomainException: $message${details != null ? ' - $details' : ''}';
}

/// Exception thrown when spool scanning fails
class SpoolScanException extends DomainException {
  final String scanMethod;
  
  SpoolScanException(
    super.message, {
    required this.scanMethod,
    super.details,
    super.timestamp,
  });

  @override
  String toString() => 'SpoolScanException [$scanMethod]: $message${details != null ? ' - $details' : ''}';
}

/// Exception thrown when spool data is invalid
class InvalidSpoolDataException extends DomainException {
  final String field;
  final dynamic value;
  
  InvalidSpoolDataException(
    super.message, {
    required this.field,
    this.value,
    super.details,
    super.timestamp,
  });

  @override
  String toString() => 'InvalidSpoolDataException [$field]: $message${details != null ? ' - $details' : ''}';
}

/// Exception thrown when trying to write to a write-protected spool
class SpoolWriteProtectedException extends DomainException {
  final String spoolUid;
  
  SpoolWriteProtectedException(
    super.message, {
    required this.spoolUid,
    super.details,
    super.timestamp,
  });

  @override
  String toString() => 'SpoolWriteProtectedException [$spoolUid]: $message${details != null ? ' - $details' : ''}';
}

/// Exception thrown when spool is not found
class SpoolNotFoundException extends DomainException {
  final String spoolUid;
  
  SpoolNotFoundException(
    super.message, {
    required this.spoolUid,
    super.details,
    super.timestamp,
  });

  @override
  String toString() => 'SpoolNotFoundException [$spoolUid]: $message${details != null ? ' - $details' : ''}';
}

/// Exception thrown when device connection fails
class DeviceConnectionException extends DomainException {
  final String deviceType;
  
  DeviceConnectionException(
    super.message, {
    required this.deviceType,
    super.details,
    super.timestamp,
  });

  @override
  String toString() => 'DeviceConnectionException [$deviceType]: $message${details != null ? ' - $details' : ''}';
}

/// Exception thrown when spool profile operations fail
class SpoolProfileException extends DomainException {
  final String operation;
  
  SpoolProfileException(
    super.message, {
    required this.operation,
    super.details,
    super.timestamp,
  });

  @override
  String toString() => 'SpoolProfileException [$operation]: $message${details != null ? ' - $details' : ''}';
}

/// Exception thrown when business rules are violated
class BusinessRuleViolationException extends DomainException {
  final String rule;
  
  BusinessRuleViolationException(
    super.message, {
    required this.rule,
    super.details,
    super.timestamp,
  });

  @override
  String toString() => 'BusinessRuleViolationException [$rule]: $message${details != null ? ' - $details' : ''}';
}

/// Exception thrown when RFID scanning operations fail
class RfidScanException extends DomainException {
  final String? tagId;
  final String scanOperation;
  
  RfidScanException(
    super.message, {
    this.tagId,
    required this.scanOperation,
    super.details,
    super.timestamp,
  });

  @override
  String toString() => 'RfidScanException [$scanOperation${tagId != null ? ' - $tagId' : ''}]: $message${details != null ? ' - $details' : ''}';
}

/// Exception thrown when RFID data parsing fails
class RfidDataParsingException extends DomainException {
  final String dataSource;
  final String? block;
  
  RfidDataParsingException(
    super.message, {
    required this.dataSource,
    this.block,
    super.details,
    super.timestamp,
  });

  @override
  String toString() => 'RfidDataParsingException [$dataSource${block != null ? ' - Block $block' : ''}]: $message${details != null ? ' - $details' : ''}';
}

/// Exception thrown when RFID hardware is not available
class RfidHardwareException extends DomainException {
  final String hardwareType;
  final String operation;
  
  RfidHardwareException(
    super.message, {
    required this.hardwareType,
    required this.operation,
    super.details,
    super.timestamp,
  });

  @override
  String toString() => 'RfidHardwareException [$hardwareType - $operation]: $message${details != null ? ' - $details' : ''}';
}

/// Exception thrown when RFID tag validation fails
class RfidValidationException extends DomainException {
  final String uid;
  final List<String> validationErrors;
  
  RfidValidationException(
    super.message, {
    required this.uid,
    required this.validationErrors,
    super.details,
    super.timestamp,
  });

  @override
  String toString() => 'RfidValidationException [$uid]: $message - ${validationErrors.join(', ')}${details != null ? ' - $details' : ''}';
}

/// Exception thrown when RFID signature verification fails
class RfidSignatureException extends DomainException {
  final String uid;
  final String signatureType;
  
  RfidSignatureException(
    super.message, {
    required this.uid,
    required this.signatureType,
    super.details,
    super.timestamp,
  });

  @override
  String toString() => 'RfidSignatureException [$uid - $signatureType]: $message${details != null ? ' - $details' : ''}';
}