import 'package:moto_manage/features/owner_management/domain/entities/owner.dart';

class OwnerModel extends OwnerEntity{
    OwnerModel({
    super.id,
    required super.username,
    required super.email,
    super.phoneNumber,
    super.age,
    required super.firstName,
    required super.lastName,
    super.fullName,
    super.isActive,
    super.dateJoined,
    required super.mobileNumber,
    super.address,
    required super.gender,
    });

    //convert (Map)json to OwnerModel object
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
        dateJoined: json['date_joined'] != null
            ? DateTime.tryParse(json['date_joined'])
            : null,
        mobileNumber: json['mobile_number'],
        address: json['address'],
        gender:json['gender'],
        );
    }

    //convert an OwnerEntity object to an OwnerModel object
    factory OwnerModel.fromEntity(OwnerEntity entity){
        return OwnerModel(
        id: entity.id,
        username: entity.username,
        email: entity.email,
        phoneNumber: entity.phoneNumber,
        age: entity.age,
        firstName: entity.firstName,
        lastName: entity.lastName,
        fullName: entity.fullName,
        isActive: entity.isActive,
        dateJoined: entity.dateJoined,
        mobileNumber: entity.mobileNumber,
        address: entity.address,
        gender:entity.gender,
        );
    }

    // convert OwnerModel object to Map(Json)
    Map<String, dynamic> toJson(){
        return {
        "username": username,
        "email": email,
        "mobile_number": mobileNumber,
        "first_name": firstName,
        "last_name": lastName,
        "age": age,
        "gender": gender,
        };
    }
}