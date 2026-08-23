import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/utils/icon_list.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/universal/status_button_row.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/sizes.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_text_field.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({super.key,  this.isEdit=false});

  final bool isEdit;

  @override
  State<AddNewCard> createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController iconsController = TextEditingController();


  final List<String> displayMode = [
    "Icon",
    "Image"
  ];
  int selectedStatus =0;

  IconData selectedIcon = IconList.iconList[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: widget.isEdit?"Edit Card" :"Create New Card",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(top:AppSizes.screenPadding,left: AppSizes.screenPadding,right: AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: .start,
                  children: [

                    CustomCard(child:Column(
                      crossAxisAlignment: .start,
                      children: [
                        // Title
                        TextBodyStyleWidget(title: "Title", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "Card Title", controller: titleController),
                        SizedBox(height: AppSizes.itemGap),


                        // URL SLUG
                        TextBodyStyleWidget(title: "Description", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "Write a short description", controller: descriptionController,),
                        SizedBox(height: AppSizes.itemGap),


                        // AUTHOR
                        TextBodyStyleWidget(title: "Display Mode", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        StatusButtonRow(
                          items: displayMode,
                          selectedIndex: selectedStatus,
                          onSelected: (index){
                            setState(() {
                              selectedStatus = index;
                              if (index == 1) {
                                Navigator.pushNamed(
                                  context,
                                  RoutesName.media_manage_details,
                                );
                              }
                            });
                        },),
                        if(selectedStatus == 0)...[
                          SizedBox(height: AppSizes.itemGap,),
                          TextBodyStyleWidget(title: "Select Icon", color: AppColors.primary,size: AppSizes.sectionTitle,),
                          SizedBox(height: AppSizes.appbarGap),
                          GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 8,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1,
                            ),
                            itemCount: IconList.iconList.length,
                            itemBuilder: (context, index) {
                              final icon = IconList.iconList[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIcon = icon;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: selectedIcon == icon
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                                  ),
                                  child: Icon(
                                    icon,
                                    color: selectedIcon == icon
                                        ? Colors.white
                                        : Colors.blueGrey,
                                    size: AppSizes.icon,
                                  ),
                                ),
                              );
                            },
                          )

                        ],



                      ],
                    )),
                    SizedBox(height: AppSizes.sectionGap,),
                    // Save Button
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text:"Cancel", onTap: (){},width: 30.w,backgroundColor: Colors.white,foregroundColor: AppColors.primary,),
                        SizedBox(width: AppSizes.appbarGap,),
                        Flexible(child: CustomButton(text:widget.isEdit?"Edit Card":"Save Changes", onTap: (){},)),
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
