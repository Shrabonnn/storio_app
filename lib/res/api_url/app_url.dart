class AppUrl {
  static const String baseUrl = "https://api.storio.cloud";

  static const String tenantHost = "diu.storio.cloud";

  // Auth
  static const String loginApi = "$baseUrl/api/auth/login/";

  static const String standardLoginApi = "$baseUrl/api/auth/login/";

  static const String refreshTokenApi = "$baseUrl/api/token/refresh/";

  static const String logoutApi = "$baseUrl/api/auth/logout/";

  // Notice
  static const String getNotice = "$baseUrl/api/notice/";
  static const String getManagementNotice = "$baseUrl/api/management/notice/";
  static const String getNoticeStatusChoices = "$baseUrl/api/management/notice/status-choices/";
  static const String createNotice = "$baseUrl/api/management/notice/create/";

  static String noticeArchive(int id) => "${getManagementNotice}$id/archive/";
  static String noticeDraft(int id) => "${getManagementNotice}$id/draft/";
  static String noticeRestore(int id) => "${getManagementNotice}$id/restore/";
  static String noticePermanentDelete(int id) => "${getManagementNotice}$id/permanent-delete/";
  static const String noticeBulk = "${getManagementNotice}bulk/";
  static const String noticeBin = "${getManagementNotice}bin/";

  // Media
  static const String _mediaBase = "$baseUrl/api/management/media/";
  static const String mediaFileUploadConfig = "${_mediaBase}file-upload-config/";
  static const String mediaFileTypes = "${_mediaBase}file-types/";
  static const String mediaList = _mediaBase;              // GET (list)
  static const String mediaCreate = "${_mediaBase}create/"; // POST (upload)
  static String mediaDetail(int id) => "$_mediaBase$id/";   // GET/PATCH/DELETE
}
//Admin12345@
//alfasunny94@gmail.com