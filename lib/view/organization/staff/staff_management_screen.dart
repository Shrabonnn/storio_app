import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/custom_button/view_button.dart';
import 'package:storio_app/widget/universal/status_button_row.dart';

import '../../../routes/routes_name.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/sizes.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/textStyle/text_title_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_status_badge.dart';
import '../../../widget/universal/search_text_field.dart';

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  final TextEditingController searchController = TextEditingController();


  final List<String> statusList = [
    "All",
    "Marketing",
    "Active",
    "Inactive",
    "On leave",
    "Retired"
  ];
  int selectedStatus = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Staff Management",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(top:AppSizes.screenPadding,left: AppSizes.screenPadding,right: AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Expanded(
                          child: SearchTextField(onChanged:(value){},hinText: "Search staff...", controller: searchController),
                        ),


                      ],
                    ),
                    SizedBox(height: AppSizes.itemGap,),
                    StatusButtonRow(items: statusList, selectedIndex: selectedStatus, onSelected: (index){
                      setState(() {
                        selectedStatus = index;
                      });
                    }),
                    SizedBox(height: AppSizes.sectionGap,)

                  ],
                ),

              ]),
            ),
          ),
          SliverPadding(
              padding: EdgeInsetsGeometry.only(left: AppSizes.screenPadding,right: AppSizes.screenPadding),
              sliver: SliverList.builder(
                  itemCount:2,
                  itemBuilder: (context,index){
                    return Container(
                      margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                      child: CustomCard(
                        child: Column(
                          children: [

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.primary,
                                      width: 1,
                                    ),
                                  ),
                                  child: const CircleAvatar(
                                    backgroundImage: AssetImage(
                                      "assets/images/person.png",
                                    ),
                                  ),
                                ),

                                SizedBox(width: AppSizes.smallGap),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextTitleWidget(
                                        title: "Emma Stone",
                                        size: AppSizes.sectionTitle,
                                        color: AppColors.primary,
                                      ),

                                      SizedBox(height: AppSizes.appbarGap),

                                      TextBodyStyleWidget(
                                        title: "Sr. Advisor Marketing",
                                        size: AppSizes.cardTitle,
                                        color: AppColors.primary,
                                      ),

                                      SizedBox(height: AppSizes.appbarGap),

                                      CustomStatusBadge(
                                        title: "ACTIVE",

                                      ),
                                    ],
                                  ),
                                ),
                                ViewButton(onTap: (){
                                  Navigator.pushNamed(context, RoutesName.view_staff_manage);
                                },)
                              ],
                            ),


                            SizedBox(height: AppSizes.itemGap),

                            Row(
                              children: [
                                Icon(Icons.email_outlined,color: AppColors.primary,size: AppSizes.icon,),
                                SizedBox(width: AppSizes.appbarGap,),
                                TextBodyStyleWidget(title: "check@gmail.com",color: AppColors.primary,fontbold: false,
                                ),
                              ],
                            ),
                            SizedBox(height: AppSizes.appbarGap,),
                            Row(
                              children: [
                                Icon(Icons.phone,color: AppColors.primary,size: AppSizes.icon,),
                                SizedBox(width: AppSizes.appbarGap,),
                                TextBodyStyleWidget(title: "01712340000",color: AppColors.primary,fontbold: false,
                                ),
                              ],
                            ),
                            SizedBox(height: AppSizes.appbarGap,),
                            Row(
                              children: [
                                Icon(Icons.calendar_month_outlined,color: AppColors.primary,size: AppSizes.icon,),
                                SizedBox(width: AppSizes.appbarGap,),
                                TextBodyStyleWidget(title: "Joined Apr 2, 2026",color: AppColors.primary,fontbold: false,
                                ),
                              ],
                            ),


                          ],
                        ),
                      ),
                    );
                  })
          )

        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(

            heroTag: "addCategory",
            backgroundColor: AppColors.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.manage_staff_department);
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
              Navigator.pushNamed(context, RoutesName.add_new_staff_manage);

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
