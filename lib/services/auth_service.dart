import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userNameKey = 'user_name';
  static const String _userIdKey = 'user_id';

  final ApiService _apiService = ApiService();

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final expiredAtStr = prefs.getString('jwt_expired_at');
    if (token == null || token.isEmpty) return false;
    if (expiredAtStr != null) {
      final expiredAt = DateTime.tryParse(expiredAtStr);
      if (expiredAt != null && DateTime.now().isAfter(expiredAt)) {
        await logout();
        return false;
      }
    }
    return true;
  }

  // Get stored token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Get user info
  Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_userNameKey),
      'id': prefs.getString(_userIdKey),
    };
  }

  // Login with API
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _apiService.post('/v1/auth/login', {
        'email': username,
        'password': password,
      });

      final ok = response['ok'] == true;
      final token = response['token'] as String?;
      final expiresIn = response['expires_in']; // detik

      if (ok) {
        final prefs = await SharedPreferences.getInstance();
        if (token != null) {
          await prefs.setString(_tokenKey, token);
        }
        await prefs.setString(_userNameKey, response['user']?['name'] ?? username);
        await prefs.setString(_userIdKey, response['user']?['id']?.toString() ?? '');
        // Simpan waktu expired
        if (expiresIn != null && expiresIn is int) {
          final expiredAt = DateTime.now().add(Duration(seconds: expiresIn));
          await prefs.setString('jwt_expired_at', expiredAt.toIso8601String());
        }
        return {'success': true, 'message': response['message'] ?? 'Login successful'};
      }

      return {'success': false, 'message': response['message'] ?? 'Login failed'};
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        return {'success': false, 'message': 'Invalid username or password'};
      } else if (e.statusCode == 422) {
        return {'success': false, 'message': 'Validation error'};
      }
      return {'success': false, 'message': 'Connection error'};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userIdKey);
    await prefs.remove('jwt_expired_at');
  }
}
