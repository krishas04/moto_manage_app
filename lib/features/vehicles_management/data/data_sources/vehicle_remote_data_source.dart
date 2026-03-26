
import '../../../../core/api/api_service.dart';
import '../models/vehicle_model.dart';


class VehicleRemoteDataSource extends BaseRemoteDataSource<VehicleModel>{
  VehicleRemoteDataSource({required super.client});

  // Fetch All Vehicles
  Future<List<VehicleModel>> fetchVehicles() async{
    return getList(
        endpoint: '/vehicles/',
        fromJson: (json)=>VehicleModel.fromJson(json));
  }

  //fetch vehicles for a specific owner
  Future<List<VehicleModel>> fetchVehiclesByOwner(String ownerId) async{
    return getList(
        endpoint: '/users/$ownerId/vehicles/',
        fromJson: (json)=>VehicleModel.fromJson(json));
  }

}