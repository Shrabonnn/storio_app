import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/custom_card.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/custom_status_badge.dart';
import '../../widget/universal/image_card.dart';
import '../../widget/universal/info_item_card.dart';

class ViewNoticeScreen extends StatefulWidget {
  const ViewNoticeScreen({super.key});

  @override
  State<ViewNoticeScreen> createState() => _ViewNoticeScreenState();
}

class _ViewNoticeScreenState extends State<ViewNoticeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Holiday",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(
              top: AppSizes.screenPadding,
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    CustomCard(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_month_outlined,color: AppColors.primary,size: AppSizes.icon,),
                                  SizedBox(width: AppSizes.appbarGap,),
                                  Flexible(child: TextBodyStyleWidget(title: "Last Updated: Jun 8, 2026",maxLines: 1,size: AppSizes.cardTitle)),
                                ],
                              ),
                            ),
                            CustomStatusBadge(title: "Published",size: AppSizes.cardTitle,),
                          ],
                        ),
                        SizedBox(height: AppSizes.itemGap),

                        CustomCard2(child: Padding(
                          padding:  EdgeInsets.all(AppSizes.contentPadding),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              TextBodyStyleWidget(title: "Dear All,\nOur school will be close every from 11th Feb to 12th Feb 2026"
                                ,color: AppColors.primary
                                ,size: AppSizes.cardTitle,maxLines: 20,),


                            ],
                          ),
                        )),

                      ],
                    ))
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
