import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/app_sizes.dart';
import 'custom_card.dart';

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status + Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _skeletonBox(
                  width: 65,
                  height: 24,
                  radius: 6,
                ),

                Row(
                  children: [
                    _skeletonBox(
                      width: 32,
                      height: 32,
                      radius: 6,
                    ),

                    const SizedBox(width: 8),

                    _skeletonBox(
                      width: 32,
                      height: 32,
                      radius: 6,
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: AppSizes.smallGap),

            // Title
            _skeletonBox(
              width: double.infinity,
              height: 20,
              radius: 4,
            ),

            SizedBox(height: AppSizes.appbarGap),

            // Content - 2 lines
            _skeletonBox(
              width: double.infinity,
              height: 14,
              radius: 4,
            ),

            const SizedBox(height: 6),

            _skeletonBox(
              width: 220,
              height: 14,
              radius: 4,
            ),

            SizedBox(height: AppSizes.smallGap),

            const Divider(
       color: color.lightVersionOfPrimaryLightVersion,
       height: 1, ),

            SizedBox(height: AppSizes.smallGap),

            // Last Updated
            Row(
              children: [
                _skeletonBox(
                  width: AppSizes.icon,
                  height: AppSizes.icon,
                  radius: 4,
                ),

                SizedBox(width: AppSizes.appbarGap),

                Expanded(
                  child: _skeletonBox(
                    width: double.infinity,
                    height: 14,
                    radius: 4,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _skeletonBox({
    required double width,
    required double height,
    double radius = 4,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}