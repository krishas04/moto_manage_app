import '../entities/vehicle.dart';

abstract class VehicleRepository{
  // Admin
  Future<List<VehicleEntity>> getVehicles(String token);

  Future<List<VehicleEntity>> getVehiclesByOwner(int ownerId,String token);
  Future<VehicleEntity> getVehicleById(int id, String token);
  Future<VehicleEntity> createVehicle(VehicleEntity vehicle, String token, {String? imagePath});
  Future<VehicleEntity> updateVehicle(VehicleEntity vehicle, String token, {String? imagePath});
  Future<bool> deleteVehicle(int id, String token);

  // Regular user
  Future<List<VehicleEntity>> getMyVehicles(String token);
  Future<VehicleEntity> getMyVehicleById(int id, String token);
  Future<VehicleEntity> createMyVehicle(VehicleEntity vehicle, String token, {String? imagePath});
  Future<VehicleEntity> updateMyVehicle(VehicleEntity vehicle, String token, {String? imagePath});
  Future<bool> deleteMyVehicle(int id, String token);
}