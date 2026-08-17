import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/custom_drop_down.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/quill/editor_icon.dart';
import '../../widget/quill/editor_option.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_text_field.dart';
import '../../widget/universal/status_button_row.dart';

class AddNewJobCircular extends StatefulWidget {
  const AddNewJobCircular({super.key,  this.isEdit=false});
  final bool isEdit;

  @override
  State<AddNewJobCircular> createState() => _AddNewJobCircularState();
}

class _AddNewJobCircularState extends State<AddNewJobCircular> {

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
    "Active",
    "Expired",
  ];

  final List<String> employeeType = [
    "Full-Time",
    "Part_Time",
    "Contract",
    "Remote",
    "Internship",
  ];

  final List<String> applicationMethod = [
    "Link",
    "Email",
  ];
  int selectedMethod = 0;

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
            title:widget.isEdit? "Edit Job Circular":"New Job Circular",
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

                        TextBodyStyleWidget(title: "Job Details", color: AppColors.primary,size: AppSizes.screenTitle,),
                        SizedBox(height: AppSizes.smallGap,),


                        // Title
                        TextBodyStyleWidget(title: "Job Title", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "Job Title", controller: jonTitleController),
                        SizedBox(height: AppSizes.itemGap),


                        // Activities
                        TextBodyStyleWidget(title: "Designation", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "junior software engineer", controller: designationController,),


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
                            TextBodyStyleWidget(title: "Attachment", color: AppColors.primary,size: AppSizes.sectionTitle,),
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


                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        TextBodyStyleWidget(title: "Configuration", color: AppColors.primary,size: AppSizes.screenTitle,),
                        SizedBox(height: AppSizes.smallGap,),


                        // Title
                        TextBodyStyleWidget(title: "Employment Type", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomDropdown(
                          width: 100.w,
                          items: employeeType,
                          initialValue: employeeType[0],),
                        SizedBox(height: AppSizes.itemGap),


                        // Activities
                        TextBodyStyleWidget(title: "Vacancy Count", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "1", controller: designationController,),
                        SizedBox(height: AppSizes.itemGap),


                        TextBodyStyleWidget(title: "Application Deadline", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "mm/dd/yy", controller: applicationDeadlineController,isDatePicker: true,),

                      ],
                    )),

                    SizedBox(height: AppSizes.sectionGap,),

                    CustomCard(child: Column(
                      children: [
                        Row(
                          children: [
                            TextBodyStyleWidget(title: "Application Method", color: AppColors.primary,size: AppSizes.sectionTitle,),

                            SizedBox(width: AppSizes.sectionGap,),
                            Flexible(
                              child: StatusButtonRow(
                                
                                items: applicationMethod,
                                selectedIndex: selectedMethod,
                                onSelected: (index) {
                                  setState(() {
                                    selectedMethod = index;
                                  });
                                },
                                onTap: (status) {


                                  print("Clicked: $status");
                                },
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        if(selectedMethod == 0)
                          CustomTextFieldWidget(hintText: "Link", controller: applicationMethodController,),


                        if(selectedMethod == 1)
                          CustomTextFieldWidget(hintText: "Email", controller: applicationMethodController,),



                      ],
                    )),
                    SizedBox(height: AppSizes.sectionGap,),

                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text: "Cancel", onTap: (){},width: 30.w,backgroundColor: Colors.white,foregroundColor: AppColors.primary,),
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
