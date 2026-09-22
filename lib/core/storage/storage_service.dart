import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/model/Auth/user_model.dart';
class TokenStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // ============================================================
  // Access Token
  // ============================================================
  static Future<void> saveToken(String token) async {
    await _storage.write(key: "token", value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: "token");
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: "token");
  }

  // ============================================================
  // Refresh Token
  // ============================================================
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(
      key: "refresh_token",
      value: token,
    );
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: "refresh_token");
  }

  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: "refresh_token");
  }

  // ============================================================
  // User Data Storage
  // ============================================================
  static Future<void> saveUser(UserModel user) async {
    final jsonString = jsonEncode(user.toJson());
    await _storage.write(key: "user_data", value: jsonString);
  }

  static Future<UserModel?> getUser() async {
    final jsonString = await _storage.read(key: "user_data");
    if (jsonString != null && jsonString.isNotEmpty) {
      return UserModel.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  static Future<void> deleteUser() async {
    await _storage.delete(key: "user_data");
  }

  // ============================================================
  // Convenience Helpers
  // ============================================================

  // Login response থ
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await saveToken(accessToken);
    await saveRefreshToken(refreshToken);
  }

  // Logout / refresh-token-expired
  static Future<void> clearTokens() async {
    await deleteToken();
    await deleteRefreshToken();
    await deleteUser();
  }
}