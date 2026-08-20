import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/custom_status_badge.dart';
import 'package:storio_app/widget/universal/status_button_row.dart';

import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';

class ViewAdmissionScreen extends StatefulWidget {
  const ViewAdmissionScreen({super.key});

  @override
  State<ViewAdmissionScreen> createState() => _ViewAdmissionScreenState();
}

class _ViewAdmissionScreenState extends State<ViewAdmissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Tony Stark",
            subtitle: "ID : ADM-2026-0001",
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                CustomStatusBadge(title: "Pending",size: AppSizes.cardTitle,),
                                Icon(Icons.delete_outline_outlined,color: Colors.red,size: AppSizes.iconLarge,)
                              ],
                            ),
                            SizedBox(height: AppSizes.appbarGap,),
                            Row(
                              mainAxisAlignment: .center,
                              children: [
                                // Approve
                                GestureDetector(
                                  onTap: () {
                                    // Approve
                                  },
                                  child: Icon(
                                    Icons.check_circle_outline,
                                    size: AppSizes.iconLarge,
                                    color: Colors.green,
                                  ),
                                ),

                                SizedBox(width: AppSizes.itemGap,),



                                // Reject
                                GestureDetector(
                                  onTap: () {
                                    // Reject
                                  },
                                  child: Icon(
                                    Icons.cancel_outlined,
                                    size:AppSizes.iconLarge,
                                    color: Colors.red,
                                  ),
                                ),

                                SizedBox(width: AppSizes.itemGap,),

                                // Under Review
                                GestureDetector(
                                  onTap: () {
                                    // Under Review
                                  },
                                  child: Icon(
                                    Icons.visibility_outlined,
                                    size: AppSizes.iconLarge,
                                    color: Colors.blue,
                                  ),
                                ),


                                SizedBox(width: AppSizes.itemGap,),
                                // Reset to Pending
                                GestureDetector(
                                  onTap: () {
                                    // Reset to Pending
                                  },
                                  child: Icon(
                                    Icons.access_time,
                                    size: AppSizes.iconLarge,
                                    color: Colors.orange,
                                  ),
                                ),

                                SizedBox(width: AppSizes.itemGap,),

                                // Download Slip
                                GestureDetector(
                                  onTap: () {
                                    // Download Slip
                                  },
                                  child: Icon(
                                    Icons.download_outlined,
                                    size: AppSizes.iconLarge,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                              ],
                            ),

                            Divider(),
                            _infoRow("Admission No", "ADM-2026-0001"),
                            _infoRow("Email", "alfasunny95@gmail.com"),
                            _infoRow("Phone", "01793960082"),
                            _infoRow("Date", "Apr 9, 2026"),


                          ],
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

Widget _infoRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 30.w,
            child: TextBodyStyleWidget(title: title)
        ),
        Expanded(
          child: TextBodyStyleWidget(title: value,color: AppColors.primary,),
        ),
      ],
    ),
  );
}