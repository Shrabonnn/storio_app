import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';

class ViewButton extends StatelessWidget {
  const ViewButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 3.5.h,
        width: 8.5.w,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.cartBackgroundLight),
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            color: AppColors.cartBackgroundLight
        ),child: Icon(Icons.remove_red_eye,color: AppColors.primary,size: AppSizes.icon,),),
    );
  }
}
