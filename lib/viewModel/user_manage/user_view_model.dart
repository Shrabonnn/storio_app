import 'package:flutter/material.dart';
import '../../../core/network/api_exception.dart';
import '../../data/model/user_manage/user/user_model.dart';
import '../../data/repository/user_manage/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _repository = UserRepository();

  bool _loading = false;
  bool get loading => _loading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<ManageUserModel> _userList = [];
  List<ManageUserModel> get userList => _userList;

  List<UserRoleModel> _roleList = [];
  List<UserRoleModel> get roleList => _roleList;

  ManageUserModel? _selectedUser;
  ManageUserModel? get selectedUser => _selectedUser;

  ManageUserModel? _currentUserProfile;
  ManageUserModel? get currentUserProfile => _currentUserProfile;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Fetch all users

  Future<void> fetchUsers({
    String? status,
    String? search,
    bool isFilterOrSearch = false,
  }) async {
    if (isFilterOrSearch || _userList.isEmpty) {
      _loading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      _userList = await _repository.getUsers();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = "Something went wrong. Please try again.";
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // Fetch available roles
  Future<void> fetchRoles() async {
    try {
      _roleList = await _repository.getRoles();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching roles: $e");
    }
  }

  // Create new user
  Future<bool> createUser({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoneNumber,
    String? firstName,
    String? lastName,
    String? address,
    int? roleId,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await _repository.createUser(
        username: username,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phoneNumber: phoneNumber,
        firstName: firstName,
        lastName: lastName,
        address: address,
        roleId: roleId,
      );
      if (success) await fetchUsers();
      return success;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError("Failed to create user.");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Fetch details of a single user
  Future<void> fetchUserDetail(int id) async {
    _setLoading(true);
    _setError(null);

    try {
      _selectedUser = await _repository.getUserDetail(id);
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError("Failed to fetch user detail.");
    } finally {
      _setLoading(false);
    }
  }

  // Update user information or status
  Future<bool> updateUser(int id, Map<String, dynamic> data) async {
    _setLoading(true);
    _setError(null);

    try {
      final updatedUser = await _repository.updateUser(id, data);

      final index = _userList.indexWhere((u) => u.id == id);
      if (index != -1) {
        _userList[index] = updatedUser;
      }
      if (_selectedUser?.id == id) {
        _selectedUser = updatedUser;
      }
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError("Failed to update user.");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Assign role to user
  Future<bool> assignRole(int userId, int? groupId) async {
    _setLoading(true);
    _setError(null);

    try {
      final updatedUser = await _repository.assignRole(userId, groupId);
      final index = _userList.indexWhere((u) => u.id == userId);
      if (index != -1) {
        _userList[index] = updatedUser;
      }
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError("Failed to assign role.");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete user
  Future<bool> deleteUser(int id) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await _repository.deleteUser(id);
      if (success) {
        _userList.removeWhere((u) => u.id == id);
        notifyListeners();
      }
      return success;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError("Failed to delete user.");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Perform bulk actions
  Future<bool> performBulkAction(String action, List<int> userIds) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await _repository.bulkUserAction(action, userIds);
      if (success) {
        await fetchUsers();
      }
      return success;
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError("Failed to perform bulk action.");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Reset password
  Future<bool> resetUserPassword(
      int id, String newPassword, String confirmNewPassword) async {
    _setLoading(true);
    _setError(null);

    try {
      return await _repository.resetUserPassword(
          id, newPassword, confirmNewPassword);
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError("Failed to reset password.");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Fetch current user profile
  Future<void> fetchProfile(String slug) async {
    _setLoading(true);
    _setError(null);

    try {
      _currentUserProfile = await _repository.getProfile(slug);
    } on ApiException catch (e) {
      _setError(e.message);
    } catch (e) {
      _setError("Failed to fetch profile.");
    } finally {
      _setLoading(false);
    }
  }

  // Change current user password
  Future<bool> changePassword(
      String slug,
      String currentPassword,
      String newPassword,
      String confirmNewPassword,
      ) async {
    _setLoading(true);
    _setError(null);

    try {
      return await _repository.changePassword(
          slug, currentPassword, newPassword, confirmNewPassword);
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    } catch (e) {
      _setError("Failed to change password.");
      return false;
    } finally {
      _setLoading(false);
    }
  }
}