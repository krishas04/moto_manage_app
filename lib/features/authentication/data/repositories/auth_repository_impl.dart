import '../../domain/entities/auth_entity.dart';
import '../../domain/repository_interfaces/auth_repository_interface.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_model.dart';
import '../../../../core/utils/token_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<AuthEntity> login({required String username, required String password}) async {
    final auth = await _dataSource.login(username: username, password: password);
    await TokenStorage.saveTokens(
      access: auth.accessToken,
      refresh: auth.refreshToken,
      role: auth.role,
      userId: auth.userId,
      username: auth.username,
    );
    return auth;
  }

  @override
  Future<void> register({required Map<String, dynamic> data}) async {
    await _dataSource.register(data);
  }

  @override
  Future<void> logout() async {
    await TokenStorage.clear();
  }

  @override
  Future<AuthEntity?> restoreSession() async {
    final access = await TokenStorage.getAccessToken();
    if (access == null) return null;
    final refresh = await TokenStorage.getRefreshToken();
    final role = await TokenStorage.getRole();
    final userId = await TokenStorage.getUserId();
    final username = await TokenStorage.getUsername();
    if (role == null || userId == null || username == null) return null;
    return AuthModel(
      accessToken: access,
      refreshToken: refresh ?? '',
      role: role,
      userId: userId,
      username: username,
    );
  }
}