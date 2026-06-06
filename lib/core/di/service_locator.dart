import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:moto_manage/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:moto_manage/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:moto_manage/features/authentication/domain/repository_interfaces/auth_repository_interface.dart';
import 'package:moto_manage/features/authentication/domain/usecases/auth_usecase.dart';
import 'package:moto_manage/features/owner_management/data/data_sources/owner_remote_data_source.dart';
import 'package:moto_manage/features/owner_management/data/repositories/owner_repository_impl.dart';
import 'package:moto_manage/features/owner_management/domain/repository_interfaces/owner_repository_interface.dart';
import 'package:moto_manage/features/owner_management/domain/usecases/create_owner_usecase.dart';
import 'package:moto_manage/features/owner_management/domain/usecases/get_owners_usecase.dart';
import 'package:moto_manage/features/vehicles_management/data/data_sources/vehicle_remote_data_source.dart';
import 'package:moto_manage/features/vehicles_management/data/repositories/vehicle_repository_impl.dart';
import 'package:moto_manage/features/vehicles_management/domain/repository_interfaces/vehicle_repository_interface.dart';

// Import the Notifiers
import 'package:moto_manage/features/authentication/presentation/statemanagement/auth_notifier.dart';
import 'package:moto_manage/features/owner_management/presentation/state_management/owner_notifier.dart';
import 'package:moto_manage/features/vehicles_management/presentation/state_management/vehicles_notifier.dart';

import '../../features/insurance_management/data/data_sources/insurance_remote_data_source.dart';
import '../../features/insurance_management/data/repositories/insurance_repository_impl.dart';
import '../../features/insurance_management/domain/repository_interfaces/insurance_repository_interface.dart';
import '../../features/insurance_management/domain/usecases/insurance_usecases.dart';
import '../../features/owner_management/domain/usecases/update_owner_usecase.dart';
import '../../features/vehicles_management/domain/usecases/vehicles_usecase.dart';

final getIt = GetIt.instance;

void registerAuthFeature() {
  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSource(client: getIt<http.Client>()),
  );

  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
        () => LoginUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<RegisterUseCase>(
        () => RegisterUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<LogoutUseCase>(
        () => LogoutUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<RestoreSessionUseCase>(
        () => RestoreSessionUseCase(getIt<AuthRepository>()),
  );

  // --- REGISTER AUTH NOTIFIER ---
  getIt.registerLazySingleton<AuthNotifier>(() => AuthNotifier(
    loginUseCase: getIt(),
    registerUseCase: getIt(),
    logoutUseCase: getIt(),
    restoreSessionUseCase: getIt(),
  ));
}

void registerOwnerFeature() {
  getIt.registerLazySingleton<OwnerRemoteDataSource>(
        () => OwnerRemoteDataSource(client: getIt<http.Client>()),
  );

  getIt.registerLazySingleton<OwnerRepository>(
        () => OwnerRepositoryImpl(getIt<OwnerRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetOwnersUseCase>(
        () => GetOwnersUseCase(getIt<OwnerRepository>()),
  );

  getIt.registerLazySingleton<CreateOwnerUseCase>(
        () => CreateOwnerUseCase(getIt<OwnerRepository>()),
  );

  getIt.registerLazySingleton<UpdateOwnerUseCase>(
        () => UpdateOwnerUseCase(getIt<OwnerRepository>()),
  );

  // --- REGISTER OWNER NOTIFIER ---
  getIt.registerLazySingleton(() => OwnerNotifier(
    getOwnersUseCase: getIt(),
    createOwnerUseCase: getIt(),
    updateOwnerUseCase: getIt(),
  ));
}

void registerVehicleFeature() {
  getIt.registerLazySingleton<VehicleRemoteDataSource>(
        () => VehicleRemoteDataSource(client: getIt<http.Client>()),
  );

  getIt.registerLazySingleton<VehicleRepository>(
        () => VehicleRepositoryImpl(getIt<VehicleRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetVehiclesUseCase>(
        () => GetVehiclesUseCase(getIt<VehicleRepository>()),
  );

  getIt.registerLazySingleton<GetVehiclesByOwnerUseCase>(
        () => GetVehiclesByOwnerUseCase(getIt<VehicleRepository>()),
  );
  getIt.registerLazySingleton<GetVehicleByIdUseCase>(
        () => GetVehicleByIdUseCase(getIt<VehicleRepository>()),
  );
  getIt.registerLazySingleton(() => CreateVehicleUseCase(getIt<VehicleRepository>()));
  getIt.registerLazySingleton(() => UpdateVehicleUseCase(getIt<VehicleRepository>()));
  getIt.registerLazySingleton(() => DeleteVehicleUseCase(getIt<VehicleRepository>()));
  getIt.registerLazySingleton(() => GetMyVehiclesUseCase(getIt<VehicleRepository>()));
  getIt.registerLazySingleton(() => CreateMyVehicleUseCase(getIt<VehicleRepository>()));
  getIt.registerLazySingleton(() => UpdateMyVehicleUseCase(getIt<VehicleRepository>()));
  getIt.registerLazySingleton(() => DeleteMyVehicleUseCase(getIt<VehicleRepository>()));

  // --- REGISTER VEHICLE NOTIFIER ---
  getIt.registerLazySingleton(() => VehicleNotifier(
    getVehiclesUseCase: getIt(),
    getVehiclesByOwnerUseCase: getIt(),
    getVehicleByIdUseCase: getIt(),
    createVehicleUseCase: getIt(),
    updateVehicleUseCase: getIt(),
    deleteVehicleUseCase: getIt(),
    getMyVehiclesUseCase: getIt(),
    createMyVehicleUseCase: getIt(),
    updateMyVehicleUseCase: getIt(),
    deleteMyVehicleUseCase: getIt(),
  ));

  // ── Insurance ──────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<InsuranceRemoteDataSource>(
          () => InsuranceRemoteDataSource(client: getIt<http.Client>()));

  getIt.registerLazySingleton<InsuranceRepository>(
          () => InsuranceRepositoryImpl(getIt<InsuranceRemoteDataSource>()));

  getIt.registerLazySingleton(() => GetInsurancesUseCase(getIt<InsuranceRepository>()));
  getIt.registerLazySingleton(() => GetInsuranceByVehicleUseCase(getIt<InsuranceRepository>()));
  getIt.registerLazySingleton(() => CreateInsuranceUseCase(getIt<InsuranceRepository>()));
  getIt.registerLazySingleton(() => UpdateInsuranceUseCase(getIt<InsuranceRepository>()));
  getIt.registerLazySingleton(() => DeleteInsuranceUseCase(getIt<InsuranceRepository>()));
  getIt.registerLazySingleton(() => GetMyVehicleInsuranceUseCase(getIt<InsuranceRepository>()));
}

void setupLocator() {
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  registerOwnerFeature();
  registerVehicleFeature();
  registerAuthFeature();
}