import '../../core/network/network_api_services.dart';
import '../../res/api_url/app_url.dart';
import '../model/institute_profile/institute_profile_model.dart';

class InstitutionProfileRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // GET profile to fill edit forms
  Future<InstitutionProfileModel> getInstitutionProfile() async {
    final response = await _apiServices.getApi(
      AppUrl.institutionProfile,
      requiresAuth: true,
    );
    return InstitutionProfileModel.fromJson(response);
  }

  // PUT / PATCH profile updates
  Future<InstitutionProfileModel> updateInstitutionProfile(
      Map<String, dynamic> data, {
        bool isPatch = false,
      }) async {
    final response = isPatch
        ? await _apiServices.patchApi(AppUrl.institutionProfile, data, requiresAuth: true)
        : await _apiServices.putApi(AppUrl.institutionProfile, data, requiresAuth: true);

    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return InstitutionProfileModel.fromJson(response['data']);
    }
    return InstitutionProfileModel.fromJson(response);
  }
}