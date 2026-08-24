import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card2.dart';
import '../../../widget/universal/custom_status_badge.dart';
import '../../../widget/universal/image_card.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/sizes.dart';
import '../../../widget/universal/info_row_widget.dart';

class ViewTeamScreen extends StatefulWidget {
  const ViewTeamScreen({super.key});

  @override
  State<ViewTeamScreen> createState() => _ViewTeamScreenState();
}

class _ViewTeamScreenState extends State<ViewTeamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Motin Mia",
            subtitle: "CEO at Hello Bangladesh ",
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
                              CustomStatusBadge(title: "VISIBLE",size: AppSizes.cardTitle,),
                              Row(
                                children: [
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.pushNamed(context, RoutesName.add_new_team_member,arguments: {
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
                                InfoRowWidget(icon: Icons.badge_outlined, title: "Designation", value: "CEO"),
                                SizedBox(height: AppSizes.smallGap,),
                                Row(
                                  crossAxisAlignment: .start,
                                  children: [
                                    Icon(Icons.file_copy_outlined,color: AppColors.primary,size: AppSizes.icon,),

                                    SizedBox(width: AppSizes.appbarGap,),
                                    Flexible(
                                      child: TextBodyStyleWidget(title: "Detailed Description: Experienced business leader with a strong background in technology, strategic planning, and organizational growth. Passionate about building innovative products, leading high-performing teams, and creating long-term business value. ",color: AppColors.primary,fontbold: false,maxLines: 25,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSizes.appbarGap,),
                                Row(
                                  crossAxisAlignment: .start,
                                  children: [
                                    Icon(Icons.workspace_premium,color: AppColors.primary,size: AppSizes.icon,),
                                    SizedBox(width: AppSizes.appbarGap,),
                                    Flexible(
                                      child: TextBodyStyleWidget(title: "Experience / Background: 12+ years of professional experience7+ years in leadership and management 5+ years as a senior executive Expertise in business strategy, product development, and team leadershi pSuccessfully led multiple large-scale projects and business initiatives",color: AppColors.primary,fontbold: false,maxLines: 25,
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
