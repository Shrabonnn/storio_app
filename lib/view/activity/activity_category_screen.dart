import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/widget/institute_profile/Institute_overview_screen.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';

import '../../utils/sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_text_field.dart';

class ActivityCategoryScreen extends StatefulWidget {
  const ActivityCategoryScreen({super.key});

  @override
  State<ActivityCategoryScreen> createState() => _ActivityCategoryScreenState();
}

class _ActivityCategoryScreenState extends State<ActivityCategoryScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController urlSlugController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Activity Manage Category",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [
                       TextTitleWidget(title: "Manage Category",size: AppSizes.sectionTitle,color: AppColors.primary,),
                        SizedBox(height: AppSizes.sectionGap),


                        // Name
                        TextBodyStyleWidget(title: "Name", color: AppColors.primary,size: AppSizes.cardTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "annual Sports Day", controller: nameController),
                        SizedBox(height: AppSizes.itemGap),


                        // Url
                        TextBodyStyleWidget(title: "URL Slug", color: AppColors.primary,size: AppSizes.cardTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "annual-sports-day", controller: urlSlugController),
                        SizedBox(height: AppSizes.itemGap),


                        // Description
                        TextBodyStyleWidget(title: "Description", color: AppColors.primary,size: AppSizes.cardTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "Brief description category", minLines: 3,maxLines: 5,controller: descriptionController),

                        SizedBox(height: AppSizes.sectionGap),
                        Row(
                          mainAxisAlignment: .end,
                          children: [
                            CustomButton(text: "Add Category",width: 30.w, onTap: (){})
                          ],
                        ),

                        SizedBox(height: AppSizes.sectionGap),
                        Divider(),

                        TextTitleWidget(title: "Existing catagories",size: AppSizes.sectionTitle,color: AppColors.primary,),
                        SizedBox(height: AppSizes.itemGap),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextTitleWidget(title: "Annual Sports",color: Colors.black54,),
                                Row(
                                  children: [
                                    IconButton(onPressed: (){}, icon: Icon(Icons.edit_calendar_outlined),),
                                    IconButton(onPressed: (){}, icon: Icon(Icons.delete_forever,color: Colors.red,))
                                  ],
                                )
                              ],
                            ),

                          ],
                        )







                      ],
                    ))
                  ],
                )

              ]),
            ),
          ),

        ],
      ),
    );
  }
}
