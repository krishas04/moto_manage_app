import '../entities/vehicle.dart';

abstract class VehicleRepository{
  Future<List<VehicleEntity>> getVehicles();
  Future<List<VehicleEntity>> getVehiclesByOwner(String ownerId);
}