import '../entities/vehicle.dart';
import '../repository_interfaces/vehicle_repository_interface.dart';

class GetVehiclesByOwnerUseCase{
  final VehicleRepository vehicleRepository;

  GetVehiclesByOwnerUseCase(this.vehicleRepository);

  Future<List<VehicleEntity>> call(String ownerId) async{
    return await vehicleRepository.getVehiclesByOwner(ownerId);
  }
}