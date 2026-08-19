import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? width;
  final double? size;
  final double? height;
  final Color ? backgroundColor;
  final Color ? foregroundColor;
  final BorderSide? borderSide;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width,
    this.size,
    this.height,
    this.backgroundColor,
    this.foregroundColor, this.borderSide, this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 4.8.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: foregroundColor ?? Colors.white,
          elevation: 0,
          padding:  EdgeInsets.symmetric(horizontal: AppSizes.smallPadding),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            side: borderSide ?? BorderSide.none,
          ),

        ),
        child: Row(
          mainAxisAlignment: .center,
          children: [
            if(icon !=null)...[
              Icon(icon),
              SizedBox(width: AppSizes.appbarGap,)

            ],
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size ?? AppSizes.cardTitle ,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}