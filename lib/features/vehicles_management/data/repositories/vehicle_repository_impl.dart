import 'package:moto_manage/features/vehicles_management/domain/repository_interfaces/vehicle_repository_interface.dart';
import '../../domain/entities/vehicle.dart';
import '../data_sources/vehicle_remote_data_source.dart';
import '../models/vehicle_model.dart';

class VehicleRepositoryImpl implements VehicleRepository{
  final VehicleRemoteDataSource vehicleRemoteDataSource;

  VehicleRepositoryImpl(this.vehicleRemoteDataSource);

// admin methods
  @override
  Future<List<VehicleEntity>> getVehicles(String token) async{
    final vehicleModels = await vehicleRemoteDataSource.fetchVehicles(token);
    return vehicleModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<VehicleEntity>> getVehiclesByOwner(int ownerId, String token) async{
    final vehicleModels = await vehicleRemoteDataSource.fetchVehiclesByOwner(ownerId, token);
    return vehicleModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<VehicleEntity> getVehicleById(int id, String token) async{
    final vehicleModel = await vehicleRemoteDataSource.fetchVehicleById(id, token);
    return vehicleModel.toEntity();
  }

  @override
  Future<VehicleEntity> createVehicle(VehicleEntity vehicle, String token, {String? imagePath}) async {
    final vehicleModel = VehicleModel.fromEntity(vehicle);
    final createdModel = await vehicleRemoteDataSource.createVehicle(vehicleModel, token, imagePath: imagePath);
    return createdModel.toEntity();
  }

  @override
  Future<VehicleEntity> updateVehicle(VehicleEntity vehicle, String token, {String? imagePath}) async {
    final vehicleModel = VehicleModel.fromEntity(vehicle);
    final updatedModel = await vehicleRemoteDataSource.updateVehicle(vehicleModel, token, imagePath: imagePath);
    return updatedModel.toEntity();
  }

  @override
  Future<bool> deleteVehicle(int id, String token) async {
    return await vehicleRemoteDataSource.deleteVehicle(id, token);
  }

  //Regular user methods
  @override
  Future<List<VehicleEntity>> getMyVehicles(String token) async {
    final vehicleModels = await vehicleRemoteDataSource.fetchMyVehicles(token);
    return vehicleModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<VehicleEntity> getMyVehicleById(int id, String token) async {
    final vehicleModel = await vehicleRemoteDataSource.fetchMyVehicleById(id, token);
    return vehicleModel.toEntity();
  }

  @override
  Future<VehicleEntity> createMyVehicle(VehicleEntity vehicle, String token, {String? imagePath}) async {
    final vehicleModel = VehicleModel.fromEntity(vehicle);
    final createdModel = await vehicleRemoteDataSource.createMyVehicle(vehicleModel, token, imagePath: imagePath);
    return createdModel.toEntity();
  }

  @override
  Future<VehicleEntity> updateMyVehicle(VehicleEntity vehicle, String token, {String? imagePath}) async {
    final vehicleModel = VehicleModel.fromEntity(vehicle);
    final updatedModel = await vehicleRemoteDataSource.updateMyVehicle(vehicleModel, token, imagePath: imagePath);
    return updatedModel.toEntity();
  }

  @override
  Future<bool> deleteMyVehicle(int id, String token) async {
    return await vehicleRemoteDataSource.deleteMyVehicle(id, token);
  }
}