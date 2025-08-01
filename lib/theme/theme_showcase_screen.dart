import 'package:flutter/material.dart';
import 'package:spool_coder_app/theme/theme.dart';

/// Example home screen showcasing the theme implementation
/// This demonstrates the design concept with proper styling
class ThemeShowcaseScreen extends StatelessWidget {
  const ThemeShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _buildWelcomeSection(context),
              
              // Read Card Section
              _buildActionCard(
                context,
                title: 'Read RFID Card',
                description: 'Scan your filament spool to read data',
                buttonText: 'READ',
                icon: Icons.nfc,
                onPressed: () {},
              ),
              
              // Spool Selection
              _buildSpoolSelection(context),
              
              // Write Card Section
              _buildActionCard(
                context,
                title: 'Write RFID Card',
                description: 'Program new data to your spool',
                buttonText: 'WRITE',
                icon: Icons.edit,
                onPressed: () {},
              ),
              
              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
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

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String description,
    required String buttonText,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
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

  Widget _buildSpoolSelection(BuildContext context) {
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
            itemCount: 3,
            itemBuilder: (context, index) {
              return _buildSpoolCard(context, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSpoolCard(BuildContext context, int index) {
    final spools = [
      {
        'type': 'PLA Matte Black',
        'brand': 'Prusament',
        'remaining': 1.8,
        'lastUsed': 'Today',
        'color': AppColors.primaryBlack,
      },
      {
        'type': 'PETG Clear',
        'brand': 'Overture',
        'remaining': 0.5,
        'lastUsed': '5 days ago',
        'color': AppColors.backgroundGray,
      },
      {
        'type': 'PLA Green',
        'brand': 'eSUN',
        'remaining': 2.3,
        'lastUsed': '1 week ago',
        'color': AppColors.accentGreen,
      },
    ];

    final spool = spools[index];
    final isSelected = index == 0;

    return Container(
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
                    color: spool['color'] as Color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    spool['type'] as String,
                    style: AppTextStyles.spoolCardTitle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              spool['brand'] as String,
              style: AppTextStyles.spoolCardBrand,
            ),
            const Divider(height: 20),
            Text(
              '${(spool['remaining'] as double).toStringAsFixed(1)} kg remaining',
              style: AppTextStyles.spoolCardAmount,
            ),
            const SizedBox(height: 4),
            Text(
              'Last used: ${spool['lastUsed']}',
              style: AppTextStyles.spoolCardLastUsed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        border: Border(
          top: BorderSide(
            color: AppColors.backgroundGray,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(context, Icons.home, 'Home', true),
            _buildNavItem(context, Icons.nfc, 'Read', false),
            _buildNavItem(context, Icons.edit, 'Write', false),
            _buildNavItem(context, Icons.settings, 'Settings', false),
            _buildNavItem(context, Icons.person, 'Profile', false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 24,
          color: isActive ? AppColors.accentGreen : AppColors.mutedBlack,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.navigationLabel.copyWith(
            color: isActive ? AppColors.accentGreen : AppColors.mutedBlack,
          ),
        ),
      ],
    );
  }
}
