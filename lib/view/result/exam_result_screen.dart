import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/confirm_action.dart';
import 'package:storio_app/widget/universal/search_text_field.dart';
import 'package:storio_app/widget/universal/status_button_row.dart';

import '../../data/model/Content/result/exam_result_model.dart';
import '../../data/model/result/exam_statistic.dart';
import '../../routes/routes_name.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../viewModel/Content/exam_result_view_model.dart';
import '../../widget/result/exam_info_card.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/date_time_formate.dart';

class ExamResultScreen extends StatefulWidget {
  const ExamResultScreen({super.key});

  @override
  State<ExamResultScreen> createState() => _ExamResultScreenState();
}

class _ExamResultScreenState extends State<ExamResultScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> examTypeTabs = const [
    {"label": "School Exam", "value": "school"},
    {"label": "Public Exams", "value": "public"},
    {"label": "Admission", "value": "admission"},
  ];

  int selectedStatus = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadResults();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _loadResults() {
    context.read<ExamResultViewModel>().getExamResultApi(
      examType: examTypeTabs[selectedStatus]['value'],
      search: searchController.text.trim().isEmpty
          ? null
          : searchController.text.trim(),
    );
  }

  Future<void> _handleDelete(ExamResultModel result) async {
    if (result.id == null) return;

    final confirmed = await confirmAction(
      context,
      title: "Delete Exam Result",
      message: "Are you sure you want to permanently delete this entry?",
    );

    if (!confirmed) return;
    if (!mounted) return;

    final viewModel = context.read<ExamResultViewModel>();
    final success = await viewModel.deleteExamResult(result.id!);

    if (!mounted) return;

    SnackBarMessage.showSnackBar(
      context,
      success
          ? "Exam result deleted successfully"
          : (viewModel.errorMessage ?? "Failed to delete exam result"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Exam Results",
            subtitle: "Academic Records",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    StatusButtonRow(
                      items: examTypeTabs.map((e) => e['label']!).toList(),
                      selectedIndex: selectedStatus,
                      onSelected: (index) {
                        setState(() {
                          selectedStatus = index;
                        });
                        _loadResults();
                      },
                      onTap: (status) {},
                    ),
                    SizedBox(height: AppSizes.sectionGap),
                    Row(
                      children: [
                        Expanded(
                          child: SearchTextField(
                            onChanged: (value) {
                              _loadResults();
                            },
                            hinText: 'Search exams...',
                            controller: searchController,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ]),
            ),
          ),

          Consumer<ExamResultViewModel>(
            builder: (context, provider, child) {
              if (provider.loading) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }

              if (provider.errorMessage != null &&
                  provider.examResultList.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: TextBodyStyleWidget(
                        title: provider.errorMessage!,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              }

              if (provider.examResultList.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: TextBodyStyleWidget(
                        title: "No exam results found",
                        color: color.primary,
                      ),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPadding,
                ),
                sliver: SliverList.builder(
                  itemCount: provider.examResultList.length,
                  itemBuilder: (context, index) {
                    final result = provider.examResultList[index];
                    final isPublicExam =
                        examTypeTabs[selectedStatus]['value'] == 'public';

                    return Container(
                      margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                      child: ExamInfoCard(
                        title: result.examName ?? "-",
                        examType: examTypeTabs[selectedStatus]['label']!,
                        year: (result.className != null &&
                            result.className!.isNotEmpty)
                            ? "${result.className} · ${result.year ?? ''}"
                            : (result.year ?? "-"),
                        status: "Published",
                        publishedDate: formatDate(result.createdAt),
                        statistics: [
                          ExamStatistic(
                            title: "Participants",
                            value: "${result.totalExaminees ?? 0}",
                          ),
                          ExamStatistic(
                            title: "Pass",
                            value: "${result.passed ?? 0}",
                            valueColor: Colors.green,
                          ),
                          ExamStatistic(
                            title: "Fail",
                            value: "${result.failed ?? 0}",
                            valueColor: Colors.red,
                          ),
                          if (isPublicExam) ...[
                            ExamStatistic(
                              title: "A+",
                              value: "${result.aplusCount ?? 0}",
                            ),
                            ExamStatistic(
                              title: "A Grade",
                              value: "${result.agradeCount ?? 0}",
                            ),
                          ],
                          ExamStatistic(
                            title: "Pass Rate",
                            value: result.passRate ?? "-",
                          ),
                        ],
                        editTap: () async {
                          final res = await Navigator.pushNamed(
                            context,
                            RoutesName.edit_result,
                            arguments: {
                              "isEdit": true,
                              "examResult": result,
                            },
                          );

                          if (!mounted) return;

                          if (res == true) {
                            _loadResults();
                          }
                        },
                        deleteTap: () {
                          _handleDelete(result);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),

          SliverPadding(padding: EdgeInsets.only(bottom: AppSizes.sectionGap)),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "add",
            backgroundColor: color.primary,
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                RoutesName.publish_result,
                arguments: {
                  "isEdit": false,
                  "defaultExamType": examTypeTabs[selectedStatus]['value'],
                },
              );

              if (!mounted) return;

              if (result == true) {
                _loadResults();
              }
            },
            child: Icon(Icons.add, color: color.cardBackground),
          ),
        ],
      ),
    );
  }
}