import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/info_row_widget.dart';

import '../../../routes/routes_name.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/textStyle/text_title_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card2.dart';
import '../../../widget/universal/custom_status_badge.dart';
import '../../../widget/universal/image_card.dart';
import '../../../widget/universal/info_item_card.dart';

class ViewStaffScreen extends StatefulWidget {
  const ViewStaffScreen({super.key});

  @override
  State<ViewStaffScreen> createState() => _ViewStaffScreenState();
}

class _ViewStaffScreenState extends State<ViewStaffScreen> {
  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Emma Stone",
            subtitle: "Sr. Advisor Marketing",
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
                        height: 14.h,
                        fit: BoxFit.fitHeight,
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(mainAxisAlignment: .spaceBetween,
                            children: [
                              CustomStatusBadge(title: "ACTIVE",size: AppSizes.cardTitle,),
                              Row(
                                children: [
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.pushNamed(context, RoutesName.add_new_staff_manage,arguments: {
                                          'isEdit' : true,
                                        });
                                      },child: Icon(Icons.edit,size: AppSizes.iconLarge,color: color.primary,)),
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
                                InfoRowWidget(icon: Icons.email_outlined, title: "Email", value: "check@gmail.com"),
                                SizedBox(height: AppSizes.smallGap,),
                                InfoRowWidget(icon: Icons.phone, title: "Phone", value: "01712340000"),
                                SizedBox(height: AppSizes.smallGap,),


                                InfoRowWidget(icon: Icons.school_outlined, title: "Qualification", value: "MSC in Marketing"),
                                SizedBox(height: AppSizes.smallGap,),
                                InfoRowWidget(icon: Icons.workspace_premium, title: "Experience", value: "check@gmail.com"),
                                SizedBox(height: AppSizes.smallGap,),

                                InfoRowWidget(icon: Icons.calendar_month_outlined, title: "Join Date", value: "Apr 2, 2026"),



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
