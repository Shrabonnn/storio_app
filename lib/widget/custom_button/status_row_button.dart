// lib/widget/custom_button/status_button.dart
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';

class StatusButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? size;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderSide? borderSide;

  const StatusButton({
    super.key,
    required this.text,
    required this.onTap,
    this.size,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Material(
      color: backgroundColor ?? color.primary,
      borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        child: Container(
          height: height ?? 4.5.h,
          padding: EdgeInsets.symmetric(horizontal: AppSizes.smallPadding + 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            border: Border.fromBorderSide(
              borderSide ?? BorderSide.none,
            ),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding:  EdgeInsets.all(AppSizes.contentPadding),
            child: Text(
              text,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: foregroundColor ?? color.cardBackground,
                fontSize: size ?? AppSizes.cardSubTitle,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}