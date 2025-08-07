import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spool_coder_app/features/home/widgets/home_widgets.dart';
import 'package:spool_coder_app/l10n/app_localizations.dart';
import 'package:spool_coder_app/core/di/injector.dart';
import 'package:spool_coder_app/domain/use_cases/nfc_scan_use_case.dart';
import 'package:spool_coder_app/data/use_cases/nfc_scan_use_case_impl.dart';
import 'package:spool_coder_app/domain/value_objects/rfid_data.dart';
import 'dart:async';

/// Home screen - main entry point for the app
/// Implements the design concept with welcome section, action cards, spool selection, and bottom navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomNavIndex = 0;
  
  // NFC scanning state
  late final NfcScanUseCase _nfcScanUseCase;
  StreamSubscription<NfcScanState>? _scanStateSubscription;
  StreamSubscription<double>? _scanProgressSubscription;
  StreamSubscription<String>? _errorSubscription;
  StreamSubscription<RfidData>? _scannedDataSubscription;
  
  NfcScanState _scanState = NfcScanState.idle;
  double _scanProgress = 0.0;
  String? _errorMessage;
  RfidData? _scannedData;

  @override
  void initState() {
    super.initState();
    _nfcScanUseCase = locator<NfcScanUseCase>();
    _setupScanListeners();
  }

  @override
  void dispose() {
    _cancelScanListeners();
    if (_nfcScanUseCase is NfcScanUseCaseImpl) {
      (_nfcScanUseCase as NfcScanUseCaseImpl).dispose();
    }
    super.dispose();
  }

  void _setupScanListeners() {
    _scanStateSubscription = _nfcScanUseCase.scanStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _scanState = state;
        });
        
        // Debug: Print state changes
        print('NFC State changed to: $state');
        
        // If scan is successful, ensure we stay on the read tab
        if (state == NfcScanState.success) {
          print('Success state - ensuring we stay on read tab (index 1)');
          if (_currentBottomNavIndex != 1) {
            setState(() {
              _currentBottomNavIndex = 1;
            });
          }
        }
      }
    });

    _scanProgressSubscription = _nfcScanUseCase.scanProgressStream.listen((progress) {
      if (mounted) {
        setState(() {
          _scanProgress = progress;
        });
      }
    });

    _errorSubscription = _nfcScanUseCase.errorStream.listen((error) {
      if (mounted) {
        setState(() {
          _errorMessage = error;
        });
      }
    });

    _scannedDataSubscription = _nfcScanUseCase.scannedDataStream.listen((data) {
      if (mounted) {
        setState(() {
          _scannedData = data;
        });
        
        // Debug: Print scanned data
        print('Scanned data received: ${data.uid}');
        
        // Ensure we stay on the read tab when data is received
        if (_currentBottomNavIndex != 1) {
          print('Navigation was not on read tab, correcting to index 1');
          setState(() {
            _currentBottomNavIndex = 1;
          });
        }
      }
    });
  }

  void _cancelScanListeners() {
    _scanStateSubscription?.cancel();
    _scanProgressSubscription?.cancel();
    _errorSubscription?.cancel();
    _scannedDataSubscription?.cancel();
  }

  void _startNfcScan() {
    _nfcScanUseCase.startScanning();
  }
  
  void _resetScanState() {
    print('Manually resetting scan state');
    setState(() {
      _scanState = NfcScanState.idle;
      _scannedData = null;
      _errorMessage = null;
      _scanProgress = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _buildBody(),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBody() {
    // Show different content based on bottom navigation selection
    switch (_currentBottomNavIndex) {
      case 0: // Home
        return _buildHomeContent();
      case 1: // Read
        return _buildReadContent();
      case 2: // Write
        return _buildWriteContent();
      case 3: // Settings - Navigate directly, so show home content
        return _buildHomeContent();
      case 4: // Profile
        return _buildProfileContent();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    final l10n = AppLocalizations.of(context)!;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          const WelcomeSection(),
          
          // Read Card Section
          ActionCard(
            title: l10n.readRfidCard,
            description: l10n.scanFilamentSpool,
            buttonText: l10n.readButtonLabel,
            icon: Icons.nfc,
            onPressed: () {
              setState(() {
                _currentBottomNavIndex = 1; // Switch to Read tab
              });
              // Auto-start scanning when navigating to Read tab
              Future.delayed(const Duration(milliseconds: 300), () {
                _startNfcScan();
              });
            },
          ),
          
          // Spool Selection
          const SpoolSelectionSection(),
          
          // Write Card Section
          ActionCard(
            title: l10n.writeRfidCard,
            description: l10n.programSpoolData,
            buttonText: l10n.writeButtonLabel,
            icon: Icons.edit,
            onPressed: () {
              setState(() {
                _currentBottomNavIndex = 2; // Switch to Write tab
              });
            },
          ),
          
          const SizedBox(height: 100), // Space for bottom navigation
        ],
      ),
    );
  }

  Widget _buildReadContent() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // NFC Icon with animation during scanning
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              Icons.nfc,
              size: 64,
              color: _scanState == NfcScanState.scanning 
                  ? theme.colorScheme.secondary 
                  : theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.readRfidCard,
            style: theme.textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          
          // Show different content based on scan state
          if (_scanState == NfcScanState.idle) ...[
            Text(
              l10n.tapScanButtonToStart,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ] else if (_scanState == NfcScanState.scanning) ...[
            Text(
              l10n.scanning,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: _scanProgress,
                backgroundColor: theme.colorScheme.onSurface.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.secondary),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(_scanProgress * 100).toInt()}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ] else if (_scanState == NfcScanState.success) ...[
            Icon(
              Icons.check_circle,
              size: 32,
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.scanSuccessful,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            if (_scannedData != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UID: ${_scannedData!.uid}',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      'Type: ${_scannedData!.detailedFilamentType}',
                      style: theme.textTheme.bodySmall,
                    ),
                    Text(
                      'Length: ${_scannedData!.filamentLength?.meters.toStringAsFixed(1) ?? 'Unknown'}m',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ] else if (_scanState == NfcScanState.error) ...[
            Icon(
              Icons.error,
              size: 32,
              color: Colors.red,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.scanFailed,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.red.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
          
          const SizedBox(height: 32),
          
          // Action buttons based on scan state
          if (_scanState == NfcScanState.success) ...[
            // Success state - show both scan again and reset buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _startNfcScan,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.scanAgain),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _resetScanState,
                  icon: const Icon(Icons.clear),
                  label: const Text('Reset'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Non-success state - show regular scan button
            ElevatedButton.icon(
              onPressed: _scanState == NfcScanState.scanning ? null : _startNfcScan,
              icon: Icon(_scanState == NfcScanState.scanning ? Icons.hourglass_empty : Icons.nfc),
              label: Text(l10n.startScan),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWriteContent() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.edit,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.writeRfidCard,
            style: theme.textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.writeDataToCard,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.profile,
            style: theme.textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.manageAccount,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final theme = Theme.of(context);
    
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        border: Border(
          top: BorderSide(
            color: theme.dividerTheme.color ?? theme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Icons.home, AppLocalizations.of(context)!.home),
            _buildNavItem(1, Icons.nfc, AppLocalizations.of(context)!.read),
            _buildNavItem(2, Icons.edit, AppLocalizations.of(context)!.write),
            _buildNavItem(3, Icons.settings, AppLocalizations.of(context)!.settings),
            _buildNavItem(4, Icons.person, AppLocalizations.of(context)!.profile),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentBottomNavIndex == index;
    final theme = Theme.of(context);
    
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: theme.bottomNavigationBarTheme.selectedItemColor?.withOpacity(0.2),
        highlightColor: theme.bottomNavigationBarTheme.selectedItemColor?.withOpacity(0.1),
        hoverColor: theme.bottomNavigationBarTheme.selectedItemColor?.withOpacity(0.1),
        onTap: () {
          // Navigate to settings page when settings tab is tapped
          if (index == 3) { // Settings tab
            context.push('/settings');
            // Don't update the bottom nav index for settings since it's a separate page
            return;
          }
          
          setState(() {
            _currentBottomNavIndex = index;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: isActive 
                    ? theme.bottomNavigationBarTheme.selectedItemColor 
                    : theme.bottomNavigationBarTheme.unselectedItemColor,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: isActive 
                    ? theme.bottomNavigationBarTheme.selectedLabelStyle
                    : theme.bottomNavigationBarTheme.unselectedLabelStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}