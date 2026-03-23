class VehicleEntity {
  final int id;
  final int ownerId;
  final String ownerUsername;
  final String make;
  final String model;
  final int year;
  final String vehicleType;
  final String fuelType;

  VehicleEntity({
    required this.id,
    required this.ownerId,
    required this.ownerUsername,
    required this.make,
    required this.model,
    required this.year,
    required this.vehicleType,
    required this.fuelType,
  });
}