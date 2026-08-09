import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/institute_profile/Institute_overview_screen.dart';

import '../model/activity/activity_details_seo_settings_model.dart';
import '../model/form_field/form_feild_data.dart';
import '../utils/app_colors.dart';
import '../utils/sizes.dart';
import '../widget/custom_button/custom_buttom.dart';
import '../widget/institute_profile/infrastructure_drop_down.dart';
import '../widget/textStyle/text_body_style.dart';
import '../widget/universal/custom_app_bar.dart';
import '../widget/universal/custom_card.dart' ;
import '../widget/universal/custom_text_field.dart';

class ActivityManageDetailsScreen extends StatefulWidget {
  const ActivityManageDetailsScreen({super.key});

  @override
  State<ActivityManageDetailsScreen> createState() => _ActivityManageDetailsScreenState();
}

class _ActivityManageDetailsScreenState extends State<ActivityManageDetailsScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController activityController = TextEditingController();
  final TextEditingController authorNameController = TextEditingController();
  final TextEditingController tagNameController = TextEditingController();
  final TextEditingController metaTitleController = TextEditingController();
  final TextEditingController metaDescriptionController = TextEditingController();
  final TextEditingController metaSummaryController = TextEditingController();



  final ImagePicker picker = ImagePicker();
  XFile? selectedFile;
  Future<void> _pickImage() async {
    print("Clicked From Activity Manage Details");
    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        selectedFile = image;
      });
    }
  }



  List<ActivityDetailsSeoSettingModel> activitySeoSetting = [];
  bool isActivitySettingSeoExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Activity Manage Detail",
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
                        CustomTextFieldWidget(hintText: "e.g., Annual Tech Conference 2025", controller: titleController),
                        SizedBox(height: AppSizes.itemGap),


                        // Activities
                        TextBodyStyleWidget(title: "Activities", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "annual-tech-conference-2025", controller: activityController,minLines: 2,),
                        SizedBox(height: AppSizes.itemGap),

                      ],


                    )),
                    SizedBox(height: AppSizes.sectionGap,),

                    // Images
                    CustomCard(child: Column(
                      crossAxisAlignment: .center,
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            TextBodyStyleWidget(title: "Gallery Images", color: AppColors.primary,size: AppSizes.sectionTitle,),
                            SizedBox(width: AppSizes.appbarGap),
                            CustomButton(
                              height: 4.h,
                              width: 30.w,
                              text: "Add Photos",
                              onTap: _pickImage,
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Click 'Add Photos' to start adding pictures.",size: AppSizes.cardTitle,),




                      ],


                    )),

                    SizedBox(height: AppSizes.sectionGap,),

                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [

                        // Tag
                        TextBodyStyleWidget(title: "Add Tags", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "add tags...", controller: tagNameController),
                        SizedBox(height: AppSizes.itemGap),

                      ],


                    )),
                    SizedBox(height: AppSizes.sectionGap,),


                    // Activity Setting
                    CustomCard(child: InstituteOverviewScreen(
                      title: "SEO Settings",
                      showIcon: true,
                      userIcon: isActivitySettingSeoExpanded ? Icons.remove : Icons.keyboard_arrow_down,
                      onTap:() {
                        setState(() {
                          isActivitySettingSeoExpanded = !isActivitySettingSeoExpanded;
                        });
                      },
                      isExpanded: isActivitySettingSeoExpanded,
                      expandableChild: InfrastructureDropDown(

                        fields: [
                          FormFieldData(
                            title: "Meta Title",
                            hint: "SEO Title",
                            controller: metaTitleController,
                          ),
                          FormFieldData(
                            title: "Meta Description",
                            hint: "SEO Description",
                            controller: metaDescriptionController,
                          ),
                          FormFieldData(
                            title: "Excerpt/Short Summary",
                            hint: "Brief Summary",
                            controller: metaSummaryController,
                          ),
                        ],

                        onSave: () {
                          setState(() {
                            activitySeoSetting.add(
                              ActivityDetailsSeoSettingModel(
                              metaTitle: metaTitleController.text.trim(),
                                metaDescription: metaDescriptionController.text.trim(),
                                metaSummary: metaSummaryController.text.trim()
                              ),
                            );

                            metaTitleController.clear();
                            metaDescriptionController.clear();
                            metaSummaryController.clear();

                            isActivitySettingSeoExpanded = false;
                          });
                        },

                      ),
                    ),)
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
