import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';

import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_text_field.dart';
import '../../widget/universal/file_picker.dart';
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


  // need to create controller for public and academic result publish

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    examNameController.dispose();
    classNameController.dispose();
    academicaYearController.dispose();
    totalExaminessController.dispose();
    passController.dispose();
    failController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Publish Results",
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

                // School result
                if(selectedStatus == 0)
                  CustomCard(child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      TextTitleWidget(title: "Publish New Result",color: color.primary,),
                      TextBodyStyleWidget(title: "School Level",),
                      Divider(),
                      SizedBox(height: AppSizes.smallGap,),

                      TextBodyStyleWidget(title: "Exam Name", color: color.primary,size: AppSizes.cardTitle,),
                      SizedBox(height: AppSizes.appbarGap),
                      CustomTextFieldWidget(hintText: "e.g. Annual Exam", controller: examNameController),
                      SizedBox(height: AppSizes.itemGap),

                      TextBodyStyleWidget(title: "Class Name", color: color.primary,size: AppSizes.cardTitle,),
                      SizedBox(height: AppSizes.appbarGap),
                      CustomTextFieldWidget(hintText: "e.g. Class Ten", controller: classNameController),
                      SizedBox(height: AppSizes.itemGap),

                      TextBodyStyleWidget(title: "Academic Year", color: color.primary,size: AppSizes.cardTitle,),
                      SizedBox(height: AppSizes.appbarGap),
                      CustomTextFieldWidget(hintText: "2026", controller: academicaYearController),
                      SizedBox(height: AppSizes.itemGap),

                      TextBodyStyleWidget(title: "Total Examinees", color: color.primary,size: AppSizes.cardTitle,),
                      SizedBox(height: AppSizes.appbarGap),
                      CustomTextFieldWidget(hintText: "100", controller: totalExaminessController),
                      SizedBox(height: AppSizes.itemGap),


                      Row(
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                TextBodyStyleWidget(title: "Passed", color: color.primary,size: AppSizes.cardTitle,),
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
                                TextBodyStyleWidget(title: "Failed", color: color.primary,size: AppSizes.cardTitle,),
                                SizedBox(height: AppSizes.appbarGap),
                                CustomTextFieldWidget(hintText: "30", controller: failController),
                                SizedBox(height: AppSizes.itemGap),
                              ],
                            ),
                          )
                        ],
                      ),


                      Row(
                        children: [
                          Icon(Icons.file_copy_outlined,size: AppSizes.icon,color: color.primary,),
                          SizedBox(width: AppSizes.appbarGap,),
                          TextBodyStyleWidget(title: "Result Sheet (PDF)", color: color.primary,size: AppSizes.cardTitle,),
                        ],
                      ),
                      SizedBox(height: AppSizes.appbarGap),
                      FilePickerWidget()




                    ],
                  )),

                // Public result
                if(selectedStatus == 1)
                  CustomCard(child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      TextTitleWidget(title: "Publish New Result",color: color.primary,),
                      TextBodyStyleWidget(title: "Public Level",),
                      Divider(),
                      SizedBox(height: AppSizes.smallGap,),

                      TextBodyStyleWidget(title: "Exam Name", color: color.primary,size: AppSizes.cardTitle,),
                      SizedBox(height: AppSizes.appbarGap),
                      CustomTextFieldWidget(hintText: "e.g. S.S.C H.S.C", controller: examNameController),
                      SizedBox(height: AppSizes.itemGap),


                      TextBodyStyleWidget(title: "Academic Year", color: color.primary,size: AppSizes.cardTitle,),
                      SizedBox(height: AppSizes.appbarGap),
                      CustomTextFieldWidget(hintText: "2026", controller: academicaYearController),
                      SizedBox(height: AppSizes.itemGap),

                      TextBodyStyleWidget(title: "Total Examinees", color: color.primary,size: AppSizes.cardTitle,),
                      SizedBox(height: AppSizes.appbarGap),
                      CustomTextFieldWidget(hintText: "100", controller: totalExaminessController),
                      SizedBox(height: AppSizes.itemGap),


                      Row(
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                TextBodyStyleWidget(title: "Passed", color: color.primary,size: AppSizes.cardTitle,),
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
                                TextBodyStyleWidget(title: "Failed", color: color.primary,size: AppSizes.cardTitle,),
                                SizedBox(height: AppSizes.appbarGap),
                                CustomTextFieldWidget(hintText: "30", controller: failController),
                                SizedBox(height: AppSizes.itemGap),
                              ],
                            ),
                          )
                        ],
                      ),

                      TextBodyStyleWidget(title: "GPA A+ Recipients", color: color.primary,size: AppSizes.cardTitle,),
                      SizedBox(height: AppSizes.appbarGap),
                      CustomTextFieldWidget(hintText: "0", controller: totalExaminessController),
                      SizedBox(height: AppSizes.itemGap),

                      TextBodyStyleWidget(title: "GPA A Recipients", color: color.primary,size: AppSizes.cardTitle,),
                      SizedBox(height: AppSizes.appbarGap),
                      CustomTextFieldWidget(hintText: "0", controller: totalExaminessController),
                      SizedBox(height: AppSizes.itemGap),


                      Row(
                        children: [
                          Icon(Icons.file_copy_outlined,size: AppSizes.icon,color: color.primary,),
                          SizedBox(width: AppSizes.appbarGap,),
                          TextBodyStyleWidget(title: "Result Sheet (PDF)", color: color.primary,size: AppSizes.cardTitle,),
                        ],
                      ),
                      SizedBox(height: AppSizes.appbarGap),
                      FilePickerWidget()




                    ],
                  )),


                // Admission result
                if(selectedStatus == 2)
                  CustomCard(child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      TextTitleWidget(title: "Publish New Result",color: color.primary,),
                      TextBodyStyleWidget(title: "A Level",),
                      Divider(),
                      SizedBox(height: AppSizes.smallGap,),

                      TextBodyStyleWidget(title: "Exam Name", color: color.primary,size: AppSizes.cardTitle,),
                      SizedBox(height: AppSizes.appbarGap),
                      CustomTextFieldWidget(hintText: "e.g. Admission Test 2024", controller: examNameController),
                      SizedBox(height: AppSizes.itemGap),

                      TextBodyStyleWidget(title: "Program/Class", color: color.primary,size: AppSizes.cardTitle,),
                      SizedBox(height: AppSizes.appbarGap),
                      CustomTextFieldWidget(hintText: "e.g. Class Ten", controller: classNameController),
                      SizedBox(height: AppSizes.itemGap),

                      TextBodyStyleWidget(title: "Academic Year", color: color.primary,size: AppSizes.cardTitle,),
                      SizedBox(height: AppSizes.appbarGap),
                      CustomTextFieldWidget(hintText: "2026", controller: academicaYearController),
                      SizedBox(height: AppSizes.itemGap),

                      TextBodyStyleWidget(title: "Total Examinees", color: color.primary,size: AppSizes.cardTitle,),
                      SizedBox(height: AppSizes.appbarGap),
                      CustomTextFieldWidget(hintText: "100", controller: totalExaminessController),
                      SizedBox(height: AppSizes.itemGap),


                      Row(
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                TextBodyStyleWidget(title: "Passed", color: color.primary,size: AppSizes.cardTitle,),
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
                                TextBodyStyleWidget(title: "Failed", color: color.primary,size: AppSizes.cardTitle,),
                                SizedBox(height: AppSizes.appbarGap),
                                CustomTextFieldWidget(hintText: "30", controller: failController),
                                SizedBox(height: AppSizes.itemGap),
                              ],
                            ),
                          )
                        ],
                      ),


                      Row(
                        children: [
                          Icon(Icons.file_copy_outlined,size: AppSizes.icon,color: color.primary,),
                          SizedBox(width: AppSizes.appbarGap,),
                          TextBodyStyleWidget(title: "Result Sheet (PDF)", color: color.primary,size: AppSizes.cardTitle,),
                        ],
                      ),
                      SizedBox(height: AppSizes.appbarGap),
                      FilePickerWidget()




                    ],
                  )),


                SizedBox(height: AppSizes.sectionGap,),

                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    CustomButton(text: "Cancel", onTap: (){},width: 30.w,backgroundColor: color.cardBackground,foregroundColor: color.primary,),
                    SizedBox(width: AppSizes.appbarGap,),
                    Flexible(child: CustomButton(text: "Publish Result", onTap: (){},)),
                  ],
                ),
              ]),
            ),
          ),


          SliverPadding(padding: EdgeInsets.only(bottom:AppSizes.sectionGap))
        ],
      ),
    );
  }
}
