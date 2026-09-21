import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/universal/custom_card2.dart';
import 'package:storio_app/widget/universal/custom_status_badge.dart';


import '../../data/model/result/exam_statistic.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../custom_button/custom_buttom.dart';
import '../universal/custom_card.dart';

class ExamInfoCard extends StatelessWidget {
  final String title;
  final String examType;
  final String year;
  final String status;
  final String publishedDate;

  final IconData icon;

  final List<ExamStatistic> statistics;
  final VoidCallback editTap;
  final VoidCallback deleteTap;



  const ExamInfoCard({
    super.key,
    required this.title,
    required this.examType,
    required this.year,
    required this.status,
    required this.publishedDate,
    required this.statistics,
    this.icon = Icons.assignment_outlined, required this.editTap, required this.deleteTap,

  });

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return CustomCard(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.smallPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // =========================
            // TOP SECTION
            // =========================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: .center,
              children: [

                // Icon
                Container(
                  width: 12.5.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: color.active.withValues(alpha: .7),
                    borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.black87,
                    size: AppSizes.icon,
                  ),
                ),

                SizedBox(width: AppSizes.smallGap),

                // Title + exam type + year
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: AppSizes.cardTitle,
                                fontWeight: FontWeight.w600,
                                color: color.textPrimary,
                              ),
                            ),
                          ),

                          // Status publish
                          Flexible(
                            child: CustomStatusBadge(title: status.toUpperCase(),size: AppSizes.cardTitle,backgroundColor: color.active.withValues(alpha: 12),foregroundColor: Colors.black87,),
                          ),

                        ],
                      ),

                      SizedBox(height: AppSizes.appbarGap,),


                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [

                          // School Exam
                          CustomStatusBadge(title: examType.toUpperCase(),size: AppSizes.cardTitle,),


                          //class 10 2026
                          Flexible(
                            child: TextBodyStyleWidget(title: year,size: AppSizes.cardTitle,)
                          ),
                        ],
                      ),
                    ],
                  ),
                ),


              ],
            ),

            SizedBox(height: AppSizes.smallGap),


            Divider(
              color: color.lightVersionOfPrimaryLightVersion,
              height: 1,
            ),

            // STATISTICS

            SizedBox(
              height: 65,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    statistics.length,
                        (index) {
                      final item = statistics[index];

                      return Container(
                        width: 90,
                        margin: EdgeInsets.only(
                          right: index == statistics.length - 1
                              ? 0
                              : AppSizes.smallPadding,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            TextBodyStyleWidget(title: item.title,),

                            const SizedBox(height: 4),

                            TextBodyStyleWidget(title: item.value,color: item.valueColor ?? color.textSecondary,size: AppSizes.sectionTitle,),

                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            Divider(
              color: color.lightVersionOfPrimaryLightVersion,
              height: 1,
            ),


            // BOTTOM SECTION

            SizedBox(height: AppSizes.smallGap),

            Row(
              mainAxisAlignment: .spaceBetween,
              children: [

                TextBodyStyleWidget(title: "Published on $publishedDate",fontbold: false,),

                Row(
                  children: [
                    GestureDetector(
                      onTap: editTap,
                      child: Icon(Icons.edit,size: AppSizes.icon,color: color.primary,),
                    ),
                    SizedBox(width: AppSizes.sectionGap,),

                    GestureDetector(
                      onTap: deleteTap,
                      child: Icon(Icons.delete_outline_outlined,size: AppSizes.icon,color: Colors.redAccent,),
                    ),
                  ],
                )

              ],
            ),
          ],
        ),
      ),
    );
  }
}