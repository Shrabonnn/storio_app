import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/image_card.dart';

class GalleryManageScreen extends StatefulWidget {
  const GalleryManageScreen({super.key});

  @override
  State<GalleryManageScreen> createState() => _GalleryManageScreenState();
}

class _GalleryManageScreenState extends State<GalleryManageScreen> {
  final List<String> statusList = [
    "All Images",
    "Uncategorized",
    "Featured",
    "Hidden",
    "Study Tour Bandarban",
  ];

  int selectedStatus = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Gallery Management",
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
                          SizedBox(width: AppSizes.appbarGap),
                          CustomDropdown(
                            items: [
                              "Bulk Action",
                              "Make Visible",
                              "Make Hidden",
                              "Delete Selected",
                            ],
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
                      SizedBox(height: AppSizes.sectionGap),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (_, index) {
                          return ImageCard(
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

                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.photo_album_outlined,
                                      color: AppColors.primary,
                                      size: AppSizes.icon,
                                    ),

                                    SizedBox(width: AppSizes.appbarGap),

                                    TextTitleWidget(title: "Uncategorized",color: AppColors.primary,),

                                  ],
                                ),

                                SizedBox(height: AppSizes.appbarGap),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.image,
                                      color: AppColors.primary,
                                      size: AppSizes.icon,
                                    ),

                                    SizedBox(width: AppSizes.appbarGap),

                                    Flexible(child: const Text("Image Name")),

                                  ],
                                ),
                                SizedBox(height: AppSizes.appbarGap),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.image_aspect_ratio,
                                      color: AppColors.primary,
                                      size: AppSizes.icon,
                                    ),

                                    SizedBox(width: AppSizes.appbarGap),

                                    Flexible(child: const Text("Image Size")),

                                  ],
                                ),

                                SizedBox(height: AppSizes.sectionGap),

                                Row(
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Flexible(child: CustomButton(text: "Edit", onTap: (){
                                      Navigator.pushNamed(
                                        context,
                                        RoutesName.gallery_add_image,
                                        // when data are comes from API here send the model data also
                                        // from next page it will show
                                        arguments: {
                                          'isEdit': true,
                                        },
                                      );
                                    },)),
                                    SizedBox(width: AppSizes.appbarGap,),
                                    CustomButton(text: "Delete", onTap: (){},width: 30.w,backgroundColor: Colors.red,foregroundColor: Colors.white,),


                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
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
              Navigator.pushNamed(context, RoutesName.manage_album);
            },
            child: const Icon(Icons.grid_view_rounded, color: Colors.white),
          ),

          SizedBox(height: AppSizes.itemGap),

          FloatingActionButton(
            heroTag: "add",
            backgroundColor: AppColors.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.gallery_add_image,arguments: {
                'isEdit': false,
              },);
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
