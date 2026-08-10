import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
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
    return Container(
      margin: EdgeInsets.only(
        bottom: AppSizes.sectionGap,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
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