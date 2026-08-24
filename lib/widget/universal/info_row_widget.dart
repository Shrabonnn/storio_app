import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../textStyle/text_body_style.dart';

class InfoRowWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoRowWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppSizes.icon,
          color: AppColors.primary,
        ),
        SizedBox(width: AppSizes.appbarGap),
        Expanded(
          child: Row(
            children: [
              TextBodyStyleWidget(
                title: "$title: ",
                fontbold: false,
                size: AppSizes.cardTitle,
                color: AppColors.primary,

              ),
              Expanded(
                child: TextBodyStyleWidget(
                  title: value,
                  fontbold: false,
                  size: AppSizes.cardTitle,
                  color: AppColors.primary,

                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}