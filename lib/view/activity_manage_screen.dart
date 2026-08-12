import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';

import '../routes/routes_name.dart';
import '../utils/app_colors.dart';
import '../utils/sizes.dart';
import '../widget/universal/image_card.dart';
import '../widget/universal/custom_app_bar.dart';
import '../widget/universal/custom_card.dart';
import '../widget/universal/custom_drop_down.dart';
import '../widget/universal/status_button_row.dart';

class ActivityManageScreen extends StatefulWidget {
  const ActivityManageScreen({super.key});

  @override
  State<ActivityManageScreen> createState() => _ActivityManageScreenState();
}

class _ActivityManageScreenState extends State<ActivityManageScreen> {


  final List<String> statusList = [
    "All",
    "Published",
    "Scheduled",
    "Archived",
  ];

  int selectedStatus = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Activity Manage",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                CustomCard(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 4.5.h,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search...",
                                  prefixIcon: const Icon(Icons.search),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: AppSizes.appbarGap,),
                          CustomDropdown(
                            items: ["Bulk Action","Publish Selected","Move to Drafts","Move to Bin"],
                            initialValue: "Bulk Action",
                            width: 32.w,
                            height: 4.5.h,
                            onChanged: (value) {
                              print("Selected: $value");

                            },
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.smallGap),
                      StatusButtonRow(
                        items: statusList,
                        selectedIndex: selectedStatus,
                        onSelected: (index) {
                          setState(() {
                            selectedStatus = index;
                          });
                        },
                        onTap: (status) {
                          // Set with API

                          print("Clicked: $status");
                        },
                      ),
                      SizedBox(height: AppSizes.sectionGap),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (_, index) {
                          return  ImageCard(
                            image: Image.asset(
                              "assets/images/institute.png",
                              width: double.infinity,
                              height: 18.h,
                              fit: BoxFit.cover,
                            ),

                            status: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(
                                  AppSizes.buttonRadius,
                                ),
                              ),
                              child: TextBodyStyleWidget(
                                title: "Published",
                                color: Colors.white,
                              ),
                            ),

                            title: TextBodyStyleWidget(
                              title: "A Sunny Day",
                              size: AppSizes.sectionTitle,
                              color: AppColors.primary,
                            ),

                            child: Column(
                              children: [

                                Row(
                                  children: [
                                    Icon(
                                      Icons.category,
                                      color: AppColors.primary,
                                      size: AppSizes.icon,
                                    ),

                                    SizedBox(
                                      width: AppSizes.appbarGap,
                                    ),

                                    const Text("Category"),

                                    const Spacer(),

                                    const Text("Sunny Day"),
                                  ],
                                ),

                                SizedBox(
                                  height: AppSizes.appbarGap,
                                ),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: AppColors.primary,
                                      size: AppSizes.icon,
                                    ),

                                    SizedBox(
                                      width: AppSizes.appbarGap,
                                    ),

                                    const Text("Author"),

                                    const Spacer(),

                                    const Text("Alfa"),
                                  ],
                                ),

                                SizedBox(
                                  height: AppSizes.sectionGap,
                                ),

                                CustomButton(
                                  text: "View Details",
                                  height: 4.5.h,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),

              ]),
            ),
          ),

        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(

            heroTag: "addCategory",
            backgroundColor: AppColors.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.activity_manage_category);
            },
            child: const Icon(
              Icons.grid_view_rounded,
              color: Colors.white,
            ),
          ),

          SizedBox(height: AppSizes.itemGap),

          FloatingActionButton(


            heroTag: "add",
            backgroundColor: AppColors.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.activity_manage_details);

            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
