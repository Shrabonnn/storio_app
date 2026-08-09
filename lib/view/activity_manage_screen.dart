import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';

import '../routes/routes_name.dart';
import '../utils/app_colors.dart';
import '../utils/sizes.dart';
import '../widget/activity_manage/activity_card.dart';
import '../widget/universal/custom_app_bar.dart';
import '../widget/universal/custom_card.dart';
import '../widget/universal/custom_drop_down.dart';

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
                      Row(
                        children:List.generate(statusList.length, (index){
                          return Expanded(child: Padding(
                            padding: EdgeInsets.only(
                              right: index == statusList.length - 1
                                  ? 0
                                  : AppSizes.appbarGap,
                            ),
                            child: CustomButton(
                                text: statusList[index],
                                height: 4.5.h,
                                size: AppSizes.cardSubTitle,
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 1,),
                                backgroundColor: selectedStatus == index? Colors.white : AppColors.primary,
                                foregroundColor: selectedStatus== index ? AppColors.primary : Colors.white,
                                onTap: (){
                                  setState(() {
                                    selectedStatus =index;
                                  });
                                }),
                          ),);
                        }),
                      ),
                      SizedBox(height: AppSizes.sectionGap),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (_, index) {
                          return  ActivityCard();
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
