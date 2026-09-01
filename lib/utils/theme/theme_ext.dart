import 'package:flutter/material.dart';
import 'package:storio_app/utils/theme/app_color.dart';

extension ThemeExt on BuildContext{

  AppColor get Appcolor => Theme.of(this).extension<AppColor>()??DefaultColor() ;
}