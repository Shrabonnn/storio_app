
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;

  const StatCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final words = label.split(' ');
    final line1 = words.first;
    final line2 = words.length > 1 ? words.sublist(1).join(' ') : '';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: AppColors.cartbackground.withValues(alpha: 0.21),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            line1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppSizes.sectionTitle,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              height: 1.15,
            ),
          ),
          Text(
            line2,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppSizes.sectionTitle,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              height: 1.15,
            ),
          ),
          SizedBox(height: AppSizes.smallGap),
          Text(
            value,
            style: TextStyle(
              fontSize: AppSizes.appBarTitle,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
