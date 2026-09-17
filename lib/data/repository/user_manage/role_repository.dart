import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';
import '../../model/user_manage/role/role_permission_model.dart';
class RoleRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // ============================================================
  // FETCH ALL ROLES
  // ============================================================
  Future<List<RoleModel>> fetchRoles() async {
    try {
      final response = await _apiServices.getApi(AppUrl.getRoles);

      if (response is List) {
        return response
            .map((json) => RoleModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // ============================================================
  // FETCH ALL PERMISSIONS
  // ============================================================
  Future<List<PermissionModel>> fetchPermissions() async {
    try {
      final response = await _apiServices.getApi(AppUrl.getPermissions);

      if (response is List) {
        return response
            .map((json) => PermissionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  // ============================================================
  // CREATE ROLE
  // ============================================================
  Future<dynamic> createRole(Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.postApi(AppUrl.createRole, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // ============================================================
  // UPDATE ROLE
  // ============================================================
  Future<dynamic> updateRole(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiServices.putApi(AppUrl.updateRole(id), data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // ============================================================
  // DELETE ROLE
  // ============================================================
  Future<dynamic> deleteRole(int id) async {
    try {
      final response = await _apiServices.deleteApi(AppUrl.deleteRole(id));
      return response;
    } catch (e) {
      rethrow;
    }
  }
}