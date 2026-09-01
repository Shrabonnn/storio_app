
import 'package:flutter/material.dart';
import 'package:storio_app/utils/app_colors.dart';

import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';

class CustomCard2 extends StatelessWidget {
  const CustomCard2({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.smallPadding),
      decoration: BoxDecoration(
        color: color.lightVersionOfPrimaryLightVersion.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        border: Border.all(
          color: color.lightVersionOfPrimaryLightVersion,
        ),

      ),child: child,
    );
  }
}
