import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../textStyle/text_body_style.dart';
import '../textStyle/text_title_style.dart';

/// A reusable, professional-looking empty state.
///
/// Pass a [title] (and optionally a [subtitle] / [icon]) to reuse this
/// across any list section — Notices, Events, Blogs, etc. — instead of
/// writing a one-off empty state per screen.
///
/// Example:
/// ```dart
/// EmptyStateWidget(
///   title: "No notices yet",
///   subtitle: "New notices will appear here once published.",
///   icon: Icons.campaign_outlined,
/// )
/// ```
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.compact = false,
  });

  final String title;
  final String? subtitle;
  final IconData icon;

  /// Use a smaller footprint when embedding inside an already-compact
  /// card (e.g. dashboard sections) vs a full-page empty state.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: compact ? AppSizes.sectionGap : AppSizes.screenPadding * 2,
        horizontal: AppSizes.screenPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(compact ? 3.w : 4.5.w),
            decoration: BoxDecoration(
              color: color.lightVersionOfPrimaryLightVersion,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: compact ? AppSizes.iconLarge : AppSizes.appBarIcon,
              color: color.primary,
            ),
          ),
          SizedBox(height: AppSizes.itemGap),
          TextTitleWidget(
            title: title,
            color: color.primary,
            size: compact ? AppSizes.cardTitle : AppSizes.sectionTitle,
          ),
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            SizedBox(height: AppSizes.appbarGap),
            TextBodyStyleWidget(
              title: subtitle!,
              maxLines: 2,
            ),
          ],
        ],
      ),
    );
  }
}