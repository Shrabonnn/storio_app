import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../textStyle/text_title_style.dart';

class CustomStatusBadge extends StatelessWidget {
  const CustomStatusBadge({super.key, required this.title, this.backgroundColor, this.foregroundColor, this.size});

  final String title;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double ? size;
  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w,
          vertical: 0.5.h,),
        decoration: BoxDecoration(
          color: backgroundColor ?? color.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextTitleWidget(title: title,color: foregroundColor ?? color.primary,size: size ?? AppSizes.cardSubTitle,)
    );
  }
}
