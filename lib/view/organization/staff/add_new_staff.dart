import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../routes/routes_name.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_drop_down.dart';
import '../../../widget/universal/custom_text_field.dart';

class AddNewStaff extends StatefulWidget {
  const AddNewStaff({super.key,  this.isEdit =false});
  final bool isEdit ;

  @override
  State<AddNewStaff> createState() => _AddNewStaffState();
}

class _AddNewStaffState extends State<AddNewStaff> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController joinDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();


  final List<String> statusList = [
    "Active",
    "In Active",
    "On Leave",
    "Retired",
  ];
  String selectedStatus = "Active";

  final List<String> departmentList = [
    "Marketing",
    "New Create",
  ];
  String departmentStatus = "Marketing";
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    departmentController.dispose();
    qualificationController.dispose();
    joinDateController.dispose();
    positionController.dispose();

  }


  @override
  Widget build(BuildContext context) {

    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title:widget.isEdit? "Edit Staff Details":"Create New Staff",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    // Images
                    CustomCard(child:  Column(
                      crossAxisAlignment: .center,
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            TextBodyStyleWidget(title: "Profile Photo", color: color.primary,size: AppSizes.sectionTitle,),
                            SizedBox(width: AppSizes.appbarGap),
                            CustomButton(
                              width: 30.w,
                              text: widget.isEdit ? "Change Image":"Select Image",
                              onTap: (){
                                Navigator.pushNamed(context, RoutesName.media_manage_details);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.smallGap),

                        widget.isEdit  ? Container(
                          width: 100.w,
                          height: 16.h,
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
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [



                        // Title
                        TextBodyStyleWidget(title: "Full Name ", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "John Doe", controller: fullNameController),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Email", color: color.primary,size: AppSizes.cardTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "user@gmail.com", controller: emailController,),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Phone", color: color.primary,size: AppSizes.cardTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "01XXXXXXXXX", controller: phoneController,),
                        SizedBox(height: AppSizes.itemGap),


                        TextBodyStyleWidget(title: "Positon", color: color.primary,size: AppSizes.cardTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "role", controller: phoneController,),
                        SizedBox(height: AppSizes.itemGap),





                        // AUTHOR
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
                        SizedBox(height: AppSizes.itemGap),



                        TextBodyStyleWidget(title: "Department", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomDropdown(
                          items: departmentList,
                          initialValue: departmentStatus,
                          width: 100.w,

                          onChanged: (value) {
                            print("Selected: $value");
                            setState(() {
                              selectedStatus = value.toString();
                            });


                          },
                        ),

                      ],


                    )),
                    SizedBox(height: AppSizes.sectionGap,),
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        // Title
                        TextBodyStyleWidget(title: "Qualification", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "MSC in Marketing", controller: fullNameController),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Join Date", color: color.primary,size: AppSizes.cardTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "08/08/2026", controller: emailController,isDatePicker: true,),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Bio / Description", color: color.primary,size: AppSizes.cardTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(minLines: 4,maxLines: 5,hintText: "write a short description", controller: phoneController,),
                        SizedBox(height: AppSizes.itemGap),

                      ],
                    )),
                    SizedBox(height: AppSizes.sectionGap,),



                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text: "Cancel", onTap: (){},width: 30.w,backgroundColor: color.cardBackground,foregroundColor: color.primary,),
                        SizedBox(width: AppSizes.appbarGap,),
                        Flexible(child: CustomButton(text:widget.isEdit? "Update Post":"Save Post", onTap: (){},)),
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
