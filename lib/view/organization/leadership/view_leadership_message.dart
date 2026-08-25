import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/info_row_widget.dart';

import '../../../routes/routes_name.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/sizes.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/textStyle/text_title_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card2.dart';
import '../../../widget/universal/custom_status_badge.dart';
import '../../../widget/universal/image_card.dart';
import '../../../widget/universal/info_item_card.dart';

class ViewLeadershipMessage extends StatefulWidget {
  const ViewLeadershipMessage({super.key});

  @override
  State<ViewLeadershipMessage> createState() => _ViewLeadershipMessageState();
}

class _ViewLeadershipMessageState extends State<ViewLeadershipMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "MR. Motiur Rahman",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(
              top: AppSizes.screenPadding,
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    ImageCard(
                      image: Image.asset(
                        "assets/images/person.png",
                        width: double.infinity,
                        height: 16.h,
                        fit: BoxFit.fitHeight,
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(mainAxisAlignment: .spaceBetween,
                            children: [
                              CustomStatusBadge(title: "Published / Draft",size: AppSizes.cardTitle,),
                              Row(
                                children: [
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.pushNamed(context, RoutesName.new_section_leadership_message,arguments: {
                                          'isEdit' : true,
                                        });
                                      },child: Icon(Icons.edit,size: AppSizes.iconLarge,color: AppColors.primary,)),
                                  SizedBox(width: AppSizes.itemGap,),
                                  Icon(Icons.delete_outline_outlined,size: AppSizes.iconLarge,color: Colors.red,)
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: AppSizes.smallGap),
                          CustomCard2(child: Padding(
                            padding:  EdgeInsets.all(AppSizes.contentPadding),
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                InfoRowWidget(icon: Icons.badge, title: "Role", value: "CEO "),
                                SizedBox(height: AppSizes.smallGap,),
                                InfoRowWidget(icon: Icons.apartment_outlined, title: "Company", value: "ACS Famous"),
                                SizedBox(height: AppSizes.smallGap,),

                                Row(
                                  crossAxisAlignment: .start,
                                  children: [
                                    Icon(Icons.file_copy_outlined,color: AppColors.primary,size: AppSizes.icon,),

                                    SizedBox(width: AppSizes.appbarGap,),
                                    Flexible(
                                      child: TextBodyStyleWidget(title: "Message: Team, let’s stay focused and keep supporting each other.Every challenge is an opportunity to improve and grow.Take ownership of your work and communicate openly. Let’s work together, stay consistent, and achieve our goals.I believe in this team—let’s make it happen!",color: AppColors.primary,fontbold: false,maxLines: 35,
                                      ),
                                    ),
                                  ],
                                ),


                              ],
                            ),
                          )),


                        ],
                      ),
                    ),
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
