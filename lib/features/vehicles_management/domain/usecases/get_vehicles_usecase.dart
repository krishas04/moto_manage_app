import 'package:moto_manage/features/vehicles_management/domain/entities/vehicle.dart';
import 'package:moto_manage/features/vehicles_management/domain/repository_interfaces/vehicle_repository_interface.dart';

class GetVehiclesUseCase{
  final VehicleRepository vehicleRepository;

  GetVehiclesUseCase(this.vehicleRepository);

  Future<List<VehicleEntity>> call() async{
    return await vehicleRepository.getVehicles();
  }
}