import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';
import '../../domain/use_cases/nfc_scan_use_case.dart';
import '../../domain/entities/spool.dart';
import '../../domain/value_objects/rfid_data.dart';
import '../../l10n/app_localizations.dart';

/// NFC Reading Screen Widget
/// Provides UI for NFC scanning with progress, states, and results
class NfcReadingScreen extends StatefulWidget {
  const NfcReadingScreen({super.key});

  @override
  State<NfcReadingScreen> createState() => _NfcReadingScreenState();
}

class _NfcReadingScreenState extends State<NfcReadingScreen>
    with TickerProviderStateMixin {
  late final NfcScanUseCase _nfcScanUseCase;
  late AnimationController _pulseController;
  late AnimationController _progressController;
  
  NfcScanState _currentState = NfcScanState.idle;
  double _scanProgress = 0.0;
  String? _errorMessage;
  RfidData? _scannedData;
  Spool? _createdSpool;
  
  StreamSubscription<NfcScanState>? _stateSubscription;
  StreamSubscription<double>? _progressSubscription;
  StreamSubscription<String>? _errorSubscription;
  StreamSubscription<RfidData>? _dataSubscription;

  @override
  void initState() {
    super.initState();
    _nfcScanUseCase = GetIt.instance<NfcScanUseCase>();
    
    // Initialize animations
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // Setup stream subscriptions
    _setupStreamListeners();
  }

  void _setupStreamListeners() {
    _stateSubscription = _nfcScanUseCase.scanStateStream.listen((state) {
      setState(() {
        _currentState = state;
      });
      
      // Handle state-specific animations
      switch (state) {
        case NfcScanState.scanning:
          _pulseController.repeat();
          break;
        case NfcScanState.success:
        case NfcScanState.error:
        case NfcScanState.idle:
          _pulseController.stop();
          _pulseController.reset();
          break;
        default:
          break;
      }
    });
    
    _progressSubscription = _nfcScanUseCase.scanProgressStream.listen((progress) {
      setState(() {
        _scanProgress = progress;
      });
      _progressController.animateTo(progress);
    });
    
    _errorSubscription = _nfcScanUseCase.errorStream.listen((error) {
      setState(() {
        _errorMessage = error;
      });
    });
    
    _dataSubscription = _nfcScanUseCase.scannedDataStream.listen((rfidData) async {
      setState(() {
        _scannedData = rfidData;
      });
      
      // Create spool from scanned data
      try {
        final spool = await _nfcScanUseCase.createSpoolFromScan(rfidData);
        setState(() {
          _createdSpool = spool;
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to create spool: $e';
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    _stateSubscription?.cancel();
    _progressSubscription?.cancel();
    _errorSubscription?.cancel();
    _dataSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startScan() async {
    setState(() {
      _errorMessage = null;
      _scannedData = null;
      _createdSpool = null;
    });
    
    try {
      await _nfcScanUseCase.startScanning();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _stopScan() async {
    await _nfcScanUseCase.stopScanning();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header
              _buildHeader(context, l10n, theme),
              
              const SizedBox(height: 32),
              
              // Main scan area
              Expanded(
                child: _buildScanArea(context, l10n, theme),
              ),
              
              // Controls
              _buildControls(context, l10n, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return Column(
      children: [
        Text(
          l10n.readRfidCard,
          style: theme.textTheme.displayMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _getStatusText(l10n),
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildScanArea(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // NFC Icon with animation
          _buildAnimatedNfcIcon(theme),
          
          const SizedBox(height: 32),
          
          // Progress indicator
          if (_currentState == NfcScanState.scanning)
            _buildProgressIndicator(theme),
          
          const SizedBox(height: 24),
          
          // State-specific content
          _buildStateContent(context, l10n, theme),
        ],
      ),
    );
  }

  Widget _buildAnimatedNfcIcon(ThemeData theme) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getIconBackgroundColor(theme),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(
                _currentState == NfcScanState.scanning 
                  ? 0.3 + (0.4 * _pulseController.value)
                  : 0.3
              ),
              width: 2,
            ),
          ),
          child: Icon(
            Icons.nfc,
            size: 48,
            color: _getIconColor(theme),
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return Column(
      children: [
        SizedBox(
          width: 200,
          child: LinearProgressIndicator(
            value: _scanProgress,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${(_scanProgress * 100).toInt()}%',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildStateContent(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    switch (_currentState) {
      case NfcScanState.idle:
        return Text(
          l10n.tapScanButtonToStart,
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        );
        
      case NfcScanState.scanning:
        return Text(
          l10n.holdCardNearReader,
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        );
        
      case NfcScanState.success:
        return _buildSuccessContent(context, l10n, theme);
        
      case NfcScanState.error:
        return _buildErrorContent(context, l10n, theme);
        
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSuccessContent(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return Column(
      children: [
        Icon(
          Icons.check_circle,
          size: 48,
          color: Colors.green,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.scanSuccessful,
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.green),
          textAlign: TextAlign.center,
        ),
        if (_scannedData != null) ...[
          const SizedBox(height: 16),
          _buildScannedDataSummary(context, l10n, theme),
        ],
      ],
    );
  }

  Widget _buildErrorContent(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return Column(
      children: [
        Icon(
          Icons.error,
          size: 48,
          color: theme.colorScheme.error,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.scanFailed,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.error,
          ),
          textAlign: TextAlign.center,
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            _errorMessage!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildScannedDataSummary(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    if (_createdSpool == null) return const SizedBox.shrink();
    
    final spool = _createdSpool!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scanned Spool:',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text('Material: ${spool.materialType.displayName}'),
          Text('Manufacturer: ${spool.manufacturer}'),
          Text('Color: ${spool.color.name}'),
          Text('Length: ${spool.netLength.format()}'),
          if (spool.temperatureProfile != null)
            Text('Print Temp: ${spool.temperatureProfile!.maxHotendTemperature}°C'),
        ],
      ),
    );
  }

  Widget _buildControls(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return Row(
      children: [
        // Stop/Cancel button
        if (_currentState == NfcScanState.scanning)
          Expanded(
            child: OutlinedButton(
              onPressed: _stopScan,
              child: Text(l10n.cancel),
            ),
          ),
        
        if (_currentState == NfcScanState.scanning) const SizedBox(width: 16),
        
        // Main action button
        Expanded(
          child: ElevatedButton(
            onPressed: _getMainButtonEnabled() ? _getMainButtonAction() : null,
            child: Text(_getMainButtonText(l10n)),
          ),
        ),
      ],
    );
  }

  // Helper methods
  String _getStatusText(AppLocalizations l10n) {
    switch (_currentState) {
      case NfcScanState.idle:
        return l10n.nfcReady;
      case NfcScanState.scanning:
        return l10n.scanning;
      case NfcScanState.success:
        return l10n.scanComplete;
      case NfcScanState.error:
        return l10n.scanError;
      default:
        return '';
    }
  }

  Color _getIconBackgroundColor(ThemeData theme) {
    switch (_currentState) {
      case NfcScanState.success:
        return Colors.green.withOpacity(0.1);
      case NfcScanState.error:
        return theme.colorScheme.error.withOpacity(0.1);
      default:
        return theme.colorScheme.primary.withOpacity(0.1);
    }
  }

  Color _getIconColor(ThemeData theme) {
    switch (_currentState) {
      case NfcScanState.success:
        return Colors.green;
      case NfcScanState.error:
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.primary;
    }
  }

  bool _getMainButtonEnabled() {
    return _currentState != NfcScanState.scanning;
  }

  String _getMainButtonText(AppLocalizations l10n) {
    switch (_currentState) {
      case NfcScanState.idle:
      case NfcScanState.error:
        return l10n.startScan;
      case NfcScanState.scanning:
        return l10n.scanning;
      case NfcScanState.success:
        return l10n.scanAgain;
      default:
        return l10n.startScan;
    }
  }

  VoidCallback? _getMainButtonAction() {
    switch (_currentState) {
      case NfcScanState.idle:
      case NfcScanState.error:
      case NfcScanState.success:
        return _startScan;
      default:
        return null;
    }
  }
}
