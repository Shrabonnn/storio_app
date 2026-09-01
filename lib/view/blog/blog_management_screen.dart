import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/search_text_field.dart';

import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_status_badge.dart';
import '../../widget/universal/image_card.dart';
import '../../widget/universal/status_button_row.dart';

class BlogManagementScreen extends StatefulWidget {
  const BlogManagementScreen({super.key});

  @override
  State<BlogManagementScreen> createState() => _BlogManagementScreenState();
}

class _BlogManagementScreenState extends State<BlogManagementScreen> {

  final TextEditingController searchController = TextEditingController();

  final List<String> actionList = [
    "Bulk Action", "Publish Selected", "Move to Drafts", "Move to Bin"
  ];

  final List<String> statusList = [
    "All",
    "Published",
    "Scheduled",
    "Draft",
    "Binned"
  ];

  int selectedStatus = 0;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Blog Management",
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
                          child: SearchTextField(onChanged:(value){},hinText: "Search", controller: searchController),
                        ),
                        SizedBox(width: AppSizes.appbarGap,),
                        CustomDropdown(
                          items:actionList ,
                          initialValue: actionList[0],
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
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            CustomStatusBadge(title: "Published",size: AppSizes.cardTitle,),



                            // More
                            InkWell(
                                onTap: (){},
                                child: Icon(Icons.more_vert))
                          ],
                        ),

                        SizedBox(height: AppSizes.smallGap),


                        TextTitleWidget(
                          title: "Study Tour 2026",
                          color: color.primary,
                        ),

                        SizedBox(height: AppSizes.appbarGap),
                        TextBodyStyleWidget(title: "Testing this API",maxLines: 4,),


                        SizedBox(height: AppSizes.smallGap),

                        Divider(),
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: AppSizes.icon,
                                ),

                                SizedBox(width: AppSizes.appbarGap),

                                TextBodyStyleWidget(title: "John"),
                              ],
                            ),



                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: AppSizes.icon,
                                ),

                                SizedBox(width: AppSizes.appbarGap),

                                TextBodyStyleWidget(title: "Feb 1, 2026"),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: AppSizes.itemGap),

                        CustomButton(
                            height:4.5.h,
                            size:AppSizes.cardTitle,text: "Read More", onTap: () {
                          Navigator.pushNamed(context, RoutesName.view_blog);
                        })

                      ],
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
              Navigator.pushNamed(context, RoutesName.manage_blog_category);
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
              Navigator.pushNamed(context, RoutesName.add_blog);

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
