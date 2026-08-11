import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../textStyle/text_title_style.dart';

class CustomStatusBadge extends StatelessWidget {
  const CustomStatusBadge({super.key, required this.title, this.backgroundColor});

  final String title;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w,
          vertical: 0.5.h,),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextTitleWidget(title: title,color: AppColors.primary,size: AppSizes.cardSubTitle,)
    );
  }
}
