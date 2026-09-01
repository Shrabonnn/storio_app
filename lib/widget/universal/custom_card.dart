import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_sizes.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/theme/theme_ext.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Container(
      width: 100.w,
      padding: padding ?? EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: color.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: child,
    );
  }
}