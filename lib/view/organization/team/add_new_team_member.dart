import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../routes/routes_name.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/sizes.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_drop_down.dart';
import '../../../widget/universal/custom_text_field.dart';

class AddNewTeamMember extends StatefulWidget {
  const AddNewTeamMember({super.key,  this.isEdit = false});
  final bool isEdit ;

  @override
  State<AddNewTeamMember> createState() => _AddNewTeamMemberState();
}

class _AddNewTeamMemberState extends State<AddNewTeamMember> {

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController joinDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();


  final List<String> statusList = [
    "Hello Bangladesh",
    "Brain Station 23",
  ];
  String selectedStatus = "Hello Bangladesh";
  bool isVisible = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title:widget.isEdit? "Edit Member Details":"Add New Member",
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
                            TextBodyStyleWidget(title: "Profile Photo", color: AppColors.primary,size: AppSizes.sectionTitle,),
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
                        TextBodyStyleWidget(title: "Full Name ", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "John Doe", controller: fullNameController),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Designation", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "user@gmail.com", controller: emailController,),
                        SizedBox(height: AppSizes.itemGap),



                        // AUTHOR
                        TextBodyStyleWidget(title: "Section", color: AppColors.primary,size: AppSizes.sectionTitle,),
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
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        // Title
                        TextBodyStyleWidget(title: "Detailed Description", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "Description details", controller: fullNameController,minLines: 2,maxLines: 5,),
                        SizedBox(height: AppSizes.itemGap),



                        TextBodyStyleWidget(title: "Experience / Background", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(minLines: 2,maxLines: 5,hintText: "write about experience", controller: phoneController,),
                        SizedBox(height: AppSizes.itemGap),

                        Row(
                          mainAxisAlignment: .start,
                          children: [
                            Checkbox(activeColor: AppColors.primary,value: isVisible, onChanged: (value){
                              setState(() {
                                isVisible = value ?? false;
                              });
                            }),
                            SizedBox(width: AppSizes.smallGap,),
                            Flexible(child: TextBodyStyleWidget(title: "Make this member visible to the public ",color: AppColors.primary,size: AppSizes.cardTitle,))
                          ],
                        )

                      ],
                    )),
                    SizedBox(height: AppSizes.sectionGap,),



                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text: "Cancel", onTap: (){},width: 30.w,backgroundColor: Colors.white,foregroundColor: AppColors.primary,),
                        SizedBox(width: AppSizes.appbarGap,),
                        Flexible(child: CustomButton(text:widget.isEdit? "Update Member":"Create Member", onTap: (){},)),
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
