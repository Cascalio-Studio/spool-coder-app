import '../../domain/entities/spool.dart';
import '../../domain/repositories/spool_repository.dart';
import '../../domain/value_objects/spool_uid.dart';
import '../datasources/spool_data_source.dart';

/// Repository interface for spool data operations
/// Part of the Data Layer: defines contracts for data access
/// 
/// Note: This is the concrete implementation that bridges the domain repository
/// interface with the data source abstraction layer.
class SpoolRepositoryImpl implements SpoolRepository {
  final SpoolDataSource _dataSource;
  
  const SpoolRepositoryImpl({
    required SpoolDataSource dataSource,
  }) : _dataSource = dataSource;

  @override
  Future<Spool> scanSpool(ScanMethod method) async {
    // Scanning is handled by platform-specific implementations
    // This would delegate to NFC, USB, or Bluetooth data sources
    throw UnimplementedError('Scanning not yet implemented - use platform-specific services');
  }

  @override
  Future<Spool?> getSpoolById(SpoolUid uid) async {
    return await _dataSource.getSpoolById(uid);
  }

  @override
  Future<List<Spool>> getAllSpools() async {
    return await _dataSource.getAllSpools();
  }

  @override
  Future<void> saveSpool(Spool spool) async {
    await _dataSource.saveSpool(spool);
  }

  @override
  Future<void> updateSpool(Spool spool) async {
    await _dataSource.updateSpool(spool);
  }

  @override
  Future<void> deleteSpool(SpoolUid uid) async {
    await _dataSource.deleteSpool(uid);
  }

  @override
  Future<void> writeSpool(Spool spool, ScanMethod method) async {
    // Writing to physical spool is handled by platform-specific implementations
    // This would delegate to NFC, USB, or Bluetooth data sources
    throw UnimplementedError('Writing to physical spool not yet implemented - use platform-specific services');
  }

  @override
  Future<bool> validateSpoolData(SpoolUid uid) async {
    final spool = await _dataSource.getSpoolById(uid);
    if (spool == null) return false;
    
    // Basic validation
    return spool.uid.value.isNotEmpty &&
           spool.manufacturer.isNotEmpty &&
           spool.netLength.meters > 0 &&
           spool.remainingLength.meters >= 0 &&
           spool.remainingLength.meters <= spool.netLength.meters;
  }

  @override
  Future<List<Spool>> searchSpools({
    String? materialType,
    String? manufacturer,
    String? color,
    bool? isNearlyEmpty,
  }) async {
    return await _dataSource.searchSpools(
      materialType: materialType,
      manufacturer: manufacturer,
      color: color,
      isNearlyEmpty: isNearlyEmpty,
    );
  }

  @override
  Future<List<Spool>> getNearlyEmptySpools() async {
    return await _dataSource.getNearlyEmptySpools();
  }

  @override
  Future<String> exportSpoolData() async {
    return await _dataSource.exportSpoolData();
  }

  @override
  Future<void> importSpoolData(String backupData) async {
    await _dataSource.importSpoolData(backupData);
  }
}