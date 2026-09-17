import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';
import '../../model/user_manage/user/user_model.dart';

class UserRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // 1. Fetch Users List
  Future<List<ManageUserModel>> getUsers() async {
    final response = await _apiServices.getApi(AppUrl.userList);
    return (response as List).map((e) => ManageUserModel.fromJson(e)).toList();
  }

  // 2. Create User
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
    final Map<String, dynamic> data = {
      "username": username,
      "email": email,
      "password": password,
      "confirm_password": confirmPassword,
      "phone_number": phoneNumber,
    };

    if (firstName != null) data["first_name"] = firstName;
    if (lastName != null) data["last_name"] = lastName;
    if (address != null) data["address"] = address;
    if (roleId != null) data["role_id"] = roleId;

    final response = await _apiServices.postApi(AppUrl.createUser, data);
    return response != null;
  }

  // 3. Get User Detail
  Future<ManageUserModel> getUserDetail(int id) async {
    final response = await _apiServices.getApi(AppUrl.userDetail(id));
    return ManageUserModel.fromJson(response);
  }

  // 4. Update User
  Future<ManageUserModel> updateUser(int id, Map<String, dynamic> data) async {
    final response = await _apiServices.patchApi(AppUrl.updateUser(id), data);
    return ManageUserModel.fromJson(response['user'] ?? response);
  }

  // 5. Delete User
  Future<bool> deleteUser(int id) async {
    final response = await _apiServices.deleteApi(AppUrl.deleteUser(id));
    if (response is Map<String, dynamic>) {
      return response['success'] == true;
    }
    return true;
  }

  // 6. Assign Role
  Future<ManageUserModel> assignRole(int userId, int? groupId) async {
    final response = await _apiServices.postApi(
      AppUrl.assignRole,
      {
        "user_id": userId,
        "group_id": groupId,
      },
    );
    return ManageUserModel.fromJson(response['user'] ?? response);
  }

  // 7. Reset User Password
  Future<bool> resetUserPassword(
      int id,
      String newPassword,
      String confirmNewPassword,
      ) async {
    final response = await _apiServices.postApi(
      AppUrl.resetUserPassword(id),
      {
        "new_password": newPassword,
        "confirm_new_password": confirmNewPassword,
      },
    );
    return response != null && (response['success'] == true || response is Map);
  }

  // 8. Bulk Operations
  Future<bool> bulkUserAction(String action, List<int> userIds) async {
    final response = await _apiServices.postApi(
      AppUrl.bulkUserAction,
      {
        "action": action,
        "user_ids": userIds,
      },
    );
    return response != null && (response['success'] == true || response is Map);
  }

  // 9. Fetch Roles List
  Future<List<UserRoleModel>> getRoles() async {
    final response = await _apiServices.getApi(AppUrl.roleList);
    return (response as List).map((e) => UserRoleModel.fromJson(e)).toList();
  }

  // 10. Fetch Own Profile
  Future<ManageUserModel> getProfile(String slug) async {
    final response = await _apiServices.getApi(AppUrl.userProfile(slug));
    return ManageUserModel.fromJson(response);
  }

  // 11. Update Profile
  Future<ManageUserModel> updateProfile(String slug, Map<String, dynamic> data) async {
    final response = await _apiServices.patchApi(AppUrl.userProfile(slug), data);
    return ManageUserModel.fromJson(response);
  }

  // 12. Change Password
  Future<bool> changePassword(
      String slug,
      String currentPassword,
      String newPassword,
      String confirmNewPassword,
      ) async {
    final response = await _apiServices.postApi(
      AppUrl.changePassword(slug),
      {
        "current_password": currentPassword,
        "new_password": newPassword,
        "confirm_new_password": confirmNewPassword,
      },
    );
    return response != null;
  }
}