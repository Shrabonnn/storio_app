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

  // Blog

  static const String getManagementBlogs = "$baseUrl/api/management/blogs/";
  static const String createBlog = "${getManagementBlogs}create/";
  static const String getBlogStatusChoices = "${getManagementBlogs}status-choices/";
  static const String blogBulkOperations = "${getManagementBlogs}bulk-operations/";

  static String blogDetail(int id) => "${getManagementBlogs}$id/";
  static String blogSchedule(int id) => "${getManagementBlogs}$id/schedule/";
  static String blogBin(int id) => "${getManagementBlogs}$id/bin/";
  static String blogRestore(int id) => "${getManagementBlogs}$id/restore/";

  // Blog Category Management
  static const String getManagementBlogCategories = "$baseUrl/api/management/categories/";
  static const String createBlogCategory = "${getManagementBlogCategories}create/";
  static String blogCategoryDetail(int id) => "${getManagementBlogCategories}$id/";






  // Career / Jobs


  // Public
  static const String getJobs = "$baseUrl/api/jobs/";
  static String getJobDetail(String slug) => "${getJobs}$slug/";

  // Management
  static const String getManagementJobs = "$baseUrl/api/management/jobs/";
  static const String createJob = "${getManagementJobs}create/";
  static const String jobStatusChoices = "${getManagementJobs}status-choices/";
  static const String jobTypeChoices = "${getManagementJobs}type-choices/";
  static const String jobBulkOperations = "${getManagementJobs}bulk-operations/";

  static String jobDetail(int id) => "${getManagementJobs}$id/";


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