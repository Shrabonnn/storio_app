
import '../../../core/network/network_api_services.dart';
import '../../../res/api_url/app_url.dart';

class NoticeRepository {
  final NetworkApiServices _apiServices = NetworkApiServices();

  Future<dynamic> getManagementNoticeApi({String? status, String? search}) async {
    return await _apiServices.getApi(
      AppUrl.getManagementNotice,
      requiresAuth: true,
      queryParams: {
        if (status != null && status.isNotEmpty) 'status': status,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
  }


  Future<dynamic> getNoticeStatusChoicesApi() async {
    return await _apiServices.getApi(
      AppUrl.getNoticeStatusChoices,
      requiresAuth: true,
    );
  }

  Future<dynamic> createNoticeApi({
    required String title,
    required String content,
    required String status,
    String? publishDate,
    List<int>? attachments,
  }) async {
    final Map<String, dynamic> data = {
      "title": title,
      "content": content,
      "status": status,
      "attachments": attachments ?? [],
    };

    if (publishDate != null && publishDate.isNotEmpty) {
      data["publish_date"] = publishDate;
    }

    return await _apiServices.postApi(
      AppUrl.createNotice,
      data,
      requiresAuth: true,
    );
  }




  Future<dynamic> updateNoticeApi({
    required int id,
    required String title,
    required String content,
    required String status,
    String? publishDate,
    List<int>? attachments,
    bool? pdfViewMode,
  }) async {
    final Map<String, dynamic> data = {
      "title": title,
      "content": content,
      "status": status,
      "attachments": attachments ?? [],
    };

    if (publishDate != null && publishDate.isNotEmpty) {
      data["publish_date"] = publishDate;
    }

    if (pdfViewMode != null) {
      data["pdf_view_mode"] = pdfViewMode;
    }


    return await _apiServices.patchApi(
      "${AppUrl.getManagementNotice}$id/",
      data,
      requiresAuth: true,
    );
  }


  Future<dynamic> archiveNoticeApi(int id) async {
    return await _apiServices.postApi(
      AppUrl.noticeArchive(id),
      {},
      requiresAuth: true,
    );
  }

  Future<dynamic> draftNoticeApi(int id) async {
    return await _apiServices.postApi(
      AppUrl.noticeDraft(id),
      {},
      requiresAuth: true,
    );
  }

  Future<dynamic> restoreNoticeApi(int id) async {
    return await _apiServices.postApi(
      AppUrl.noticeRestore(id),
      {},
      requiresAuth: true,
    );
  }

  Future<dynamic> permanentDeleteNoticeApi(int id) async {
    return await _apiServices.deleteApi(
      AppUrl.noticePermanentDelete(id),
      requiresAuth: true,
    );
  }

  Future<dynamic> bulkNoticeApi({
    required String action,
    required List<int> noticeIds,
  }) async {
    return await _apiServices.postApi(
      AppUrl.noticeBulk,
      {
        "action": action,
        "notice_ids": noticeIds,
      },
      requiresAuth: true,
    );
  }
}