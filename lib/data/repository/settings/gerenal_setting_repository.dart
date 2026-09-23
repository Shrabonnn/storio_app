import '../../../../res/api_url/app_url.dart';
import '../../../core/network/network_api_services.dart';
import '../../model/settings/general_settings_model.dart';


class GeneralSettingRepository {
  final NetworkApiServices _apiService = NetworkApiServices();

  // 1. Get Public Settings (Unauthenticated)
  Future<GeneralSettingModel> getPublicSettings() async {
    try {
      final response = await _apiService.getApi(
        AppUrl.publicGeneralSettings,
        requiresAuth: false,
      );
      return GeneralSettingModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // 2. Get All Settings (Authenticated)
  Future<GeneralSettingModel> getManagementSettings() async {
    try {
      final response = await _apiService.getApi(
        AppUrl.managementGeneralSettings,
        requiresAuth: true,
      );
      return GeneralSettingModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // 3. Update Settings (PUT or PATCH)
  Future<GeneralSettingModel> updateSettings(
      Map<String, dynamic> data, {
        bool isPatch = true,
      }) async {
    try {
      final response = isPatch
          ? await _apiService.patchApi(AppUrl.updateGeneralSettings, data, requiresAuth: true)
          : await _apiService.putApi(AppUrl.updateGeneralSettings, data, requiresAuth: true);

      print("UPDATE SETTINGS RAW RESPONSE: $response");

      if (response is Map<String, dynamic> && response.containsKey('data')) {
        return GeneralSettingModel.fromJson(response['data']);
      }
      return GeneralSettingModel.fromJson(response);
    } catch (e) {
      print("UPDATE SETTINGS ERROR: $e");
      rethrow;
    }
  }

  // ============================================================
  // SOCIAL LINKS METHODS
  // ============================================================

  // 1. List All Social Links
  Future<List<SocialLinkData>> getSocialLinks({String? searchQuery}) async {
    try {
      Map<String, dynamic>? queryParams;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams = {'search': searchQuery};
      }

      final response = await _apiService.getApi(
        AppUrl.socialLinks,
        queryParams: queryParams,
        requiresAuth: true,
      );

      List<SocialLinkData> list = [];
      if (response is List) {
        for (var v in response) {
          list.add(SocialLinkData.fromJson(v));
        }
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  // 2. Create Social Link
  Future<SocialLinkData> createSocialLink({
    required String platform,
    required String url,
  }) async {
    try {
      final response = await _apiService.postApi(
        AppUrl.socialLinks,
        {
          'platform': platform,
          'url': url,
        },
        requiresAuth: true,
      );

      if (response is Map<String, dynamic> &&
          response.containsKey('social_link')) {
        return SocialLinkData.fromJson(response['social_link']);
      }
      return SocialLinkData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // 3. Update Social Link
  Future<SocialLinkData> updateSocialLink({
    required int id,
    required String platform,
    required String url,
  }) async {
    try {
      final response = await _apiService.putApi(
        AppUrl.socialLinkDetail(id),
        {
          'platform': platform,
          'url': url,
        },
        requiresAuth: true,
      );

      if (response is Map<String, dynamic> &&
          response.containsKey('social_link')) {
        return SocialLinkData.fromJson(response['social_link']);
      }
      return SocialLinkData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // 4. Get Platform Choices
  Future<List<PlatformChoiceData>> getPlatformChoices() async {
    try {
      final response = await _apiService.getApi(
        AppUrl.socialLinkPlatformChoices,
        requiresAuth: true,
      );

      List<PlatformChoiceData> choices = [];
      if (response is Map<String, dynamic> && response['choices'] != null) {
        for (var v in response['choices']) {
          choices.add(PlatformChoiceData.fromJson(v));
        }
      }
      return choices;
    } catch (e) {
      rethrow;
    }
  }



// 5. Delete Social Link
  Future<void> deleteSocialLink(int id) async {
    try {
      await _apiService.deleteApi(
        AppUrl.socialLinkDetail(id),
        requiresAuth: true,
      );
    } catch (e) {
      rethrow;
    }
  }
}