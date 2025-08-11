import 'package:flutter/material.dart';
import '../../domain/value_objects/rfid_data.dart';
import '../../l10n/app_localizations.dart';

/// Detailed RFID Spool Data Display Widget
/// 
/// Displays comprehensive spool information after successful NFC scan
/// Matches the design from the Spool Coder Python project
class RfidSpoolDataDisplay extends StatelessWidget {
  final RfidData rfidData;
  final VoidCallback? onBack;

  const RfidSpoolDataDisplay({
    super.key,
    required this.rfidData,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with success message
            _buildHeader(context, l10n, theme),
            
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information Section
                    _buildSection(
                      context, 
                      l10n, 
                      theme,
                      title: l10n.basicInformation,
                      children: [
                        _buildInfoRow(l10n.name, _getMaterialName(), theme),
                        _buildInfoRow(l10n.type, rfidData.filamentType ?? 'Unknown', theme),
                        _buildColorRow(l10n.color, rfidData.color, theme),
                        _buildInfoRow(l10n.manufacturer, 'Bambu Lab', theme), // From RFID spec
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Technical Data Section
                    _buildSection(
                      context,
                      l10n,
                      theme,
                      title: l10n.technicalData,
                      children: [
                        if (rfidData.spoolWeight != null)
                          _buildInfoRow(l10n.density, '${(rfidData.spoolWeight! / 1000).toStringAsFixed(2)} g/cm³', theme),
                        if (rfidData.filamentDiameter != null)
                          _buildInfoRow(l10n.diameter, '${rfidData.filamentDiameter!.toStringAsFixed(2)} mm', theme),
                        if (rfidData.temperatureProfile?.maxHotendTemperature != null)
                          _buildInfoRow(l10n.nozzleTemperature, '${rfidData.temperatureProfile!.maxHotendTemperature} °C', theme),
                        if (rfidData.temperatureProfile?.bedTemperature != null)
                          _buildInfoRow(l10n.bedTemperature, '${rfidData.temperatureProfile!.bedTemperature} °C', theme),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Remaining Amount Section
                    _buildSection(
                      context,
                      l10n,
                      theme,
                      title: l10n.remainingAmount,
                      children: [
                        if (rfidData.filamentLength != null)
                          _buildInfoRow(l10n.length, '${rfidData.filamentLength!.meters.toStringAsFixed(1)} m', theme),
                        if (rfidData.spoolWeight != null)
                          _buildInfoRow(l10n.weight, '${rfidData.spoolWeight!.toStringAsFixed(1)} g', theme),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Advanced Information Section (Collapsible)
                    _buildAdvancedSection(context, l10n, theme),
                    
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            
            // Bottom button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onBack ?? () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(l10n.backButton),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Column(
        children: [
          Text(
            l10n.spoolDataTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.spoolDataSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l10n.nfcDeviceConnect,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l10n.bambuLabRead,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              l10n.readSuccessful,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme, {
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Section content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorRow(String label, dynamic color, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                // Color preview
                if (color?.rgbValues != null) ...[
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(
                        color!.rgbValues![0],
                        color.rgbValues![1],
                        color.rgbValues![2],
                        1.0,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: theme.dividerColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  color?.hexCode ?? color?.name ?? 'Unknown',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSection(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return ExpansionTile(
      title: Text(
        l10n.advancedInformation,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(l10n.uid, rfidData.uid, theme),
              if (rfidData.trayUid != null)
                _buildInfoRow(l10n.trayUid, rfidData.trayUid!, theme),
              if (rfidData.nozzleDiameter != null)
                _buildInfoRow(l10n.nozzleDiameter, '${rfidData.nozzleDiameter} mm', theme),
              if (rfidData.spoolWidth != null)
                _buildInfoRow(l10n.spoolWidth, '${rfidData.spoolWidth} mm', theme),
              if (rfidData.productionInfo?.productionDateTime != null)
                _buildInfoRow(l10n.productionDate, 
                  '${rfidData.productionInfo!.productionDateTime!.day}.${rfidData.productionInfo!.productionDateTime!.month}.${rfidData.productionInfo!.productionDateTime!.year}',
                  theme),
              if (rfidData.temperatureProfile?.dryingTemperature != null)
                _buildInfoRow(l10n.dryingTemperature, '${rfidData.temperatureProfile!.dryingTemperature} °C', theme),
              if (rfidData.temperatureProfile?.dryingTimeHours != null)
                _buildInfoRow(l10n.dryingTime, '${rfidData.temperatureProfile!.dryingTimeHours} h', theme),
              _buildInfoRow(l10n.authentic, rfidData.isGenuineBambuLab ? '${l10n.yes} ✅' : '${l10n.no} ❌', theme),
              _buildInfoRow(l10n.scanTime, '${rfidData.scanTime.day}.${rfidData.scanTime.month}.${rfidData.scanTime.year} ${rfidData.scanTime.hour}:${rfidData.scanTime.minute.toString().padLeft(2, '0')}', theme),
            ],
          ),
        ),
      ],
    );
  }

  String _getMaterialName() {
    if (rfidData.detailedFilamentType != null) {
      return rfidData.detailedFilamentType!;
    }
    
    if (rfidData.filamentType != null && rfidData.color?.name != null) {
      return '${rfidData.filamentType} ${rfidData.color!.name}';
    }
    
    return rfidData.filamentType ?? 'Unknown Material';
  }
}
