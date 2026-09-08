import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';

import '../../data/model/Content/career/career_model.dart';
import '../../routes/routes_name.dart';
import '../../utils/app_sizes.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/career_view_model.dart';
import '../../widget/universal/confirm_action.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/search_text_field.dart';
import '../../widget/universal/status_button_row.dart';

class CareerManagementScreen extends StatefulWidget {
  const CareerManagementScreen({super.key});

  @override
  State<CareerManagementScreen> createState() => _CareerManagementScreenState();
}

class _CareerManagementScreenState extends State<CareerManagementScreen> {
  final TextEditingController searchController = TextEditingController();

  int selectedStatus = 0;

  final List<String> dropDownActionList = [
    "Bulk Action",
    "Mark Active",
    "Mark Draft",
    "Mark Expired",
    "Delete Selected",
  ];
  String selectedDropDownAction = "Bulk Action";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<CareerViewModel>();
      await provider.getStatusChoices();
      await provider.getJobApi();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _refreshJobList() {
    final provider = context.read<CareerViewModel>();
    provider.getJobApi(
      status: selectedStatus == 0 ? null : provider.statusChoices[selectedStatus - 1].value,
      search: searchController.text,
    );
  }

  Future<void> _handleBulkAction(String action) async {
    final provider = context.read<CareerViewModel>();

    final ids = provider.jobList.map((job) => job.id).whereType<int>().toList();

    if (ids.isEmpty) return;

    String apiAction;
    String confirmTitle;
    String confirmMessage;

    switch (action) {
      case "Mark Active":
        apiAction = "active";
        confirmTitle = "Mark as Active";
        confirmMessage = "Do you want to mark all ${ids.length} job(s) as active?";
        break;
      case "Mark Draft":
        apiAction = "draft";
        confirmTitle = "Move to Draft";
        confirmMessage = "Do you want to move all ${ids.length} job(s) to draft?";
        break;
      case "Mark Expired":
        apiAction = "expired";
        confirmTitle = "Mark as Expired";
        confirmMessage = "Do you want to mark all ${ids.length} job(s) as expired?";
        break;
      case "Delete Selected":
        apiAction = "delete";
        confirmTitle = "Delete Jobs";
        confirmMessage = "Do you want to permanently delete all ${ids.length} job(s)? This cannot be undone.";
        break;
      default:
        return;
    }

    final confirmed = await confirmAction(context, title: confirmTitle, message: confirmMessage);

    if (!mounted || !confirmed) return;

    final success = await provider.bulkAction(action: apiAction, ids: ids);

    if (!mounted) return;

    if (success) {
      _refreshJobList();
    } else {
      SnackBarMessage.showSnackBar(context, provider.errorMessage ?? "Bulk action failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Career Management",
            subtitle: "Job Circulars",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(top: AppSizes.screenPadding, left: AppSizes.screenPadding, right: AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SearchTextField(
                            onChanged: (value) {
                              final provider = context.read<CareerViewModel>();
                              final statusValue = selectedStatus == 0
                                  ? null
                                  : provider.statusChoices[selectedStatus - 1].value;

                              provider.getJobApi(status: statusValue, search: value);
                            },
                            hinText: 'Search by title or company...',
                            controller: searchController,
                          ),
                        ),
                        SizedBox(width: AppSizes.appbarGap),
                        CustomDropdown(
                          items: dropDownActionList,
                          initialValue: selectedDropDownAction,
                          width: 32.w,
                          height: 4.5.h,
                          onChanged: (value) {
                            if (value == "Bulk Action") {
                              setState(() {
                                selectedDropDownAction = value.toString();
                              });
                              return;
                            }

                            Future.delayed(const Duration(milliseconds: 200), () async {
                              if (!mounted) return;

                              final provider = context.read<CareerViewModel>();

                              if (provider.jobList.isEmpty) {
                                SnackBarMessage.showSnackBar(context, "No jobs to update");
                                return;
                              }

                              await _handleBulkAction(value.toString());

                              if (!mounted) return;
                              setState(() {
                                selectedDropDownAction = "Bulk Action";
                              });
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.sectionGap),
                    Consumer<CareerViewModel>(
                      builder: (context, provider, child) {
                        if (provider.statusLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final displayList = ["All", ...provider.statusChoices.map((e) => e.label)];

                        return StatusButtonRow(
                          items: displayList,
                          selectedIndex: selectedStatus,
                          onSelected: (index) {
                            setState(() {
                              selectedStatus = index;
                            });

                            final statusValue = index == 0 ? null : provider.statusChoices[index - 1].value;

                            provider.getJobApi(status: statusValue, search: searchController.text);
                          },
                        );
                      },
                    ),
                    SizedBox(height: AppSizes.sectionGap),
                  ],
                ),
              ]),
            ),
          ),
          Consumer<CareerViewModel>(
            builder: (context, provider, child) {
              if (provider.loading) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }

              if (provider.errorMessage != null) {
                return SliverToBoxAdapter(
                  child: Center(child: Text(provider.errorMessage!)),
                );
              }

              if (provider.jobList.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text("No job circulars found")),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
                sliver: SliverList.builder(
                  itemCount: provider.jobList.length,
                  itemBuilder: (context, index) {
                    final job = provider.jobList[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                      child: CustomCard(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 900),
                            child: Table(
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              columnWidths: const {
                                0: FlexColumnWidth(2.3),
                                1: FlexColumnWidth(1.8),
                                2: FlexColumnWidth(1.2),
                                3: FlexColumnWidth(1.3),
                                4: FlexColumnWidth(1.2),
                                5: FlexColumnWidth(1),
                              },
                              children: [
                                TableRow(
                                  children: [
                                    _tableCell(context: context, "JOB TITLE & COMPANY", isHeader: true),
                                    _tableCell(context: context, "TYPE & LOCATION", isHeader: true),
                                    _tableCell(context: context, "VACANCY", isHeader: true),
                                    _tableCell(context: context, "DEADLINE", isHeader: true),
                                    _tableCell(context: context, "STATUS", isHeader: true),
                                    _tableCell(context: context, "ACTIONS", isHeader: true),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    _tableCell(
                                      context: context,
                                      "${job.title ?? ''}\n${job.companyName ?? ''}",
                                    ),
                                    _tableCell(
                                      context: context,
                                      "${job.jobType ?? ''}\n${job.location ?? ''}",
                                    ),
                                    _tableCell(context: context, "${job.vacancy ?? 0} Opening(s)"),
                                    _tableCell(
                                      context: context,
                                      job.deadline != null ? DateFormat('MM/dd/yyyy').format(job.deadline!) : "—",
                                    ),
                                    _tableCell(context: context, job.status ?? ""),
                                    _tableCell(
                                      context: context,
                                      "",
                                      icons: const [Icons.edit_outlined, Icons.delete_outline],
                                      onTaps: [
                                            () {
                                          Navigator.pushNamed(
                                            context,
                                            RoutesName.edit_job_circular,
                                            arguments: {'job': job},
                                          ).then((result) {
                                            if (result == true) _refreshJobList();
                                          });
                                        },
                                            () async {
                                          final confirmed = await confirmAction(
                                            context,
                                            title: "Delete Job Circular",
                                            message: "Are you sure you want to permanently delete this job circular?",
                                          );

                                          if (!mounted || !confirmed) return;

                                          final success = await provider.deleteJob(job.id!);

                                          if (!mounted) return;

                                          if (success) {
                                            _refreshJobList();
                                          } else {
                                            SnackBarMessage.showSnackBar(
                                              context,
                                              provider.errorMessage ?? "Failed to delete",
                                            );
                                          }
                                        },
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
      floatingActionButton: FloatingActionButton(
        heroTag: "add",
        backgroundColor: color.primary,
        onPressed: () async {
          final result = await Navigator.pushNamed(context, RoutesName.add_new_job_circular);

          if (!mounted) return;

          if (result == true) {
            _refreshJobList();
          }
        },
        child: Icon(Icons.add, color: color.cardBackground),
      ),
    );
  }
}

Widget _tableCell(
    String text, {
      required BuildContext context,
      bool isHeader = false,
      List<IconData>? icons,
      List<VoidCallback>? onTaps,
    }) {
  final color = context.Appcolor;
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: AppSizes.cardPadding,
      vertical: AppSizes.itemGap,
    ),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(color: Colors.grey.shade300),
      ),
    ),
    child: icons != null
        ? Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(icons.length, (index) {
        return InkWell(
          onTap: onTaps?[index],
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(icons[index], size: 20),
          ),
        );
      }),
    )
        : Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: isHeader ? AppSizes.cardSubTitle : AppSizes.cardTitle,
        fontWeight: isHeader ? FontWeight.w600 : FontWeight.w500,
        color: isHeader ? color.primary : Colors.grey.shade700,
      ),
    ),
  );
}