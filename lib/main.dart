import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:storio_app/routes/routes.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/splash_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/utils/app_sizes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:storio_app/utils/theme/app_theme.dart';
import 'package:storio_app/viewModel/hero_view_model.dart';
import 'package:storio_app/viewModel/setting/theme_view_model.dart';

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
          ChangeNotifierProvider(create: (_) => HeroProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
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