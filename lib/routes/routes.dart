import 'package:flutter/material.dart';
import 'package:storio_app/data/model/Content/blog/blog_model.dart';
import 'package:storio_app/data/model/Content/career/career_model.dart';
import 'package:storio_app/data/model/Content/contact/contact_model.dart';
import 'package:storio_app/data/model/Content/event/event_model.dart';
import 'package:storio_app/data/model/Content/faq/faq_model.dart';
import 'package:storio_app/data/model/Content/gallery/gallery_model.dart';
import 'package:storio_app/data/model/Content/promotion/promotion_model.dart';
import 'package:storio_app/data/model/Content/result/exam_result_model.dart';
import 'package:storio_app/data/model/Content/testimonial/testimonial_model.dart';
import 'package:storio_app/data/model/organization/card/card_model.dart';
import 'package:storio_app/data/model/organization/leader_message/leadership_message_model.dart';
import 'package:storio_app/data/model/organization/links/important_link_model.dart';
import 'package:storio_app/data/model/organization/staff/staff_model.dart';
import 'package:storio_app/data/model/organization/team/team_member_model.dart';
import 'package:storio_app/data/model/user_manage/role/role_permission_model.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/splash_screen.dart';
import 'package:storio_app/view/FAQ/add_new_faq.dart';
import 'package:storio_app/view/FAQ/edit_faq.dart';
import 'package:storio_app/view/FAQ/faq_management_screen.dart';
import 'package:storio_app/view/action_details.dart';
import 'package:storio_app/view/activity/activity_category_screen.dart';
import 'package:storio_app/view/activity/activity_manage_details_screen.dart';
import 'package:storio_app/view/activity/activity_manage_screen.dart';
import 'package:storio_app/view/activity/edit_activity_manage.dart';
import 'package:storio_app/view/admission/admission_form_builder.dart';
import 'package:storio_app/view/admission/admission_management_screen.dart';
import 'package:storio_app/view/admission/admission_general_setting.dart';
import 'package:storio_app/view/admission/view_admission_screen.dart';
import 'package:storio_app/view/blog/add_new_blog.dart';
import 'package:storio_app/view/blog/blog_management_screen.dart';
import 'package:storio_app/view/blog/edit_blog.dart';
import 'package:storio_app/view/blog/manage_blog_category.dart';
import 'package:storio_app/view/blog/view_blog_screen.dart';
import 'package:storio_app/view/bottom_navbar.dart';
import 'package:storio_app/view/calender/add_new_event_calender.dart';
import 'package:storio_app/view/calender/calender_screen.dart';
import 'package:storio_app/view/calender/calender_setting.dart';
import 'package:storio_app/view/career/add_new_job_circular.dart';
import 'package:storio_app/view/career/career_management_screen.dart';
import 'package:storio_app/view/career/edit_career.dart';
import 'package:storio_app/view/contact/contact_message_details.dart';
import 'package:storio_app/view/contact/contact_screen.dart';
import 'package:storio_app/view/content_details.dart';
import 'package:storio_app/view/customization_screen.dart';
import 'package:storio_app/view/dashboard.dart';
import 'package:storio_app/view/event/add_new_event.dart';
import 'package:storio_app/view/event/edit_event.dart';
import 'package:storio_app/view/event/event_management_screen.dart';
import 'package:storio_app/view/event/manage_event_category.dart';
import 'package:storio_app/view/event/view_event_screen.dart';
import 'package:storio_app/view/gallery/add_gallery_images.dart';
import 'package:storio_app/view/gallery/edit_gallery_images.dart';
import 'package:storio_app/view/gallery/gallery_management_screen.dart';
import 'package:storio_app/view/gallery/manage_albums.dart';
import 'package:storio_app/view/hero/add_new_hero_slide.dart';
import 'package:storio_app/view/hero/hero_section_manager_screen.dart';
import 'package:storio_app/view/institute_profile_screen.dart';
import 'package:storio_app/view/login_screen.dart';
import 'package:storio_app/view/media/media_manage_details_screen.dart';
import 'package:storio_app/view/media/media_manage_screen.dart';
import 'package:storio_app/view/notice/add_new_notice.dart';
import 'package:storio_app/view/notice/edit_notice.dart';
import 'package:storio_app/view/notice/notice_management_screen.dart';
import 'package:storio_app/view/notice/view_notice_screen.dart';
import 'package:storio_app/view/organization/card/add_new_card.dart';
import 'package:storio_app/view/organization/card/card_management_screen.dart';
import 'package:storio_app/view/organization/leadership/edit_leadership_message.dart';
import 'package:storio_app/view/organization/leadership/leadership_messages_screen.dart';
import 'package:storio_app/view/organization/leadership/new_section_leadership_message.dart';
import 'package:storio_app/view/organization/leadership/view_leadership_message.dart';
import 'package:storio_app/view/organization/links/add_new_link.dart';
import 'package:storio_app/view/organization/links/education_board_notices.dart';
import 'package:storio_app/view/organization/staff/add_new_staff.dart';
import 'package:storio_app/view/organization/staff/edit_staff.dart';
import 'package:storio_app/view/organization/staff/manage_staff_department.dart';
import 'package:storio_app/view/organization/staff/staff_management_screen.dart';
import 'package:storio_app/view/organization/staff/view_staff_screen.dart';
import 'package:storio_app/view/organization/team/add_new_team_member.dart';
import 'package:storio_app/view/organization/team/edit_team_member.dart';
import 'package:storio_app/view/organization/team/manage_team_section.dart';
import 'package:storio_app/view/organization/team/team_management_screen.dart';
import 'package:storio_app/view/organization/team/view_team_screen.dart';

import 'package:storio_app/view/profile_screen.dart';
import 'package:storio_app/view/promotion/add_promotion.dart';
import 'package:storio_app/view/promotion/edit_promotion.dart';
import 'package:storio_app/view/promotion/promotion_management_screen.dart';
import 'package:storio_app/view/result/edit_result.dart';
import 'package:storio_app/view/result/exam_result_screen.dart';
import 'package:storio_app/view/result/publish_result.dart';
import 'package:storio_app/view/settings/general_settings_screen.dart';
import 'package:storio_app/view/settings/security_screen.dart';
import 'package:storio_app/view/settings/settings_screen.dart';
import 'package:storio_app/view/settings/theme_screen.dart';
import 'package:storio_app/view/testimonial/add_new_testimonial.dart';
import 'package:storio_app/view/testimonial/testimonial_screen.dart';
import 'package:storio_app/view/testimonial/view_testimonial.dart';
import 'package:storio_app/view/video/add_new_video.dart';
import 'package:storio_app/view/video/video_management_screen.dart';

import '../data/model/Content/notice/notice_model.dart';
import '../view/testimonial/edit_testimonial.dart';
import '../view/user_manage/role/add_new_role.dart';
import '../view/user_manage/role/role_management_screen.dart';
import '../view/user_manage/user/add_new_user.dart';
import '../view/user_manage/user/user_management_screen.dart';
import '../view/user_manage/user/view_user_details.dart';

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
        return MaterialPageRoute(builder: (context)=> MediaManageDetailsScreen(),settings: setting,);

       // Activity
      case RoutesName.activity_manage:
        return MaterialPageRoute(builder: (context)=> ActivityManageScreen());
      case RoutesName.activity_manage_category:
        return MaterialPageRoute(builder: (context)=> ActivityCategoryScreen());
      case RoutesName.activity_manage_details:
        return MaterialPageRoute(builder: (context)=> ActivityManageDetailsScreen());
      case RoutesName.edit_activity_manage_details:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> EditActivityManageDetailsScreen(
          activity: args?['activity'] ?? "",
        ));



        // Contact
      case RoutesName.contact:
        return MaterialPageRoute(builder: (context)=> ContactScreen());
      case RoutesName.contact_message_details:
        final args = setting.arguments as Map<String,dynamic>?;
        return MaterialPageRoute(builder: (context)=> ContactMessageDetails(
          message: args?['message'] as ContactMessageModel,
        ));


        case RoutesName.content_details:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> ContentDetails(
          initialContent: args?['content'] ?? "",
        ));


     // Gallery
      case RoutesName.gallery_manage:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> GalleryManageScreen(

        ));
      case RoutesName.gallery_add_image:
        return MaterialPageRoute(builder: (context)=> AddGalleryImages());
      case RoutesName.edit_gallery_image:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> EditGalleryImages(
          image: args?['image'] as GalleryModel,
        ));
      case RoutesName.manage_album:
        return MaterialPageRoute(builder: (context)=> ManageAlbums());



        // Promotion
      case RoutesName.promotion:
        return MaterialPageRoute(builder: (context)=> PromotionManagementScreen());
      case RoutesName.add_promotion:
        return MaterialPageRoute(builder: (context)=> AddPromotion(

        ));
      case RoutesName.edit_promotion:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context) => EditPromotion(
            promotion: args?["promotion"] as PromotionModel,
          ),
        );



        // Result
      case RoutesName.exam_result:
        return MaterialPageRoute(builder: (context)=> ExamResultScreen());
      case RoutesName.publish_result:
        return MaterialPageRoute(builder: (context)=> PublishResult());
      case RoutesName.edit_result:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> EditResult(
          examResult: args?['examResult'] as ExamResultModel,
        ));



      //Testimonial
      case RoutesName.testimonial:
        return MaterialPageRoute(builder: (context)=> TestimonialScreen());
      case RoutesName.add_new_testimonial:
        return MaterialPageRoute(builder: (context)=> AddNewTestimonial());
      case RoutesName.edit_testimonial:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> EditTestimonial(
          testimonial: args?['testimonial'] as TestimonialModel,
        ));
      case RoutesName.view_testimonial:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> ViewTestimonial(
          testimonial: args?['testimonial'] as TestimonialModel,
        ));



      //FAQ
      case RoutesName.faq:
        return MaterialPageRoute(builder: (context)=> FaqManagementScreen());
      case RoutesName.edit_faq:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> EditFaq(
          faq: args?['faq'] as FaqModel,
        ));
      case RoutesName.add_new_faq:
        return MaterialPageRoute(builder: (context)=> CreateNewFaq());


      // Career
      case RoutesName.career:
        return MaterialPageRoute(builder: (context)=> CareerManagementScreen());
      case RoutesName.add_new_job_circular:
        return MaterialPageRoute(builder: (context)=> AddNewJobCircular(
        ));
      case RoutesName.edit_job_circular:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> EditJobCircular(
          job: args?['job'] as CareerModel,
        ));


       // Bolg
      case RoutesName.blog:
        return MaterialPageRoute(builder: (context)=> BlogManagementScreen());
      case RoutesName.manage_blog_category:
        return MaterialPageRoute(builder: (context)=> ManageBlogCategory());
      case RoutesName.view_blog:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> ViewBlogScreen(
          blog: args?['blog'] as BlogModel,
        ));
      case RoutesName.add_blog:
        return MaterialPageRoute(builder: (context)=> AddBlog());
      case RoutesName.edit_blog:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> EditBlog(
          blog: args?['blog'] as BlogModel,
        ));


       // Event
      case RoutesName.event:
        return MaterialPageRoute(builder: (context)=> EventManagementScreen());
      case RoutesName.manage_event_category:
        return MaterialPageRoute(builder: (context)=> ManageEventCategory());
      case RoutesName.view_event:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> ViewEventScreen(
          event: args?['event'] as EventModel,
        ));
      case RoutesName.add_new_event:
        return MaterialPageRoute(builder: (context)=> AddNewEvent(
        ));
      case RoutesName.edit_event:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> EditEvent(
          event: args?['event'] as EventModel,
        ));

        //Notice
      case RoutesName.notice:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> NoticeManagementScreen(
          showBackButton: args?['showBackButton'] ?? false,
        ));
      case RoutesName.view_notice:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> ViewNoticeScreen(
          notice: args?['notice'] as NoticeModel,
        ));
      case RoutesName.add_new_notice:
        return MaterialPageRoute(builder: (context)=> AddNewNotice());
      case RoutesName.edit_notice:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> EditNotice(
          notice: args?['notice'] as NoticeModel,
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

      // Card
      case RoutesName.card_manage:
        return MaterialPageRoute(builder: (context)=> CardManagementScreen());
      case RoutesName.add_new_card_manage:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> AddNewCard(
          isEdit: args?['isEdit'] ?? false,
          card: args?['card'] as CardModel?,
        ));


      // Important Links
      case RoutesName.important_links:
        return MaterialPageRoute(builder: (context)=> EducationBoardNotices());
      case RoutesName.add_new_links:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> AddNewLink(
          isEdit: args?['isEdit'] ?? false,
          link: args?['link'] as ImportantLinkModel?,
        ));

      // Staff
      case RoutesName.staff_manage:
        return MaterialPageRoute(builder: (context)=> StaffManagementScreen());
      case RoutesName.view_staff_manage:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> ViewStaffScreen(

          staff: args?['staff'] as StaffModel,
        ));
      case RoutesName.add_new_staff_manage:
        return MaterialPageRoute(builder: (context)=> AddNewStaff(
          ));
      case RoutesName.edit_staff:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> EditStaff(
            staff: args?['staff'] as StaffModel,
        ));
      case RoutesName.manage_staff_department:
        return MaterialPageRoute(builder: (context)=> ManageStaffDepartment(
         ));



      // Team Manage
      case RoutesName.team_manage:
        return MaterialPageRoute(builder: (context)=> TeamManagementScreen());
      case RoutesName.view_team_manage:
         final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> ViewTeamScreen(
             member: args?['member'] as TeamMemberModel));

      case RoutesName.add_new_team_member:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> AddNewTeamMember(
         ));
      case RoutesName.edit_team_member:
        final args = setting.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (context)=> EditTeamMember(
            member: args?['member'] as TeamMemberModel));
      case RoutesName.manage_team_section:
        return MaterialPageRoute(builder: (context)=> ManageTeamSection());


        case RoutesName.role:
        return MaterialPageRoute(builder: (context)=> RoleManagementScreen());
      case RoutesName.add_new_role:
        final args = setting.arguments as Map<String ,dynamic>?;
        return MaterialPageRoute(builder: (context)=> AddNewRole(
          isEdit: args?['isEdit'] ?? false,
          role: args?['role'] as RoleModel?,
        ));

      case RoutesName.user:
        return MaterialPageRoute(builder: (context)=> UserManagementScreen());
      case RoutesName.add_new_user:
        final args = setting.arguments as Map<String ,dynamic>?;
        return MaterialPageRoute(builder: (context)=> AddNewUser(
          isEdit: args?['isEdit'] ?? false,
        ));
      case RoutesName.view_user_details:
        return MaterialPageRoute(builder: (context)=> ViewUserDetails());


        // Leadership Message
      case RoutesName.leadership_message:
        return MaterialPageRoute(builder: (context)=> LeadershipMessagesScreen());
      case RoutesName.view_leadership_message:
        final args = setting.arguments as Map<String ,dynamic>?;
        return MaterialPageRoute(builder: (context)=> ViewLeadershipMessage(
          message: args?["message"] as LeadershipMessageModel,
        ));
      case RoutesName.new_section_leadership_message:
        final args = setting.arguments as Map<String ,dynamic>?;
        return MaterialPageRoute(builder: (context)=> NewSectionLeadershipMessage());
      case RoutesName.edit_leadership_message:
        final args = setting.arguments as Map<String ,dynamic>?;
        return MaterialPageRoute(builder: (context)=> EditSectionLeadershipMessage(
          message: args?["message"] as LeadershipMessageModel,
        ));



      // Settings
      case RoutesName.general_settings:
        return MaterialPageRoute(builder: (context)=> GeneralSettingsScreen());
      case RoutesName.security:
        return MaterialPageRoute(builder: (context)=> SecurityScreen());
      case RoutesName.theme:
        return MaterialPageRoute(builder: (context)=> ThemeScreen());













      default:
        return MaterialPageRoute(builder: (context)=>Scaffold(
          body: Center(
            child: Text("No Route Has Been Selected"),
          ),
        ));
    }

  }
}