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


  //Promotions ====================

  // Public
  static const String getPromotions = "$baseUrl/api/promotions/";

  static String promotionClick(int id) => "$baseUrl/api/promotions/$id/click/";

  // Management
  static const String getManagementPromotions = "$baseUrl/api/management/promotions/";

  static  String updateManagementPromotions(int id) => "$baseUrl/api/management/promotions/$id/";

  static const String movedToBin = "$baseUrl/api/management/promotions/bin/";


  static const String createPromotion = "$baseUrl/api/management/promotions/create/";

  static String publishPromotion(int id) => "$baseUrl/api/management/promotions/$id/publish/";

  static String archivePromotion(int id) => "$baseUrl/api/management/promotions/$id/archive/";

  static String draftPromotion(int id) => "$baseUrl/api/management/promotions/$id/draft/";

  static String restorePromotion(int id) => "$baseUrl/api/management/promotions/$id/restore/";

  static String permanentlyDeletePromotion(int id) => "$baseUrl/api/management/promotions/$id/permanent-delete/";

  static const String bulkPromotion = "$baseUrl/api/management/promotions/bulk/";



  //Testimonial
  // Public
  static const String testimonialsApi = '$baseUrl/api/testimonials/';

  // Management
  static const String managementTestimonialsApi = '$baseUrl/api/management/testimonials/';

  // Create
  static const String createTestimonialApi = '$baseUrl/api/management/testimonials/create/';

  // Bulk
  static const String bulkTestimonialOperationsApi = '$baseUrl/api/management/testimonials/bulk-operations/';

  // Reorder
  static const String reorderTestimonialsApi = '$baseUrl/api/management/testimonials/reorder/';



  // ============================================================
  // Activity
  // ============================================================

  // Public
  static const String getActivities = "$baseUrl/api/activities/";
  static String getActivityDetail(String slug) => "${getActivities}$slug/";
  static const String getPublicActivityCategories = "$baseUrl/api/activities/categories/";

  // Management
  static const String getManagementActivities = "$baseUrl/api/management/activities/";
  static const String createActivity = "${getManagementActivities}create/";
  static const String getActivityStatusChoices = "${getManagementActivities}status-choices/";
  static const String activityBulkOperations = "${getManagementActivities}bulk-operations/";

  static String activityDetail(int id) => "${getManagementActivities}$id/";
  static String activitySchedule(int id) => "${getManagementActivities}$id/schedule/";
  static String activityBin(int id) => "${getManagementActivities}$id/bin/";
  static String activityRestore(int id) => "${getManagementActivities}$id/restore/";

  // Category Management
  static const String getManagementActivityCategories = "${getManagementActivities}categories/";
  static const String createActivityCategory = "${getManagementActivityCategories}create/";
  static String activityCategoryDetail(int id) => "${getManagementActivityCategories}$id/";



  // ============================================================
  // Career / Jobs
  // ============================================================


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

   // ===================================
  // FAQ
  static const String getFaqs = "$baseUrl/api/faq/";

  static const String getManagementFaqs = "$baseUrl/api/management/faq/";
  static const String createFaq = "${getManagementFaqs}create/";

  static String faqDetail(int id) => "${getManagementFaqs}$id/";




  // ============================================================
  // Gallery
  // ============================================================

  // Public
  static const String getGallery = "$baseUrl/api/gallery/";
  static const String getPublicAlbums = "$baseUrl/api/gallery/albums/";

  // Management
  static const String getManagementGallery = "$baseUrl/api/management/gallery/";
  static const String createGalleryImage = "${getManagementGallery}create/";
  static const String galleryBulkOperations = "${getManagementGallery}bulk-operations/";

  static String galleryImageDetail(int id) => "${getManagementGallery}$id/";

  // Album Management
  static const String getManagementAlbums = "${getManagementGallery}albums/";
  static const String createAlbum = "${getManagementAlbums}create/";
  static String albumDetail(int id) => "${getManagementAlbums}$id/";




  // ============================================================
  // Event
  // ============================================================

  // Event List
  static const String getEvent = "$baseUrl/api/events/";
  static  String eventDatils(int id) => "${getEvent}$id/";

  // Event Categories
  static const String getEventCategories  = "$baseUrl/api/event-categories/";
  static  String eventCategoriesDetails(int id)  => "${getEventCategories}$id/";




   // ================================
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