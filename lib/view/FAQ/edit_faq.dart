import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/custom_card.dart';

import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_text_field.dart';

class EditFaq extends StatefulWidget {
  const EditFaq({super.key});

  @override
  State<EditFaq> createState() => _EditFaqState();
}

class _EditFaqState extends State<EditFaq> {

  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    questionController.dispose();
    answerController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Edit FAQ",showBackButton: true,
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


                        TextBodyStyleWidget(title: "Question", color: color.primary,size: AppSizes.cardTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "", controller: questionController,maxLines: 2,),
                        SizedBox(height: AppSizes.itemGap),


                        TextBodyStyleWidget(title: "Answer", color: color.primary,size: AppSizes.cardTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "", controller: answerController,minLines: 6,maxLines: 6,),


                      ],
                    )),

                    SizedBox(height: AppSizes.itemGap),
                    // Edit + Delete buttons
                    Row(
                      children: [

                        CustomButton(text: "Cancel", onTap: (){

                        },height: 4.5.h,width: 30.w,backgroundColor: color.cardBackground,foregroundColor: color.primary,),
                        SizedBox(width: AppSizes.appbarGap,),
                        Flexible(child: CustomButton(text: "Update FAQ", onTap: (){},height: 4.5.h)),


                      ],
                    ),

                  ],
                )
              ]),
            ),
          ),




          SliverPadding(padding: EdgeInsets.only(bottom:AppSizes.sectionGap))
        ],
      )

    );
  }
}
