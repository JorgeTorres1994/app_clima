// lib/app/router.dart
import 'dart:async';
import 'package:app_clima/features/auth/application/presentation/login_page.dart';
import 'package:app_clima/features/auth/application/presentation/register_page.dart';
import 'package:app_clima/features/favorites/presentation/pages/favorites_page.dart';
import 'package:app_clima/features/weather/profile/presentation/pages/profile_page.dart';
import 'package:app_clima/features/weather/settings/application/presentation/pages/settings_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// AUTH (ajusta si tus paths difieren)
import 'package:app_clima/features/auth/application/auth_providers.dart';

// WEATHER PAGES
import 'package:app_clima/features/weather/presentation/pages/home_page.dart';
import 'package:app_clima/features/weather/presentation/pages/search_page.dart';


/// Listenable que refresca GoRouter cuando cambia el stream de auth.
class _AuthRefreshListenable extends ChangeNotifier {
  StreamSubscription? _sub;
  _AuthRefreshListenable(Stream<dynamic> authStream) {
    _sub = authStream.listen((_) => notifyListeners());
  }
  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

GoRouter createRouter(WidgetRef ref) {
  final refreshListenable = _AuthRefreshListenable(
    ref.read(authStateProvider.stream),
  );

  return GoRouter(
    refreshListenable: refreshListenable,

    // Guard de autenticación
    redirect: (context, state) {
      final user = ref.read(authStateProvider).valueOrNull;

      // Si tu go_router es < 13, usa: final loc = state.subloc;
      final loc = state.matchedLocation;
      final logging = (loc == '/login' || loc == '/register');

      if (user == null && !logging) return '/login';
      if (user != null && logging) return '/';
      return null;
    },

    routes: [
      GoRoute(path: '/', builder: (_, __) => const HomePage()),
      GoRoute(path: '/search', builder: (_, __) => const SearchPage()),         // ✅ NUEVA
      GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),     // ✅ NUEVA
      GoRoute(path: '/favorites', builder: (_, __) => const FavoritesPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),       // ✅ NUEVA
    ],
  );
}
