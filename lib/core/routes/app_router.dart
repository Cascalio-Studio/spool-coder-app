import 'package:go_router/go_router.dart';
import 'package:spool_coder_app/presentation/screens/home_screen.dart';
import 'package:spool_coder_app/features/settings/settings.dart';

/// Application router configuration
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    // Add additional routes here
  ],
);
