import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:spool_coder_app/theme/theme.dart';
import 'package:spool_coder_app/l10n/app_localizations.dart';

/// Home screen widgets - Components for the main home screen
/// Implements design concept components: welcome section, action cards, spool selection

/// Welcome section widget showing user greeting and status
class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(color: AppColors.pureWhite),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.appTitle,
            style: AppTextStyles.displayLarge,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.goodMorning,
            style: AppTextStyles.welcomeGreeting,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.lastReadStatus,
            style: AppTextStyles.welcomeSubtitle,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.readyToScan,
            style: AppTextStyles.bodyLargeSecondary,
          ),
        ],
      ),
    );
  }
}

/// Action card widget for read/write operations
class ActionCard extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final IconData icon;
  final VoidCallback onPressed;

  const ActionCard({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlack.withOpacity(0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: AppColors.primaryBlack,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppTextStyles.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTextStyles.bodyMediumSecondary,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}

/// Spool selection section with horizontal scrolling cards
class SpoolSelectionSection extends StatefulWidget {
  const SpoolSelectionSection({super.key});

  @override
  State<SpoolSelectionSection> createState() => _SpoolSelectionSectionState();
}

class _SpoolSelectionSectionState extends State<SpoolSelectionSection> {
  int _selectedSpoolIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final spoolData = _getSpoolData(l10n);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            l10n.recentSpools,
            style: AppTextStyles.sectionHeader,
          ),
        ),
        SizedBox(
          height: 180,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              trackVisibility: true,
              radius: const Radius.circular(8),
              thickness: 6,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: spoolData.length,
                    itemBuilder: (context, index) {
                    return SpoolCard(
                      spoolData: spoolData[index],
                      isSelected: _selectedSpoolIndex == index,
                      onTap: () {
                        setState(() {
                          _selectedSpoolIndex = index;
                        });
                      },
                    );
                  },
                ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Individual spool card widget
class SpoolCard extends StatelessWidget {
  final SpoolData spoolData;
  final bool isSelected;
  final VoidCallback onTap;

  const SpoolCard({
    super.key,
    required this.spoolData,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive card width: fit 2.5 cards on screen, fallback to 280px for small screens
    final cardWidth = screenWidth > 700
        ? (screenWidth - 32 - 24) / 2.5
        : 280.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accentGreen : AppColors.backgroundGray,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlack.withOpacity(0.06),
              offset: const Offset(0, 1),
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: spoolData.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      spoolData.type,
                      style: AppTextStyles.spoolCardTitle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                spoolData.brand,
                style: AppTextStyles.spoolCardBrand,
              ),
              const Divider(height: 20),
              Text(
                l10n.kgRemaining(spoolData.remaining.toStringAsFixed(1)),
                style: AppTextStyles.spoolCardAmount,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.lastUsed(spoolData.lastUsed),
                style: AppTextStyles.spoolCardLastUsed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Data model for spool information
class SpoolData {
  final String type;
  final String brand;
  final double remaining;
  final String lastUsed;
  final Color color;

  const SpoolData({
    required this.type,
    required this.brand,
    required this.remaining,
    required this.lastUsed,
    required this.color,
  });
}

/// Get sample spool data with localized strings
List<SpoolData> _getSpoolData(AppLocalizations l10n) {
  return [
    SpoolData(
      type: 'PLA Matte Black',
      brand: 'Prusament',
      remaining: 1.8,
      lastUsed: l10n.today,
      color: AppColors.primaryBlack,
    ),
    SpoolData(
      type: 'PETG Clear',
      brand: 'Overture',
      remaining: 0.5,
      lastUsed: l10n.daysAgo('5'),
      color: AppColors.backgroundGray,
    ),
    SpoolData(
      type: 'PLA Green',
      brand: 'eSUN',
      remaining: 2.3,
      lastUsed: l10n.daysAgo('7'),
      color: AppColors.accentGreen,
    ),
    SpoolData(
      type: 'ABS Red',
      brand: 'SUNLU',
      remaining: 0.8,
      lastUsed: l10n.daysAgo('14'),
      color: const Color(0xFFFF3B30),
    ),
    SpoolData(
      type: 'PLA+ White',
      brand: 'eSUN',
      remaining: 1.2,
      lastUsed: l10n.daysAgo('3'),
      color: AppColors.pureWhite,
    ),
  ];
}
