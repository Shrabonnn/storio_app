

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/routes/routes_name.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/sizes.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/textStyle/text_title_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_card2.dart';
import '../../../widget/universal/custom_text_field.dart';

class ManageTeamSection extends StatefulWidget {
  const ManageTeamSection({super.key,  this.isEdit =false});
  final bool isEdit ;

  @override
  State<ManageTeamSection> createState() => _ManageTeamSectionState();
}

class _ManageTeamSectionState extends State<ManageTeamSection> {

  final TextEditingController departmentNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();


   bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title:"Manage Team Sections", showBackButton: true),
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
                          Row(mainAxisAlignment: .spaceBetween,
                            children: [
                              TextBodyStyleWidget(
                                title: widget.isEdit?"Edit Section: {Name section} " : "Create New Section",
                                color: AppColors.primary,
                                size: AppSizes.sectionTitle,
                              ),
                              Row(
                                children: [
                                  Checkbox(value: isVisible, activeColor: AppColors.primary,onChanged: (value){
                                    isVisible = value ?? false;
                                  }),
                                  TextBodyStyleWidget(title: "Is Visible",color: AppColors.primary,)
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: AppSizes.sectionGap),

                          // Title
                          TextBodyStyleWidget(
                            title: "Section  Name ",
                            color: AppColors.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "New Section ",
                            controller: departmentNameController,
                          ),
                          SizedBox(height: AppSizes.itemGap),


                          // Description
                          TextBodyStyleWidget(
                            title: "Description",
                            color: AppColors.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "Brief description of the section",
                            controller: descriptionController,
                            minLines: 4,
                            maxLines: 6,
                          ),



                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap),

                    Row(
                      children: [
                        if(widget.isEdit)...[
                          CustomButton(text: "cancel",width: 30.w ,onTap: () {
                            Navigator.pop(context);
                          },backgroundColor: Colors.white,foregroundColor: AppColors.primary,),

                          SizedBox(width: AppSizes.appbarGap,),
                        ],
                        Flexible(child: CustomButton(text:widget.isEdit?"Update Section" :"Create Section", onTap: () {})),
                      ],
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    CustomCard(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          TextBodyStyleWidget(
                            title: "Existing Sections ( 1 )",
                            color: AppColors.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context,index){
                                return CustomCard2(
                                  child: Padding(
                                    padding: EdgeInsets.all(AppSizes.smallPadding),
                                    child: Row(
                                      mainAxisAlignment: .spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: .start,
                                            children: [
                                              TextTitleWidget(
                                                title: "Hello Bangladesh ",
                                                color: AppColors.primary,
                                                maxLines: 1,
                                              ),
                                              SizedBox(height: AppSizes.appbarGap),
                                              TextBodyStyleWidget(
                                                title: "aaaaaaaaaaaaaaaaaaa",
                                                maxLines: 1,
                                                size: AppSizes.cardTitle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            if(!widget.isEdit)...[
                                              GestureDetector(
                                                  onTap: (){
                                                    Navigator.pushNamed(context, RoutesName.manage_team_section,arguments: {
                                                      'isEdit' : true,
                                                    });
                                                  }
                                                  ,child: Icon(Icons.edit,size: AppSizes.iconLarge, color: AppColors.primary)),
                                            ],
                                            SizedBox(width: AppSizes.itemGap,),
                                            Icon(Icons.delete_outline_outlined,size: AppSizes.iconLarge, color: Colors.red),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }, separatorBuilder:(context, index) {
                            return Divider();} , itemCount: 1)
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.appbarGap),
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
