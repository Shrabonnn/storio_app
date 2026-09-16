import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';

import '../../model/organization/links/education_link_model.dart';
import '../../model/organization/links/important_link_model.dart';

class ImportantLinkRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // --------------------------------------------------
  // Important Links
  // --------------------------------------------------

  Future<List<ImportantLinkModel>> getImportantLinks() async {
    final response = await _apiServices.getApi(
      AppUrl.getImportantLinks,
    );

    return (response as List)
        .map((e) => ImportantLinkModel.fromJson(e))
        .toList();
  }

  Future<List<ImportantLinkModel>> getPublicImportantLinks() async {
    final response = await _apiServices.getApi(
      AppUrl.getImportantLinks,
      requiresAuth: false,
    );

    return (response as List)
        .map((e) => ImportantLinkModel.fromJson(e))
        .toList();
  }

  Future<ImportantLinkModel> createImportantLink(
      Map<String, dynamic> data,
      ) async {
    final response = await _apiServices.postApi(
      AppUrl.getImportantLinks,
      data,
    );

    return ImportantLinkModel.fromJson(response);
  }

  Future<ImportantLinkModel> updateImportantLink(
      int id,
      Map<String, dynamic> data,
      ) async {
    final response = await _apiServices.patchApi(
      AppUrl.importantLinkDetail(id),
      data,
    );

    return ImportantLinkModel.fromJson(response);
  }

  Future<void> deleteImportantLink(int id) async {
    await _apiServices.deleteApi(
      AppUrl.importantLinkDetail(id),
    );
  }

  // --------------------------------------------------
  // Education Board Settings
  // --------------------------------------------------

  Future<ImportantLinksBoardSettingsModel>
  getBoardSettings() async {
    final response = await _apiServices.getApi(
      AppUrl.importantLinksBoardSettings,
    );

    return ImportantLinksBoardSettingsModel.fromJson(response);
  }

  Future<ImportantLinksBoardSettingsModel>
  updateBoardSettings(
      Map<String, dynamic> data,
      ) async {
    final response = await _apiServices.patchApi(
      AppUrl.importantLinksBoardSettings,
      data,
    );

    return ImportantLinksBoardSettingsModel.fromJson(response);
  }

  // --------------------------------------------------
  // Education Board Notices
  // --------------------------------------------------

  Future<EducationBoardNoticesResponseModel>
  fetchBoardNotices(String boards) async {
    final response = await _apiServices.getApi(
      AppUrl.fetchBoardNotices(boards),
    );

    return EducationBoardNoticesResponseModel.fromJson(response);
  }
}