import 'dart:async';
import '../../domain/use_cases/nfc_scan_use_case.dart';
import '../../domain/entities/spool.dart';
import '../../domain/value_objects/rfid_data.dart';
import '../../domain/value_objects/spool_uid.dart';
import '../../domain/value_objects/material_type.dart';
import '../../domain/value_objects/spool_color.dart';
import '../../domain/value_objects/filament_length.dart';
import '../datasources/nfc/nfc_data_source.dart';

/// Implementation of NFC scan use case using the new stream-based approach
/// Part of the Data Layer: implements business logic for NFC operations
class ModernNfcScanUseCaseImpl implements NfcScanUseCase {
  final NfcDataSource _nfcDataSource;
  
  // Stream controllers for reactive updates
  final StreamController<NfcScanState> _scanStateController = StreamController<NfcScanState>.broadcast();
  final StreamController<double> _scanProgressController = StreamController<double>.broadcast();
  final StreamController<String> _errorController = StreamController<String>.broadcast();
  final StreamController<RfidData> _scannedDataController = StreamController<RfidData>.broadcast();
  
  ModernNfcScanUseCaseImpl({required NfcDataSource nfcDataSource}) 
      : _nfcDataSource = nfcDataSource {
    _setupScanResultsListener();
  }

  void _setupScanResultsListener() {
    _nfcDataSource.scanResults.listen((result) {
      result.when(
        idle: () {
          _updateState(NfcScanState.idle);
          _updateProgress(0.0);
        },
        scanning: () {
          _updateState(NfcScanState.scanning);
          _updateProgress(0.3);
        },
        reading: () {
          _updateState(NfcScanState.reading);
          _updateProgress(0.7);
        },
        success: (rfidData) {
          _updateState(NfcScanState.success);
          _updateProgress(1.0);
          _scannedDataController.add(rfidData);
        },
        error: (message) {
          _updateState(NfcScanState.error);
          _errorController.add(message);
        },
      );
    });
  }

  @override
  Future<void> startScanning() async {
    try {
      _updateState(NfcScanState.scanning);
      _updateProgress(0.1);
      
      // Check NFC availability
      final isAvailable = await _nfcDataSource.isNfcAvailable();
      if (!isAvailable) {
        throw Exception('NFC is not available on this device');
      }
      
      _updateProgress(0.2);
      
      // Start scanning with 30 second timeout
      await _nfcDataSource.startScanning(timeout: const Duration(seconds: 30));
      
    } catch (e) {
      _updateState(NfcScanState.error);
      _errorController.add(e.toString());
    }
  }

  @override
  Future<void> stopScanning() async {
    await _nfcDataSource.stopScanning();
    _updateState(NfcScanState.idle);
    _updateProgress(0.0);
  }

  @override
  Future<bool> isNfcAvailable() async {
    return await _nfcDataSource.isNfcAvailable();
  }

  @override
  Future<bool> isNfcEnabled() async {
    return await _nfcDataSource.isNfcEnabled();
  }

  @override
  Future<bool> requestNfcPermissions() async {
    // In a real implementation, this would request platform permissions
    // For now, we assume permissions are handled by the platform
    return true;
  }

  @override
  Future<RfidData> readRfidTag() async {
    // This method is called after a successful scan
    // The actual reading is handled by the stream-based approach
    throw UnimplementedError('Use scanResults stream for real-time updates');
  }

  @override
  Future<Spool> createSpoolFromScan(RfidData rfidData) async {
    return Spool(
      uid: SpoolUid.generate(),
      materialType: MaterialType.fromRfidDetailedType(rfidData.filamentType ?? 'PLA'),
      manufacturer: 'Bambu Lab',
      color: rfidData.color ?? SpoolColor.named('Unknown'),
      netLength: rfidData.filamentLength ?? FilamentLength.meters(1000),
      remainingLength: rfidData.filamentLength ?? FilamentLength.meters(1000),
      createdAt: DateTime.now(),
      rfidData: rfidData,
      temperatureProfile: rfidData.temperatureProfile,
      productionInfo: rfidData.productionInfo,
      isRfidScanned: true,
    );
  }

  // Helper methods
  void _updateState(NfcScanState newState) {
    _scanStateController.add(newState);
  }
  
  void _updateProgress(double progress) {
    _scanProgressController.add(progress);
  }

  // Stream getters
  @override
  Stream<NfcScanState> get scanStateStream => _scanStateController.stream;

  @override
  Stream<double> get scanProgressStream => _scanProgressController.stream;

  @override
  Stream<String> get errorStream => _errorController.stream;

  @override
  Stream<RfidData> get scannedDataStream => _scannedDataController.stream;
  
  // Cleanup
  void dispose() {
    _nfcDataSource.dispose();
    _scanStateController.close();
    _scanProgressController.close();
    _errorController.close();
    _scannedDataController.close();
  }
}
