import '../../domain/entities/auth_entity.dart';
import '../../../../core/utils/jwt_decoder.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.accessToken,
    required super.refreshToken,
    required super.role,
    required super.userId,
    required super.username,
  });

  factory AuthModel.fromTokenResponse(Map<String, dynamic> json) {
    final access = json['access'] as String;
    final refresh = json['refresh'] as String;
    final payload = JwtDecoder.decode(access);
    return AuthModel(
      accessToken: access,
      refreshToken: refresh,
      role: payload['role'] ?? 'user',
      userId: payload['user_id'] ?? 0,
      username: payload['username'] ?? '',
    );
  }
}