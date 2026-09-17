import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_sizes.dart';
import '../universal/custom_card.dart';
import 'custom_shimmer.dart';

class UserSkeleton extends StatelessWidget {
  const UserSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
      child: CustomCard(
        child: ShimmerWrapper(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Initial Avatar Skeleton
                  CustomShimmer.rectangular(
                    width: 50,
                    height: 50,
                    borderRadius: 25,
                  ),
                  SizedBox(width: AppSizes.smallGap),

                  // User Details Skeleton (Name, Username, Role)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomShimmer.rectangular(
                          width: 35.w,
                          height: 16,
                          borderRadius: 4,
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomShimmer.rectangular(
                          width: 25.w,
                          height: 12,
                          borderRadius: 4,
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomShimmer.rectangular(
                          width: 20.w,
                          height: 12,
                          borderRadius: 4,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: AppSizes.sectionGap),

                  // Action Buttons & Status Badge Skeleton
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          CustomShimmer.rectangular(
                            width: 28,
                            height: 28,
                            borderRadius: 6,
                          ),
                          SizedBox(width: 8),
                          CustomShimmer.rectangular(
                            width: 20,
                            height: 20,
                            borderRadius: 10,
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.smallGap),
                      CustomShimmer.rectangular(
                        width: 15.w,
                        height: 20,
                        borderRadius: 10,
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: AppSizes.itemGap),

              // Email Row Skeleton
              Row(
                children: [
                  CustomShimmer.rectangular(
                    width: 16,
                    height: 16,
                    borderRadius: 4,
                  ),
                  SizedBox(width: AppSizes.smallGap),
                  CustomShimmer.rectangular(
                    width: 50.w,
                    height: 12,
                    borderRadius: 4,
                  ),
                ],
              ),

              SizedBox(height: AppSizes.appbarGap),

              // Joined Date Row Skeleton
              Row(
                children: [
                  CustomShimmer.rectangular(
                    width: 16,
                    height: 16,
                    borderRadius: 4,
                  ),
                  SizedBox(width: AppSizes.smallGap),
                  CustomShimmer.rectangular(
                    width: 35.w,
                    height: 12,
                    borderRadius: 4,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}