import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/custom_drop_down.dart';

import '../../model/activity/activity_details_seo_settings_model.dart';
import '../../model/form_field/form_feild_data.dart';
import '../../routes/routes_name.dart';
import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/institute_profile/Institute_overview_screen.dart';
import '../../widget/institute_profile/infrastructure_drop_down.dart';
import '../../widget/quill/editor_icon.dart';
import '../../widget/quill/editor_option.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_text_field.dart';
import '../../widget/universal/status_button_row.dart';


class AddBlog extends StatefulWidget {
  const AddBlog({super.key, required this.isEdit});

  final bool isEdit;

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {



  final TextEditingController jonTitleController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController vacancyCountController = TextEditingController();
  final TextEditingController applicationDeadlineController = TextEditingController();
  final TextEditingController applicationMethodController = TextEditingController();




  final List<String> statusList = [
    "Draft",
    "Publish Immediately",
    "Schedule for Later",
  ];

  String selectedStatus = "Draft";


  List<ActivityDetailsSeoSettingModel> activitySeoSetting = [];
  bool isActivitySettingSeoExpanded = false;



  @override
  void initState() {
    super.initState();


  }

  @override
  void dispose() {
    super.dispose();
    applicationMethodController.dispose();
    applicationDeadlineController.dispose();
    vacancyCountController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    companyNameController.dispose();
    jonTitleController.dispose();
    designationController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title:widget.isEdit? "Edit Post":"Create New Post",
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
                        TextBodyStyleWidget(title: "Title*", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "e.g. Post Title", controller: jonTitleController),
                        SizedBox(height: AppSizes.itemGap),


                        // URL SLUG
                        TextBodyStyleWidget(title: "URL Slug*", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "blog -2025", controller: designationController,),
                        SizedBox(height: AppSizes.itemGap),


                        // AUTHOR
                        TextBodyStyleWidget(title: "Author*", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "e.g. John Doe", controller: designationController,),

                      ],


                    )),
                    SizedBox(height: AppSizes.sectionGap,),

                    // Images
                    CustomCard(child:  Column(
                      crossAxisAlignment: .center,
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            TextBodyStyleWidget(title: "Featured Image", color: AppColors.primary,size: AppSizes.sectionTitle,),
                            SizedBox(width: AppSizes.appbarGap),
                            CustomButton(
                              height: 4.h,
                              width: 30.w,
                              text: widget.isEdit ? "Change Image":"Select Image",
                              onTap: (){
                                Navigator.pushNamed(context, RoutesName.media_manage_details);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.itemGap),

                        widget.isEdit  ? Container(
                          width: 100.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            'assets/images/institute.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ):TextBodyStyleWidget(title: "Recommended size: 1200x600px for banners, 600x600px for cards.",size: AppSizes.cardTitle,maxLines: 2,),



                      ],


                    ),),

                    SizedBox(height: AppSizes.sectionGap,),

                    // Content
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          TextBodyStyleWidget(
                            title: "Content",
                            color: AppColors.primary,
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

                    // Status
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [

                        // Tag
                        TextBodyStyleWidget(title: "Status", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomDropdown(
                          items: statusList,
                          initialValue: selectedStatus,
                          width: 100.w,

                          onChanged: (value) {
                            print("Selected: $value");
                            setState(() {
                              selectedStatus = value.toString();
                            });


                          },
                        ),
                        if(selectedStatus == statusList[1])...[
                          SizedBox(height: AppSizes.itemGap),
                          Row(

                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: .start,
                                  children: [
                                    TextBodyStyleWidget(title: "Publish Date", color: AppColors.primary,size: AppSizes.cardTitle,),
                                    SizedBox(height: AppSizes.appbarGap),
                                    CustomTextFieldWidget(hintText: "mm/dd/yy", controller: companyNameController,isDatePicker: true,),

                                  ],
                                ),
                              ),

                            ],
                          )
                        ],
                        if(selectedStatus == statusList[2])...[
                          SizedBox(height: AppSizes.itemGap),
                          Row(

                            children: [
                              Flexible(
                                child: Column(
                                  children: [
                                    TextBodyStyleWidget(title: "Publish Date", color: AppColors.primary,size: AppSizes.cardTitle,),
                                    SizedBox(height: AppSizes.appbarGap),
                                    CustomTextFieldWidget(hintText: "mm/dd/yy", controller: companyNameController,isDatePicker: true,),

                                  ],
                                ),
                              ),
                              SizedBox(width: AppSizes.smallGap,),
                              Flexible(
                                child: Column(
                                  children: [
                                    TextBodyStyleWidget(title: "Time", color: AppColors.primary,size: AppSizes.cardTitle,),
                                    SizedBox(height: AppSizes.appbarGap),
                                    CustomTextFieldWidget(hintText: "2:30 PM", controller: companyNameController,isDatePicker: true,),

                                  ],
                                ),
                              )
                            ],
                          )
                        ]


                      ],


                    )),

                    SizedBox(height: AppSizes.sectionGap,),

                    // Eecerpt
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [

                        // Tag
                        TextBodyStyleWidget(title: "Excerpt", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "A short summary of the post...", controller: companyNameController,minLines:3,maxLines: 6,),


                      ],


                    )),
                    SizedBox(height: AppSizes.sectionGap,),

                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [

                        // Tag
                        TextBodyStyleWidget(title: "Add Tags", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "add tags...", controller: companyNameController),


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
                            controller: jonTitleController,
                          ),
                          FormFieldData(
                            title: "Meta Description",
                            hint: "SEO Description",
                            controller: descriptionController,

                          ),

                        ], onSave: () {  },



                      ),
                    ),),

                    SizedBox(height: AppSizes.sectionGap,),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text: "Cancel", onTap: (){},width: 30.w,backgroundColor: Colors.white,foregroundColor: AppColors.primary,),
                        SizedBox(width: AppSizes.appbarGap,),
                        Flexible(child: CustomButton(text:widget.isEdit? "Edit Post":"Save Post", onTap: (){},)),
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
