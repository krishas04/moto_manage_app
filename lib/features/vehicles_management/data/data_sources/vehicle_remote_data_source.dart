import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:moto_manage/core/constants/api_constants.dart';

import '../models/vehicle_model.dart';



class VehicleRemoteDataSource{
  // Fetch All Vehicles
  Future<List<VehicleModel>> fetchVehiclesFromApi() async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/vehicles/'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => VehicleModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load vehicles");
    }
  }

  //fetch vehicles for a specific owner
  Future<List<VehicleModel>> fetchVehiclesByOwnerFromApi(String ownerId) async{
    final response= await http.get(Uri.parse('${ApiConstants.baseUrl}/users/$ownerId/vehicles/'));

    if(response.statusCode==200){
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => VehicleModel.fromJson(json)).toList();
    }else {
      throw Exception("Failed to load vehicles for owner $ownerId");
    }
  }
}