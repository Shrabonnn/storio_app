import 'dart:io';
import 'package:flutter/material.dart';

import '../../core/storage/storage_service.dart';
import '../../data/model/Auth/user_model.dart';
import '../../data/repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final _myRepo = AuthRepository();

  bool _loading = false;
  bool get loading => _loading;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  List<UserModel> _userList = [];
  List<UserModel> get userList => _userList;

  List<RoleModel> _roleList = [];
  List<RoleModel> get roleList => _roleList;

  // ------------------------------------------------------------
  // Check Login Status on App Start
  // ------------------------------------------------------------
  Future<void> checkLoginStatus() async {
    _setLoading(true);

    final token = await TokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      _isLoggedIn = true;
      _currentUser = await TokenStorage.getUser();
    } else {
      _isLoggedIn = false;
      _currentUser = null;
    }

    _setLoading(false);
  }

  // ------------------------------------------------------------
  // 1. Login API
  // ------------------------------------------------------------
  Future<String?> loginApi(LoginRequestModel request) async {
    _setLoading(true);

    try {
      final response = await _myRepo.loginApi(request);
      final token = response["access"] as String?;
      final refreshToken = response["refresh"] as String?;
      final userJson = response["user"];

      if (token == null || refreshToken == null) {
        return "Login failed. Invalid tokens from server.";
      }

      await TokenStorage.saveTokens(
        accessToken: token,
        refreshToken: refreshToken,
      );

      if (userJson != null) {
        _currentUser = UserModel.fromJson(userJson);
        await TokenStorage.saveUser(_currentUser!);
      }

      _isLoggedIn = true;
      return null; // Success
    } catch (e) {
      debugPrint("Login Error: $e");
      return _parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ------------------------------------------------------------
  // 2. Logout API
  // ------------------------------------------------------------
  Future<void> logoutApi() async {
    _setLoading(true);

    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _myRepo.logoutApi(refreshToken);
      }
    } catch (e) {
      debugPrint("Logout Error: $e");
    } finally {
      await TokenStorage.clearTokens();
      _currentUser = null;
      _isLoggedIn = false;
      _setLoading(false);
    }
  }

  // ------------------------------------------------------------
  // 3. Register User API (Superuser Only)
  // ------------------------------------------------------------
  Future<String?> registerUserApi(CreateUserRequestModel request) async {
    _setLoading(true);

    try {
      await _myRepo.createUserApi(request);
      return null; // Success
    } catch (e) {
      debugPrint("Register Error: $e");
      return _parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ------------------------------------------------------------
  // 4. List Users API
  // ------------------------------------------------------------
  Future<String?> fetchUsersApi() async {
    _setLoading(true);

    try {
      _userList = await _myRepo.getUsersApi();
      return null; // Success
    } catch (e) {
      debugPrint("Fetch Users Error: $e");
      return _parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ------------------------------------------------------------
  // 5. Get User Detail API
  // ------------------------------------------------------------
  Future<UserModel?> getUserDetailApi(int userId) async {
    _setLoading(true);

    try {
      return await _myRepo.getUserDetailApi(userId);
    } catch (e) {
      debugPrint("User Detail Error: $e");
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // ------------------------------------------------------------
  // 6. Update User API (User Management)
  // ------------------------------------------------------------
  Future<String?> updateUserApi(int userId, Map<String, dynamic> data) async {
    _setLoading(true);

    try {
      final response = await _myRepo.updateUserApi(userId, data);

      if (response != null && response["user"] != null) {
        final updatedUser = UserModel.fromJson(response["user"]);

        final index = _userList.indexWhere((u) => u.id == userId);
        if (index != -1) {
          _userList[index] = updatedUser;
        }

        if (_currentUser?.id == userId) {
          _currentUser = updatedUser;
          await TokenStorage.saveUser(updatedUser);
        }
        return null; // Success
      }
      return response?["message"] ?? "Failed to update user";
    } catch (e) {
      debugPrint("Update User Error: $e");
      return _parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ------------------------------------------------------------
  // 7. Delete User API
  // ------------------------------------------------------------
  Future<String?> deleteUserApi(int userId) async {
    _setLoading(true);

    try {
      await _myRepo.deleteUserApi(userId);
      _userList.removeWhere((user) => user.id == userId);
      return null; // Success
    } catch (e) {
      debugPrint("Delete User Error: $e");
      return _parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ------------------------------------------------------------
  // 8. Assign Role API
  // ------------------------------------------------------------
  Future<String?> assignRoleApi(int userId, int? groupId) async {
    _setLoading(true);

    try {
      await _myRepo.assignRoleApi(userId, groupId);
      await fetchUsersApi(); // Refresh list
      return null; // Success
    } catch (e) {
      debugPrint("Assign Role Error: $e");
      return _parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ------------------------------------------------------------
  // 9. Bulk User Operations API
  // ------------------------------------------------------------
  Future<String?> bulkUserActionApi(String action, List<int> userIds) async {
    _setLoading(true);

    try {
      await _myRepo.bulkUserActionApi(action, userIds);
      await fetchUsersApi(); // Refresh list
      return null; // Success
    } catch (e) {
      debugPrint("Bulk Action Error: $e");
      return _parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ------------------------------------------------------------
  // 10. List Roles API
  // ------------------------------------------------------------
  Future<String?> fetchRolesApi() async {
    _setLoading(true);

    try {
      _roleList = await _myRepo.getRolesApi();
      return null; // Success
    } catch (e) {
      debugPrint("Fetch Roles Error: $e");
      return _parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ------------------------------------------------------------
  // 11. Fetch & Update User Profile (Self)
  // ------------------------------------------------------------
  Future<String?> fetchUserProfileApi(String slug) async {
    _setLoading(true);

    try {
      final profile = await _myRepo.getUserProfileApi(slug);
      _currentUser = profile;
      await TokenStorage.saveUser(profile);
      return null; // Success
    } catch (e) {
      debugPrint("Fetch Profile Error: $e");
      return _parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> updateUserProfileApi(
      String slug,
      Map<String, String> fields, {
        File? profileImage,
      }) async {
    _setLoading(true);

    try {
      final response = await _myRepo.updateUserProfileApi(
        slug,
        fields,
        profileImage: profileImage,
      );

      if (response != null && response["profile"] != null) {
        final updatedUser = UserModel.fromJson(response["profile"]);
        _currentUser = updatedUser;
        await TokenStorage.saveUser(updatedUser);
      }
      return null; // Success
    } catch (e) {
      debugPrint("Update Profile Error: $e");
      return _parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ------------------------------------------------------------
  // 12. Change Password API (Self)
  // ------------------------------------------------------------
  Future<String?> changePasswordApi({
    required String slug,
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    _setLoading(true);

    try {
      await _myRepo.changePasswordApi(
        slug: slug,
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );
      return null; // Success
    } catch (e) {
      debugPrint("Change Password Error: $e");
      return _parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ------------------------------------------------------------
  // 13. Reset User Password API (Superuser Only)
  // ------------------------------------------------------------
  Future<String?> resetUserPasswordApi({
    required int userId,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    _setLoading(true);

    try {
      await _myRepo.resetUserPasswordApi(
        userId: userId,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );
      return null; // Success
    } catch (e) {
      debugPrint("Reset Password Error: $e");
      return _parseError(e);
    } finally {
      _setLoading(false);
    }
  }

  // ------------------------------------------------------------
  // Helper Methods
  // ------------------------------------------------------------
  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  String _parseError(dynamic error) {
    String message = error.toString();

    if (message.startsWith("ApiException: ")) {
      message = message.replaceFirst("ApiException: ", "");
    } else if (message.startsWith("Exception: ")) {
      message = message.replaceFirst("Exception: ", "");
    }

    return message;
  }
}