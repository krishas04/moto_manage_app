import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_constants.dart';

abstract class BaseRemoteDataSource<T>{
  final http.Client client;
  final String baseUrl;

  BaseRemoteDataSource({required this.client, this.baseUrl=ApiConstants.baseUrl});


  Map<String, String> _authHeaders(String? token) {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<List<T>> getList<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    String? token,
  }) async {
    final response = await client.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _authHeaders(token),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map<T>((item) => fromJson(item)).toList();
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  Future<Map<String, dynamic>> getSingle({
    required String endpoint,
    String? token,
  }) async {
    final response = await client.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _authHeaders(token),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _authHeaders(token),
      body: jsonEncode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  Future<Map<String, dynamic>> put({
    required String endpoint,
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final response = await client.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _authHeaders(token),
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  Future<Map<String, dynamic>> patch({
    required String endpoint,
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final response = await client.patch(
      Uri.parse('$baseUrl$endpoint'),
      headers: _authHeaders(token),
      body: jsonEncode(body),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  Future<bool> delete({
    required String endpoint,
    String? token,
  }) async {
    final response = await client.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _authHeaders(token),
    );
    if (response.statusCode == 204 || response.statusCode == 200) {
      return true;
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

  /// Multipart POST for image uploads
  Future<Map<String, dynamic>> multipartPost({
    required String endpoint,
    required Map<String, String> fields,
    String? filePath,
    String? fileFieldName,
    String? token,
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'));
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.fields.addAll(fields);
    if (filePath != null && fileFieldName != null) {
      request.files.add(await http.MultipartFile.fromPath(fileFieldName, filePath));
    }
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw ApiException(response.statusCode, response.body);
    }
  }

}

class ApiException implements Exception {
  final int statusCode;
  final String body;

  ApiException(this.statusCode, this.body);

  String get message {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map) {
        // Flatten field errors into a single readable string
        final errors = decoded.entries.map((e) {
          final val = e.value;
          if (val is List) return '${e.key}: ${val.join(', ')}';
          return '${e.key}: $val';
        }).join('\n');
        return errors;
      }
      return decoded.toString();
    } catch (_) {
      return 'Error $statusCode: $body';
    }
  }

  @override
  String toString() => message;
}