import 'package:flutter/material.dart';
import 'package:storio_app/widget/custom_button/view_button.dart';

import '../../../routes/routes_name.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/sizes.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/textStyle/text_title_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_status_badge.dart';

class LeadershipMessagesScreen extends StatefulWidget {
  const LeadershipMessagesScreen({super.key});

  @override
  State<LeadershipMessagesScreen> createState() => _LeadershipMessagesScreenState();
}

class _LeadershipMessagesScreenState extends State<LeadershipMessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Staff Management",
            showBackButton: true,
          ),

          SliverPadding(
              padding: EdgeInsetsGeometry.only(top: AppSizes.screenPadding,left: AppSizes.screenPadding,right: AppSizes.screenPadding),
              sliver: SliverList.builder(
                  itemCount:2,
                  itemBuilder: (context,index){
                    return Container(
                      margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                      child: CustomCard(

                        child: Column(
                          crossAxisAlignment: .start,
                          children: [

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.cartBackgroundLight,
                                      width: 1,
                                    ),
                                  ),
                                  child: const CircleAvatar(
                                    backgroundImage: AssetImage(
                                      "assets/images/person.png",
                                    ),
                                  ),
                                ),

                                SizedBox(width: AppSizes.smallGap),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextTitleWidget(
                                        title: "MR. Motiur Rahman",
                                        size: AppSizes.sectionTitle,
                                        color: AppColors.primary,
                                      ),

                                      SizedBox(height: AppSizes.appbarGap),

                                      TextBodyStyleWidget(
                                        title: "Role Sr. Advisor Marketing",
                                        size: AppSizes.cardTitle,
                                        color: AppColors.primary,
                                      ),

                                      SizedBox(height: AppSizes.appbarGap),

                                      CustomStatusBadge(
                                        title: "Published / Draft",

                                      ),
                                    ],
                                  ),
                                ),

                                // view
                                ViewButton(onTap: (){
                                  Navigator.pushNamed(context, RoutesName.view_leadership_message);
                                })
                              ],
                            ),


                            SizedBox(height: AppSizes.itemGap),

                            TextBodyStyleWidget(title: "Message : ",color: AppColors.primary,maxLines: 1,),

                            SizedBox(height: AppSizes.appbarGap),

                            TextBodyStyleWidget(title: "Team, let’s stay focused and keep supporting each other.Every challenge is an opportunity to improve and grow.Take ownership of your work and communicate openly. Let’s work together, stay consistent, and achieve our goals.I believe in this team—let’s make it happen!",color: AppColors.primary,fontbold: false,maxLines: 2,),


                          ],
                        ),
                      ),
                    );
                  })
          )

        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          FloatingActionButton(


            heroTag: "add",
            backgroundColor: AppColors.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.new_section_leadership_message);

            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
