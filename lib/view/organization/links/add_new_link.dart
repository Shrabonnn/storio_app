import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/custom_card.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/sizes.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_text_field.dart';

class AddNewLink extends StatefulWidget {

  const AddNewLink({super.key,  this.isEdit=false});
  final bool isEdit ;

  @override
  State<AddNewLink> createState() => _AddNewLinkState();
}

class _AddNewLinkState extends State<AddNewLink> {

  final TextEditingController linkTitleController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController displayOrderController = TextEditingController();



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    linkTitleController.dispose();
    urlController.dispose();
    displayOrderController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: widget.isEdit?"Edit Link":"Add New Link",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(top:AppSizes.screenPadding,left: AppSizes.screenPadding,right: AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        TextBodyStyleWidget(title: "Link Title", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "e.g. Original Website", controller: linkTitleController),
                        SizedBox(height: AppSizes.itemGap),


                        // URL SLUG
                        TextBodyStyleWidget(title: "URL", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "https://example.com", controller: urlController,),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Display Order", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "1", controller: displayOrderController,),

                      ],

                    )),
                    SizedBox(height: AppSizes.sectionGap,),
                    // Save Button
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text:"Cancel", onTap: (){},width: 30.w,backgroundColor: Colors.white,foregroundColor: AppColors.primary,),
                        SizedBox(width: AppSizes.appbarGap,),
                        Flexible(child: CustomButton(text:widget.isEdit?"Update":"Save ", onTap: (){},)),
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
