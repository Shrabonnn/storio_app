import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/universal/custom_card2.dart';

import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_text_field.dart';

class GeneralSetting extends StatefulWidget {
  const GeneralSetting({super.key});

  @override
  State<GeneralSetting> createState() => _GeneralSettingState();
}

class _GeneralSettingState extends State<GeneralSetting> {

  final TextEditingController fromTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  
  bool isFormStatus = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fromTitleController.dispose();
    descriptionController.dispose();
    deadlineController.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "General Settings",
            showBackButton: true,
          ),

          SliverPadding(
              padding: EdgeInsetsGeometry.only(top: AppSizes.sectionTitle,left: AppSizes.screenPadding,right: AppSizes.screenPadding),
              sliver: SliverList(delegate: SliverChildListDelegate([
                Column(
                  children: [
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        // Title
                        TextBodyStyleWidget(title: "Form Title", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "Online Admission Form", controller: fromTitleController),
                        SizedBox(height: AppSizes.itemGap),


                        // URL SLUG
                        TextBodyStyleWidget(title: "Description", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "", controller: descriptionController,maxLines: 6,minLines: 4,),
                        SizedBox(height: AppSizes.itemGap),


                        // AUTHOR
                        TextBodyStyleWidget(title: "Application Deadline", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "07/09/2026", controller: deadlineController,isDatePicker: true,),
                        SizedBox(height: AppSizes.itemGap),
                        
                        CustomCard2(
                          child: Padding(
                            padding:  EdgeInsets.all(AppSizes.contentPadding),
                            child: Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                               Row(
                                 children: [
                                   Icon(Icons.format_align_center_outlined,color: isFormStatus ?Colors.green:Colors.red, size: AppSizes.iconLarge,),
                                   SizedBox(width: AppSizes.smallGap,),
                                   Column(
                                     crossAxisAlignment: .start,
                                     children: [
                                       TextTitleWidget(title: "Form Status",color: AppColors.primary,),
                                       SizedBox(height: AppSizes.appbarGap,),
                                       TextBodyStyleWidget(title:isFormStatus?"Currently accepting applications" :"Applications are closed"),

                                     ],
                               )
                                  ],
                                ),
                                SizedBox(width: AppSizes.sectionGap,),
                                Checkbox(value: isFormStatus, activeColor: AppColors.primary,onChanged: (value){
                                  setState(() {
                                    isFormStatus = value ?? false;
                                  });
                                })
                              ],
                            ),
                          ),
                        )


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
              ]))
          ),

        ],
      ),
    );
  }
}
