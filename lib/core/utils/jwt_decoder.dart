import 'dart:convert';

class JwtDecoder {
  static Map<String, dynamic> decode(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) throw Exception('Invalid JWT');
      final payload = parts[1];
      // Add padding if needed
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      return jsonDecode(decoded);
    } catch (_) {
      return {};
    }
  }

  static String? getRole(String token) => decode(token)['role'];
  static int? getUserId(String token) => decode(token)['user_id'];
  static String? getUsername(String token) => decode(token)['username'];

  static bool isExpired(String token) {
    try {
      final payload = decode(token);

      if (!payload.containsKey('exp')) return true;

      final exp = payload['exp']; // usually in seconds
      final expiryDate =
      DateTime.fromMillisecondsSinceEpoch(exp * 1000);

      return DateTime.now().isAfter(expiryDate);
    } catch (_) {
      return true; // treat errors as expired
    }
  }
}