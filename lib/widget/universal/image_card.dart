import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../textStyle/text_body_style.dart';

class ImageCard extends StatelessWidget {
  final Widget image;

  final Widget? status;

  final Widget? title;

  final Widget? child;

  const ImageCard({
    super.key,
    required this.image,
    this.status,
    this.title,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Container(
      margin: EdgeInsets.only(
        bottom: AppSizes.sectionGap,
      ),
      decoration: BoxDecoration(
        color: color.cardBackground,
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                AppSizes.cardRadius,
              ),
            ),
            child: image,
          ),

          // CARD CONTENT


          Padding(
            padding: EdgeInsets.all(
              AppSizes.cardPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // STATUS
                if (status != null) ...[
                  Align(
                    alignment: Alignment.topRight,
                    child: status!,
                  ),

                  SizedBox(
                    height: AppSizes.smallGap,
                  ),
                ],

                // =========================
                // TITLE
                // =========================

                if (title != null) ...[
                  title!,

                  SizedBox(
                    height: AppSizes.smallGap,
                  ),
                ],

                // =========================
                // CUSTOM CONTENT
                // =========================

                if (child != null)
                  child!,
              ],
            ),
          ),
        ],
      ),
    );
  }
}