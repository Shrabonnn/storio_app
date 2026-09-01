import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';

class ViewButton extends StatelessWidget {
  const ViewButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 3.5.h,
        width: 8.5.w,
        decoration: BoxDecoration(
            border: Border.all(color: color.lightVersionOfPrimaryLightVersion),
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            color: color.lightVersionOfPrimaryLightVersion
        ),child: Icon(Icons.remove_red_eye,color: color.primary,size: AppSizes.icon,),),
    );
  }
}
