import 'package:http/http.dart' as http;

import '../../../core/network/network_api_services.dart';
import '../../../core/storage/storage_service.dart';
import '../../../res/api_url/app_url.dart';
import '../../model/Content/admission/admission_model.dart';

class AdmissionRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // ============================================================
  // FORM CONFIG (Read & Write)
  // ============================================================

  Future<AdmissionFormConfigModel> getFormConfig() async {
    final response = await _apiServices.getApi(
      AppUrl.admissionFormConfig,
      requiresAuth: false,
    );
    return AdmissionFormConfigModel.fromJson(response);
  }

  /// Creates a new form configuration or updates an existing one based on config.id
  Future<AdmissionFormConfigModel> saveFormConfig(AdmissionFormConfigModel config) async {
    if (config.id != null) {
      final response = await _apiServices.putApi(
        AppUrl.admissionFormConfigUpdate(config.id!),
        config.toJson(),
      );
      return AdmissionFormConfigModel.fromJson(response);
    } else {
      final response = await _apiServices.postApi(
        AppUrl.admissionFormConfigBase,
        config.toJson(),
      );
      return AdmissionFormConfigModel.fromJson(response);
    }
  }

  // ============================================================
  // LIST APPLICATIONS (Management)
  // ============================================================
  Future<List<AdmissionApplicationModel>> getApplications() async {
    final response = await _apiServices.getApi(AppUrl.admissionApplications);

    return (response as List)
        .map((e) => AdmissionApplicationModel.fromJson(e))
        .toList();
  }

  // ============================================================
  // UPDATE APPLICATION STATUS (Management — approve/reject)
  // ============================================================
  Future<AdmissionApplicationModel> updateApplicationStatus(
      int id, {
        required String status,
        String? notes,
      }) async {
    final Map<String, dynamic> data = {"status": status};
    if (notes != null && notes.isNotEmpty) {
      data["notes"] = notes;
    }

    final response = await _apiServices.postApi(
      AppUrl.admissionApplicationUpdateStatus(id),
      data,
    );
    return AdmissionApplicationModel.fromJson(response);
  }

  // ============================================================
  // EXPORT APPLICATIONS TO CSV (Management)
  // ============================================================
  Future<List<int>> exportApplicationsCsv() async {
    final token = await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse(AppUrl.admissionApplicationsExportCsv),
      headers: {
        "Accept": "text/csv",
        "X-Tenant-Host": AppUrl.tenantHost,
        if (token != null && token.isNotEmpty)
          "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to export applications (status ${response.statusCode})",
      );
    }

    return response.bodyBytes;
  }
}