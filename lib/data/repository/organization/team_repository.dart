import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';


class TeamRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  // ---------------------------------------------------------
  // Public Endpoints
  // ---------------------------------------------------------
  Future<dynamic> getPublicSections() async {
    return await _apiServices.getApi(
      AppUrl.publicTeamSections,
      requiresAuth: false,
    );
  }

  Future<dynamic> getPublicMembers({int? sectionId}) async {
    Map<String, String>? queryParams;
    if (sectionId != null) {
      queryParams = {'section': sectionId.toString()};
    }
    return await _apiServices.getApi(
      AppUrl.publicTeamMembers,
      queryParams: queryParams,
      requiresAuth: false,
    );
  }

  // ---------------------------------------------------------
  // Management Endpoints - Sections
  // ---------------------------------------------------------
  Future<dynamic> getManagementSections({String? search}) async {
    Map<String, String>? queryParams;
    if (search != null && search.isNotEmpty) {
      queryParams = {'search': search};
    }
    return await _apiServices.getApi(
      AppUrl.managementTeamSections,
      queryParams: queryParams,
    );
  }

  Future<dynamic> createTeamSection(Map<String, dynamic> data) async {
    return await _apiServices.postApi(
      AppUrl.createTeamSection,
      data,
    );
  }

  Future<dynamic> getTeamSectionDetail(int id) async {
    return await _apiServices.getApi(
      AppUrl.teamSectionDetail(id),
    );
  }

  Future<dynamic> updateTeamSection(
      int id,
      Map<String, dynamic> data, {
        bool isPartial = true,
      }) async {
    if (isPartial) {
      return await _apiServices.patchApi(AppUrl.teamSectionDetail(id), data);
    } else {
      return await _apiServices.putApi(AppUrl.teamSectionDetail(id), data);
    }
  }

  Future<dynamic> deleteTeamSection(int id) async {
    return await _apiServices.deleteApi(
      AppUrl.teamSectionDetail(id),
    );
  }

  // ---------------------------------------------------------
  // Management Endpoints - Members
  // ---------------------------------------------------------
  Future<dynamic> getManagementMembers({String? search, int? sectionId}) async {
    Map<String, String> queryParams = {};
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (sectionId != null) {
      queryParams['section'] = sectionId.toString();
    }
    return await _apiServices.getApi(
      AppUrl.managementTeamMembers,
      queryParams: queryParams.isNotEmpty ? queryParams : null,
    );
  }

  Future<dynamic> createTeamMember(Map<String, dynamic> data) async {
    return await _apiServices.postApi(
      AppUrl.createTeamMember,
      data,
    );
  }

  Future<dynamic> getTeamMemberDetail(int id) async {
    return await _apiServices.getApi(
      AppUrl.teamMemberDetail(id),
    );
  }

  Future<dynamic> updateTeamMember(
      int id,
      Map<String, dynamic> data, {
        bool isPartial = true,
      }) async {
    if (isPartial) {
      return await _apiServices.patchApi(AppUrl.teamMemberDetail(id), data);
    } else {
      return await _apiServices.putApi(AppUrl.teamMemberDetail(id), data);
    }
  }

  Future<dynamic> deleteTeamMember(int id) async {
    return await _apiServices.deleteApi(
      AppUrl.teamMemberDetail(id),
    );
  }

  // ---------------------------------------------------------
  // Bulk Operations & Choices
  // ---------------------------------------------------------
  Future<dynamic> performBulkMemberOperation(
      String action,
      List<int> memberIds,
      ) async {
    return await _apiServices.postApi(
      AppUrl.bulkTeamMemberOperations,
      {
        "action": action,
        "member_ids": memberIds,
      },
    );
  }

  Future<dynamic> getImageShapeChoices() async {
    return await _apiServices.getApi(
      AppUrl.imageShapeChoices,
    );
  }
}