import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';
import '../../model/organization/links/social_links_model.dart';

class SocialLinkRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<List<SocialLinkModel>> getSocialLinks({String? search}) async {
    final Map<String, dynamic> queryParams = {};

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await _apiServices.getApi(
      AppUrl.getSocialLinks,
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    return (response as List)
        .map((e) => SocialLinkModel.fromJson(e))
        .toList();
  }

  Future<SocialLinkModel> getSocialLinkDetail(int id) async {
    final response = await _apiServices.getApi(AppUrl.socialLinkDetail(id));
    return SocialLinkModel.fromJson(response);
  }

  Future<SocialLinkModel> createSocialLink(Map<String, dynamic> data) async {
    final response = await _apiServices.postApi(AppUrl.getSocialLinks, data);
    return SocialLinkModel.fromJson(response['social_link']);
  }

  // doc অনুযায়ী update PUT, PATCH না
  Future<SocialLinkModel> updateSocialLink(
      int id,
      Map<String, dynamic> data,
      ) async {
    final response = await _apiServices.putApi(
      AppUrl.socialLinkDetail(id),
      data,
    );

    return SocialLinkModel.fromJson(response['social_link']);
  }

  Future<Map<String, dynamic>> deleteSocialLink(int id) async {
    final response = await _apiServices.deleteApi(AppUrl.socialLinkDetail(id));
    return Map<String, dynamic>.from(response);
  }

  Future<List<SocialLinkPlatformChoiceModel>> getPlatformChoices() async {
    final response =
    await _apiServices.getApi(AppUrl.getSocialLinkPlatformChoices);

    final choices = response['choices'] as List;
    return choices
        .map((e) => SocialLinkPlatformChoiceModel.fromJson(e))
        .toList();
  }
}