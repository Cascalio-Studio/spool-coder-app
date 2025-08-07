import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// App logo widget that displays the Spool Coder logo
/// Supports different sizes and adapts to different contexts
class AppLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final bool showText;
  final Color? color;
  
  const AppLogo({
    super.key,
    this.width,
    this.height,
    this.showText = true,
    this.color,
  });

  /// Small logo for app bar and compact displays
  const AppLogo.small({
    super.key,
    this.showText = false,
    this.color,
  }) : width = 32,
       height = 32;

  /// Medium logo for headers and cards
  const AppLogo.medium({
    super.key,
    this.showText = true,
    this.color,
  }) : width = 64,
       height = 64;

  /// Large logo for welcome screens and splash
  const AppLogo.large({
    super.key,
    this.showText = true,
    this.color,
  }) : width = 120,
       height = 120;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo image
        Image.asset(
          'assets/logo/spoolcoder_logo_1024.png',
          width: width ?? 80,
          height: height ?? 80,
          color: color,
          colorBlendMode: color != null ? BlendMode.srcIn : null,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback if image fails to load
            return Container(
              width: width ?? 80,
              height: height ?? 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.settings_ethernet,
                size: (width ?? 80) * 0.6,
                color: color ?? theme.colorScheme.primary,
              ),
            );
          },
        ),
        
        // Optional text below logo
        if (showText) ...[
          const SizedBox(height: 8),
          Text(
            'Spool Coder',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.primaryBlack.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

/// App logo that adapts to the current theme
class AdaptiveAppLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final bool showText;
  
  const AdaptiveAppLogo({
    super.key,
    this.width,
    this.height,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return AppLogo(
      width: width,
      height: height,
      showText: showText,
      // Adapt color based on theme
      color: isDarkMode ? null : null, // Use original colors
    );
  }
}
