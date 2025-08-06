import 'dart:async';
import '../../domain/use_cases/nfc_scan_use_case.dart';
import '../../domain/entities/spool.dart';
import '../../domain/value_objects/rfid_data.dart';
import '../../domain/value_objects/spool_uid.dart';
import '../../domain/value_objects/material_type.dart';
import '../../domain/value_objects/spool_color.dart';
import '../../domain/value_objects/filament_length.dart';
import '../datasources/nfc_data_source.dart';

/// Implementation of NFC scan use case
/// Part of the Data Layer: implements business logic for NFC operations
class NfcScanUseCaseImpl implements NfcScanUseCase {
  final NfcDataSource _nfcDataSource;
  
  // Stream controllers for reactive updates
  final StreamController<NfcScanState> _scanStateController = StreamController<NfcScanState>.broadcast();
  final StreamController<double> _scanProgressController = StreamController<double>.broadcast();
  final StreamController<String> _errorController = StreamController<String>.broadcast();
  final StreamController<RfidData> _scannedDataController = StreamController<RfidData>.broadcast();
  
  NfcScanState _currentState = NfcScanState.idle;
  
  NfcScanUseCaseImpl({required NfcDataSource nfcDataSource}) 
      : _nfcDataSource = nfcDataSource;

  @override
  Future<void> startScanning() async {
    try {
      _updateState(NfcScanState.scanning);
      _updateProgress(0.0);
      
      // Check NFC availability
      final isAvailable = await _nfcDataSource.isNfcAvailable();
      if (!isAvailable) {
        throw Exception('NFC is not available on this device');
      }
      
      _updateProgress(0.1);
      
      // Initialize NFC if needed
      await _nfcDataSource.initialize();
      _updateProgress(0.2);
      
      // Start scanning for tags
      _updateState(NfcScanState.scanning);
      _updateProgress(0.3);
      
      // Simulate scan process with progress updates
      await _performScanWithProgress();
      
    } catch (e) {
      _updateState(NfcScanState.error);
      _errorController.add(e.toString());
    }
  }
  
  Future<void> _performScanWithProgress() async {
    // Simulate progressive scanning
    for (int i = 3; i <= 8; i++) {
      if (_currentState != NfcScanState.scanning) break;
      
      await Future.delayed(const Duration(milliseconds: 500));
      _updateProgress(i / 10.0);
    }
    
    try {
      // Attempt to scan spool
      final spool = await _nfcDataSource.scanSpool();
      
      _updateProgress(0.9);
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Create RFID data from spool
      final rfidData = _createRfidDataFromSpool(spool);
      
      _updateProgress(1.0);
      _updateState(NfcScanState.success);
      _scannedDataController.add(rfidData);
      
    } catch (e) {
      _updateState(NfcScanState.error);
      _errorController.add('Failed to read NFC tag: $e');
    }
  }

  @override
  Future<void> stopScanning() async {
    _updateState(NfcScanState.idle);
    _updateProgress(0.0);
  }

  @override
  Future<bool> isNfcAvailable() async {
    return await _nfcDataSource.isNfcAvailable();
  }

  @override
  Future<bool> isNfcEnabled() async {
    return await _nfcDataSource.isNfcAvailable(); // Simplified for mock
  }

  @override
  Future<bool> requestNfcPermissions() async {
    // In a real implementation, this would request platform permissions
    return true;
  }

  @override
  Future<RfidData> readRfidTag() async {
    try {
      _updateState(NfcScanState.reading);
      final spool = await _nfcDataSource.scanSpool();
      
      final rfidData = _createRfidDataFromSpool(spool);
      _updateState(NfcScanState.success);
      
      return rfidData;
    } catch (e) {
      _updateState(NfcScanState.error);
      rethrow;
    }
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
    _currentState = newState;
    _scanStateController.add(newState);
  }
  
  void _updateProgress(double progress) {
    _scanProgressController.add(progress);
  }
  
  RfidData _createRfidDataFromSpool(Spool spool) {
    return RfidData(
      uid: spool.uid.value,
      scanTime: DateTime.now(),
      filamentType: spool.materialType.value,
      detailedFilamentType: spool.materialType.displayName,
      color: spool.color,
      filamentLength: spool.netLength,
      temperatureProfile: spool.temperatureProfile,
      productionInfo: spool.productionInfo,
    );
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
    _scanStateController.close();
    _scanProgressController.close();
    _errorController.close();
    _scannedDataController.close();
  }
}
