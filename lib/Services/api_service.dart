import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:moto_manage/Models/owner_model.dart';

import '../Models/vehicles_model.dart';

class ApiService{
  final String baseUrl = "http://192.168.101.4:8000/api";

  // fetch all users
  Future<List<OwnerModel>> getOwners() async{
    final response=await http.get(Uri.parse('$baseUrl/users'));

    if(response.statusCode==200){
      // json string -> dart object
      List<dynamic> data=jsonDecode(response.body);
      //dart object -> OwnerModel
      return data.map((json)=>OwnerModel.fromJson(json)).toList();
    }else{
      throw Exception('Failed to load users');
    }
  }

  // Fetch All Vehicles
  Future<List<VehicleModel>> getVehicles() async {
    final response = await http.get(Uri.parse('$baseUrl/vehicles/'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => VehicleModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load vehicles");
    }
  }
}