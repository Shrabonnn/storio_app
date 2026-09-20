import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_sizes.dart';
import 'custom_shimmer.dart';

class HeroSlideRowSkeleton extends StatelessWidget {
  const HeroSlideRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.5.h,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: ShimmerWrapper(
        child: Row(
          children: [
            // Checkbox Skeleton
            SizedBox(
              width: 14.w,
              child: Center(
                child: CustomShimmer.rectangular(
                  width: 18,
                  height: 18,
                  borderRadius: 3,
                ),
              ),
            ),

            // Super Content (Thumbnail + Heading/Subheading) Skeleton
            SizedBox(
              width: 110.w,
              child: Row(
                children: [
                  // Image Thumbnail Skeleton
                  CustomShimmer.rectangular(
                    width: 10.w,
                    height: 5.h,
                    borderRadius: 4,
                  ),
                  SizedBox(width: 2.w),

                  // Heading & Subheading Skeleton
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomShimmer.rectangular(
                          width: 45.w,
                          height: 14,
                          borderRadius: 4,
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomShimmer.rectangular(
                          width: 60.w,
                          height: 12,
                          borderRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Button Text & Link Skeleton
            SizedBox(
              width: 36.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShimmer.rectangular(
                    width: 20.w,
                    height: 14,
                    borderRadius: 4,
                  ),
                  SizedBox(height: AppSizes.appbarGap),
                  CustomShimmer.rectangular(
                    width: 28.w,
                    height: 12,
                    borderRadius: 4,
                  ),
                ],
              ),
            ),
            SizedBox(width: 2.w),

            // Status Badge Skeleton
            SizedBox(
              width: 25.w,
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomShimmer.rectangular(
                  width: 18.w,
                  height: 22,
                  borderRadius: 12,
                ),
              ),
            ),

            // Action Buttons (Edit, Copy, Delete) Skeleton
            SizedBox(
              width: 31.w,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomShimmer.rectangular(
                    width: 20,
                    height: 20,
                    borderRadius: 4,
                  ),
                  SizedBox(width: AppSizes.itemGap),
                  CustomShimmer.rectangular(
                    width: 20,
                    height: 20,
                    borderRadius: 4,
                  ),
                  SizedBox(width: AppSizes.itemGap),
                  CustomShimmer.rectangular(
                    width: 20,
                    height: 20,
                    borderRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}