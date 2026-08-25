import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/custom_button/view_button.dart';
import 'package:storio_app/widget/universal/info_row_widget.dart';

import '../../../routes/routes_name.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/sizes.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/textStyle/text_title_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_status_badge.dart';
import '../../../widget/universal/more_menu.dart';
import '../../../widget/universal/search_text_field.dart';
import '../../../widget/universal/status_button_row.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController searchController = TextEditingController();


  final List<String> statusList = [
    "All",
    "Hello Bangladesh",
  ];
  int selectedStatus = 0;
  String name = "John chena";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "User Management",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(top:AppSizes.screenPadding,left: AppSizes.screenPadding,right: AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(

                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Expanded(
                          child: SearchTextField(onChanged:(value){},hinText: "Search users...", controller: searchController),
                        ),


                      ],
                    ),

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
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                    border: Border.all(
                                      color: AppColors.cartBackgroundLight,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(child: TextTitleWidget(title: name.isNotEmpty ? name[0].toUpperCase()+name[1].toUpperCase() : "?",color: Colors.white,size: 19.sp,)),
                                ),

                                SizedBox(width: AppSizes.smallGap),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextTitleWidget(
                                        title: name,
                                        size: AppSizes.sectionTitle,
                                        color: AppColors.primary,
                                      ),

                                      SizedBox(height: AppSizes.appbarGap),

                                      TextBodyStyleWidget(
                                        title: "@alfasunny94",
                                        size: AppSizes.cardTitle,
                                        color: AppColors.primary,
                                      ),

                                      SizedBox(height: AppSizes.appbarGap),
                                      TextBodyStyleWidget(
                                        title: "SOFTWARE TESTING",
                                        size: AppSizes.cardTitle,
                                        color: AppColors.primary,
                                      ),
                                      SizedBox(height: AppSizes.appbarGap),


                                    ],
                                  ),
                                ),
                                SizedBox(width: AppSizes.sectionGap,),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        ViewButton(onTap: (){
                                          Navigator.pushNamed(context, RoutesName.view_user_details);
                                        }),
                                        MoreMenu(
                                          items: const [
                                            MoreMenuAction.edit,
                                            MoreMenuAction.view,
                                            MoreMenuAction.changePassword,
                                            MoreMenuAction.suspend,
                                            MoreMenuAction.delete,
                                          ],
                                          onSelected: (action) {
                                            switch (action) {
                                              case MoreMenuAction.edit:
                                                Navigator.pushNamed(context, RoutesName.add_new_user,arguments: {
                                                  'isEdit' : true,
                                                });
                                                break;

                                              case MoreMenuAction.view:
                                                //Navigator.pushNamed(context, RoutesName.view_notice);
                                                break;

                                              case MoreMenuAction.changePassword:
                                                //Navigator.pushNamed(context, RoutesName.view_notice);
                                                break;
                                              case MoreMenuAction.suspend:
                                                //Navigator.pushNamed(context, RoutesName.view_notice);
                                                break;

                                              case MoreMenuAction.delete:
                                              // delete
                                                break;
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: AppSizes.appbarGap),
                                    CustomStatusBadge(
                                      title: "ACTIVE",


                                    ),

                                  ],
                                ),
                              ],
                            ),


                            SizedBox(height: AppSizes.itemGap),

                            InfoRowWidget(icon: Icons.email_outlined, title: "Email", value: "alfasunny94@gmail.com"),
                            SizedBox(height: AppSizes.appbarGap,),
                            InfoRowWidget(icon: Icons.calendar_month_outlined, title: "Joined", value: "Jun 15, 2026"),


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
              Navigator.pushNamed(context, RoutesName.add_new_user);

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
