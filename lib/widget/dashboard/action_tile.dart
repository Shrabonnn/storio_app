import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_sizes.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/theme/theme_ext.dart';


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
    final color = context.Appcolor;
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSizes.screenPadding),
            decoration: BoxDecoration(
              color: color.primaryLightVersion.withValues(alpha: 0.21),
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              border: Border.all(color: color.secondary),
            ),
            child: Icon(
              icon,
              size: AppSizes.icon,
              color: color.primary,
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