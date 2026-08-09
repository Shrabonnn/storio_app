
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../custom_button/custom_buttom.dart';
import '../textStyle/text_body_style.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        boxShadow: [
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

          /// Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.cardRadius),
            ),
            child: Image.asset(
              "assets/images/institute.png",
              width: double.infinity,
              height: 18.h,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: EdgeInsets.all(AppSizes.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                      ),
                      child: TextBodyStyleWidget(title: "Published",color: Colors.white,)
                  ),
                ),

                SizedBox(height: AppSizes.itemGap),

                TextBodyStyleWidget(title: 'A Sunny Day',size: AppSizes.sectionTitle,color: AppColors.primary,),

                SizedBox(height: AppSizes.smallGap),

                Row(
                  children: [
                    Icon(Icons.category,
                        color: AppColors.primary, size: AppSizes.icon),
                    SizedBox(width: AppSizes.appbarGap),
                    Text("Category"),
                    Spacer(),
                    Text("Sunny Day"),
                  ],
                ),

                SizedBox(height: AppSizes.appbarGap),

                Row(
                  children: [
                    Icon(Icons.person,
                        color: AppColors.primary, size: AppSizes.icon),
                    SizedBox(width: AppSizes.appbarGap),
                    Text("Author"),
                    Spacer(),
                    Text("Alfa"),
                  ],
                ),

                SizedBox(height: AppSizes.sectionGap),

                CustomButton(
                  text: "View Details",
                  height: 4.5.h,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
