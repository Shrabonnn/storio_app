import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/custom_drop_down.dart';

import '../../model/activity/activity_details_seo_settings_model.dart';
import '../../model/form_field/form_feild_data.dart';
import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/institute_profile/Institute_overview_screen.dart';
import '../../widget/institute_profile/infrastructure_drop_down.dart';
import '../../widget/quill/editor_icon.dart';
import '../../widget/quill/editor_option.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_text_field.dart';

class AddNewNotice extends StatefulWidget {
  const AddNewNotice({super.key,  this.isEdit = false});
  final bool isEdit;

  @override
  State<AddNewNotice> createState() => _AddNewNoticeState();
}

class _AddNewNoticeState extends State<AddNewNotice> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController publishDateController = TextEditingController();
  final TextEditingController publishTimeController = TextEditingController();

  final List<String> statusList = [
    "Draft",
    "Published",
    "Schedule for Later",
    "Archived"
  ];

  String selectedStatus = "Draft";

  bool isShowPdf = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    publishTimeController.dispose();
    publishDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(

      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title:widget.isEdit? "Edit Notice":"Create New Notice",
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
                        CustomTextFieldWidget(hintText: "e.g. Notice Title", controller: titleController),

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

                    // Status
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [

                        // Tag
                        TextBodyStyleWidget(title: "Status", color: color.primary,size: AppSizes.sectionTitle,),
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
                        if(selectedStatus == statusList[0] || selectedStatus == statusList[1] || selectedStatus == statusList[3] )...[
                          SizedBox(height: AppSizes.itemGap),
                          Row(

                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: .start,
                                  children: [
                                    TextBodyStyleWidget(title: "Publish Date", color: color.primary,size: AppSizes.cardTitle,),
                                    SizedBox(height: AppSizes.appbarGap),
                                    CustomTextFieldWidget(hintText: "mm/dd/yy", controller: publishDateController,isDatePicker: true,),

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
                                    TextBodyStyleWidget(title: "Publish Date", color: color.primary,size: AppSizes.cardTitle,),
                                    SizedBox(height: AppSizes.appbarGap),
                                    CustomTextFieldWidget(hintText: "mm/dd/yy", controller: publishDateController,isDatePicker: true,),

                                  ],
                                ),
                              ),
                              SizedBox(width: AppSizes.smallGap,),
                              Flexible(
                                child: Column(
                                  children: [
                                    TextBodyStyleWidget(title: "Time", color: color.primary,size: AppSizes.cardTitle,),
                                    SizedBox(height: AppSizes.appbarGap),
                                    CustomTextFieldWidget(hintText: "2:30 PM", controller: publishTimeController,isDatePicker: true,),

                                  ],
                                ),
                              )
                            ],
                          )
                        ]


                      ],


                    )),

                    SizedBox(height: AppSizes.sectionGap,),


                    CustomCard(child: Row(
                      children: [
                        Checkbox(
                          value: isShowPdf,
                          onChanged: (value) {
                            setState(() {
                              isShowPdf = value ?? false;
                            });
                          },
                        ),

                        Expanded(
                          child: TextBodyStyleWidget(
                           title:  "Show PDF in view mode (embed PDF viewer on public page instead of showing only a download button ",fontbold: false,
                          ),
                        ),
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
                            TextBodyStyleWidget(title: "Featured Image", color: color.primary,size: AppSizes.sectionTitle,),
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


                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text: "Cancel", onTap: (){},width: 30.w,backgroundColor: color.cardBackground,foregroundColor: color.primary,),
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
