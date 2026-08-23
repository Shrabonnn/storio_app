
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:storio_app/routes/routes.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/splash_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/utils/sizes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:storio_app/viewModel/hero_view_model.dart';

void main(){
  runApp( MyApp(),);
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context,orientation,screenType){
      return MultiProvider(providers: [
        ChangeNotifierProvider(create: (_)=> HeroProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,



        localizationsDelegates: const [
          FlutterQuillLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        supportedLocales: const [
          Locale('en'),
        ],


        initialRoute: RoutesName.splash_screen,
        onGenerateRoute: Routes.generateRoute,
        theme: ThemeData(
            textTheme: GoogleFonts.interTextTheme(
              ThemeData.light().textTheme,
            ).apply(
                bodyColor: AppColors.primary,
                displayColor: AppColors.primary
            ),

            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white70,

              hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                borderSide: BorderSide(color: AppColors.secondary, width: 1),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
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
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
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
            scaffoldBackgroundColor: AppColors.background

        ),
      ));
    });
  }
}
