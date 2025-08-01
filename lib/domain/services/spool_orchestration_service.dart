import '../entities/spool.dart';
import '../repositories/spool_repository.dart';

/// Domain service for orchestrating complex spool operations
/// Part of the Domain Layer: coordinates multiple domain operations
abstract class SpoolOrchestrationService {
  /// Complete spool scanning workflow with validation and storage
  Future<SpoolScanResult> performCompleteScan(ScanMethod method);

  /// Sync spool data with external system
  Future<SyncResult> syncSpoolData();

  /// Bulk import spools from external data
  Future<ImportResult> importSpools(List<SpoolImportData> spoolData);

  /// Export spools to external format
  Future<ExportResult> exportSpools({
    List<String>? spoolUids,
    ExportFormat format = ExportFormat.json,
  });

  /// Clone spool with new UID (useful for creating templates)
  Future<Spool> cloneSpool(Spool originalSpool, {String? newUid});

  /// Merge spool data from multiple sources
  Future<Spool> mergeSpoolData(List<Spool> spoolSources);
}

/// Result of a complete scan operation
class SpoolScanResult {
  final Spool? spool;
  final bool success;
  final List<String> warnings;
  final String? errorMessage;
  final ScanMethod methodUsed;
  final Duration scanDuration;

  const SpoolScanResult({
    this.spool,
    required this.success,
    this.warnings = const [],
    this.errorMessage,
    required this.methodUsed,
    required this.scanDuration,
  });
}

/// Result of data synchronization
class SyncResult {
  final int spoolsSynced;
  final int spoolsUpdated;
  final int spoolsCreated;
  final List<String> errors;
  final DateTime syncTime;

  const SyncResult({
    required this.spoolsSynced,
    required this.spoolsUpdated,
    required this.spoolsCreated,
    this.errors = const [],
    required this.syncTime,
  });

  bool get hasErrors => errors.isNotEmpty;
}

/// Import operation result
class ImportResult {
  final int totalProcessed;
  final int successful;
  final int failed;
  final List<ImportError> errors;
  final Duration processingTime;

  const ImportResult({
    required this.totalProcessed,
    required this.successful,
    required this.failed,
    this.errors = const [],
    required this.processingTime,
  });

  bool get hasErrors => errors.isNotEmpty;
  double get successRate => totalProcessed > 0 ? successful / totalProcessed : 0.0;
}

/// Export operation result
class ExportResult {
  final String data;
  final ExportFormat format;
  final int spoolCount;
  final DateTime exportTime;

  const ExportResult({
    required this.data,
    required this.format,
    required this.spoolCount,
    required this.exportTime,
  });
}

/// Data structure for importing spools
class SpoolImportData {
  final Map<String, dynamic> rawData;
  final String? sourceFormat;

  const SpoolImportData({
    required this.rawData,
    this.sourceFormat,
  });
}

/// Import error details
class ImportError {
  final int recordIndex;
  final String field;
  final String error;
  final dynamic value;

  const ImportError({
    required this.recordIndex,
    required this.field,
    required this.error,
    this.value,
  });

  @override
  String toString() => 'Record $recordIndex - $field: $error';
}

/// Export format options
enum ExportFormat {
  json('JSON'),
  csv('CSV'),
  xml('XML'),
  pdf('PDF');

  const ExportFormat(this.displayName);
  final String displayName;

  @override
  String toString() => displayName;
}