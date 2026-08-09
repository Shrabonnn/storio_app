import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';
import 'package:storio_app/widget/institute_profile/information_row.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';

import '../widget/universal/custom_app_bar.dart';
import '../widget/universal/custom_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.background,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 4.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                Column(
                  children: [
                    Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 13.w,
                              backgroundImage: const AssetImage(
                                'assets/images/person.png',
                              ),
                            ),

                          ],
                        ),

                        SizedBox(height: 1.5.h),

                        TextTitleWidget(
                          title: "Maiyasha Sultana",
                          color: AppColors.primary,
                          size: 18.sp,
                        ),

                        SizedBox(height: .5.h),

                        TextBodyStyleWidget(
                          title: "maiyasha@gmail.com",
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h,),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: AppColors.primary,
                          size: 8.w,
                        ),
                        SizedBox(width: 1.w),
                        TextTitleWidget(
                          title: "Personal Information",
                          color: AppColors.primary,
                          size: 16.sp,
                        ),
                        SizedBox(width: 15.w),

                        Expanded(
                          child: CustomButton(
                            onTap: () {},
                            text: "Edit Profile",
                            width: 25.w,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h,),
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoRow(label: "First Name", value: "Maiyasha"),
                          Divider(thickness: 0.7,),
                          InfoRow(label: "Last Name", value: "Sultana"),
                          Divider(thickness: 0.7,),
                          InfoRow(label: "Email Address", value: "sultana@gmail.com"),
                          Divider(thickness: 0.7,),
                          InfoRow(label: "Phone Number", value: "0179492035"),
                          Divider(thickness: 0.7,),
                          InfoRow(label: "Address", value: "Dhaka"),
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
