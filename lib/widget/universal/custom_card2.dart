
import 'package:flutter/material.dart';
import 'package:storio_app/utils/app_colors.dart';

import '../../utils/sizes.dart';

class CustomCard2 extends StatelessWidget {
  const CustomCard2({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.smallPadding),
      decoration: BoxDecoration(
        color: AppColors.cartBackgroundLight.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        border: Border.all(
          color: AppColors.cartBackgroundLight,
        ),

      ),child: child,
    );
  }
}
