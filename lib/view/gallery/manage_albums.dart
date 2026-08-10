import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/universal/custom_card2.dart';

import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_text_field.dart';

class ManageAlbums extends StatefulWidget {
  const ManageAlbums({super.key});

  @override
  State<ManageAlbums> createState() => _ManageAlbumsState();
}

class _ManageAlbumsState extends State<ManageAlbums> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController urlSlugController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<String> statusList = ["No Parent", "Study Tour Bandarban"];

  @override
  void dispose() {
    nameController.dispose();
    urlSlugController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: "Manage Albums", showBackButton: true),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          TextBodyStyleWidget(
                            title: "Create New Album",
                            color: AppColors.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.sectionGap),

                          // Title
                          TextBodyStyleWidget(
                            title: "Name",
                            color: AppColors.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "New Album",
                            controller: nameController,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          // Activities
                          TextBodyStyleWidget(
                            title: "URL Slug",
                            color: AppColors.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "",
                            controller: urlSlugController,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          // Title
                          TextBodyStyleWidget(
                            title: "Description",
                            color: AppColors.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "Write your content here",
                            controller: descriptionController,
                            minLines: 2,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          TextBodyStyleWidget(
                            title: "Parent Album (Optional)",
                            color: AppColors.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomDropdown(
                            items: statusList,
                            initialValue: statusList[0],
                            width: 100.w,
                            height: 4.5.h,
                            onChanged: (value) {
                              print("Selected: $value");
                            },
                          ),

                          SizedBox(height: AppSizes.itemGap),

                          SizedBox(height: AppSizes.sectionGap),

                          CustomButton(text: "Add Album", onTap: () {}),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    CustomCard(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          TextBodyStyleWidget(
                            title: "Existing Albums ( 1 )",
                            color: AppColors.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          ListView.separated(
                            padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context,index){
                            return CustomCard2(
                              child: Padding(
                                padding: EdgeInsets.all(AppSizes.smallPadding),
                                child: Row(
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: .start,
                                      children: [
                                        TextBodyStyleWidget(
                                          title: "Study Tour Bandarban (2)",
                                          color: AppColors.primary,
                                        ),
                                        SizedBox(height: AppSizes.appbarGap),
                                        TextBodyStyleWidget(
                                          title: "/study-tour-bandarban",
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: AppColors.primary,
                                        ),
                                        SizedBox(width: AppSizes.smallGap),
                                        Icon(Icons.delete, color: Colors.red),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }, separatorBuilder:(context, index) {
                            return Divider();} , itemCount: 1)
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.appbarGap),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
