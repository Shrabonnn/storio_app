import 'package:flutter/material.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/splash_screen.dart';
import 'package:storio_app/view/FAQ/edit_faq.dart';
import 'package:storio_app/view/FAQ/faq_management_screen.dart';
import 'package:storio_app/view/action_details.dart';
import 'package:storio_app/view/activity/activity_category_screen.dart';
import 'package:storio_app/view/activity/activity_manage_details_screen.dart';
import 'package:storio_app/view/activity/activity_manage_screen.dart';
import 'package:storio_app/view/admission/admission_form_builder.dart';
import 'package:storio_app/view/admission/admission_management_screen.dart';
import 'package:storio_app/view/admission/admission_general_setting.dart';
import 'package:storio_app/view/admission/view_admission_screen.dart';
import 'package:storio_app/view/blog/add_new_blog.dart';
import 'package:storio_app/view/blog/blog_management_screen.dart';
import 'package:storio_app/view/blog/manage_blog_category.dart';
import 'package:storio_app/view/blog/view_blog_screen.dart';
import 'package:storio_app/view/bottom_navbar.dart';
import 'package:storio_app/view/calender/add_new_event_calender.dart';
import 'package:storio_app/view/calender/calender_screen.dart';
import 'package:storio_app/view/calender/calender_setting.dart';
import 'package:storio_app/view/career/add_new_job_circular.dart';
import 'package:storio_app/view/career/career_management_screen.dart';
import 'package:storio_app/view/contact/contact_message_details.dart';
import 'package:storio_app/view/contact/contact_screen.dart';
import 'package:storio_app/view/content_details.dart';
import 'package:storio_app/view/customization_screen.dart';
import 'package:storio_app/view/dashboard.dart';
import 'package:storio_app/view/event/add_new_event.dart';
import 'package:storio_app/view/event/event_management_screen.dart';
import 'package:storio_app/view/event/manage_event_category.dart';
import 'package:storio_app/view/event/view_event_screen.dart';
import 'package:storio_app/view/gallery/add_gallery_images.dart';
import 'package:storio_app/view/gallery/gallery_management_screen.dart';
import 'package:storio_app/view/gallery/manage_albums.dart';
import 'package:storio_app/view/hero/add_new_hero_slide.dart';
import 'package:storio_app/view/hero/hero_section_manager_screen.dart';
import 'package:storio_app/view/institute_profile_screen.dart';
import 'package:storio_app/view/login_screen.dart';
import 'package:storio_app/view/media/media_manage_details_screen.dart';
import 'package:storio_app/view/media/media_manage_screen.dart';
import 'package:storio_app/view/notice/add_new_notice.dart';
import 'package:storio_app/view/notice/notice_management_screen.dart';
import 'package:storio_app/view/notice/view_notice_screen.dart';
import 'package:storio_app/view/organization/card/add_new_card.dart';
import 'package:storio_app/view/organization/card/card_management_screen.dart';
import 'package:storio_app/view/organization/leadership/leadership_messages_screen.dart';
import 'package:storio_app/view/organization/leadership/new_section_leadership_message.dart';
import 'package:storio_app/view/organization/leadership/view_leadership_message.dart';
import 'package:storio_app/view/organization/links/add_new_link.dart';
import 'package:storio_app/view/organization/links/education_board_notices.dart';
import 'package:storio_app/view/organization/role/add_new_role.dart';
import 'package:storio_app/view/organization/role/role_management_screen.dart';
import 'package:storio_app/view/organization/staff/add_new_staff.dart';
import 'package:storio_app/view/organization/staff/manage_staff_department.dart';
import 'package:storio_app/view/organization/staff/staff_management_screen.dart';
import 'package:storio_app/view/organization/staff/view_staff_screen.dart';
import 'package:storio_app/view/organization/team/add_new_team_member.dart';
import 'package:storio_app/view/organization/team/manage_team_section.dart';
import 'package:storio_app/view/organization/team/team_management_screen.dart';
import 'package:storio_app/view/organization/team/view_team_screen.dart';
import 'package:storio_app/view/organization/user/add_new_user.dart';
import 'package:storio_app/view/organization/user/user_management_screen.dart';
import 'package:storio_app/view/organization/user/view_user_details.dart';
import 'package:storio_app/view/profile_screen.dart';
import 'package:storio_app/view/promotion/add_promotion.dart';
import 'package:storio_app/view/promotion/promotion_management_screen.dart';
import 'package:storio_app/view/result/exam_result_screen.dart';
import 'package:storio_app/view/result/publish_result.dart';
import 'package:storio_app/view/settings/general_settings_screen.dart';
import 'package:storio_app/view/settings/security_screen.dart';
import 'package:storio_app/view/settings/settings_screen.dart';
import 'package:storio_app/view/testimonial/add_new_testimonial.dart';
import 'package:storio_app/view/testimonial/edit_testimonial.dart';
import 'package:storio_app/view/testimonial/testimonial_screen.dart';
import 'package:storio_app/view/video/add_new_video.dart';
import 'package:storio_app/view/video/video_management_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings setting){
    switch(setting.name){
      case RoutesName.splash_screen:
        return MaterialPageRoute(builder: (context)=> StorioSplashScreen());
      case RoutesName.login:
        return MaterialPageRoute(builder: (context)=> LoginScreen());
      case RoutesName.nav_bar:
        return MaterialPageRoute(builder: (context)=> BottomNavbar());
      case RoutesName.dasboard:
        return MaterialPageRoute(builder: (context)=> Dashboard());
      case RoutesName.customization:
        return MaterialPageRoute(builder: (context)=> CustomizationScreen());
      case RoutesName.action_details:
        return MaterialPageRoute(builder: (context)=> ActionDetails());
      case RoutesName.institute_profile:
        return MaterialPageRoute(builder: (context)=> InstituteProfileScreen());
      case RoutesName.settings:
        return MaterialPageRoute(builder: (context)=> SettingsScreen());
      case RoutesName.profile:
        return MaterialPageRoute(builder: (context)=> ProfileScreen());
      case RoutesName.media_manage:
        return MaterialPageRoute(builder: (context)=> MediaManageScreen());
      case RoutesName.media_manage_details:
        return MaterialPageRoute(builder: (context)=> MediaManageDetailsScreen());
      case RoutesName.activity_manage:
        return MaterialPageRoute(builder: (context)=> ActivityManageScreen());
      case RoutesName.activity_manage_category:
        return MaterialPageRoute(builder: (context)=> ActivityCategoryScreen());
      case RoutesName.activity_manage_details:
        return MaterialPageRoute(builder: (context)=> ActivityManageDetailsScreen());
      case RoutesName.contact:
        return MaterialPageRoute(builder: (context)=> ContactScreen());
      case RoutesName.contact_message_details:
        return MaterialPageRoute(builder: (context)=> ContactMessageDetails(name: "Maiyasha", email: "maiyasha@gmail.com", phone: "01714532456", dateTime: "10:00 AM . August 2026", subject: "Re admission", message: "Please Admit your child", status: "new"));
      case RoutesName.content_details:
        return MaterialPageRoute(builder: (context)=> ContentDetails());
      case RoutesName.gallery_manage:
        return MaterialPageRoute(builder: (context)=> GalleryManageScreen());
      case RoutesName.gallery_add_image:

        final args = setting.arguments as Map<String, dynamic>?;

        return MaterialPageRoute(builder: (context)=> AddGalleryImages(
          isEdit: args?['isEdit'] ?? false,
        ));
      case RoutesName.manage_album:
        return MaterialPageRoute(builder: (context)=> ManageAlbums());
      case RoutesName.promotion:
        return MaterialPageRoute(builder: (context)=> PromotionManagementScreen());
      case RoutesName.add_promotion:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> AddPromotion(
          isEdit: args?['isEdit'] ?? false,
        ));
      case RoutesName.exam_result:
        return MaterialPageRoute(builder: (context)=> ExamResultScreen());
      case RoutesName.publish_result:
        return MaterialPageRoute(builder: (context)=> PublishResult());
      case RoutesName.testimonial:
        return MaterialPageRoute(builder: (context)=> TestimonialScreen());
      case RoutesName.add_new_testimonial:
        return MaterialPageRoute(builder: (context)=> AddNewTestimonial());
      case RoutesName.edit_testimonial:
        return MaterialPageRoute(builder: (context)=> EditTestimonial());
      case RoutesName.faq:
        return MaterialPageRoute(builder: (context)=> FaqManagementScreen());
      case RoutesName.edit_faq:
        return MaterialPageRoute(builder: (context)=> EditFaq());
      case RoutesName.career:
        return MaterialPageRoute(builder: (context)=> CareerManagementScreen());
      case RoutesName.add_new_job_circular:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> AddNewJobCircular(
          isEdit: args?['isEdit'] ?? false,
        ));
      case RoutesName.blog:
        return MaterialPageRoute(builder: (context)=> BlogManagementScreen());
      case RoutesName.manage_blog_category:
        return MaterialPageRoute(builder: (context)=> ManageBlogCategory());
      case RoutesName.view_blog:
        return MaterialPageRoute(builder: (context)=> ViewBlogScreen());
      case RoutesName.add_blog:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> AddBlog(
          isEdit: args?['isEdit'] ?? false,
        ));
      case RoutesName.event:
        return MaterialPageRoute(builder: (context)=> EventManagementScreen());
      case RoutesName.manage_event_category:
        return MaterialPageRoute(builder: (context)=> ManageEventCategory());
      case RoutesName.view_event:
        return MaterialPageRoute(builder: (context)=> ViewEventScreen());
      case RoutesName.add_new_event:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> AddNewEvent(
          isEdit: args?['isEdit'] ?? false,
        ));
      case RoutesName.notice:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> NoticeManagementScreen(
          showBackButton: args?['showBackButton'] ?? false,
        ));
      case RoutesName.view_notice:
        return MaterialPageRoute(builder: (context)=> ViewNoticeScreen());
      case RoutesName.add_new_notice:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> AddNewNotice(
          isEdit: args?['isEdit'] ?? false,
        ));
      case RoutesName.calender:
        return MaterialPageRoute(builder: (context)=> CalenderScreen());
      case RoutesName.add_new_event_calender:
        return MaterialPageRoute(builder: (context)=> AddNewEventCalender());
      case RoutesName.calender_setting:
        return MaterialPageRoute(builder: (context)=> CalenderSetting());
      case RoutesName.video:
        return MaterialPageRoute(builder: (context)=> VideoManagementScreen());
      case RoutesName.add_new_video:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> AddNewVideo(
          isEdit: args?['isEdit'] ?? false,
        ));
      case RoutesName.hero:
        return MaterialPageRoute(builder: (context)=> HeroSectionManagerScreen());
      case RoutesName.add_new_hero_slide:
        return MaterialPageRoute(builder: (context)=> AddNewHeroSlide());
      case RoutesName.admission:
        return MaterialPageRoute(builder: (context)=> AdmissionManagementScreen());
      case RoutesName.admission_form_builder:
        return MaterialPageRoute(builder: (context)=> AdmissionFormBuilder());
      case RoutesName.admission_general_setting:
        return MaterialPageRoute(builder: (context)=> AdmissionGeneralSetting());
      case RoutesName.view_admission:
        return MaterialPageRoute(builder: (context)=> ViewAdmissionScreen());



      // organization
      case RoutesName.card_manage:
        return MaterialPageRoute(builder: (context)=> CardManagementScreen());
      case RoutesName.add_new_card_manage:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> AddNewCard(
          isEdit: args?['isEdit'] ?? false,
        ));
      case RoutesName.important_links:
        return MaterialPageRoute(builder: (context)=> EducationBoardNotices());
      case RoutesName.add_new_links:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> AddNewLink(
          isEdit: args?['isEdit'] ?? false,));
      case RoutesName.staff_manage:
        return MaterialPageRoute(builder: (context)=> StaffManagementScreen());
      case RoutesName.view_staff_manage:
        return MaterialPageRoute(builder: (context)=> ViewStaffScreen());
      case RoutesName.add_new_staff_manage:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> AddNewStaff(
          isEdit: args?['isEdit'] ?? false,));
      case RoutesName.manage_staff_department:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> ManageStaffDepartment(
          isEdit: args?['isEdit'] ?? false,));
      case RoutesName.team_manage:
        return MaterialPageRoute(builder: (context)=> TeamManagementScreen());
      case RoutesName.view_team_manage:
        return MaterialPageRoute(builder: (context)=> ViewTeamScreen());
      case RoutesName.add_new_team_member:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> AddNewTeamMember(
          isEdit: args?['isEdit'] ?? false,));
      case RoutesName.manage_team_section:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> ManageTeamSection(
          isEdit: args?['isEdit'] ?? false,));
      case RoutesName.role:
        return MaterialPageRoute(builder: (context)=> RoleManagementScreen());
      case RoutesName.add_new_role:
        return MaterialPageRoute(builder: (context)=> AddNewRole());

      case RoutesName.user:
        return MaterialPageRoute(builder: (context)=> UserManagementScreen());
      case RoutesName.add_new_user:
        final args = setting.arguments as Map<String ,dynamic>?;
        return MaterialPageRoute(builder: (context)=> AddNewUser(
          isEdit: args?['isEdit'] ?? false,
        ));
      case RoutesName.view_user_details:
        return MaterialPageRoute(builder: (context)=> ViewUserDetails());
      case RoutesName.leadership_message:
        return MaterialPageRoute(builder: (context)=> LeadershipMessagesScreen());
      case RoutesName.view_leadership_message:
        return MaterialPageRoute(builder: (context)=> ViewLeadershipMessage());
      case RoutesName.new_section_leadership_message:
        final args = setting.arguments as Map<String ,dynamic>?;
        return MaterialPageRoute(builder: (context)=> NewSectionLeadershipMessage(
          isEdit: args?['isEdit'] ?? false,));



      // Settings
      case RoutesName.general_settings:
        return MaterialPageRoute(builder: (context)=> GeneralSettingsScreen());
      case RoutesName.security:
        return MaterialPageRoute(builder: (context)=> SecurityScreen());













      default:
        return MaterialPageRoute(builder: (context)=>Scaffold(
          body: Center(
            child: Text("No Route Has Been Selected"),
          ),
        ));
    }

  }
}