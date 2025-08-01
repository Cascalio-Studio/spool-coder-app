import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spool_coder_app/theme/theme.dart';

void main() {
  group('Font Loading Tests', () {
    testWidgets('Space Grotesk fonts load correctly', (WidgetTester tester) async {
      // Build a simple widget with our custom theme
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Column(
              children: [
                Text('Display Large', style: AppTextStyles.displayLarge),
                Text('Display Medium', style: AppTextStyles.displayMedium),
                Text('Title Large', style: AppTextStyles.titleLarge),
                Text('Body Large', style: AppTextStyles.bodyLarge),
                Text('Body Medium', style: AppTextStyles.bodyMedium),
                Text('Label Large', style: AppTextStyles.labelLarge),
                Text('Label Small', style: AppTextStyles.labelSmall),
              ],
            ),
          ),
        ),
      );

      // Verify that the widgets rendered without errors
      expect(find.text('Display Large'), findsOneWidget);
      expect(find.text('Display Medium'), findsOneWidget);
      expect(find.text('Title Large'), findsOneWidget);
      expect(find.text('Body Large'), findsOneWidget);
      expect(find.text('Body Medium'), findsOneWidget);
      expect(find.text('Label Large'), findsOneWidget);
      expect(find.text('Label Small'), findsOneWidget);
    });

    testWidgets('Theme colors are applied correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: Container(
              color: AppColors.accentGreen,
              child: Text(
                'Test Text',
                style: TextStyle(color: AppColors.primaryBlack),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
    });

    test('Font family is set correctly in text styles', () {
      expect(AppTextStyles.displayLarge.fontFamily, equals('Space Grotesk'));
      expect(AppTextStyles.displayMedium.fontFamily, equals('Space Grotesk'));
      expect(AppTextStyles.titleLarge.fontFamily, equals('Space Grotesk'));
      expect(AppTextStyles.bodyLarge.fontFamily, equals('Space Grotesk'));
      expect(AppTextStyles.bodyMedium.fontFamily, equals('Space Grotesk'));
      expect(AppTextStyles.labelLarge.fontFamily, equals('Space Grotesk'));
      expect(AppTextStyles.labelSmall.fontFamily, equals('Space Grotesk'));
    });

    test('Font weights are set correctly', () {
      expect(AppTextStyles.displayLarge.fontWeight, equals(FontWeight.bold));
      expect(AppTextStyles.displayMedium.fontWeight, equals(FontWeight.w500));
      expect(AppTextStyles.titleLarge.fontWeight, equals(FontWeight.w500));
      expect(AppTextStyles.bodyLarge.fontWeight, equals(FontWeight.normal));
      expect(AppTextStyles.bodyMedium.fontWeight, equals(FontWeight.normal));
      expect(AppTextStyles.labelLarge.fontWeight, equals(FontWeight.w500));
      expect(AppTextStyles.labelSmall.fontWeight, equals(FontWeight.normal));
    });

    test('Colors are defined correctly', () {
      expect(AppColors.primaryBlack, equals(const Color(0xFF202020)));
      expect(AppColors.accentGreen, equals(const Color(0xFFC9F158)));
      expect(AppColors.backgroundGray, equals(const Color(0xFFF2F3F5)));
      expect(AppColors.pureWhite, equals(const Color(0xFFFFFFFF)));
    });
  });
}
