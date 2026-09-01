import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_text_field.dart';
import '../../widget/universal/search_text_field.dart';

class AddPromotion extends StatefulWidget {
  const AddPromotion({super.key,  this.isEdit=false});

  final bool isEdit;

  @override
  State<AddPromotion> createState() => _AddPromotionState();
}

class _AddPromotionState extends State<AddPromotion> {

  final TextEditingController titleConroller = TextEditingController();
  final TextEditingController subTitleConroller = TextEditingController();
  final TextEditingController badgeTextConroller = TextEditingController();
  final TextEditingController descriptionConroller = TextEditingController();
  final TextEditingController ctaButtonLabelConroller = TextEditingController();
  final TextEditingController ctaUrlConroller = TextEditingController();
  final TextEditingController priorityConroller = TextEditingController();

  final TextEditingController startDateConroller = TextEditingController();
  final TextEditingController endDateConroller = TextEditingController();


  final List<String> statusList = [
    "Draft",
    "Published",
    "Archived",
  ];

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: widget.isEdit ?"Edit Promotion":"Create New Promotion",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          // Title
                          TextBodyStyleWidget(title: "TItle*", color: color.primary,size: AppSizes.cardTitle,),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(hintText: "e.g. Admission Open 2026", controller: titleConroller),
                          SizedBox(height: AppSizes.itemGap),


                          // Subtitle
                          TextBodyStyleWidget(title: "Subtitle", color: color.primary,size: AppSizes.cardTitle,),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(hintText: "Short supporting line", controller: subTitleConroller,),
                          SizedBox(height: AppSizes.itemGap),

                          // Subtitle
                          TextBodyStyleWidget(title: "Badge Text", color: color.primary,size: AppSizes.cardTitle,),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(hintText: "50% off", controller: subTitleConroller,),
                          SizedBox(height: AppSizes.itemGap),


                          Column(
                            crossAxisAlignment: .center,
                            children: [
                              Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  TextBodyStyleWidget(title: "Gallery Images", color: color.primary,size: AppSizes.cardTitle,),
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


                          ),

                          SizedBox(height: AppSizes.itemGap),

                          // Description
                          TextBodyStyleWidget(title: "Description", color: color.primary,size: AppSizes.cardTitle,),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(hintText: "Full promotion details ...", controller: descriptionConroller,minLines: 3,maxLines: 4,),
                          SizedBox(height: AppSizes.itemGap),

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
                          SizedBox(height: AppSizes.itemGap),


                          // Activities
                          TextBodyStyleWidget(title: "CTA Button Label", color: color.primary,size: AppSizes.cardTitle,),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(hintText: "e.g. Apply Now", controller: ctaButtonLabelConroller,),
                          SizedBox(height: AppSizes.itemGap),


                          TextBodyStyleWidget(title: "CTA URL", color: color.primary,size: AppSizes.cardTitle,),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(hintText: "/admissions or https:// ...", controller: ctaUrlConroller,),
                          SizedBox(height: AppSizes.itemGap),


                          Row(

                            children: [
                              Flexible(
                                child: Column(
                                  children: [
                                    TextBodyStyleWidget(title: "Start Date", color: color.primary,size: AppSizes.cardTitle,),
                                    SizedBox(height: AppSizes.appbarGap),
                                    CustomTextFieldWidget(hintText: "mm/dd/yy", controller: startDateConroller,isDatePicker: true,),
                                    SizedBox(height: AppSizes.itemGap),
                                  ],
                                ),
                              ),
                              SizedBox(width: AppSizes.smallGap,),
                              Flexible(
                                child: Column(
                                  children: [
                                    TextBodyStyleWidget(title: "End Date", color: color.primary,size: AppSizes.cardTitle,),
                                    SizedBox(height: AppSizes.appbarGap),
                                    CustomTextFieldWidget(hintText: "mm/dd/yy", controller: endDateConroller,isDatePicker: true,),
                                    SizedBox(height: AppSizes.itemGap),
                                  ],
                                ),
                              )
                            ],
                          ),

                          TextBodyStyleWidget(title: "Priority (higher = first)", color: color.primary,size: AppSizes.cardTitle,),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(hintText: "0", controller: priorityConroller,),
                          SizedBox(height: AppSizes.itemGap),




                        ],
                      ),

                    ),
                    SizedBox(height: AppSizes.sectionGap,),

                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text: "Cancel", onTap: (){},width: 30.w,backgroundColor: color.cardBackground,foregroundColor: color.primary,),
                        SizedBox(width: AppSizes.appbarGap,),
                        Flexible(child: CustomButton(text: "Create Promotion", onTap: (){},)),
                      ],
                    ),
                    SizedBox(height: AppSizes.sectionGap),



                  ],
                ),
              ]),
            ),
          ),


        ],
      ),
    );
  }
}
