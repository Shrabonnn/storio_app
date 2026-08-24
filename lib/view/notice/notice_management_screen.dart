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
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_status_badge.dart';
import '../../widget/universal/image_card.dart';
import '../../widget/universal/more_menu.dart';
import '../../widget/universal/search_text_field.dart';

class NoticeManagementScreen extends StatefulWidget {
  const NoticeManagementScreen({super.key});

  @override
  State<NoticeManagementScreen> createState() => _NoticeManagementScreenState();
}


class _NoticeManagementScreenState extends State<NoticeManagementScreen> {

  final TextEditingController searchController = TextEditingController();

  final List<String> statusList = [
    "All",
    "Published",
    "Schedule",
    "Draft",
    "Archived",
  ];
  int selectedStatus = 0;

  // drop down
  final List<String> dropDownStatusList = [
    "Bulk Action",
    "Public",
    "Archive",
    "Bin",
    "Restore",
    "Delete All",
  ];
  String selectedDropDownList = "Bulk Action";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Notice Board",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(top:AppSizes.screenPadding,left: AppSizes.screenPadding,right: AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Row(
                      children: [
                        Flexible(child: SearchTextField(hinText: "Search...", controller: searchController)),
                        SizedBox(width: AppSizes.appbarGap),
                        CustomDropdown(
                          items:dropDownStatusList ,
                          initialValue: selectedDropDownList,
                          height: 4.5.h,
                          width: 32.w,
                          onChanged: (value) {
                            setState(() {
                              selectedDropDownList = value.toString();
                              print(selectedDropDownList);
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.smallGap),
                    Row(
                      children: List.generate(statusList.length, (index) {
                        return Expanded(
                          child: Padding(
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
                                width: 1,
                              ),
                              backgroundColor: selectedStatus == index
                                  ? Colors.white
                                  : AppColors.primary,
                              foregroundColor: selectedStatus == index
                                  ? AppColors.primary
                                  : Colors.white,
                              onTap: () {
                                setState(() {
                                  selectedStatus = index;
                                });
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: AppSizes.sectionGap,),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                CustomStatusBadge(title: "Published",size: AppSizes.cardTitle,),



                                MoreMenu(
                                  items: const [
                                    MoreMenuAction.edit,
                                    MoreMenuAction.view,
                                    MoreMenuAction.delete,
                                  ],
                                  onSelected: (action) {
                                    switch (action) {
                                      case MoreMenuAction.edit:
                                        Navigator.pushNamed(context, RoutesName.add_new_notice,arguments: {
                                          'isEdit' : true,
                                        });
                                        break;

                                      case MoreMenuAction.view:
                                        Navigator.pushNamed(context, RoutesName.view_notice);
                                        break;

                                      case MoreMenuAction.delete:
                                      // delete
                                        break;
                                      case MoreMenuAction.changePassword:
                                        // TODO: Handle this case.
                                        throw UnimplementedError();
                                      case MoreMenuAction.suspend:
                                        // TODO: Handle this case.
                                        throw UnimplementedError();
                                    }
                                  },
                                ),
                              ],
                            ),

                            SizedBox(height: AppSizes.smallGap),


                            TextTitleWidget(
                              title: "Holiday",
                              color: AppColors.primary,
                              maxLines: 1,
                            ),

                            SizedBox(height: AppSizes.appbarGap),

                            TextBodyStyleWidget(title: "Dear All, Our school will be close every from 11th Feb to 12th Feb 2026",
                                maxLines: 2,
                                size: AppSizes.cardTitle),


                            SizedBox(height: AppSizes.smallGap),

                            Divider(),

                            SizedBox(height: AppSizes.smallGap),

                            Row(
                              children: [
                                Icon(Icons.calendar_month_outlined,color: AppColors.primary,size: AppSizes.icon,),
                                SizedBox(width: AppSizes.appbarGap,),
                                Flexible(child: TextBodyStyleWidget(title: "Last Updated: Jun 8, 2026",maxLines: 1,size: AppSizes.cardTitle)),
                              ],
                            ),
                            SizedBox(height: AppSizes.smallGap),

                            CustomButton(
                                height:4.5.h,
                                size:AppSizes.cardTitle,text: "View Details", onTap: () {
                              Navigator.pushNamed(context, RoutesName.view_notice);
                            }),



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


            heroTag: "add",
            backgroundColor: AppColors.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.add_new_notice);

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
