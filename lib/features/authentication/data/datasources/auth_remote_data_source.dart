import '../../../../core/api/api_service.dart';
import '../../../../core/api/api_constants.dart';
import '../models/auth_model.dart';

class AuthRemoteDataSource extends BaseRemoteDataSource {
  AuthRemoteDataSource({required super.client});

  Future<AuthModel> login({required String username, required String password}) async {
    final data = await post(
      endpoint: ApiConstants.login,
      body: {'username': username, 'password': password},
    );
    return AuthModel.fromTokenResponse(data);
  }

  Future<void> register(Map<String, dynamic> body) async {
    await post(endpoint: ApiConstants.register, body: body);
  }
}