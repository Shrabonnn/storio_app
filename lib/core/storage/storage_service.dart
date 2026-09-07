import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // access token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: "token", value: token);
  }


  static Future<String?> getToken() async {
    return await _storage.read(key: "token");
  }

  // Refresh Token
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(
      key: "refresh_token",
      value: token,
    );
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: "refresh_token");
  }

  //delete token
  static Future<void> deleteToken() async {
    await _storage.delete(key: "token");
  }
}