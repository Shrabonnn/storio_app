import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_sizes.dart';
import '../universal/custom_card.dart';
import 'custom_shimmer.dart';

class CustomSkeletonCard extends StatelessWidget {
  const CustomSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
      child: CustomCard(
        child: ShimmerWrapper(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CustomShimmer.rectangular(
                width: double.infinity,
                height: 18.h,
                borderRadius: 10,
              ),
              SizedBox(height: AppSizes.smallGap),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomShimmer.rectangular(
                    width: 22.w,
                    height: 22,
                    borderRadius: 6,
                  ),
                  Row(
                    children: [
                      CustomShimmer.rectangular(
                        width: 14.w,
                        height: 26,
                        borderRadius: 6,
                      ),
                      SizedBox(width: AppSizes.appbarGap),
                      CustomShimmer.rectangular(
                        width: 24,
                        height: 24,
                        borderRadius: 12,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: AppSizes.smallGap),


              CustomShimmer.rectangular(
                width: 75.w,
                height: 18,
                borderRadius: 4,
              ),
              SizedBox(height: AppSizes.appbarGap),

              CustomShimmer.rectangular(
                width: double.infinity,
                height: 12,
                borderRadius: 4,
              ),
              SizedBox(height: 6),
              CustomShimmer.rectangular(
                width: double.infinity,
                height: 12,
                borderRadius: 4,
              ),
              SizedBox(height: 6),
              CustomShimmer.rectangular(
                width: 50.w,
                height: 12,
                borderRadius: 4,
              ),
              SizedBox(height: AppSizes.smallGap),

              CustomShimmer.rectangular(
                width: double.infinity,
                height: 1,
                borderRadius: 0,
              ),
              SizedBox(height: AppSizes.smallGap),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomShimmer.rectangular(
                        width: 18,
                        height: 18,
                        borderRadius: 4,
                      ),
                      SizedBox(width: AppSizes.appbarGap),
                      CustomShimmer.rectangular(
                        width: 20.w,
                        height: 12,
                        borderRadius: 4,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomShimmer.rectangular(
                        width: 18,
                        height: 18,
                        borderRadius: 4,
                      ),
                      SizedBox(width: AppSizes.appbarGap),
                      CustomShimmer.rectangular(
                        width: 22.w,
                        height: 12,
                        borderRadius: 4,
                      ),
                    ],
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