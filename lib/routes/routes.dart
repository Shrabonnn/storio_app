import 'package:flutter/material.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/splash_screen.dart';
import 'package:storio_app/view/action_details.dart';
import 'package:storio_app/view/activity_category_screen.dart';
import 'package:storio_app/view/activity_manage_details_screen.dart';
import 'package:storio_app/view/activity_manage_screen.dart';
import 'package:storio_app/view/bottom_navbar.dart';
import 'package:storio_app/view/contact_message_details.dart';
import 'package:storio_app/view/contact_screen.dart';
import 'package:storio_app/view/customization_screen.dart';
import 'package:storio_app/view/dashboard.dart';
import 'package:storio_app/view/institute_profile_screen.dart';
import 'package:storio_app/view/login_screen.dart';
import 'package:storio_app/view/media_manage_details_screen.dart';
import 'package:storio_app/view/media_manage_screen.dart';
import 'package:storio_app/view/profile_screen.dart';
import 'package:storio_app/view/settings_screen.dart';

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
      default:
        return MaterialPageRoute(builder: (context)=>Scaffold(
          body: Center(
            child: Text("No Route Has Been Selected"),
          ),
        ));
    }

  }
}