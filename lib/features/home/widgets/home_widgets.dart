import 'package:flutter/material.dart';
import 'package:spool_coder_app/theme/theme.dart';

/// Home screen widgets - Components for the main home screen
/// Implements design concept components: welcome section, action cards, spool selection

/// Welcome section widget showing user greeting and status
class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(color: AppColors.pureWhite),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good morning, Alex',
            style: AppTextStyles.welcomeGreeting,
          ),
          const SizedBox(height: 8),
          Text(
            'Last read: PLA Blue (Prusament) • 3 spools managed',
            style: AppTextStyles.welcomeSubtitle,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(
            'Your Spools',
            style: AppTextStyles.sectionHeader,
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _spoolData.length,
            itemBuilder: (context, index) {
              return SpoolCard(
                spoolData: _spoolData[index],
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
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
                '${spoolData.remaining.toStringAsFixed(1)} kg remaining',
                style: AppTextStyles.spoolCardAmount,
              ),
              const SizedBox(height: 4),
              Text(
                'Last used: ${spoolData.lastUsed}',
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

/// Sample spool data
final List<SpoolData> _spoolData = [
  const SpoolData(
    type: 'PLA Matte Black',
    brand: 'Prusament',
    remaining: 1.8,
    lastUsed: 'Today',
    color: AppColors.primaryBlack,
  ),
  const SpoolData(
    type: 'PETG Clear',
    brand: 'Overture',
    remaining: 0.5,
    lastUsed: '5 days ago',
    color: AppColors.backgroundGray,
  ),
  const SpoolData(
    type: 'PLA Green',
    brand: 'eSUN',
    remaining: 2.3,
    lastUsed: '1 week ago',
    color: AppColors.accentGreen,
  ),
  const SpoolData(
    type: 'ABS Red',
    brand: 'SUNLU',
    remaining: 0.8,
    lastUsed: '2 weeks ago',
    color: Color(0xFFFF3B30),
  ),
  const SpoolData(
    type: 'PLA+ White',
    brand: 'eSUN',
    remaining: 1.2,
    lastUsed: '3 days ago',
    color: AppColors.pureWhite,
  ),
];
