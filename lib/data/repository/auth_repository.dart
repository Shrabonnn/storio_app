import 'dart:io';
import '../../core/network/network_api_services.dart';
import '../../core/storage/storage_service.dart';
import '../../res/api_url/app_url.dart';
import '../model/Auth/user_model.dart';

class AuthRepository {
  final _apiServices = NetworkApiServices();

  // 1. Login
  Future<Map<String, dynamic>> loginApi(LoginRequestModel request) async {
    return await _apiServices.postApi(
      AppUrl.loginApi,
      request.toJson(),
      requiresAuth: false,
    );
  }

  // 2. Logout
  Future<dynamic> logoutApi(String refreshToken) async {
    return await _apiServices.postApi(
      AppUrl.logoutApi,
      {'refresh': refreshToken},
      requiresAuth: false,
    );
  }

  // 3. User Registration (Superuser only)
  Future<dynamic> createUserApi(CreateUserRequestModel request) async {
    return await _apiServices.postApi(
      AppUrl.createUserApi,
      request.toJson(),
    );
  }

  // 4. List Users
  Future<List<UserModel>> getUsersApi() async {
    final response = await _apiServices.getApi(AppUrl.userListApi);
    return (response as List).map((json) => UserModel.fromJson(json)).toList();
  }

  // 5. Get User Detail
  Future<UserModel> getUserDetailApi(int userId) async {
    final response = await _apiServices.getApi(AppUrl.userDetailApi(userId));
    return UserModel.fromJson(response);
  }

  // 6. Update User
  Future<dynamic> updateUserApi(int userId, Map<String, dynamic> data) async {
    return await _apiServices.patchApi(
      AppUrl.userDetailApi(userId),
      data,
    );
  }

  // 7. Delete User
  Future<dynamic> deleteUserApi(int userId) async {
    return await _apiServices.deleteApi(AppUrl.userDetailApi(userId));
  }

  // 8. Assign / Remove Role
  Future<dynamic> assignRoleApi(int userId, int? groupId) async {
    return await _apiServices.postApi(
      AppUrl.assignRoleApi,
      {
        'user_id': userId,
        'group_id': groupId,
      },
    );
  }

  // 9. Bulk User Operations
  Future<dynamic> bulkUserActionApi(String action, List<int> userIds) async {
    return await _apiServices.postApi(
      AppUrl.bulkUserApi,
      {
        'action': action,
        'user_ids': userIds,
      },
    );
  }

  // 10. List Roles
  Future<List<RoleModel>> getRolesApi() async {
    final response = await _apiServices.getApi(AppUrl.rolesListApi);
    return (response as List).map((json) => RoleModel.fromJson(json)).toList();
  }

  // 11. User Profile (Get)
  Future<UserModel> getUserProfileApi(String slug) async {
    final response = await _apiServices.getApi(AppUrl.userProfileApi(slug));
    return UserModel.fromJson(response);
  }

  // 11b. User Profile (Update - JSON or Multipart)
  Future<dynamic> updateUserProfileApi(
      String slug,
      Map<String, String> fields, {
        File? profileImage,
      }) async {
    if (profileImage != null) {
      return await _apiServices.multipartApi(
        AppUrl.userProfileApi(slug),
        fields,
        {'profile_picture': profileImage},
      );
    } else {
      return await _apiServices.patchApi(
        AppUrl.userProfileApi(slug),
        fields,
      );
    }
  }

  // 12. Change Password
  Future<dynamic> changePasswordApi({
    required String slug,
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    return await _apiServices.postApi(
      AppUrl.changePasswordApi(slug),
      {
        'current_password': currentPassword,
        'new_password': newPassword,
        'confirm_new_password': confirmNewPassword,
      },
    );
  }

  // 13. Superuser Reset User Password
  Future<dynamic> resetUserPasswordApi({
    required int userId,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    return await _apiServices.postApi(
      AppUrl.resetPasswordApi(userId),
      {
        'new_password': newPassword,
        'confirm_new_password': confirmNewPassword,
      },
    );
  }
}