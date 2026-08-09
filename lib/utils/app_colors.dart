import 'dart:ui';

class AppColors {
  static const Color secondary = Color(0XFF58769E);
  static const Color primary = Color(0xFF1A437A);
  static const Color background = Color(0xFFEDEDF7);
  static const Color cartbackground = Color(0xFF78A6E4);

  static Color get cartBackgroundLight =>
  cartbackground.withValues(alpha: 0.3);



}