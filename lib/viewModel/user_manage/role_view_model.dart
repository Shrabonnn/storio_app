import 'package:flutter/material.dart';

import '../../data/model/user_manage/role/role_permission_model.dart';
import '../../data/repository/user_manage/role_repository.dart';

class RoleViewModel extends ChangeNotifier {
  final RoleRepository _repository = RoleRepository();

  // State Variables
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<RoleModel> _rolesList = [];
  List<RoleModel> get rolesList => _rolesList;

  List<PermissionModel> _permissionsList = [];
  List<PermissionModel> get permissionsList => _permissionsList;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ============================================================
  // FETCH ROLES
  // ============================================================
  Future<void> fetchRolesApi() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _rolesList = await _repository.fetchRoles();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // FETCH PERMISSIONS
  // ============================================================
  Future<void> fetchPermissionsApi() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _permissionsList = await _repository.fetchPermissions();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // ============================================================
  // CREATE ROLE
  // ============================================================
  Future<bool> createRoleApi(Map<String, dynamic> data) async {
    _errorMessage = null;
    try {
      final response = await _repository.createRole(data);
      if (response['success'] == true) {
        await fetchRolesApi(); // Refresh roles list after creation
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  // ============================================================
  // UPDATE ROLE
  // ============================================================
  Future<bool> updateRoleApi(int id, Map<String, dynamic> data) async {
    _errorMessage = null;
    try {
      final response = await _repository.updateRole(id, data);
      if (response['success'] == true) {
        await fetchRolesApi(); // Refresh roles list after update
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  // ============================================================
  // DELETE ROLE
  // ============================================================
  Future<bool> deleteRoleApi(int id) async {
    _errorMessage = null;
    try {
      await _repository.deleteRole(id);

      _rolesList.removeWhere((role) => role.id == id);
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }
}