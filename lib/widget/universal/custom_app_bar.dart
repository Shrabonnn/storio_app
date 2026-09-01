import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_sizes.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/theme/theme_ext.dart';
import '../textStyle/appbar_text_style.dart';
import '../textStyle/text_title_style.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final VoidCallback? onTap;

  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return SliverAppBar(
      expandedHeight: subtitle != null ? 9.h : 6.h,
      pinned: true,
      elevation: 0,
      collapsedHeight: 8.h,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentGeometry.topCenter,
            end: AlignmentGeometry.bottomCenter,
            colors: [
              color.primaryLightVersion,
              color.primary,
            ],
          ),
        ),
        child: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showBackButton) ...[
                IconButton(
                  onPressed: onTap ?? () => Navigator.pop(context),
                  icon:  Icon(
                    Icons.arrow_back_ios_new,
                    color: color.cardBackground,
                  ),
                ),
              ],

              Expanded(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppbarTextStyle(
                        title: title,
                        size: AppSizes.appBarTitle,
                      ),

                      if (subtitle != null) ...[

                        SizedBox(height: AppSizes.appbarGap),

                        TextTitleWidget(
                          title: subtitle!,
                          size: AppSizes.appBarSubTitle,
                          color: color.cardBackground.withValues(alpha: 0.7),
                        ),

                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}