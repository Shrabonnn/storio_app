import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_text_field.dart';

class EditTestimonial extends StatefulWidget {
  const EditTestimonial({super.key});

  @override
  State<EditTestimonial> createState() => _EditTestimonialState();
}

class _EditTestimonialState extends State<EditTestimonial> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController messageController = TextEditingController();


  List<String> rating = ["5 Star","4 Star","3 Star","2 Star","1 Star"];
  List<String> statusItem = ["Draft","Published" ];



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Edit Testimonial",
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

                        // Images
                        Center(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, RoutesName.media_manage_details);
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 1,
                                ),
                              ),
                              child: const CircleAvatar(
                                backgroundImage: AssetImage(
                                  "assets/images/person.png",
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Name*", color: AppColors.primary,size: AppSizes.cardTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "", controller: nameController),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Designation / Company *", color: AppColors.primary,size: AppSizes.cardTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "", controller: designationController),
                        SizedBox(height: AppSizes.itemGap),

                        Row(
                          children: [
                            Flexible(
                              child: Column(
                                children: [
                                  TextBodyStyleWidget(title: "Status", color: AppColors.primary,size: AppSizes.cardTitle,),
                                  SizedBox(height: AppSizes.appbarGap),
                                  CustomDropdown(
                                    items: statusItem,
                                    initialValue: statusItem[0],
                                    width: 100.w,
                                    height: 4.5.h,
                                    onChanged: (value) {
                                      print("Selected: $value");
                                    },
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(width: AppSizes.appbarGap,),



                            Flexible(
                              child: Column(
                                children: [
                                  TextBodyStyleWidget(title: "Rating", color: AppColors.primary,size: AppSizes.cardTitle,),
                                  SizedBox(height: AppSizes.appbarGap),
                                  CustomDropdown(
                                    items: rating,
                                    initialValue: rating[0],
                                    width: 100.w,
                                    height: 4.5.h,
                                    onChanged: (value) {
                                      print("Selected: $value");
                                    },
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),


                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Testimonial Message *", color: AppColors.primary,size: AppSizes.cardTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "", minLines: 5,maxLines: 5,controller: messageController),
                        SizedBox(height: AppSizes.itemGap),











                      ],
                    )),
                    SizedBox(height: AppSizes.sectionGap),

                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text: "Cancel", onTap: (){},width: 30.w,backgroundColor: Colors.white,foregroundColor: AppColors.primary,),
                        SizedBox(width: AppSizes.appbarGap,),
                        Flexible(child: CustomButton(text: "Edit Testimonial", onTap: (){},)),
                      ],
                    ),
                  ],
                )
              ]),
            ),
          ),



          SliverPadding(padding: EdgeInsets.only(bottom:AppSizes.sectionGap))
        ],
      ),
    );
  }
}
