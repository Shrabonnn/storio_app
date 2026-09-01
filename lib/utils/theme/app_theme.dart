import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:storio_app/utils/theme/app_color.dart';

import '../app_sizes.dart';

class AppTheme {
  ThemeData get light => _base(DefaultColor());
  ThemeData get emeraldGreen => _base(EmeraldColor()) ;
  ThemeData get dark => _base(DarkColor()) ;

  ThemeData _base(AppColor color){
    return ThemeData(
      useMaterial3: false,
      extensions: [color],
      scaffoldBackgroundColor: color.screenBackground,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ).apply(
          bodyColor: color.primary,
          displayColor: color.primary
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
          borderSide:  BorderSide(color: color.primary, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.buttonRadius)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.primary,
          foregroundColor: color.cardBackground,
          minimumSize: const Size.fromHeight(48),
          //fixedSize: Size.fromWidth(double.maxFinite),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(AppSizes.buttonRadius),
          ),
          textStyle: TextStyle(
            fontSize: AppSizes.sectionTitle,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),




    );
  }
}