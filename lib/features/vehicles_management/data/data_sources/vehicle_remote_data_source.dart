
import '../../../../core/api/api_constants.dart';
import '../../../../core/api/api_service.dart';
import '../models/vehicle_model.dart';


class VehicleRemoteDataSource extends BaseRemoteDataSource<VehicleModel>{
  VehicleRemoteDataSource({required super.client});

//Admin
  // Fetch All Vehicles
  Future<List<VehicleModel>> fetchVehicles(String token){
    return getList(
        endpoint: ApiConstants.vehicles,
        fromJson: (json)=>VehicleModel.fromJson(json),
        token: token,
    );
  }

  //fetch vehicles for a specific owner
  Future<List<VehicleModel>> fetchVehiclesByOwner(int ownerId, String token) async{
    return getList(
        endpoint: ApiConstants.vehiclesByUser(ownerId),
        fromJson: (json)=>VehicleModel.fromJson(json),
        token: token,
    );
  }

  Future<VehicleModel> fetchVehicleById(int id, String token) async {
    final json = await getSingle(
        endpoint: ApiConstants.vehicleById(id),
        token: token
    );
    return VehicleModel.fromJson(json);
  }

  Future<VehicleModel> createVehicle(VehicleModel vehicle, String token,
      {String? imagePath}) async {
    final json = await multipartPost(
      endpoint: ApiConstants.vehicles,
      fields: vehicle.toFormFields(),
      filePath: imagePath,
      fileFieldName: imagePath != null ? 'image' : null,
      token: token,
    );
    return VehicleModel.fromJson(json);
  }

  Future<VehicleModel> updateVehicle(VehicleModel vehicle, String token,
      {String? imagePath}) async {
    if (imagePath != null) {
      final json = await multipartPost(
        endpoint: ApiConstants.vehicleById(vehicle.id!),
        fields: vehicle.toFormFields(),
        filePath: imagePath,
        fileFieldName: 'image',
        token: token,
      );
      return VehicleModel.fromJson(json);
    }
    final json = await put(
      endpoint: ApiConstants.vehicleById(vehicle.id!),
      body: {
        'ownerId': vehicle.ownerId,
        'make': vehicle.make,
        'model': vehicle.model,
        'year': vehicle.year,
        'vehicle_type': vehicle.vehicleType,
        'fuel_type': vehicle.fuelType,
      },
      token: token,
    );
    return VehicleModel.fromJson(json);
  }

  Future<bool> deleteVehicle(int id, String token) =>
      delete(endpoint: ApiConstants.vehicleById(id), token: token);

// Regular user

  Future<List<VehicleModel>> fetchMyVehicles(String token) =>
      getList<VehicleModel>(
        endpoint: ApiConstants.mobileVehicles,
        fromJson: VehicleModel.fromJson,
        token: token,
      );

  Future<VehicleModel> fetchMyVehicleById(int id, String token) async {
    final json = await getSingle(
        endpoint: ApiConstants.mobileVehicleById(id), token: token);
    return VehicleModel.fromJson(json);
  }

  Future<VehicleModel> createMyVehicle(VehicleModel vehicle, String token,
      {String? imagePath}) async {
    final json = await multipartPost(
      endpoint: ApiConstants.mobileVehicles,
      fields: vehicle.toFormFields(includeOwner: false),
      filePath: imagePath,
      fileFieldName: imagePath != null ? 'image' : null,
      token: token,
    );
    return VehicleModel.fromJson(json);
  }

  Future<VehicleModel> updateMyVehicle(VehicleModel vehicle, String token,
      {String? imagePath}) async {
    if (imagePath != null) {
      final json = await multipartPost(
        endpoint: ApiConstants.mobileVehicleById(vehicle.id!),
        fields: vehicle.toFormFields(includeOwner: false),
        filePath: imagePath,
        fileFieldName: 'image',
        token: token,
      );
      return VehicleModel.fromJson(json);
    }
    final json = await patch(
      endpoint: ApiConstants.mobileVehicleById(vehicle.id!),
      body: {
        'make': vehicle.make,
        'model': vehicle.model,
        'year': vehicle.year,
        'vehicle_type': vehicle.vehicleType,
        'fuel_type': vehicle.fuelType,
      },
      token: token,
    );
    return VehicleModel.fromJson(json);
  }

  Future<bool> deleteMyVehicle(int id, String token) =>
      delete(endpoint: ApiConstants.mobileVehicleById(id), token: token);
}
