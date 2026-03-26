import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_constants.dart';

abstract class BaseRemoteDataSource<T>{
  final http.Client client;
  final String baseUrl;

  BaseRemoteDataSource({required this.client, this.baseUrl=ApiConstants.baseUrl});


  // fetches list from endpoint
  Future<List<T>> getList({
        required String endpoint,
        required T Function(Map<String, dynamic>) fromJson,
      }) async{
    final response = await client.get(Uri.parse('$baseUrl$endpoint'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<T>((item) => fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data from $endpoint');
    }
  }

  //create an object at endpoint and returns true
  Future<bool> post({
    required String endpoint,
    required Map<String, dynamic> body,
    }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
     return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      throw Exception('API Error at $endpoint: $e');
    }
  }

}