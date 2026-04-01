class OwnerEntity {
  final int? id;
  final String username;
  final String email;
  final String phoneNumber;
  final int? age;
  final String firstName;
  final String lastName;
  final String? fullName;
  final bool? isActive;
  final DateTime? dateJoined;
  final String? mobileNumber;
  final String? address;
  final String gender;

  OwnerEntity({
    this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.age,
    required this.firstName,
    required this.lastName,
    this.fullName,
    this.isActive,
    this.dateJoined,
    this.mobileNumber,
    this.address,
    required this.gender,
  });
}