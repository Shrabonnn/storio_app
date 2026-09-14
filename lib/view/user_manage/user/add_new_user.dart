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

class AddNewUser extends StatefulWidget {
  const AddNewUser({super.key,  this.isEdit= false});

  final bool isEdit;

  @override
  State<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {

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
    "Inactive",
  ];
  String selectedStatus = "Active";

  final List<String> roleList = [
    "Dev",
    "SQA",
    "DevOps"
  ];
  String selectedRole = "Dev";



  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title:widget.isEdit? "Edit User":"Add New User",
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
                        TextBodyStyleWidget(title: "Full Name ", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "John ", controller: fullNameController),
                        SizedBox(height: AppSizes.itemGap),

                        // last name
                        TextBodyStyleWidget(title: "Last Name ", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "Doe", controller: fullNameController),
                        SizedBox(height: AppSizes.itemGap),


                        TextBodyStyleWidget(title: "Username ", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "Username", controller: emailController,),
                        SizedBox(height: AppSizes.itemGap),

                        // Title
                        TextBodyStyleWidget(title: "Email", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "user@gmail.com", controller: fullNameController),
                        SizedBox(height: AppSizes.itemGap),

                        // last name
                        TextBodyStyleWidget(title: "Phone Number", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "01XXXXXXXXX", controller: fullNameController),
                        SizedBox(height: AppSizes.itemGap),


                        TextBodyStyleWidget(title: "Address", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "Dhanmondi 32", controller: emailController,),
                        SizedBox(height: AppSizes.itemGap),

                        // Title
                        TextBodyStyleWidget(title: "Password  ", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "Secure password ", controller: fullNameController),
                        SizedBox(height: AppSizes.itemGap),

                        // last name
                        TextBodyStyleWidget(title: "Confirm Password ", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "ecure password ", controller: fullNameController),
                        SizedBox(height: AppSizes.itemGap),





                        // AUTHOR
                        TextBodyStyleWidget(title: "Role", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomDropdown(
                          items: roleList,
                          initialValue: selectedRole,
                          width: 100.w,

                          onChanged: (value) {
                            print("Selected: $value");
                            setState(() {
                              selectedStatus = value.toString();
                            });


                          },
                        ),
                        SizedBox(height: AppSizes.itemGap,),

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

                      ],


                    )),

                    SizedBox(height: AppSizes.sectionGap,),



                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text: "Cancel", onTap: (){},width: 30.w,backgroundColor: color.cardBackground,foregroundColor: color.primary,),
                        SizedBox(width: AppSizes.smallGap,),
                        Flexible(child: CustomButton(text:widget.isEdit? "Update User":"Create User", onTap: (){},)),
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
