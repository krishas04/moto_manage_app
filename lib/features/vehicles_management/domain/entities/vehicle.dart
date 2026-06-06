class VehicleEntity {
  final int? id;
  final int ownerId;
  final String ownerUsername;
  final String make;
  final String model;
  final int year;
  final String vehicleType;
  final String fuelType;
  final String? imageUrl;

  VehicleEntity({
    this.id,
    required this.ownerId,
    required this.ownerUsername,
    required this.make,
    required this.model,
    required this.year,
    required this.vehicleType,
    this.fuelType='petrol',
    this.imageUrl,
  });
  static const List<String> vehicleTypes = ['two_wheeler', 'four_wheeler', 'heavy'];
  static const List<String> fuelTypes = ['petrol', 'diesel', 'electric'];
}