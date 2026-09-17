import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import 'custom_shimmer.dart';

class StatusRowSkeleton extends StatelessWidget {
  final int itemCount;
  final double borderRadius;

  const StatusRowSkeleton({
    super.key,
    this.itemCount = 5,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final List<double> chipWidths = [18.w, 28.w, 35.w, 24.w, 30.w];
    final color = context.Appcolor;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: List.generate(
          itemCount,
              (index) {
            return Padding(
              padding: EdgeInsets.only(
                right: index == itemCount - 1 ? 0 : AppSizes.appbarGap,
              ),
              child: CustomShimmer.rectangular(
                width: chipWidths[index % chipWidths.length],
                height: 4.25.h,
                borderRadius: borderRadius,
              ),
            );
          },
        ),
      ),
    );
  }
}