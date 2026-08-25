import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card2.dart';
import '../../../widget/universal/custom_status_badge.dart';
import '../../../widget/universal/image_card.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/sizes.dart';
import '../../../widget/universal/info_row_widget.dart';
class ViewUserDetails extends StatefulWidget {
  const ViewUserDetails({super.key});

  @override
  State<ViewUserDetails> createState() => _ViewUserDetailsState();
}

class _ViewUserDetailsState extends State<ViewUserDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "John Chena",
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
                    CustomCard(

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomStatusBadge(title: "DEV",size: AppSizes.cardTitle,backgroundColor: Colors.green.shade100,),
                              SizedBox(width: AppSizes.itemGap,),

                              CustomStatusBadge(title: "VISIBLE",size: AppSizes.cardTitle,),
                              Spacer(),
                              Row(
                                children: [
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.pushNamed(context, RoutesName.add_new_team_member,arguments: {
                                          'isEdit' : true,
                                        });
                                      },child: Icon(Icons.edit,size: AppSizes.iconLarge,color: AppColors.primary,)),

                                ],
                              )
                            ],
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          CustomCard2(child: Padding(
                            padding:  EdgeInsets.all(AppSizes.contentPadding),
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                InfoRowWidget(icon: Icons.badge_outlined, title: "Designation", value: "CEO"),
                                SizedBox(height: AppSizes.smallGap,),
                                InfoRowWidget(icon: Icons.phone, title: "Phone Number", value: "01789734725"),
                                SizedBox(height: AppSizes.smallGap,),

                                InfoRowWidget(icon: Icons.location_on_outlined, title: "Address", value: "N/A"),
                                SizedBox(height: AppSizes.smallGap,),

                                InfoRowWidget(icon: Icons.calendar_month_outlined, title: "Joined", value: "Aug 24, 2026"),



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
