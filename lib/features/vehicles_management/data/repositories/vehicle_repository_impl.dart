import 'package:moto_manage/features/vehicles_management/domain/repository_interfaces/vehicle_repository_interface.dart';
import '../../domain/entities/vehicle.dart';
import '../data_sources/vehicle_remote_data_source.dart';

class VehicleRepositoryImpl implements VehicleRepository{
  final VehicleRemoteDataSource vehicleRemoteDataSource;

  VehicleRepositoryImpl(this.vehicleRemoteDataSource);

  @override
  Future<List<VehicleEntity>> getVehicles() async{
    final vehicleModels = await vehicleRemoteDataSource.fetchVehicles();
    return vehicleModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<VehicleEntity>> getVehiclesByOwner(String ownerId) async{
    final vehicleModels = await vehicleRemoteDataSource.fetchVehiclesByOwner(ownerId);
    return vehicleModels.map((model) => model.toEntity()).toList();
  }
}