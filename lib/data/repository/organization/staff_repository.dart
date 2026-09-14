import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';
import '../../model/organization/staff/staff_model.dart';
import '../../model/organization/staff/staff_status_choice_model.dart';

class StaffRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // ============================================================
  // STAFF LIST (Management)
  // ============================================================
  Future<List<StaffModel>> getStaffList({
    String? search,
    int? department,
    String? status,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (department != null) {
      queryParams['department'] = department.toString();
    }
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    final response = await _apiServices.getApi(
      AppUrl.getManagementStaff,
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    return (response as List).map((e) => StaffModel.fromJson(e)).toList();
  }

  // ============================================================
  // STAFF LIST (Public)
  // ============================================================
  Future<List<StaffModel>> getPublicStaffList() async {
    final response = await _apiServices.getApi(
      AppUrl.getStaff,
      requiresAuth: false,
    );

    return (response as List).map((e) => StaffModel.fromJson(e)).toList();
  }

  // ============================================================
  // STAFF DETAIL
  // ============================================================
  Future<StaffModel> getStaffDetail(int id) async {
    final response = await _apiServices.getApi(AppUrl.staffDetail(id));
    return StaffModel.fromJson(response);
  }

  // ============================================================
  // CREATE STAFF
  // ============================================================
  Future<StaffModel> createStaff(Map<String, dynamic> data) async {
    final response = await _apiServices.postApi(AppUrl.createStaff, data);
    return StaffModel.fromJson(response['staff']);
  }

  // ============================================================
  // UPDATE STAFF (PATCH)
  // ============================================================
  Future<StaffModel> updateStaff(int id, Map<String, dynamic> data) async {
    final response = await _apiServices.patchApi(
      AppUrl.staffDetail(id),
      data,
    );
    return StaffModel.fromJson(response['staff']);
  }

  // ============================================================
  // DELETE STAFF
  // ============================================================
  Future<Map<String, dynamic>> deleteStaff(int id) async {
    final response = await _apiServices.deleteApi(AppUrl.staffDetail(id));
    return Map<String, dynamic>.from(response);
  }

  // ============================================================
  // STATUS CHOICES
  // ============================================================
  Future<List<StaffStatusChoiceModel>> getStatusChoices() async {
    final response = await _apiServices.getApi(AppUrl.getStaffStatusChoices);

    // doc অনুযায়ী এই endpoint সরাসরি একটা List রিটার্ন করে (অন্য
    // module গুলোর মতো {"choices": [...]} wrapper নেই)
    return (response as List)
        .map((e) => StaffStatusChoiceModel.fromJson(e))
        .toList();
  }

  // ============================================================
  // BULK OPERATIONS
  // ============================================================
  Future<Map<String, dynamic>> bulkOperation({
    required String action,
    required List<int> staffIds,
  }) async {
    final response = await _apiServices.postApi(
      AppUrl.staffBulkOperations,
      {
        "action": action,
        "staff_ids": staffIds,
      },
    );

    return Map<String, dynamic>.from(response);
  }

  // ============================================================
  // REORDER STAFF
  // ============================================================
  Future<Map<String, dynamic>> reorderStaff(List<int> orderedIds) async {
    final response = await _apiServices.postApi(
      AppUrl.staffReorder,
      {"ordered_ids": orderedIds},
    );

    return Map<String, dynamic>.from(response);
  }

  // ============================================================
  // DEPARTMENT MANAGEMENT
  // ============================================================

  Future<List<DepartmentModel>> getDepartmentList({String? search}) async {
    final Map<String, dynamic> queryParams = {};
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await _apiServices.getApi(
      AppUrl.getManagementDepartments,
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    return (response as List)
        .map((e) => DepartmentModel.fromJson(e))
        .toList();
  }

  Future<List<DepartmentModel>> getPublicDepartmentList() async {
    final response = await _apiServices.getApi(
      AppUrl.getPublicDepartments,
      requiresAuth: false,
    );

    return (response as List)
        .map((e) => DepartmentModel.fromJson(e))
        .toList();
  }

  Future<DepartmentModel> getDepartmentDetail(int id) async {
    final response = await _apiServices.getApi(AppUrl.departmentDetail(id));
    return DepartmentModel.fromJson(response);
  }

  Future<DepartmentModel> createDepartment(Map<String, dynamic> data) async {
    final response = await _apiServices.postApi(
      AppUrl.createDepartment,
      data,
    );
    return DepartmentModel.fromJson(response['department']);
  }

  Future<DepartmentModel> updateDepartment(
      int id,
      Map<String, dynamic> data,
      ) async {
    final response = await _apiServices.patchApi(
      AppUrl.departmentDetail(id),
      data,
    );
    return DepartmentModel.fromJson(response['department']);
  }

  Future<Map<String, dynamic>> deleteDepartment(int id) async {
    final response =
    await _apiServices.deleteApi(AppUrl.departmentDetail(id));
    return Map<String, dynamic>.from(response);
  }
}