import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/image_card.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/search_text_field.dart';
import '../../widget/universal/status_button_row.dart';

class VideoManagementScreen extends StatefulWidget {
  const VideoManagementScreen({super.key});

  @override
  State<VideoManagementScreen> createState() => _VideoManagementScreenState();
}

class _VideoManagementScreenState extends State<VideoManagementScreen> {
  final TextEditingController searchController = TextEditingController();

  List<String> statusList = ["All Content", "Long Form", "Reels"];

  int selectedStatus = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Video Management",
            subtitle: "Reels & Media",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(
              left: AppSizes.screenPadding,
              top: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    StatusButtonRow(
                      items: statusList,
                      selectedIndex: selectedStatus,
                      onSelected: (index) {
                        setState(() {
                          selectedStatus = index;
                        });
                      },
                      onTap: (status) {
                        print("Clicked: $status");
                      },
                    ),
                    SizedBox(height: AppSizes.sectionGap),
                    Row(
                      children: [
                        Expanded(
                          child: SearchTextField(onChanged:(value){},
                            hinText: 'Search videos...',
                            controller: searchController,
                          ),
                        ),
                      ],
                    ),

                    //SizedBox(height: AppSizes.sectionGap),
                  ],
                ),
              ]),
            ),
          ),
          if (selectedStatus == 0)
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding,
                vertical: AppSizes.sectionGap,
              ),
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
                      crossAxisAlignment: .start,
                      children: [
                        TextTitleWidget(
                          title: "Chile Part",
                          color: AppColors.primary,
                        ),
                        SizedBox(height: AppSizes.itemGap),
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: AppSizes.appbarGap),
                                TextBodyStyleWidget(title: "0"),

                                SizedBox(width: AppSizes.itemGap),

                                Icon(
                                  Icons.favorite_border_outlined,
                                  size: AppSizes.icon,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: AppSizes.appbarGap),
                                TextBodyStyleWidget(title: "2"),
                              ],
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, RoutesName.add_new_video,arguments: {
                                      "isEdit":true,
                                    });
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    size: AppSizes.iconLarge,
                                    color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(width: AppSizes.smallGap),
                                InkWell(
                                  onTap: () {},
                                  child: Icon(
                                    Icons.delete_outline_outlined,
                                    size: AppSizes.iconLarge,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },

                itemCount: 2,
              ),
            ),

          SliverPadding(padding: EdgeInsets.only(bottom: AppSizes.sectionGap)),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "add",
            backgroundColor: AppColors.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.add_new_video);
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
