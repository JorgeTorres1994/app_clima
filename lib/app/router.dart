import 'package:app_clima/features/weather/favorites/presentation/pages/favorites_page.dart';
import 'package:app_clima/features/weather/favorites/presentation/pages/settings_page.dart';
import 'package:go_router/go_router.dart';
import '../features/weather/presentation/pages/home_page.dart';
import '../features/weather/presentation/pages/search_page.dart';

GoRouter createRouter() => GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomePage()),
    GoRoute(path: '/search', builder: (_, __) => const SearchPage()),
    GoRoute(path: '/favorites', builder: (_, __) => const FavoritesPage()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
  ],
);
