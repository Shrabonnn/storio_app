import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_text_field.dart';

class AddNewEventCalender extends StatefulWidget {
  const AddNewEventCalender({super.key});

  @override
  State<AddNewEventCalender> createState() => _AddNewEventCalenderState();
}

class _AddNewEventCalenderState extends State<AddNewEventCalender> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();


  final List<String> levelList = [
    "School-Wide",
    "Primary",
    "Secondary",
    "College"
  ];

  String selectedLevel = "School-Wide";

  final List<String> categoryList = [
    "Academic Events",
    "Holiday & Breaks",
    "Examinations",
    "Festivals & Sports",
    "Admin Deadlines"
  ];

  String selectedCategory = "Academic Events";

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title:"Add New Event",
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



                        // Title
                        TextBodyStyleWidget(title: "Title", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "e.g. Enter event title", controller: titleController),
                        SizedBox(height: AppSizes.itemGap,),


                        TextBodyStyleWidget(title: "Description", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "e.g. Enter event description", controller: descriptionController,minLines: 4,maxLines: 6,),

                      ],


                    )),
                    SizedBox(height: AppSizes.sectionGap,),



                    // Time
                    CustomCard(
                      child: Row(

                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                TextBodyStyleWidget(title: "Start Date", color: AppColors.primary,size: AppSizes.cardTitle,),
                                SizedBox(height: AppSizes.appbarGap),
                                CustomTextFieldWidget(hintText: "mm/dd/yy", controller: startDateController,isDatePicker: true,),

                              ],
                            ),
                          ),
                          SizedBox(width: AppSizes.smallGap,),
                          Flexible(
                            child: Column(
                              children: [
                                TextBodyStyleWidget(title: "End Date", color: AppColors.primary,size: AppSizes.cardTitle,),
                                SizedBox(height: AppSizes.appbarGap),
                                CustomTextFieldWidget(hintText: "2:30 PM", controller: endDateController,isDatePicker: true,),

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap,),
                    // Status
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [

                        // Tag
                        Row(
                          children: [
                            Flexible(
                              child: Column(
                                children: [
                                  TextBodyStyleWidget(title: "Category", color: AppColors.primary,size: AppSizes.cardTitle,),
                                  SizedBox(height: AppSizes.appbarGap),

                                  CustomDropdown(
                                    items: categoryList,
                                    initialValue: selectedCategory,
                                    width: 100.w,

                                    onChanged: (value) {
                                      print("Selected: $value");
                                      setState(() {
                                        selectedCategory = value.toString();
                                      });


                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: AppSizes.appbarGap,),
                            Flexible(
                              child: Column(
                                children: [
                                  TextBodyStyleWidget(title: "Level", color: AppColors.primary,size: AppSizes.cardTitle,),
                                  SizedBox(height: AppSizes.appbarGap),

                                  CustomDropdown(
                                    items: levelList,
                                    initialValue: selectedLevel,
                                    width: 100.w,

                                    onChanged: (value) {
                                      print("Selected: $value");
                                      setState(() {
                                        selectedLevel = value.toString();
                                      });


                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),



                      ],


                    )),

                    SizedBox(height: AppSizes.sectionGap,),





                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text: "Cancel", onTap: (){},width: 30.w,backgroundColor: Colors.white,foregroundColor: AppColors.primary,),
                        SizedBox(width: AppSizes.appbarGap,),
                        Flexible(child: CustomButton(text:"Save Post", onTap: (){},)),
                      ],
                    ),
                    SizedBox(height: AppSizes.sectionGap),



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
