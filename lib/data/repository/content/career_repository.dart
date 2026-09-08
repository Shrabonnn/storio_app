import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';
import '../../model/Content/career/career_model.dart';
import '../../model/Content/career/career_status_choice_model.dart';


class CareerRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // ============================================================
  // JOB LIST (Management)
  // ============================================================
  Future<List<CareerModel>> getJobList({
    String? status,
    String? search,
    String? jobType,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (jobType != null && jobType.isNotEmpty) {
      queryParams['job_type'] = jobType;
    }

    final response = await _apiServices.getApi(
      AppUrl.getManagementJobs,
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    return (response as List).map((e) => CareerModel.fromJson(e)).toList();
  }

  // ============================================================
  // JOB DETAIL (Management)
  // ============================================================
  Future<CareerModel> getJobDetail(int id) async {
    final response = await _apiServices.getApi(AppUrl.jobDetail(id));
    return CareerModel.fromJson(response);
  }

  // ============================================================
  // CREATE JOB
  // ============================================================
  Future<CareerModel> createJob(Map<String, dynamic> data) async {
    final response = await _apiServices.postApi(AppUrl.createJob, data);
    return CareerModel.fromJson(response['data']);
  }

  // ============================================================
  // UPDATE JOB (PATCH)
  // ============================================================
  Future<CareerModel> updateJob(int id, Map<String, dynamic> data) async {
    final response = await _apiServices.patchApi(AppUrl.jobDetail(id), data);
    return CareerModel.fromJson(response['data']);
  }

  // ============================================================
  // DELETE JOB
  // ============================================================
  Future<Map<String, dynamic>> deleteJob(int id) async {
    final response = await _apiServices.deleteApi(AppUrl.jobDetail(id));
    return response;
  }

  // ============================================================
  // BULK OPERATIONS
  // ============================================================
  Future<Map<String, dynamic>> bulkOperation({
    required String action,
    required List<int> ids,
  }) async {
    final response = await _apiServices.postApi(
      AppUrl.jobBulkOperations,
      {
        "action": action,
        "ids": ids,
      },
    );
    return response;
  }

  // ============================================================
  // STATUS CHOICES (plain array response, unlike Blog's {"choices": [...]})
  // ============================================================
  Future<List<CareerStatusChoiceModel>> getStatusChoices() async {
    final response = await _apiServices.getApi(AppUrl.jobStatusChoices);
    return (response as List)
        .map((e) => CareerStatusChoiceModel.fromJson(e))
        .toList();
  }

  // ============================================================
  // TYPE CHOICES (plain array response)
  // ============================================================
  Future<List<CareerStatusChoiceModel>> getTypeChoices() async {
    final response = await _apiServices.getApi(AppUrl.jobTypeChoices);
    return (response as List)
        .map((e) => CareerStatusChoiceModel.fromJson(e))
        .toList();
  }
}