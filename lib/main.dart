import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:storio_app/data/model/user_manage/user/user_model.dart';
import 'package:storio_app/routes/routes.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/splash_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/utils/app_sizes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:storio_app/utils/theme/app_theme.dart';
import 'package:storio_app/viewModel/Authenticaion/auth_view_model.dart';
import 'package:storio_app/viewModel/Content/activity_view_model.dart';
import 'package:storio_app/viewModel/Content/blog_view_model.dart';
import 'package:storio_app/viewModel/Content/career_view_model.dart';
import 'package:storio_app/viewModel/Content/contact_view_model.dart';
import 'package:storio_app/viewModel/Content/event_view_model.dart';
import 'package:storio_app/viewModel/Content/exam_result_view_model.dart';
import 'package:storio_app/viewModel/Content/faq_view_model.dart';
import 'package:storio_app/viewModel/Content/gallery_view_model.dart';
import 'package:storio_app/viewModel/Content/notice_view_model.dart';
import 'package:storio_app/viewModel/Content/promotion_view_model.dart';
import 'package:storio_app/viewModel/Content/testimonial_view_model.dart';
import 'package:storio_app/viewModel/Media/media_view_model.dart';
import 'package:storio_app/viewModel/hero_view_model.dart';
import 'package:storio_app/viewModel/organization/card_view_model.dart';
import 'package:storio_app/viewModel/organization/important_view_model.dart';
import 'package:storio_app/viewModel/organization/leadership_message_view_model.dart';
import 'package:storio_app/viewModel/organization/social_link_view_model.dart';
import 'package:storio_app/viewModel/organization/staff_view_model.dart';
import 'package:storio_app/viewModel/organization/team_member_view_model.dart';
import 'package:storio_app/viewModel/setting/theme_view_model.dart';
import 'package:storio_app/viewModel/user_manage/role_view_model.dart';
import 'package:storio_app/viewModel/user_manage/user_view_model.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
          ChangeNotifierProvider(create: (_) => HeroProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => NoticeViewModel()),
          ChangeNotifierProvider(create: (_) => MediaViewModel()),

          ChangeNotifierProvider(create: (_) => BlogViewModel()),
          ChangeNotifierProvider(create: (_) => CareerViewModel()),
          ChangeNotifierProvider(create: (_) => ContactViewModel()),
          ChangeNotifierProvider(create: (_) => ActivityViewModel()),
          ChangeNotifierProvider(create: (_) => FaqViewModel()),
          ChangeNotifierProvider(create: (_) => GalleryViewModel()),
          ChangeNotifierProvider(create: (_) => EventViewModel()),
          ChangeNotifierProvider(create: (_) => PromotionViewModel()),
          ChangeNotifierProvider(create: (_) => TestimonialViewModel()),
          ChangeNotifierProvider(create: (_) => ExamResultViewModel()),

          ChangeNotifierProvider(create: (_) => StaffViewModel()),
          ChangeNotifierProvider(create: (_) => LeadershipMessageViewModel()),
          ChangeNotifierProvider(create: (_) => TeamViewModel()),
          ChangeNotifierProvider(create: (_) => SocialLinkViewModel()),
          ChangeNotifierProvider(create: (_) => ImportantLinkViewModel()),
          ChangeNotifierProvider(create: (_) => CardViewModel()),


          ChangeNotifierProvider(create: (_) => RoleViewModel()),
          ChangeNotifierProvider(create: (_) => UserViewModel()),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return MaterialApp(

              debugShowCheckedModeBanner: false,

              localizationsDelegates: const [
                FlutterQuillLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],

              supportedLocales: const [Locale('en')],

              initialRoute: RoutesName.splash_screen,
              onGenerateRoute: Routes.generateRoute,
              theme: themeProvider.currentTheme,
            );
          },
        ),
      );
    });
  }
}