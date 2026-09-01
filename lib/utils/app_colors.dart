import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const Color secondary = Color(0XFF58769E);
  static const Color primary = Color(0xFF1A437A);

  static const Color background = Color(0xFFEDEDF7);
  static const Color primaryLightVersion = Color(0xFF78A6E4);

  static const Color cardBackground =Color(0xFFFFFFFF);

  static Color get lightVersionOfPrimaryLightVersion =>
  primaryLightVersion.withValues(alpha: 0.3);




}