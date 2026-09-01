import 'package:flutter/material.dart';

class AppColor extends ThemeExtension<AppColor> {
  AppColor({
    required this.primary,
    required this.secondary,
    required this.screenBackground,
    required this.primaryLightVersion,
    required this.cardBackground,
    required this.lightVersionOfPrimaryLightVersion,
    required this.textPrimary,
    required this.textSecondary,
    required this.textAppbar,
  });

  final Color primary;
  final Color secondary;
  final Color screenBackground;
  final Color primaryLightVersion;
  final Color cardBackground;
  final Color lightVersionOfPrimaryLightVersion;
  final Color textPrimary;
  final Color textSecondary;
  final Color textAppbar;

  @override
  ThemeExtension<AppColor> copyWith() => this;

  @override
  ThemeExtension<AppColor> lerp(
    covariant ThemeExtension<AppColor>? other,
    double t,
  ) => this;
}

class DefaultColor extends AppColor {
  DefaultColor()
    : super(
        primary: Color(0xFF1A437A),
        secondary: Color(0XFF58769E),

        screenBackground: Color(0xFFEDEDF7),
        primaryLightVersion: Color(0xFF78A6E4),

        cardBackground: Color(0xFFFFFFFF),
        lightVersionOfPrimaryLightVersion: Color(0xFF1A437A).withValues(alpha: 0.15),

        textPrimary: Color(0xFF1A437A),
        textSecondary: Colors.black54,
        textAppbar: Color(0xFFFFFFFF),

      );
}
class EmeraldColor extends AppColor {
  EmeraldColor()
      : super(
    primary: Color(0xFF0E6B4F),
    secondary: Color(0xFFD32F2F),

    screenBackground: Color(0xFFE7F5EE),
    primaryLightVersion: Color(0xFF66BFA0),

    cardBackground: Color(0xFFFFFFFF),
    lightVersionOfPrimaryLightVersion: Color(0xFF0E6B4F).withValues(alpha: 0.15),

    textPrimary: Color(0xFF0E6B4F),
    textSecondary: Colors.black54,
    textAppbar: Color(0xFFFFFFFF),

  );
}
class DarkColor extends AppColor {
  DarkColor()
      : super(
    primary: Color(0xFF9CA3B8),
    secondary: Color(0xFF78A6E4).withValues(alpha: 0.5),

    screenBackground: Colors.black45.withValues(alpha: 0.3),
    primaryLightVersion: Color(0xFF4A5AC7),

    cardBackground: Color(0xFF171C2E),
    lightVersionOfPrimaryLightVersion: Color(0xFF9CA3B8).withValues(alpha: 0.15),

    textPrimary: Color(0xFF9CA3D8),
    textSecondary: Color(0xFF9CA3B8),
    textAppbar: Color(0xFFE8E9F5),

  );
}