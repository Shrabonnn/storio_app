import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/universal/custom_card2.dart';

import '../../model/result/exam_statistic.dart';
import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
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

  final VoidCallback? onViewDetails;

  const ExamInfoCard({
    super.key,
    required this.title,
    required this.examType,
    required this.year,
    required this.status,
    required this.publishedDate,
    required this.statistics,
    this.icon = Icons.assignment_outlined,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
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
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.green.shade700,
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
                                color: Colors.black87,
                              ),
                            ),
                          ),

                          // Status publish
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: TextBodyStyleWidget(title: status,color: Colors.green.shade700,)
                            ),
                          ),

                        ],
                      ),



                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [

                          // School Exam
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade600,
                              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                            ),
                            child: TextBodyStyleWidget(title: examType,color: Colors.black87,)

                          ),


                          //class 10 2026
                          Flexible(
                            child: TextBodyStyleWidget(title: year,)
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
              color: Colors.grey.shade200,
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

                            Text(
                              item.title,
                              style: TextStyle(
                                fontSize: AppSizes.cardSubTitle,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              item.value,
                              style: TextStyle(
                                fontSize: AppSizes.cardTitle,
                                fontWeight: FontWeight.w600,
                                color: item.valueColor ??
                                    Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            Divider(
              color: Colors.grey.shade200,
              height: 1,
            ),


            // BOTTOM SECTION

            SizedBox(height: AppSizes.smallGap),

            Row(
              children: [

                Expanded(
                  child: Text(
                    "Published on $publishedDate",
                    style: TextStyle(
                      fontSize: AppSizes.cardSubTitle,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),

                SizedBox(
                  width: 112,
                  child: CustomButton(
                    text: "View Details",
                    height: 4.h,
                    size: AppSizes.cardSubTitle,
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    onTap: onViewDetails ?? (){},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}