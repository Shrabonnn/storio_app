import 'package:flutter/material.dart';


class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;


  static Future<void> logoutAndRedirectToLogin(String loginRouteName) async {
    final navigatorState = navigatorKey.currentState;

    if (navigatorState == null) return;

    navigatorState.pushNamedAndRemoveUntil(
      loginRouteName,
          (route) => false,
    );
  }
}
