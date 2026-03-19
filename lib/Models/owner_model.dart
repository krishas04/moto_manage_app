class OwnerModel{
  final int id;
  final String username;
  final String email;
  final String phoneNumber;
  final int age;
  final String firstName;
  final String lastName;
  final String fullName;
  final bool isActive;
  final DateTime dateJoined;
  final String mobileNumber;
  final String? address;

  OwnerModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.age,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.isActive,
    required this.dateJoined,
    required this.mobileNumber,
    this.address,
  });

  //convert json to OwnerModel object
  factory OwnerModel.fromJson(Map<String,dynamic> json){
    return OwnerModel(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        phoneNumber: json['phone_number'],
        age: json['age'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        fullName: json['full_name'],
        isActive: json['is_active'],
        dateJoined: DateTime.parse(json['date_joined']),
        mobileNumber: json['mobile_number'],
        address: json['address'],
    );
  }
}