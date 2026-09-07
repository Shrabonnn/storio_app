import 'package:flutter/material.dart';
import 'package:storio_app/data/repository/auth_repository.dart';

import '../../core/storage/storage_service.dart';

class AuthViewModel extends ChangeNotifier{

  final _myRepo = AuthRepository();
  bool loading = false;

  Future<String?> loginApi(dynamic data) async {
    loading = true;
    notifyListeners();

    try {
      final response = await _myRepo.loginApi(data);

      final token = response["access"];
      final refreshToken = response["refresh"];

      if (token == null || refreshToken == null) {
        return "Login failed. Invalid response from server.";
      }

      await TokenStorage.saveToken(token);
      await TokenStorage.saveRefreshToken(refreshToken);

      print(token);
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}