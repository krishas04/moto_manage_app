import 'package:moto_manage/features/vehicles_management/domain/entities/vehicle.dart';

class VehicleModel extends VehicleEntity{
  VehicleModel({
    super.id,
    required super.ownerId,
    required super.ownerUsername,
    required super.make,
    required super.model,
    required super.year,
    required super.vehicleType,
    super.fuelType,
    super.imageUrl
  });

  factory VehicleModel.fromJson(Map<String,dynamic> json){
    return VehicleModel(
      id: json['id'],
      ownerId: json['owner'],
      ownerUsername: json['owner_username'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      vehicleType: json['vehicle_type'] ?? 'two_wheeler',
      fuelType: json['fuel_type'] ?? 'petrol',
      imageUrl: json['image'],
    );
  }

  factory VehicleModel.fromEntity(VehicleEntity e) {
    return VehicleModel(
      id: e.id,
      ownerId: e.ownerId,
      ownerUsername: e.ownerUsername,
      make: e.make,
      model: e.model,
      year: e.year,
      vehicleType: e.vehicleType,
      fuelType: e.fuelType,
      imageUrl: e.imageUrl,
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
      imageUrl: imageUrl
    );
  }

  Map<String, String> toFormFields({bool includeOwner = true}) {
    final fields = <String, String>{
      'make': make,
      'model': model,
      'year': year.toString(),
      'vehicle_type': vehicleType,
      'fuel_type': fuelType,
    };
    if (includeOwner) fields['owner'] = ownerId.toString();
    return fields;
  }
}