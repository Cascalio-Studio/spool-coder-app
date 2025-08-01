import 'package:flutter/material.dart';
import 'package:spool_coder_app/theme/theme.dart';
import 'package:spool_coder_app/features/home/widgets/home_widgets.dart';

/// Home screen - main entry point for the app
/// Implements the design concept with welcome section, action cards, spool selection, and bottom navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
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
      case 3: // Settings
        return _buildSettingsContent();
      case 4: // Profile
        return _buildProfileContent();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          const WelcomeSection(),
          
          // Read Card Section
          ActionCard(
            title: 'Read RFID Card',
            description: 'Scan your filament spool to read data',
            buttonText: 'READ',
            icon: Icons.nfc,
            onPressed: () {
              setState(() {
                _currentBottomNavIndex = 1; // Switch to Read tab
              });
            },
          ),
          
          // Spool Selection
          const SpoolSelectionSection(),
          
          // Write Card Section
          ActionCard(
            title: 'Write RFID Card',
            description: 'Program new data to your spool',
            buttonText: 'WRITE',
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.nfc,
            size: 64,
            color: AppColors.accentGreen,
          ),
          const SizedBox(height: 24),
          const Text(
            'Read RFID Card',
            style: AppTextStyles.displayMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Hold your RFID card near the reader',
            style: AppTextStyles.bodyLargeSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWriteContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.edit,
            size: 64,
            color: AppColors.accentGreen,
          ),
          const SizedBox(height: 24),
          const Text(
            'Write RFID Card',
            style: AppTextStyles.displayMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Program new data to your filament spool',
            style: AppTextStyles.bodyLargeSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.settings,
            size: 64,
            color: AppColors.accentGreen,
          ),
          const SizedBox(height: 24),
          const Text(
            'Settings',
            style: AppTextStyles.displayMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Configure your app preferences',
            style: AppTextStyles.bodyLargeSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person,
            size: 64,
            color: AppColors.accentGreen,
          ),
          const SizedBox(height: 24),
          const Text(
            'Profile',
            style: AppTextStyles.displayMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Manage your account and preferences',
            style: AppTextStyles.bodyLargeSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
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
            _buildNavItem(0, Icons.home, 'Home'),
            _buildNavItem(1, Icons.nfc, 'Read'),
            _buildNavItem(2, Icons.edit, 'Write'),
            _buildNavItem(3, Icons.settings, 'Settings'),
            _buildNavItem(4, Icons.person, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentBottomNavIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentBottomNavIndex = index;
        });
      },
      child: Column(
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
      ),
    );
  }
}