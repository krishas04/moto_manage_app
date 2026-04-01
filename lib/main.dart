import 'package:flutter/material.dart';
import 'package:moto_manage/core/constants/app_colors.dart';
import 'package:provider/provider.dart';

import 'config/Router/router.dart';
import 'core/di/service_locator.dart';
import 'features/authentication/domain/usecases/auth_usecase.dart';
import 'features/authentication/presentation/statemanagement/auth_notifier.dart';
import 'features/owner_management/domain/usecases/create_owner_usecase.dart';
import 'features/owner_management/domain/usecases/get_owners_usecase.dart';
import 'features/owner_management/domain/usecases/update_owner_usecase.dart';
import 'features/owner_management/presentation/state_management/owner_notifier.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        //auth
        ChangeNotifierProvider(
          create: (_) => AuthNotifier(
            loginUseCase: getIt<LoginUseCase>(),
            registerUseCase: getIt<RegisterUseCase>(),
            logoutUseCase: getIt<LogoutUseCase>(),
            restoreSessionUseCase: getIt<RestoreSessionUseCase>(),
          )..restoreSession(),
        ),

        // Owner
        ChangeNotifierProvider(
          create: (_) => OwnerNotifier(
            getOwnersUseCase: getIt<GetOwnersUseCase>(),
            createOwnerUseCase: getIt<CreateOwnerUseCase>(),
            updateOwnerUseCase: getIt<UpdateOwnerUseCase>(),
          ),
        ),


      ],
      child: MaterialApp.router(
        title: 'Moto Manage',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
           colorScheme: ColorScheme.fromSeed(seedColor: AppColors.bluishWhite),
          fontFamily: 'Outfit',
        ),
        routerConfig: router,
      ),
    );
  }
}

