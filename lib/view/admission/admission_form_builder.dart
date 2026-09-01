import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/universal/custom_drop_down.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/custom_text_field.dart';
import '../../widget/universal/search_text_field.dart';

class AdmissionFormBuilder extends StatefulWidget {
  const AdmissionFormBuilder({super.key});

  @override
  State<AdmissionFormBuilder> createState() => _AdmissionFormBuilderState();
}

class _AdmissionFormBuilderState extends State<AdmissionFormBuilder> {

  final TextEditingController labelController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController logicTargetController = TextEditingController();
  final TextEditingController logicIdController = TextEditingController();



  final List<String> formType = [
    "Single Line Text",
    "Email Address",
    'Phone Number',
    "Number",
    "Dropdown Select",
    "Radio Selection",
    "Checkbox",
    "Multi-line Text",
    "File Upload",
    "Image Upload",
    "Phone Number"
  ];

  String selectedForm = "Single Line Text";

  final List<String> logicType = [
    "Equals",
    "Doesnot Equal",
  ];

  String selectedLogic = "Equals";

  int formField = 0;

  bool isReuired = false;
  String logic = "Disable";

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    labelController.dispose();
    idController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Admission Form Builder",
            showBackButton: true,
          ),

          SliverPadding(
              padding: EdgeInsetsGeometry.only(top:AppSizes.screenPadding,left: AppSizes.screenPadding,right: AppSizes.screenPadding),
              sliver: SliverList(delegate: SliverChildListDelegate([
                Column(
                  children: [
                    CustomCard(child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        TextBodyStyleWidget(title: "Form Fields (${formField})", color: color.primary,size: AppSizes.sectionTitle,),
                        CustomButton(width: 30.w,text: "Add New Field", onTap: (){
                          setState(() {
                            formField ++;
                          });
                        })
                      ],
                    ),

                    ),
                    SizedBox(height: AppSizes.itemGap),

                  ],
                )
              ]))
          ),
          SliverPadding(
              padding: EdgeInsetsGeometry.only(left: AppSizes.screenPadding,right: AppSizes.screenPadding),
              sliver: SliverList.builder(
                  itemCount:formField,
                  itemBuilder: (context,index){
                    return Container(
                      margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                      child: CustomCard(child: Column(
                        crossAxisAlignment: .start,
                        children: [

                          TextBodyStyleWidget(title: "Field Label", color: color.primary,size: AppSizes.sectionTitle,),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(hintText: "", controller: labelController),
                          SizedBox(height: AppSizes.itemGap),


                          // URL SLUG
                          TextBodyStyleWidget(title: "Field ID (Internal Name)", color: color.primary,size: AppSizes.sectionTitle,),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(hintText: "", controller: idController,),
                          SizedBox(height: AppSizes.itemGap),

                          TextBodyStyleWidget(title: "Type", color: color.primary,size: AppSizes.sectionTitle,),
                          SizedBox(width: AppSizes.smallGap),
                          CustomDropdown(height: 5.h,width: 100.w,items: formType,initialValue: selectedForm,),


                          Row(
                            mainAxisAlignment: .end,
                            children: [
                              TextBodyStyleWidget(title: "Required",color: color.primary,),
                              Checkbox(
                                  value: isReuired,
                                  activeColor: color.primary,
                                  onChanged: (value){
                                    setState(() {
                                      isReuired = value ?? false;
                                    });
                                  }),

                            ],
                          ),
                          Divider(),
                          SizedBox(height: AppSizes.smallGap,),
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              TextBodyStyleWidget(title: "Required",color: color.primary,),
                              GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      logic = logic == "Disable"?"Enable":"Disable";
                                    });
                                  },
                                  child: TextBodyStyleWidget(title: logic,color: color.primary,)),



                            ],
                          ),
                          if(logic == "Enable")...[
                            SizedBox(
                              height: AppSizes.smallGap,
                            ),
                            CustomCard2(child: Padding(
                              padding:  EdgeInsets.all(AppSizes.contentPadding),
                              child: Column(
                                children: [
                                  CustomTextFieldWidget(hintText: "Select or type field ID...", controller: logicIdController),
                                  SizedBox(height: AppSizes.itemGap),
                                  CustomDropdown(height: 5.h,width: 100.w,items: logicType,initialValue: selectedLogic,),
                                  SizedBox(height: AppSizes.itemGap),
                                  CustomTextFieldWidget(hintText: "Target Value", controller: logicTargetController),
                                  SizedBox(height: AppSizes.itemGap),
                                ],
                              ),
                            ))
                          ],
                          SizedBox(height: AppSizes.smallGap,)




                        ],
                      )),
                    );
                  })
          ),
          SliverPadding(
              padding: EdgeInsetsGeometry.only(left: AppSizes.screenPadding,right: AppSizes.screenPadding),
              sliver: SliverList(delegate: SliverChildListDelegate([
                Column(
                  children: [





                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text: "Cancel", onTap: (){},width: 30.w,backgroundColor: color.cardBackground,foregroundColor: color.primary,),
                        SizedBox(width: AppSizes.appbarGap,),
                        Flexible(child: CustomButton(text:"Save Post", onTap: (){},)),
                      ],
                    ),
                    SizedBox(height: AppSizes.sectionGap),

                  ],
                )
              ]))
          ),

        ],
      ),
    );
  }
}
