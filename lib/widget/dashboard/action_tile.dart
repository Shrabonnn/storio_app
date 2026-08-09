import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/sizes.dart';

import '../../utils/app_colors.dart';


class ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSizes.screenPadding),
            decoration: BoxDecoration(
              color: AppColors.cartbackground.withValues(alpha: 0.21),
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              border: Border.all(color: AppColors.secondary),
            ),
            child: Icon(
              icon,
              size: AppSizes.icon,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: AppSizes.appbarGap),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppSizes.body,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}