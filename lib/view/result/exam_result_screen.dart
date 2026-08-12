import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/search_text_field.dart';
import 'package:storio_app/widget/universal/status_button_row.dart';

import '../../model/result/exam_statistic.dart';
import '../../routes/routes_name.dart';
import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../../widget/result/exam_info_card.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';

class ExamResultScreen extends StatefulWidget {
  const ExamResultScreen({super.key});

  @override
  State<ExamResultScreen> createState() => _ExamResultScreenState();
}

class _ExamResultScreenState extends State<ExamResultScreen> {
  final TextEditingController searchController = TextEditingController();

  List<String> statusList = ["School Exam", "Public Exams", "Admission"];

  int selectedStatus = 0;

  // Come from Api and use it in Item count
  int schoolExamCount = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Exam Results",
            subtitle: "Academic Records",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    StatusButtonRow(
                      items: statusList,
                      selectedIndex: selectedStatus,
                      onSelected: (index) {
                        setState(() {
                          selectedStatus = index;
                        });
                      },
                      onTap: (status) {


                        print("Clicked: $status");
                      },
                    ),
                    SizedBox(height: AppSizes.sectionGap),
                    Row(
                      children: [
                        Expanded(
                          child: SearchTextField(
                            hinText: 'Search exams...',
                            controller: searchController,
                          ),
                        ),
                      ],
                    ),

                    //SizedBox(height: AppSizes.sectionGap),

                  ],
                ),
              ]),
            ),
          ),
          if(selectedStatus == 0)
            SliverPadding(padding: EdgeInsets.symmetric(horizontal:AppSizes.screenPadding),
              sliver: SliverList.builder(
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                    child: ExamInfoCard(
                      title: "2nd Term",
                      examType: "School Exam",
                      year: "Class Ten · 2026",
                      status: "Published",
                      publishedDate: "20 May, 2026",

                      statistics: const [

                        ExamStatistic(
                          title: "Participants",
                          value: "100",
                        ),
                        ExamStatistic(
                          title: "Pass",
                          value: "87",
                          valueColor: Colors.green,
                        ),
                        ExamStatistic(
                          title: "Fail",
                          value: "13",
                          valueColor: Colors.red,
                        ),
                        ExamStatistic(
                          title: "Pass Rate",
                          value: "90.1%",
                        ),


                      ],

                      onViewDetails: () {
                        // View Details click
                      },
                    ),
                  );
                },

                itemCount: schoolExamCount,
              ),),

          if(selectedStatus == 1)
            SliverPadding(padding: EdgeInsets.symmetric(horizontal:AppSizes.screenPadding),
              sliver: SliverList.builder(
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                    child: ExamInfoCard(
                      title: "H.S.C",
                      examType: "Public Exam",
                      year: "2026",
                      status: "Published",
                      publishedDate: "20 May, 2026",

                      statistics: const [

                        ExamStatistic(
                          title: "Participants",
                          value: "1000",
                        ),
                        ExamStatistic(
                          title: "Pass",
                          value: "789",
                          valueColor: Colors.green,
                        ),
                        ExamStatistic(
                          title: "Fail",
                          value: "211",
                          valueColor: Colors.red,
                        ),
                        ExamStatistic(
                          title: "Pass",
                          value: "789",
                        ),
                        ExamStatistic(
                          title: "Fail",
                          value: "2",
                        ),
                        ExamStatistic(
                          title: "Pass Rate",
                          value: "78.9%",
                        ),


                      ],

                      onViewDetails: () {
                        // View Details click
                      },
                    ),
                  );
                },

                itemCount: schoolExamCount,
              ),),

          if(selectedStatus ==2 )
            SliverPadding(padding: EdgeInsets.symmetric(horizontal:AppSizes.screenPadding),
              sliver: SliverList.builder(
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                    child: ExamInfoCard(
                      title: "H.S.C",
                      examType: "Public Exam",
                      year: "2026",
                      status: "Published",
                      publishedDate: "20 May, 2026",

                      statistics: const [

                        ExamStatistic(
                          title: "Participants",
                          value: "1000",
                        ),
                        ExamStatistic(
                          title: "Pass",
                          value: "789",
                          valueColor: Colors.green,
                        ),
                        ExamStatistic(
                          title: "Fail",
                          value: "211",
                          valueColor: Colors.red,
                        ),
                        ExamStatistic(
                          title: "Pass",
                          value: "789",
                        ),
                        ExamStatistic(
                          title: "Fail",
                          value: "2",
                        ),
                        ExamStatistic(
                          title: "Pass Rate",
                          value: "78.9%",
                        ),


                      ],

                      onViewDetails: () {
                        // View Details click
                      },
                    ),
                  );
                },

                itemCount: 0,
              ),),


          SliverPadding(padding: EdgeInsets.only(bottom:AppSizes.sectionGap))
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "add",
            backgroundColor: AppColors.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.publish_result);
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
