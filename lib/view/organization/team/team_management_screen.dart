import 'package:flutter/material.dart';

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
import '../../../widget/universal/status_button_row.dart';

class TeamManagementScreen extends StatefulWidget {
  const TeamManagementScreen({super.key});

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen> {

  final TextEditingController searchController = TextEditingController();


  final List<String> statusList = [
    "All",
    "Hello Bangladesh",
  ];
  int selectedStatus = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Team Management",
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
                          child: SearchTextField(hinText: "Search by name, title, role...", controller: searchController),
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
                                        title: "John Chena",
                                        size: AppSizes.sectionTitle,
                                        color: AppColors.primary,
                                      ),

                                      SizedBox(height: AppSizes.appbarGap),

                                      TextBodyStyleWidget(
                                        title: "Designation CEO",
                                        size: AppSizes.cardTitle,
                                        color: AppColors.primary,
                                      ),

                                      SizedBox(height: AppSizes.appbarGap),
                                      TextBodyStyleWidget(
                                        title: "Section  Hello Bangladesh",
                                        size: AppSizes.cardTitle,
                                        color: AppColors.primary,
                                      ),
                                      SizedBox(height: AppSizes.appbarGap),

                                      CustomStatusBadge(
                                        title: "VISIBLE",

                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),


                            SizedBox(height: AppSizes.itemGap),

                            Row(
                              children: [
                                Icon(Icons.file_copy_outlined,color: AppColors.primary,size: AppSizes.icon,),
                                SizedBox(width: AppSizes.appbarGap,),
                                Flexible(
                                  child: TextBodyStyleWidget(title: "aaaaaaaaaaaaaaaa ",color: AppColors.primary,fontbold: false,maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSizes.appbarGap,),
                            Row(
                              children: [
                                Icon(Icons.workspace_premium,color: AppColors.primary,size: AppSizes.icon,),
                                SizedBox(width: AppSizes.appbarGap,),
                                Flexible(
                                  child: TextBodyStyleWidget(title: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",color: AppColors.primary,fontbold: false,maxLines: 2,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: AppSizes.itemGap),
                            // Edit + Delete buttons
                            Row(
                              children: [

                                Flexible(child: CustomButton(icon: Icons.remove_red_eye_outlined,text: "View Details", onTap: (){
                                  Navigator.pushNamed(context, RoutesName.view_team_manage);
                                })),


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
              Navigator.pushNamed(context, RoutesName.manage_team_section);
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
              Navigator.pushNamed(context, RoutesName.add_new_team_member);

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
