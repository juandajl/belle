import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/auth_providers.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/feed/presentation/main_shell.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const onboarding = '/onboarding';
  static const home = '/';
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthRouterNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final userState = ref.read(currentUserProvider);

      // Aún cargando estado inicial → splash
      if (authState.isLoading) {
        return state.matchedLocation == AppRoutes.splash
            ? null
            : AppRoutes.splash;
      }

      final firebaseUser = authState.valueOrNull;
      final goingTo = state.matchedLocation;

      if (firebaseUser == null) {
        // Sin sesión → solo login disponible
        return goingTo == AppRoutes.login ? null : AppRoutes.login;
      }

      // Con sesión: revisamos si completó onboarding
      final user = userState.valueOrNull;
      if (userState.isLoading) {
        return goingTo == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final needsOnboarding = user == null || !user.hasCompletedOnboarding;

      if (needsOnboarding) {
        return goingTo == AppRoutes.onboarding ? null : AppRoutes.onboarding;
      }

      // Sesión + onboarding completo: bloquear /login, /onboarding, /splash
      if (goingTo == AppRoutes.login ||
          goingTo == AppRoutes.onboarding ||
          goingTo == AppRoutes.splash) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, __) => const MainShell(),
      ),
    ],
  );
});

/// Refresca el GoRouter cuando cambia el estado de auth o el doc de usuario.
class _AuthRouterNotifier extends ChangeNotifier {
  _AuthRouterNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, __) => notifyListeners());
    _ref.listen(currentUserProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
}
