import 'package:flutter/material.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../textStyle/text_body_style.dart';

class InfoRowWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final int ?maxline;

  const InfoRowWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.value,  this.maxline,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Row(
      crossAxisAlignment: .start,
      children: [
        Icon(
          icon,
          size: AppSizes.icon,
          color: color.primary,
        ),
        SizedBox(width: AppSizes.appbarGap),
        Expanded(
          child: Row(
            crossAxisAlignment: .start,
            children: [
              TextBodyStyleWidget(
                title: "$title : ",
                fontbold: false,
                size: AppSizes.cardTitle,
                color: color.primary,

              ),
              Expanded(
                child: TextBodyStyleWidget(
                  title: value,
                  fontbold: false,
                  size: AppSizes.cardTitle,
                  color: color.primary,
                  maxLines: maxline ?? 1,

                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}