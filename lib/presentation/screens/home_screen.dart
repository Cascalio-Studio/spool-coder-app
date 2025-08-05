import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spool_coder_app/features/home/widgets/home_widgets.dart';
import 'package:spool_coder_app/l10n/app_localizations.dart';

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
          Icon(
            Icons.nfc,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.readRfidCard,
            style: theme.textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.holdCardNearReader,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
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