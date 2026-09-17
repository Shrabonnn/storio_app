import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_sizes.dart';
import '../universal/custom_card2.dart';
import 'custom_shimmer.dart';

class ContactMessageSkeleton extends StatelessWidget {
  const ContactMessageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.itemGap),
      child: CustomCard2(
        child: ShimmerWrapper(
          child: Padding(
            padding: EdgeInsets.all(AppSizes.smallPadding),
            child: Row(
              children: [
                // Avatar Skeleton
                CustomShimmer.rectangular(
                  width: 44,
                  height: 44,
                  borderRadius: 22,
                ),
                SizedBox(width: AppSizes.smallGap),

                // Name, Subject, and Body Skeleton
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShimmer.rectangular(
                        width: 28.w,
                        height: 14,
                        borderRadius: 4,
                      ),
                      SizedBox(height: AppSizes.appbarGap),
                      CustomShimmer.rectangular(
                        width: 45.w,
                        height: 12,
                        borderRadius: 4,
                      ),
                      SizedBox(height: AppSizes.appbarGap),
                      CustomShimmer.rectangular(
                        width: 35.w,
                        height: 10,
                        borderRadius: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSizes.smallGap),

                // Time and Status Badge Skeleton
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomShimmer.rectangular(
                      width: 12.w,
                      height: 11,
                      borderRadius: 4,
                    ),
                    SizedBox(height: AppSizes.smallGap),
                    CustomShimmer.rectangular(
                      width: 16.w,
                      height: 20,
                      borderRadius: 10,
                    ),
                  ],
                ),
                SizedBox(width: AppSizes.smallGap),

                // Chevron Icon Skeleton
                CustomShimmer.rectangular(
                  width: 16,
                  height: 16,
                  borderRadius: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}