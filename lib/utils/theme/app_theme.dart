import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:storio_app/utils/theme/app_color.dart';

import '../app_sizes.dart';

class AppTheme {
  ThemeData get light => _base(DefaultColor(), isDark: false);
  ThemeData get emeraldGreen => _base(EmeraldColor(), isDark: false);
  ThemeData get dark => _base(DarkColor(), isDark: true);

  ThemeData _base(AppColor color, {required bool isDark}) {
    // Correct base theme according to light/dark
    final baseTheme = isDark ? ThemeData.dark() : ThemeData.light();

    return ThemeData(
      useMaterial3: false,
      brightness: isDark ? Brightness.dark : Brightness.light, // 1. Fix Brightness
      extensions: [color],

      // 2. Main Fix for Page Route White Flash
      scaffoldBackgroundColor: color.screenBackground,
      canvasColor: color.screenBackground, // Routes animation base
      cardColor: color.cardBackground,
      dialogBackgroundColor: color.screenBackground,

      colorScheme: isDark
          ? ColorScheme.dark(surface: color.screenBackground)
          : ColorScheme.light(surface: color.screenBackground),

      // 3. Fix Typography Mismatch
      textTheme: GoogleFonts.interTextTheme(
        baseTheme.textTheme, // Correct base TextTheme
      ).apply(
        bodyColor: color.primary,
        displayColor: color.primary,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: color.cardBackground.withValues(alpha: 0.7),
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          borderSide: BorderSide(color: color.secondary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          borderSide: BorderSide(color: color.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.buttonRadius)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.primary,
          foregroundColor: color.cardBackground,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          ),
          textStyle: TextStyle(
            fontSize: AppSizes.sectionTitle,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,


        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),

        fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return color.primary;
          }
          return Colors.transparent;
        }),
        side: BorderSide(
          color: color.primary,
          width: 2.0,
        ),
      ),

      iconTheme: IconThemeData(
        color: color.primary,
      ),
    );
  }
}