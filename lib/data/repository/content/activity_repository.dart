import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';

import '../../model/Content/activity/activity_model.dart';
import '../../model/Content/activity/activity_status_choice_model.dart';


class ActivityRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // ============================================================
  // ACTIVITY LIST (Management)
  // ============================================================
  Future<List<ActivityModel>> getActivityList({
    String? status,
    String? search,
    int? category,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (status != null && status.isNotEmpty) queryParams['status'] = status;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (category != null) queryParams['category'] = category.toString();

    final response = await _apiServices.getApi(
      AppUrl.getManagementActivities,
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    return (response as List).map((e) => ActivityModel.fromJson(e)).toList();
  }

  // ============================================================
  // ACTIVITY DETAIL (Management)
  // ============================================================
  Future<ActivityModel> getActivityDetail(int id) async {
    final response = await _apiServices.getApi(AppUrl.activityDetail(id));
    return ActivityModel.fromJson(response);
  }

  // ============================================================
  // CREATE ACTIVITY
  // ============================================================
  Future<ActivityModel> createActivity(Map<String, dynamic> data) async {
    final response = await _apiServices.postApi(AppUrl.createActivity, data);
    return ActivityModel.fromJson(response['activity_post']);
  }

  // ============================================================
  // UPDATE ACTIVITY (PATCH)
  // ============================================================
  Future<ActivityModel> updateActivity(int id, Map<String, dynamic> data) async {
    final response = await _apiServices.patchApi(AppUrl.activityDetail(id), data);
    return ActivityModel.fromJson(response['activity_post']);
  }

  // ============================================================
  // SCHEDULE ACTIVITY
  // ============================================================
  Future<Map<String, dynamic>> scheduleActivity(int id, DateTime publishDate) async {
    final response = await _apiServices.postApi(
      AppUrl.activitySchedule(id),
      {"publish_date": publishDate.toUtc().toIso8601String()},
    );
    return response;
  }

  // ============================================================
  // DELETE ACTIVITY (permanent)
  // ============================================================
  Future<Map<String, dynamic>> deleteActivity(int id) async {
    return await _apiServices.deleteApi(AppUrl.activityDetail(id));
  }

  // ============================================================
  // MOVE TO BIN
  // ============================================================
  Future<Map<String, dynamic>> binActivity(int id) async {
    return await _apiServices.postApi(AppUrl.activityBin(id), {});
  }

  // ============================================================
  // RESTORE FROM BIN
  // ============================================================
  Future<Map<String, dynamic>> restoreActivity(int id) async {
    return await _apiServices.postApi(AppUrl.activityRestore(id), {});
  }

  // ============================================================
  // BULK OPERATIONS
  // ============================================================
  Future<Map<String, dynamic>> bulkOperation({
    required String action,
    required List<int> postIds,
  }) async {
    return await _apiServices.postApi(
      AppUrl.activityBulkOperations,
      {"action": action, "post_ids": postIds},
    );
  }

  // ============================================================
  // STATUS CHOICES
  // ============================================================
  Future<List<ActivityStatusChoiceModel>> getStatusChoices() async {
    final response = await _apiServices.getApi(AppUrl.getActivityStatusChoices);
    final choices = response['choices'] as List;
    return choices.map((e) => ActivityStatusChoiceModel.fromJson(e)).toList();
  }

  // ============================================================
  // CATEGORY MANAGEMENT
  // ============================================================
  Future<List<ActivityCategoryModel>> getCategoryList({String? search}) async {
    final Map<String, dynamic> queryParams = {};
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final response = await _apiServices.getApi(
      AppUrl.getManagementActivityCategories,
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    return (response as List).map((e) => ActivityCategoryModel.fromJson(e)).toList();
  }

  Future<ActivityCategoryModel> createCategory(Map<String, dynamic> data) async {
    final response = await _apiServices.postApi(AppUrl.createActivityCategory, data);
    return ActivityCategoryModel.fromJson(response['category']);
  }

  Future<ActivityCategoryModel> updateCategory(int id, Map<String, dynamic> data) async {
    final response = await _apiServices.patchApi(AppUrl.activityCategoryDetail(id), data);
    return ActivityCategoryModel.fromJson(response['category']);
  }

  Future<Map<String, dynamic>> deleteCategory(int id) async {
    return await _apiServices.deleteApi(AppUrl.activityCategoryDetail(id));
  }
}