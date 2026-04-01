import '../entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> login({required String username, required String password});
  Future<void> register({required Map<String, dynamic> data});
  Future<void> logout();
  Future<AuthEntity?> restoreSession();
}