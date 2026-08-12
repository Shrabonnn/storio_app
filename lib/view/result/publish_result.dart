import 'package:flutter/material.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';

import '../../utils/sizes.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_text_field.dart';
import '../../widget/universal/status_button_row.dart';

class PublishResult extends StatefulWidget {
  const PublishResult({super.key});

  @override
  State<PublishResult> createState() => _PublishResultState();
}

class _PublishResultState extends State<PublishResult> {


  final TextEditingController examNameController = TextEditingController();
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController academicaYearController = TextEditingController();
  final TextEditingController totalExaminessController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController failController = TextEditingController();

  List<String> statusList = ["School Result", "Public Result", "Admission Result"];

  int selectedStatus = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Exam Results",
            subtitle: "Academic Records",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
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


                    //SizedBox(height: AppSizes.sectionGap),

                  ],
                ),
                CustomCard(child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    TextTitleWidget(title: "Publish New Result",color: AppColors.primary,),
                    TextBodyStyleWidget(title: "School Level",),
                    Divider(),
                    SizedBox(height: AppSizes.smallGap,),

                    TextBodyStyleWidget(title: "Exam Name", color: AppColors.primary,size: AppSizes.cardTitle,),
                    SizedBox(height: AppSizes.appbarGap),
                    CustomTextFieldWidget(hintText: "e.g. Annual Exam", controller: examNameController),
                    SizedBox(height: AppSizes.itemGap),

                    TextBodyStyleWidget(title: "Class Name", color: AppColors.primary,size: AppSizes.cardTitle,),
                    SizedBox(height: AppSizes.appbarGap),
                    CustomTextFieldWidget(hintText: "e.g. Class Ten", controller: classNameController),
                    SizedBox(height: AppSizes.itemGap),

                    TextBodyStyleWidget(title: "Academic Year", color: AppColors.primary,size: AppSizes.cardTitle,),
                    SizedBox(height: AppSizes.appbarGap),
                    CustomTextFieldWidget(hintText: "2026", controller: academicaYearController),
                    SizedBox(height: AppSizes.itemGap),

                    TextBodyStyleWidget(title: "Total Examinees", color: AppColors.primary,size: AppSizes.cardTitle,),
                    SizedBox(height: AppSizes.appbarGap),
                    CustomTextFieldWidget(hintText: "100", controller: totalExaminessController),
                    SizedBox(height: AppSizes.itemGap),


                    Row(
                      children: [
                        Flexible(
                          child: Column(
                            children: [
                              TextBodyStyleWidget(title: "Passed", color: AppColors.primary,size: AppSizes.cardTitle,),
                              SizedBox(height: AppSizes.appbarGap),
                              CustomTextFieldWidget(hintText: "70", controller: passController),
                              SizedBox(height: AppSizes.itemGap),
                            ],
                          ),
                        ),
                        SizedBox(width: AppSizes.smallGap,),

                        Flexible(
                          child: Column(
                            children: [
                              TextBodyStyleWidget(title: "Failed", color: AppColors.primary,size: AppSizes.cardTitle,),
                              SizedBox(height: AppSizes.appbarGap),
                              CustomTextFieldWidget(hintText: "30", controller: failController),
                              SizedBox(height: AppSizes.itemGap),
                            ],
                          ),
                        )
                      ],
                    )



                  ],
                ))
              ]),
            ),
          ),


          SliverPadding(padding: EdgeInsets.only(bottom:AppSizes.sectionGap))
        ],
      ),
    );
  }
}
