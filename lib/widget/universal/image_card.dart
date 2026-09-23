import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../textStyle/text_body_style.dart';

class ImageCard extends StatelessWidget {
  final Widget image;

  final Widget? status;
  final Widget? activeStatus;
  final bool? isActiveStatus;
  final Widget? title;

  final Widget? child;

  const ImageCard({
    super.key,
    required this.image,
    this.status,
    this.title,
    this.child, this.activeStatus, this.isActiveStatus = false,
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

          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                AppSizes.cardRadius,
              ),
            ),
            child: image,
          ),
          // IMAGE
          /*Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    AppSizes.cardRadius,
                  ),
                ),
                child: image,
              ),

              if (isActiveStatus != null)
                Positioned(
                  top: 10,
                  right: 10,
                  child: activeStatus!,
                ),
            ],
          ),*/

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