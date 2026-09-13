import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  // Convenience Helpers
  // ============================================================

  // Login response থেকে access + refresh একসাথে সেভ করার জন্য
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await saveToken(accessToken);
    await saveRefreshToken(refreshToken);
  }

  // Logout / refresh-token-expired হলে সব টোকেন মুছে ফেলার জন্য
  static Future<void> clearTokens() async {
    await deleteToken();
    await deleteRefreshToken();
  }
}