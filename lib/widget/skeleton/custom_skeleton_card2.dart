import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_sizes.dart';
import '../universal/custom_card.dart';
import 'custom_shimmer.dart';

class CustomSkeletonCard2 extends StatelessWidget {
  const CustomSkeletonCard2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
      child: CustomCard(
        child: ShimmerWrapper(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShimmer.rectangular(
                    width: 14.w,
                    height: 14.w,
                    borderRadius: 10,
                  ),
                  SizedBox(width: AppSizes.smallGap),

                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomShimmer.rectangular(width: 35.w, height: 16, borderRadius: 4),
                              SizedBox(height: AppSizes.smallGap),
                              CustomShimmer.rectangular(width: 25.w, height: 12, borderRadius: 4),
                              SizedBox(height: AppSizes.smallGap),
                              CustomShimmer.rectangular(width: 20.w, height: 12, borderRadius: 4),
                            ],
                          ),
                        ),


                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                CustomShimmer.rectangular(width: 12.w, height: 24, borderRadius: 6),
                                SizedBox(width: AppSizes.smallGap),
                                CustomShimmer.rectangular(width: 8.w, height: 24, borderRadius: 6),
                              ],
                            ),
                            SizedBox(height: AppSizes.itemGap),
                            CustomShimmer.rectangular(width: 18.w, height: 18, borderRadius: 6),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSizes.itemGap),


              Row(
                children: [
                  CustomShimmer.rectangular(width: 18, height: 18, borderRadius: 4),
                  SizedBox(width: AppSizes.appbarGap),
                  Expanded(
                    child: CustomShimmer.rectangular(height: 12, borderRadius: 4),
                  ),
                ],
              ),

              SizedBox(height: AppSizes.appbarGap),


              Row(
                children: [
                  CustomShimmer.rectangular(width: 18, height: 18, borderRadius: 4),
                  SizedBox(width: AppSizes.appbarGap),
                  Expanded(
                    child: CustomShimmer.rectangular(height: 12, borderRadius: 4),
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