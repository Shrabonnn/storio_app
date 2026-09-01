import 'package:flutter/material.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/custom_text_field.dart';

class ManageEventCategory extends StatefulWidget {
  const ManageEventCategory({super.key});

  @override
  State<ManageEventCategory> createState() => _ManageEventCategoryState();
}

class _ManageEventCategoryState extends State<ManageEventCategory> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: "Manage Event Categories", showBackButton: true),
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
                            title: "Create New Categories",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.sectionGap),

                          // Title
                          TextBodyStyleWidget(
                            title: "Name",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "New Categories",
                            controller: nameController,
                          ),
                          SizedBox(height: AppSizes.itemGap),


                          // Description
                          TextBodyStyleWidget(
                            title: "Description",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "Write your content here",
                            controller: descriptionController,
                            minLines: 4,
                            maxLines: 6,
                          ),


                          SizedBox(height: AppSizes.sectionGap),

                          CustomButton(text: "Add Category", onTap: () {}),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    CustomCard(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          TextBodyStyleWidget(
                            title: "Existing Category ( 1 )",
                            color: color.primary,
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
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: .start,
                                            children: [
                                              TextTitleWidget(
                                                title: "Night",
                                                color: color.primary,
                                                maxLines: 1,
                                              ),
                                              SizedBox(height: AppSizes.appbarGap),
                                              TextBodyStyleWidget(
                                                title: "night party",
                                                maxLines: 1,
                                                size: AppSizes.cardTitle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.delete_outline_outlined,size: AppSizes.iconLarge, color: Colors.red),
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
