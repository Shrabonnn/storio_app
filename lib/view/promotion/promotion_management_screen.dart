import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/universal/custom_drop_down.dart';
import 'package:storio_app/widget/universal/custom_status_badge.dart';
import 'package:storio_app/widget/universal/image_card.dart';
import 'package:storio_app/widget/universal/search_text_field.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../../widget/dashboard/stat_card.dart';
import '../../widget/universal/custom_app_bar.dart';

class PromotionManagementScreen extends StatefulWidget {
  const PromotionManagementScreen({super.key});

  @override
  State<PromotionManagementScreen> createState() =>
      _PromotionManagementScreenState();
}

class _PromotionManagementScreenState extends State<PromotionManagementScreen> {
  final TextEditingController searchController = TextEditingController();

  List<String> statusItem = ["All", "Published", "Draft", "Archived"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Promotion Management",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    CustomCard(
                      child: Column(
                        children: [
                          // Search
                          Row(
                            children: [
                              Expanded(
                                child: SearchTextField(
                                  hinText: "Search promotions...",
                                  controller: searchController,
                                ),
                              ),
                              SizedBox(width: AppSizes.appbarGap),
                              CustomDropdown(
                                items: statusItem,
                                initialValue: statusItem[0],
                                width: 32.w,
                                height: 4.5.h,
                                onChanged: (value) {
                                  print("Selected: $value");
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: AppSizes.sectionGap),

                          // Stat Card
                          Row(
                            children: [
                              Expanded(
                                child: StatCard(label: "Live Now", value: "0"),
                              ),
                              SizedBox(width: AppSizes.smallGap),
                              Expanded(
                                child: StatCard(label: "Draft", value: "8"),
                              ),
                              SizedBox(width: AppSizes.smallGap),
                              Expanded(
                                child: StatCard(
                                  label: "Total Views",
                                  value: "10",
                                ),
                              ),
                              SizedBox(width: AppSizes.smallGap),
                              Expanded(
                                child: StatCard(
                                  label: "Total Clicks",
                                  value: "3",
                                ),
                              ),
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
          SliverPadding(padding: EdgeInsets.symmetric(horizontal:AppSizes.screenPadding),
            sliver: SliverList.builder(
              itemBuilder: (context, index) {
                return ImageCard(
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
                        children: [
                          CustomStatusBadge(title: "Published"),

                          SizedBox(width: AppSizes.smallGap),

                          // Open Now
                          CustomStatusBadge(
                            title: "Open Now",
                            backgroundColor: Colors.orange.withOpacity(
                              0.2,
                            ),
                          ),

                          const Spacer(),

                          // More
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_vert),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSizes.smallGap),

                      TextTitleWidget(
                        title: "Admission Going On",
                        color: AppColors.primary,
                      ),

                      SizedBox(height: AppSizes.appbarGap),
                      TextBodyStyleWidget(title: "Testing this API"),

                      SizedBox(height: AppSizes.appbarGap),

                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: AppSizes.iconSmall,
                            color: Colors.grey.shade600,
                          ),

                          SizedBox(width: AppSizes.appbarGap),

                          Flexible(
                            child: TextBodyStyleWidget(
                              title:
                              "Apr 9, 2026, 06:00 AM → Jul 2, 2026, 06:00 AM",
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSizes.appbarGap),
                      Row(
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            size: AppSizes.iconSmall,
                            color: Colors.grey.shade600,
                          ),

                          SizedBox(width: AppSizes.appbarGap),

                          TextBodyStyleWidget(title: "0"),

                          SizedBox(width: AppSizes.smallGap),

                          Icon(
                            Icons.touch_app_outlined,
                            size: AppSizes.iconSmall,
                            color: Colors.grey.shade600,
                          ),

                          SizedBox(width: AppSizes.appbarGap),

                          TextBodyStyleWidget(title: "0"),
                        ],
                      ),
                      SizedBox(height: AppSizes.smallGap),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RoutesName.add_promotion,arguments: {
                            'isEdit':true
                          });
                        },
                        child: Text("Edit Promotion"),
                      ),
                    ],
                  ),
                );
              },

              itemCount: 2,
            ),),
          SliverPadding(padding: EdgeInsets.only(bottom:AppSizes.sectionGap))

        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "add",
            backgroundColor: AppColors.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.add_promotion);
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
