import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../textStyle/text_title_style.dart';
import 'custom_card2.dart';

class InfoItemCard extends StatelessWidget {

  final String title;
  final String name;
  final IconData ? icons;

  const InfoItemCard({super.key, required this.title, required this.name, this.icons});



  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: CustomCard2(
          child: Padding(
            padding:  EdgeInsets.all(AppSizes.contentPadding),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(title,maxLines: 1,),
                SizedBox(height: AppSizes.appbarGap,),
                Row(
                  children: [
                    if(icons != null)...[
                      Icon(icons, size: AppSizes.icon),

                      SizedBox(width: AppSizes.appbarGap),
                    ],


                    Flexible(child: TextTitleWidget(maxLines: 1,title: name,color: AppColors.primary,)),
                  ],
                ),

              ],
            ),
          )),
    );
  }
}
