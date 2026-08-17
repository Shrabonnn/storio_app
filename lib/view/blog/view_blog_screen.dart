import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/universal/info_item_card.dart';

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

class ViewBlogScreen extends StatefulWidget {
  const ViewBlogScreen({super.key});

  @override
  State<ViewBlogScreen> createState() => _ViewBlogScreenState();
}

class _ViewBlogScreenState extends State<ViewBlogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Post Details: Study Tour",
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
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [

                              InfoItemCard(title: "Author:", name: "John",icons: Icons.person,),
                              SizedBox(width: AppSizes.smallGap),
                              InfoItemCard(title: "Category:", name: "Uncategorized",icons: Icons.category_outlined,)
                            ],
                          ),

                          SizedBox(height: AppSizes.smallGap),

                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [

                              InfoItemCard(title: "Published Date:", name: "Feb 1, 2026",icons: Icons.calendar_month_outlined,),
                              SizedBox(width: AppSizes.smallGap),
                              InfoItemCard(title: "Status:", name: "published",icons: Icons.star,)
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
                                TextBodyStyleWidget(title: "Welcome to the heart of the Chittagong Hill Tracts. This year, Dhaka International School is proud to organize an immersive educational excursion to Bandarban. Beyond the breathtaking landscapes, this tour is designed to foster teamwork, cultural awareness, and a deep appreciation for Bangladesh’s natural biodiversity. Check App",color: AppColors.primary,size: AppSizes.cardTitle,maxLines: 20,),


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
                                      RoutesName.add_blog,
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
