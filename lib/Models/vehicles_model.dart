class VehicleModel{
  final int id;
  final int ownerId;
  final String ownerUsername;
  final String make;
  final String model;
  final int year;
  final String vehicleType;
  final String fuelType;

  VehicleModel({
    required this.id,
    required this.ownerId,
    required this.ownerUsername,
    required this.make,
    required this.model,
    required this.year,
    required this.vehicleType,
    required this.fuelType,
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
}