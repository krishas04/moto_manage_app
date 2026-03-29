import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:moto_manage/features/owner_management/data/data_sources/owner_remote_data_source.dart';
import 'package:moto_manage/features/owner_management/data/repositories/owner_repository_impl.dart';
import 'package:moto_manage/features/owner_management/domain/repository_interfaces/owner_repository_interface.dart';
import 'package:moto_manage/features/owner_management/domain/usecases/create_owner_usecase.dart';
import 'package:moto_manage/features/owner_management/domain/usecases/get_owners_usecase.dart';
import 'package:moto_manage/features/vehicles_management/data/data_sources/vehicle_remote_data_source.dart';
import 'package:moto_manage/features/vehicles_management/data/repositories/vehicle_repository_impl.dart';
import 'package:moto_manage/features/vehicles_management/domain/repository_interfaces/vehicle_repository_interface.dart';
import 'package:moto_manage/features/vehicles_management/domain/usecases/get_vehicle_by_owner_usecase.dart';
import 'package:moto_manage/features/vehicles_management/domain/usecases/get_vehicles_usecase.dart';

import '../../features/owner_management/domain/usecases/update_owner_usecase.dart';

final getIt = GetIt.instance;

void registerOwnerFeature(){
  getIt.registerLazySingleton<OwnerRemoteDataSource>(
        ()=> OwnerRemoteDataSource(client: getIt<http.Client>()),
  );

  getIt.registerLazySingleton<OwnerRepository>(
        ()=> OwnerRepositoryImpl(getIt<OwnerRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetOwnersUseCase>(
        ()=> GetOwnersUseCase(getIt<OwnerRepository>()),
  );

  getIt.registerLazySingleton<CreateOwnerUseCase>(
        ()=> CreateOwnerUseCase(getIt<OwnerRepository>()),
  );

  getIt.registerLazySingleton<UpdateOwnerUseCase>(
        () => UpdateOwnerUseCase(getIt<OwnerRepository>()),
  );
}

void registerVehicleFeature(){
  getIt.registerLazySingleton<VehicleRemoteDataSource>(
        ()=> VehicleRemoteDataSource(client: getIt<http.Client>()),
  );

  getIt.registerLazySingleton<VehicleRepository>(
        ()=> VehicleRepositoryImpl(getIt<VehicleRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetVehiclesUseCase>(
        ()=> GetVehiclesUseCase(getIt<VehicleRepository>()),
  );

  getIt.registerLazySingleton<GetVehiclesByOwnerUseCase>(
        ()=> GetVehiclesByOwnerUseCase(getIt<VehicleRepository>()),
  );
}

void setupLocator(){
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  registerOwnerFeature();
  registerVehicleFeature();
}