import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:moto_manage/core/constants/api_constants.dart';

import '../models/owner_model.dart';

class OwnerRemoteDataSource{

  // fetch all users
  Future<List<OwnerModel>> fetchOwnersFromAPi() async{
    final response=await http.get(Uri.parse('${ApiConstants.baseUrl}/users/'));

    if(response.statusCode==200){
      // json string -> dart object
      List<dynamic> data=jsonDecode(response.body);
      //dart object -> OwnerModel
      return data.map((json)=>OwnerModel.fromJson(json)).toList();
    }else{
      throw Exception('Failed to load users');
    }
  }

  //create owner
  Future<bool> createOwnerFromApi(OwnerModel owner) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/users/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(owner.toJson()),
      );

      return response.statusCode == 201;
    } catch (e) {
      throw Exception('API Error: $e');
    }
  }

}