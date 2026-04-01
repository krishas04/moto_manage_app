class AuthEntity {
  final String accessToken;
  final String refreshToken;
  final String role; // 'admin' or 'user'
  final int userId;
  final String username;

  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.userId,
    required this.username,
  });

  bool get isAdmin => role == 'admin';
}