import 'dart:io';

import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';
import '../../model/Content/result/exam_result_model.dart';

class ExamResultRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<List<ExamResultModel>> getExamResults({
    String? examType,
    String? search,
    String? ordering,
  }) async {
    final Map<String, dynamic> queryParams = {};

    if (examType != null && examType.isNotEmpty) {
      queryParams['exam_type'] = examType;
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (ordering != null && ordering.isNotEmpty) {
      queryParams['ordering'] = ordering;
    }

    final response = await _apiServices.getApi(
      AppUrl.getExamResults,
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    return (response as List)
        .map((e) => ExamResultModel.fromJson(e))
        .toList();
  }

  Future<List<ExamResultModel>> getPublicExamResults() async {
    final response = await _apiServices.getApi(
      AppUrl.getPublicExamResults,
      requiresAuth: false,
    );

    return (response as List)
        .map((e) => ExamResultModel.fromJson(e))
        .toList();
  }

  Future<ExamResultModel> getExamResultDetail(int id) async {
    final response = await _apiServices.getApi(AppUrl.examResultDetail(id));
    return ExamResultModel.fromJson(response);
  }

  // file দিলে multipart, না দিলে plain JSON POST — doc দুটোই সাপোর্ট করে
  Future<ExamResultModel> createExamResult(
      Map<String, dynamic> data, {
        File? file,
      }) async {
    if (file != null) {
      final fields = data.map(
            (key, value) => MapEntry(key, value.toString()),
      );

      final response = await _apiServices.multipartApi(
        AppUrl.getExamResults,
        fields,
        {"file": file},
      );

      return ExamResultModel.fromJson(response);
    }

    final response = await _apiServices.postApi(AppUrl.getExamResults, data);
    return ExamResultModel.fromJson(response);
  }

  Future<ExamResultModel> updateExamResult(
      int id,
      Map<String, dynamic> data,
      ) async {
    final response = await _apiServices.patchApi(
      AppUrl.examResultDetail(id),
      data,
    );

    return ExamResultModel.fromJson(response);
  }

  Future<void> deleteExamResult(int id) async {
    await _apiServices.deleteApi(AppUrl.examResultDetail(id));
  }
}