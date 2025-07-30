import 'package:go_router/go_router.dart';
import 'package:spool_coder_app/presentation/screens/home_screen.dart';

/// Application router configuration
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    // Add additional routes here
  ],
);
