import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_text_field.dart';
import '../../widget/universal/search_text_field.dart';


class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  int items =3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title:"Security & Access",
            showBackButton: true,
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
                        TextBodyStyleWidget(title: "Authentication & Recovery", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        Divider(),

                        // Title
                        TextBodyStyleWidget(title: "Password Change", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        TextBodyStyleWidget(title: "Update your primary login password regularly to keep your account safe.",size: AppSizes.cardTitle,fontbold: false,maxLines: 2,),
                        SizedBox(height: AppSizes.smallGap,),
                        CustomButton(icon: Icons.key_outlined,text: "Change Password", onTap: (){}),



                      ],
                    )),
                    SizedBox(height: AppSizes.sectionGap,),
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        TextBodyStyleWidget(title: "Two-Factor Authentication (2FA)", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        TextBodyStyleWidget(title: "Add an extra layer of security to your account by requiring a code from your mobile device.",size: AppSizes.cardTitle,fontbold: false,maxLines: 2,),
                        SizedBox(height: AppSizes.smallGap,),
                        CustomButton(icon: Icons.security,text: "Enable 2FA", onTap: (){})



                      ],
                    )),

                    SizedBox(height: AppSizes.sectionGap,),

                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        TextBodyStyleWidget(title: "Device Management", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        Divider(),

                        // Title
                        TextBodyStyleWidget(title: "Active Login Sessions", color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        TextBodyStyleWidget(title: "Devices currently logged into your account.",size: AppSizes.cardTitle,fontbold: false,maxLines: 2,),
                        SizedBox(height: AppSizes.smallGap,),
                        CustomButton(icon: Icons.logout,text: "Log out All Others", backgroundColor: AppColors.cartBackgroundLight,foregroundColor:Colors.red,onTap: (){}),

                        SizedBox(height: AppSizes.smallGap,),
                        Divider(),

                        SizedBox(height: AppSizes.smallGap,),

                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(
                                  bottom: index == items - 1 ? 0 : AppSizes.sectionGap ,),
                              child: CustomCard2(child:  Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Column(
                                  children: [

                                    Row(
                                      children: [
                                        Container(
                                          height: 6.h,
                                          width: 12.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.desktop_windows_outlined,
                                            color: AppColors.primary,
                                            size: AppSizes.iconLarge,
                                          ),
                                        ),

                                        SizedBox(width: AppSizes.itemGap),

                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TextBodyStyleWidget(
                                                title: "Windows Desktop - Edge",
                                                color: AppColors.primary,
                                                size: AppSizes.cardTitle,
                                              ),

                                              SizedBox(height: 0.5.h),

                                              TextBodyStyleWidget(
                                                title: "Pallabi, Bangladesh · 103.213.242.115",
                                                fontbold: false,
                                                size: AppSizes.cardSubTitle,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: AppSizes.itemGap),

                                    // Logout Button
                                    CustomButton(text: "Log out", onTap: (){})
                                  ],
                                ),
                              )),
                            );
                          },
                        )

                      ],
                    )),

                  ],
                )
              ]),
            ),
          ),


        ],
      ),
    );
  }
}
