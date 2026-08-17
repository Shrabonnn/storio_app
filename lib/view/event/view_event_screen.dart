import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/custom_status_badge.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/image_card.dart';
import '../../widget/universal/info_item_card.dart';

class ViewEventScreen extends StatefulWidget {
  const ViewEventScreen({super.key});

  @override
  State<ViewEventScreen> createState() => _ViewEventScreenState();
}

class _ViewEventScreenState extends State<ViewEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Research Symposium 2026",
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
                    ImageCard(
                      image: Image.asset(
                        "assets/images/institute.png",
                        width: double.infinity,
                        height: 18.h,
                        fit: BoxFit.cover,
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomStatusBadge(title: "Published",size: AppSizes.cardTitle,),
                          SizedBox(height: AppSizes.smallGap),
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [

                              InfoItemCard(title: "Start:", name: "Jul 22, 2026, 02:47 PM",icons: Icons.calendar_month_outlined,),
                              SizedBox(width: AppSizes.smallGap),
                              InfoItemCard(title: "End:", name: "Jul 30, 2026, 08:47 PM",icons: Icons.watch_later_outlined,)
                            ],
                          ),

                          SizedBox(height: AppSizes.smallGap),

                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [

                              InfoItemCard(title: "Location:", name: "BRAC University, Merul Badda, Dhaka",icons: Icons.location_on_outlined,),

                            ],
                          ),


                          SizedBox(height: AppSizes.smallGap),

                          CustomCard2(child: Padding(
                            padding:  EdgeInsets.all(AppSizes.contentPadding),
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                TextTitleWidget(title: "Content",color: AppColors.primary,size: AppSizes.screenTitle,),
                                SizedBox(height: AppSizes.smallGap,),
                                TextBodyStyleWidget(title: "An annual symposium where undergraduate and graduate students present their research through oral and poster presentations across multiple disciplines.",color: AppColors.primary,size: AppSizes.cardTitle,maxLines: 20,),


                              ],
                            ),
                          )),

                          SizedBox(height: AppSizes.itemGap),

                          Row(
                            children: [
                              Flexible(
                                child: CustomButton(
                                  height: 4.5.h,
                                  size: AppSizes.cardTitle,
                                  text: "Edit Post",
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RoutesName.add_new_event,
                                      arguments: {
                                        'isEdit' : true
                                      },
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: AppSizes.sectionGap,),
                              Icon(Icons.delete_outline_outlined,size: AppSizes.appBarIcon,color: Colors.red,)
                            ],
                          ),
                        ],
                      ),
                    ),
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
