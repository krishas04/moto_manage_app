import 'package:flutter/material.dart';
import 'package:moto_manage/core/constants/app_colors.dart';
import 'package:moto_manage/features/vehicles_management/presentation/state_management/vehicles_notifier.dart';
import 'package:provider/provider.dart';

import 'config/Router/router.dart';
import 'core/di/service_locator.dart';
import 'features/authentication/presentation/statemanagement/auth_notifier.dart';
import 'features/owner_management/presentation/state_management/owner_notifier.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator(); // Registers everything in GetIt
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Get the singletons already created by GetIt
    final authNotifier = getIt<AuthNotifier>();
    final ownerNotifier = getIt<OwnerNotifier>();
    final vehicleNotifier = getIt<VehicleNotifier>();

    // 2. Initialize the router with the authNotifier from GetIt
    final router = createRouter(authNotifier);

    return MultiProvider(
      providers: [
        // 3. Use .value to provide the GetIt singletons to the UI
        ChangeNotifierProvider.value(value: authNotifier..restoreSession()),
        ChangeNotifierProvider.value(value: ownerNotifier),
        ChangeNotifierProvider.value(value: vehicleNotifier),
      ],
      child: MaterialApp.router(
        title: 'Moto Manage',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.background),
          fontFamily: 'Outfit',
        ),
        routerConfig: router,
      ),
    );
  }
}