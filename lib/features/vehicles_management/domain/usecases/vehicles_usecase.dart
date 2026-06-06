import '../entities/vehicle.dart';
import '../repository_interfaces/vehicle_repository_interface.dart';

// Admin use cases

  class GetVehiclesUseCase{
    final VehicleRepository vehicleRepository;

    GetVehiclesUseCase(this.vehicleRepository);

    Future<List<VehicleEntity>> call(String token) async{
      return await vehicleRepository.getVehicles(token);
    }
  }

  class GetVehiclesByOwnerUseCase{
    final VehicleRepository vehicleRepository;

    GetVehiclesByOwnerUseCase(this.vehicleRepository);

    Future<List<VehicleEntity>> call(int ownerId, String token) async{
      return await vehicleRepository.getVehiclesByOwner(ownerId,token);
    }
  }

  class GetVehicleByIdUseCase{
    final VehicleRepository vehicleRepository;
    GetVehicleByIdUseCase(this.vehicleRepository);

    Future<VehicleEntity> call(int vehicleId, String token) async{
      return await vehicleRepository.getVehicleById(vehicleId,token);
    }
  }

  class CreateVehicleUseCase{
    final VehicleRepository vehicleRepository;
    CreateVehicleUseCase(this.vehicleRepository);

    Future<VehicleEntity> call(VehicleEntity vehicle, String token, {String? imagePath}) async{
      return await vehicleRepository.createVehicle(vehicle,token,imagePath: imagePath);
    }
  }

  class UpdateVehicleUseCase{
    final VehicleRepository vehicleRepository;
    UpdateVehicleUseCase(this.vehicleRepository);

    Future<VehicleEntity> call(VehicleEntity vehicle, String token, {String? imagePath}) async{
      return await vehicleRepository.updateVehicle(vehicle,token,imagePath:imagePath);
    }
  }
  class DeleteVehicleUseCase {
    final VehicleRepository vehicleRepository;

    DeleteVehicleUseCase(this.vehicleRepository);

    Future<bool> call(int id, String token) async {
      return await vehicleRepository.deleteVehicle(id, token);
    }
  }


  // Regular user usecases

  class GetMyVehiclesUseCase{
    final VehicleRepository vehicleRepository;

    GetMyVehiclesUseCase(this.vehicleRepository);

    Future<List<VehicleEntity>> call(String token) async{
      return await vehicleRepository.getMyVehicles(token);
    }
  }

  class GetMyVehicleByIdUseCase{
    final VehicleRepository vehicleRepository;
    GetMyVehicleByIdUseCase(this.vehicleRepository);

    Future<VehicleEntity> call(int vehicleId, String token) async{
      return await vehicleRepository.getMyVehicleById(vehicleId, token);
    }
  }

  class CreateMyVehicleUseCase{
    final VehicleRepository vehicleRepository;
    CreateMyVehicleUseCase(this.vehicleRepository);

    Future<VehicleEntity> call(VehicleEntity vehicle, String token, {String? imagePath}) async{
      return await vehicleRepository.createMyVehicle(vehicle,token,imagePath: imagePath);
    }
  }

  class UpdateMyVehicleUseCase{
    final VehicleRepository vehicleRepository;
    UpdateMyVehicleUseCase(this.vehicleRepository);

    Future<VehicleEntity> call(VehicleEntity vehicle, String token, {String? imagePath}) async{
      return await vehicleRepository.updateMyVehicle(vehicle,token,imagePath:imagePath);
    }
  }
  class DeleteMyVehicleUseCase {
    final VehicleRepository vehicleRepository;

    DeleteMyVehicleUseCase(this.vehicleRepository);

    Future<bool> call(int id, String token) async {
      return await vehicleRepository.deleteMyVehicle(id, token);
    }
  }