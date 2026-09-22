class AppUrl {
  static const String baseUrl = "https://api.storio.cloud";

  static const String tenantHost = "diu.storio.cloud";

  // Auth
  static const String loginApi = "$baseUrl/api/auth/login/";

  static const String standardLoginApi = "$baseUrl/api/auth/login/";

  static const String refreshTokenApi = "$baseUrl/api/token/refresh/";

  static const String logoutApi = "$baseUrl/api/auth/logout/";

// User Management
  static const String createUserApi = "$baseUrl/api/auth/users/create/";
  static const String userListApi = "$baseUrl/api/auth/users/";
  static String userDetailApi(int id) => "$baseUrl/api/auth/users/$id/";
  static const String assignRoleApi = "$baseUrl/api/auth/users/assign-role/";
  static const String bulkUserApi = "$baseUrl/api/auth/users/bulk/";
  static const String rolesListApi = "$baseUrl/api/auth/roles/";
  static String resetPasswordApi(int id) => "$baseUrl/api/auth/users/$id/reset-password/";

  // User Profile
  static String userProfileApi(String slug) => "$baseUrl/api/auth/profile/$slug/";
  static String changePasswordApi(String slug) => "$baseUrl/api/auth/profile/$slug/change-password/";

  // Institute Profile
  static const String institutionProfile = "$baseUrl/api/institution-profile/";
  static const String v2InstitutionProfile = "$baseUrl/api/v2/template/institution-profile/";


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



  // Admission
  static String get admissionFormConfig => "$baseUrl/api/admission/form-config/current/";
  static String get admissionFormConfigBase => "$baseUrl/api/admission/form-config/";
  static String admissionFormConfigUpdate(int id) => "$baseUrl/api/admission/form-config/$id/";

  static String get admissionApplications => "$baseUrl/api/admission/applications/";
  static String admissionApplicationUpdateStatus(int id) => "$baseUrl/api/admission/applications/$id/update_status/";
  static String get admissionApplicationsExportCsv => "$baseUrl/api/admission/applications/export_csv/";





  //  Academic Calendar
  static String get calendarEvents => "$baseUrl/api/calendar/events/";
  static String calendarEventDetail(int id) => "$baseUrl/api/calendar/events/$id/";
  static String get calendarSettings => "$baseUrl/api/calendar/settings/";
  static String get calendarSettingsUpdate => "$baseUrl/api/calendar/settings/update/";




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
  // Contact Messages
  // ============================================================


  static const String getContactMessages = "$baseUrl/api/contact/";
  static String contactMessageDetail(int id) => "$baseUrl/api/contact/$id/";
  static String markContactAsRead(int id) => "$baseUrl/api/contact/$id/mark_as_read/";
  static String markContactAsReplied(int id) => "$baseUrl/api/contact/$id/mark_as_replied/";
  static String markContactAsArchived(int id) => "$baseUrl/api/contact/$id/mark_as_archived/";


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


  // Exam Results
  static const String getExamResults = "$baseUrl/api/management/exam-results/";
  static String examResultDetail(int id) => "$baseUrl/api/management/exam-results/$id/";
  static const String getPublicExamResults = "$baseUrl/api/v2/template/exam-results/";


  // ============================================================
  //  Reels & Video Management
  // ============================================================

  // Public
  static String get getPublicReels => "$baseUrl/api/reels/";

  // Management
  static String get getManagementReels => "$baseUrl/api/management/reels/create/";
  static String get createReel => "$baseUrl/api/management/reels/create/";

  static String reelDetail(int id) => "$baseUrl/api/management/reels/$id/";
  static String reelStatus(int id) => "$baseUrl/api/management/reels/$id/status/";
  static String reelMetrics(int id) => "$baseUrl/api/management/reels/$id/metrics/";

  static String get uploadReelThumbnail =>
      "$baseUrl/api/management/reels/upload-thumbnail/";


  // ============================================================
  // HERO SLIDE - PUBLIC
  // ============================================================

  /// GET - active hero slides for public display
  static const String heroSlidesPublicApi = "$baseUrl/api/hero-slides/";

  static const String heroSlidesManagementApi = "$baseUrl/api/management/hero-slides/";

  static const String heroSlideCreateApi = "$baseUrl/api/management/hero-slides/create/";

  static String heroSlideDetailApi(int id) => "$baseUrl/api/management/hero-slides/$id/";

  static const String heroSlideReorderApi = "$baseUrl/api/management/hero-slides/reorder/";

  static const String heroSlideBulkOperationsApi = "$baseUrl/api/management/hero-slides/bulk-operations/";






  // ================================
  // Media
  // ================================
  static const String _mediaBase = "$baseUrl/api/management/media/";
  static const String mediaFileUploadConfig = "${_mediaBase}file-upload-config/";
  static const String mediaFileTypes = "${_mediaBase}file-types/";
  static const String mediaList = _mediaBase;              // GET (list)
  static const String mediaCreate = "${_mediaBase}create/"; // POST (upload)
  static String mediaDetail(int id) => "$_mediaBase$id/";   // GET/PATCH/DELETE



  // Organization

  // Staff
  static const String getStaff = "$baseUrl/api/staff/";
  static const String getPublicDepartments = "$baseUrl/api/staff/departments/";

  static const String getManagementStaff = "$baseUrl/api/management/staff/";

  static const String createStaff = "${getManagementStaff}create/";

  static const String getStaffStatusChoices = "${getManagementStaff}status-choices/";

  static const String staffBulkOperations = "${getManagementStaff}bulk-operations/";

  static const String staffReorder = "${getManagementStaff}reorder/";

  static String staffDetail(int id) => "${getManagementStaff}$id/";

  static const String getManagementDepartments = "$baseUrl/api/management/departments/";

  static const String createDepartment = "${getManagementDepartments}create/";

  static String departmentDetail(int id) => "${getManagementDepartments}$id/";


  // Leadership Messages
  static const String getLeadershipMessages = "$baseUrl/api/leadership-messages/";

  static const String getManagementLeadershipMessages = "$baseUrl/api/management/leadership-messages/";

  static const String createLeadershipMessage = "${getManagementLeadershipMessages}create/";

  static const String getLeadershipMessageStatusChoices = "${getManagementLeadershipMessages}status-choices/";

  static const String leadershipMessageBulkOperations = "${getManagementLeadershipMessages}bulk-operations/";

  static const String leadershipMessageReorder = "${getManagementLeadershipMessages}reorder/";

  static String leadershipMessageDetail(int id) => "${getManagementLeadershipMessages}$id/";


  // Team Member
  static const String publicTeamSections = "$baseUrl/api/team/sections/";
  static const String publicTeamMembers = "$baseUrl/api/team/members/";

  static const String managementTeamSections = "$baseUrl/api/management/team/sections/";
  static const String createTeamSection = "$baseUrl/api/management/team/sections/create/";
  static String teamSectionDetail(int id) => "$baseUrl/api/management/team/sections/$id/";

  static const String managementTeamMembers = "$baseUrl/api/management/team/members/";
  static const String createTeamMember = "$baseUrl/api/management/team/members/create/";
  static String teamMemberDetail(int id) => "$baseUrl/api/management/team/members/$id/";
  static const String bulkTeamMemberOperations = "$baseUrl/api/management/team/members/bulk-operations/";

  static const String imageShapeChoices = "$baseUrl/api/management/team/image-shape-choices/";



  // Social Links
  static const String getSocialLinks = "$baseUrl/api/management/social-links/";
  static const String getSocialLinkPlatformChoices = "${getSocialLinks}platform-choices/";
  static String socialLinkDetail(int id) => "${getSocialLinks}$id/";



// Important Links
  static const String getImportantLinks = "$baseUrl/api/important-links/";
  static String importantLinkDetail(int id) => "$baseUrl/api/important-links/$id/";

  // Board Settings
  static const String importantLinksBoardSettings = "$baseUrl/api/important-links/board-settings/current/";

  // Fetch Education Board Notices
  static String fetchBoardNotices(String boards) => "$baseUrl/api/important-links/board-settings/fetch-notices/?boards=$boards";



  // Cards Management
  static const String cardsApi = '$baseUrl/api/institution-profile/cards/';

  static String cardDetailApi(int id) => '$cardsApi$id/';


  static const String cardReorderApi = '$cardsApi/reorder/';


  // ============================================================
  // User Manage
  // ============================================================


  // ============================================================
  // Role 
  // ============================================================

  static const String getRoles = "$baseUrl/api/roles/";
  static const String createRole = "$baseUrl/api/roles/create/";
  static String roleDetail(int id) => "$baseUrl/api/roles/$id/";
  static String updateRole(int id) => "$baseUrl/api/roles/$id/";
  static String deleteRole(int id) => "$baseUrl/api/roles/$id/";

  // Permission & Sidebar Endpoints
  static const String getPermissions = "$baseUrl/api/permissions/";
  static const String getSidebar = "$baseUrl/api/sidebar/";


  // ============================================================
  // User Management & Profile
  // ============================================================

  static const String userList = "$baseUrl/api/auth/users/";
  static const String createUser = "$baseUrl/api/auth/users/create/";
  static String userDetail(int id) => "$baseUrl/api/auth/users/$id/";
  static String updateUser(int id) => "$baseUrl/api/auth/users/$id/";
  static String deleteUser(int id) => "$baseUrl/api/auth/users/$id/";
  static const String assignRole = "$baseUrl/api/auth/users/assign-role/";
  static String resetUserPassword(int id) => "$baseUrl/api/auth/users/$id/reset-password/";
  static const String bulkUserAction = "$baseUrl/api/auth/users/bulk/";
  static const String roleList = "$baseUrl/api/auth/roles/";
  static String userProfile(String slug) => "$baseUrl/api/auth/profile/$slug/";
  static String changePassword(String slug) => "$baseUrl/api/auth/profile/$slug/change-password/";

}
//Admin12345@
//alfasunny94@gmail.com