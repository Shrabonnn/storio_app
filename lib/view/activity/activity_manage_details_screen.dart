import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/widget/institute_profile/Institute_overview_screen.dart';

import '../../model/activity/activity_details_seo_settings_model.dart';
import '../../model/form_field/form_feild_data.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/institute_profile/infrastructure_drop_down.dart';
import '../../widget/quill/editor_icon.dart';
import '../../widget/quill/editor_option.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart' ;
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_text_field.dart';

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




  final List<String> statusList = [
    "Draft",
    "Published",
    "Scheduled",
    "Cancelled",
  ];






  List<ActivityDetailsSeoSettingModel> activitySeoSetting = [];
  bool isActivitySettingSeoExpanded = false;



  @override
  void initState() {
    super.initState();


  }

  @override
  void dispose() {


    titleController.dispose();
    activityController.dispose();
    authorNameController.dispose();
    tagNameController.dispose();
    metaTitleController.dispose();
    metaDescriptionController.dispose();
    metaSummaryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Activity Manage Details",
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
                        TextBodyStyleWidget(title: "Title", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "e.g., Annual Tech Conference 2025", controller: titleController),
                        SizedBox(height: AppSizes.itemGap),


                        // Activities
                        TextBodyStyleWidget(title: "Activities", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "annual-tech-conference-2025", controller: activityController,),
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
                            TextBodyStyleWidget(title: "Gallery Images", color: color.primary,size: AppSizes.sectionTitle,),
                            SizedBox(width: AppSizes.appbarGap),
                            CustomButton(
                              height: 4.h,
                              width: 30.w,
                              text: "Add Photos",
                              onTap: (){
                                Navigator.pushNamed(context, RoutesName.media_manage_details);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Click 'Add Photos' to start adding pictures.",size: AppSizes.cardTitle,),




                      ],


                    )),

                    SizedBox(height: AppSizes.sectionGap,),

                    // Content
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          TextBodyStyleWidget(
                            title: "Content",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),

                          SizedBox(height: AppSizes.appbarGap),

                          Column(
                            children: [

                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSizes.smallPadding,
                                    vertical: 8,
                                  ),
                                  child: Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: [

                                      editorOption("paragraph"),
                                      editorOption("Default"),
                                      editorOption("14px"),

                                      editorIcon("B"),
                                      editorIcon("I"),
                                      editorIcon("U"),
                                      editorIcon("S"),

                                      const Text(
                                        "x²",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),

                                      SizedBox(width: 6),

                                      Container(
                                        width: 1,
                                        height: 25,
                                        color: Colors.grey.shade300,
                                      ),



                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: AppSizes.appbarGap,),



                              Divider(
                                height: 1,
                                color: Colors.grey.shade300,
                              ),

                              SizedBox(height: AppSizes.appbarGap,),
                              // Small preview area
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, RoutesName.content_details);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(AppSizes.smallPadding),
                                  child: TextBodyStyleWidget(title: "Write content here...",size: AppSizes.cardTitle,),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),


                    SizedBox(height: AppSizes.sectionGap,),

                    // Activity Setting
                    CustomCard(child: Column(
                      children: [
                        InstituteOverviewScreen(
                          title: "Activity Screen",
                          isExpanded: false,
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              // Authon Name
                              TextBodyStyleWidget(title: "Author Name", color: color.primary,size: AppSizes.cardTitle,),
                              SizedBox(height: AppSizes.appbarGap),
                              CustomTextFieldWidget(hintText: "Hasibul Islam",controller: titleController),
                              SizedBox(height: AppSizes.itemGap),


                              // Status
                              TextBodyStyleWidget(title: "Status", color: color.primary,size: AppSizes.cardTitle,),
                              SizedBox(height: AppSizes.appbarGap),
                              CustomDropdown(
                                items: statusList,
                                initialValue: "Draft",
                                width: 100.w,
                                height: 4.5.h,
                                onChanged: (value) {
                                  print("Selected: $value");

                                },
                              ),

                            ],


                          ),)
                      ],
                    )),

                    SizedBox(height: AppSizes.sectionGap,),

                    //Tag
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [

                        // Tag
                        TextBodyStyleWidget(title: "Add Tags", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "add tags...", controller: tagNameController),


                      ],


                    )),


                    SizedBox(height: AppSizes.sectionGap,),


                    // Seo Setting
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

                        // If click add add on third place , if click the final save btn then add to DB
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
                    ),),

                    SizedBox(height: AppSizes.sectionGap,),

                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text: "Cancel", onTap: (){},width: 30.w,backgroundColor: color.cardBackground,foregroundColor: color.primary,),
                        SizedBox(width: AppSizes.appbarGap,),
                        Flexible(child: CustomButton(text: "Save", onTap: (){},)),
                      ],
                    ),




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
