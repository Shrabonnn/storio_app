import 'package:flutter/material.dart';
import 'package:storio_app/widget/custom_button/view_button.dart';

import '../../../routes/routes_name.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/theme/theme_ext.dart';
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
    final color = context.Appcolor;
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
                          child: SearchTextField(onChanged:(value){},hinText: "Search by name, title, role...", controller: searchController),
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
                                      color: color.lightVersionOfPrimaryLightVersion,
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
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: .spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: .start,
                                        children: [
                                          TextTitleWidget(
                                            title: "John Chena",
                                            size: AppSizes.sectionTitle,
                                            color: color.primary,
                                          ),

                                          SizedBox(height: AppSizes.appbarGap),

                                          TextBodyStyleWidget(
                                            title: "Designation CEO",
                                            size: AppSizes.cardTitle,
                                            color: color.primary,
                                          ),

                                          SizedBox(height: AppSizes.appbarGap),
                                          TextBodyStyleWidget(
                                            title: "Section  Hello Bangladesh",
                                            size: AppSizes.cardTitle,
                                            color: color.primary,
                                          ),

                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: .end,
                                        children: [
                                          ViewButton(onTap: (){
                                            Navigator.pushNamed(context, RoutesName.view_team_manage);
                                          }),
                                          SizedBox(height: AppSizes.smallGap),

                                          CustomStatusBadge(
                                            title: "VISIBLE",

                                          ),
                                        ],
                                      )

                                    ],
                                  ),
                                ),
                              ],
                            ),


                            SizedBox(height: AppSizes.itemGap),

                            Row(
                              children: [
                                Icon(Icons.file_copy_outlined,color: color.primary,size: AppSizes.icon,),
                                SizedBox(width: AppSizes.appbarGap,),
                                Flexible(
                                  child: TextBodyStyleWidget(title: "aaaaaaaaaaaaaaaa ",color: color.primary,fontbold: false,maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSizes.appbarGap,),
                            Row(
                              children: [
                                Icon(Icons.workspace_premium,color: color.primary,size: AppSizes.icon,),
                                SizedBox(width: AppSizes.appbarGap,),
                                Flexible(
                                  child: TextBodyStyleWidget(title: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",color: color.primary,fontbold: false,maxLines: 2,
                                  ),
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
            backgroundColor: color.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.manage_team_section);
            },
            child:  Icon(
              Icons.grid_view_rounded,
              color: color.cardBackground,
            ),
          ),

          SizedBox(height: AppSizes.itemGap),

          FloatingActionButton(


            heroTag: "add",
            backgroundColor: color.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.add_new_team_member);

            },
            child:  Icon(
              Icons.add,
              color: color.cardBackground,
            ),
          ),
        ],
      ),
    );
  }
}
