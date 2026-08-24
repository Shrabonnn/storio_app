import 'package:flutter/material.dart';

import '../../../routes/routes_name.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/sizes.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/textStyle/text_title_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_card2.dart';
import '../../../widget/universal/custom_status_badge.dart';

class RoleManagementScreen extends StatefulWidget {
  const RoleManagementScreen({super.key});

  @override
  State<RoleManagementScreen> createState() => _RoleManagementScreenState();
}

class _RoleManagementScreenState extends State<RoleManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Role & Permission Management",
            showBackButton: true,
          ),
          SliverPadding(
              padding: EdgeInsetsGeometry.only(top: AppSizes.screenPadding,left: AppSizes.screenPadding,right: AppSizes.screenPadding),
              sliver: SliverList.builder(
                  itemCount:2,
                  itemBuilder: (context,index){
                    return Container(
                      margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                      child: CustomCard2(
                        child: Padding(
                          padding:  EdgeInsets.all(AppSizes.cardPadding),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [


                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.security_outlined,size: AppSizes.icon,color: AppColors.primary,),
                                        SizedBox(width: AppSizes.smallGap,),
                                        TextTitleWidget(
                                          title: "John Chena",
                                          size: AppSizes.sectionTitle,
                                          color: AppColors.primary,
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: (){},
                                              child:Icon(Icons.edit,size: AppSizes.icon,color: AppColors.primary,)
                                            ),
                                            SizedBox(width: AppSizes.itemGap,),
                                            GestureDetector(
                                                onTap: (){},
                                                child:Icon(Icons.delete_outline_outlined,size: AppSizes.icon,color:Colors.red,)
                                            ),
                                          ],
                                        )


                                      ],
                                    ),
                                  ),
                                ],
                              ),


                              SizedBox(height: AppSizes.itemGap),

                              Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  Flexible(
                                    child: TextTitleWidget(title: "Permissions: ",color: AppColors.primary,maxLines: 2,
                                    ),
                                  ),
                                  TextTitleWidget(title: "14/160",color: AppColors.primary,)
                                ],
                              ),
                              SizedBox(height: AppSizes.appbarGap,),
                              Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  Flexible(
                                    child: TextTitleWidget(title: "Users assigned: ",color: AppColors.primary,maxLines: 2,
                                    ),
                                  ),
                                  TextTitleWidget(title: "1",color: AppColors.primary,)
                                ],
                              ),



                            ],
                          ),
                        ),
                      ),
                    );
                  })
          )

        ],
      ),
    );
  }
}
