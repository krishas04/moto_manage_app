import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_manage/features/authentication/presentation/statemanagement/auth_notifier.dart';
import 'package:moto_manage/features/authentication/presentation/pages/login_screen.dart';
import 'package:moto_manage/features/authentication/presentation/pages/register_screen.dart';
import 'package:moto_manage/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:moto_manage/features/dashboard/presentation/pages/profile_screen.dart';
import 'package:moto_manage/features/owner_management/presentation/pages/owner_screen.dart';
import 'package:moto_manage/features/owner_management/presentation/pages/create_owner_screen.dart';
import 'package:moto_manage/features/owner_management/presentation/pages/update_owner_screen.dart';
import 'package:moto_manage/features/vehicles_management/presentation/pages/vehicles_screen.dart';
import 'package:moto_manage/features/vehicles_management/presentation/pages/create_vehicle_screen.dart';
import 'package:moto_manage/features/vehicles_management/presentation/pages/vehicles_by_owner_screen.dart';
import 'package:moto_manage/features/authentication/presentation/pages/admin_shell.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _adminShellKey = GlobalKey<NavigatorState>();

GoRouter createRouter(AuthNotifier authNotifier) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/login',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isAuth = authNotifier.isAuthenticated;
      final loc = state.matchedLocation;
      final isAuthRoute = loc == '/login' || loc == '/register';

      if (!isAuth && !isAuthRoute) return '/login';
      if (isAuth && isAuthRoute) return '/dashboard';

      return null;
    },
    routes: [
      // --- Public Routes ---
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),

      // --- Admin Shell ---
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootKey,
        builder: (context, state, shell) => AdminShell(navigationShell: shell),
        branches: [

          // TAB 0: DASHBOARD
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: '/dashboard',
                  builder: (_, __) => const DashboardScreen()
              ),
            ],
          ),

          // TAB 1: OWNERS
          StatefulShellBranch(
            // navigatorKey: _adminShellKey,
            routes: [
              GoRoute(
                path: '/owners',
                builder: (_, __) => const OwnerScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    parentNavigatorKey: _rootKey,
                    builder: (_, __) => const CreateOwnerScreen(),
                  ),
                  GoRoute(
                    path: 'edit/:ownerId',
                    parentNavigatorKey: _rootKey,
                    builder: (_, state) => UpdateOwnerScreen(ownerId: state.pathParameters['ownerId']!),
                  ),
                ],
              ),
            ],
          ),

          // TAB 2: VEHICLES
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/vehicles',
                builder: (_, __) => const VehiclesScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    parentNavigatorKey: _rootKey,
                    builder: (_, __) => const CreateVehicleScreen(),
                  ),
                  GoRoute(
                    path: ':ownerId',
                    parentNavigatorKey: _rootKey,
                    builder: (_, state) {
                      final id = int.tryParse(state.pathParameters['ownerId'] ?? '');
                      return id == null
                          ? const Scaffold(body: Center(child: Text("Invalid ID")))
                          : VehiclesByOwnerScreen(ownerId: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          // TAB 3: PROFILE
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: '/profile',
                  builder: (_, __) => ProfileScreen()
              ),
            ],
          ),
        ],
      ),
    ],
  );
}