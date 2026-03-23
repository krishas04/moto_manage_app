import 'package:moto_manage/features/vehicles_management/domain/entities/vehicle.dart';

class VehicleModel extends VehicleEntity{
  VehicleModel({
    required super.id,
    required super.ownerId,
    required super.ownerUsername,
    required super.make,
    required super.model,
    required super.year,
    required super.vehicleType,
    required super.fuelType,
  });

  factory VehicleModel.fromJson(Map<String,dynamic> json){
    return VehicleModel(
      id: json['id'],
      ownerId: json['owner'],
      ownerUsername: json['owner_username'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      vehicleType: json['vehicle_type'],
      fuelType: json['fuel_type'],
    );
  }

  //to convert VehicleModel to VehicleEntity
   VehicleEntity toEntity(){
    return VehicleEntity(
      id: id,
      ownerId: ownerId,
      ownerUsername: ownerUsername,
      make: make,
      model: model,
      year: year,
      vehicleType: vehicleType,
      fuelType: fuelType,
    );
  }
}