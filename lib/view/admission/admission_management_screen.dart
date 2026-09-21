import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/admission_view_model.dart';
import '../../widget/skeleton/custom_skeleton_card.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/confirm_action.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_status_badge.dart';
import '../../widget/universal/date_time_formate.dart';
import '../../widget/universal/more_menu.dart';
import '../../widget/universal/search_text_field.dart';
import '../../widget/universal/status_button_row.dart';

class AdmissionManagementScreen extends StatefulWidget {
  const AdmissionManagementScreen({super.key});

  @override
  State<AdmissionManagementScreen> createState() =>
      _AdmissionManagementScreenState();
}

class _AdmissionManagementScreenState
    extends State<AdmissionManagementScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<String> statusList = [
    "All",
    "Pending",
    "Approved",
    "Rejected",
  ];

  int selectedStatus = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<AdmissionViewModel>();
      await provider.getApplications(isFilterOrSearch: false);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _refreshList() {
    final provider = context.read<AdmissionViewModel>();
    provider.getApplications(isFilterOrSearch: true);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Admission Management",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              top: AppSizes.screenPadding,
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SearchTextField(
                          onChanged: (value) {
                            setState(() {});
                          },
                          hinText: "Search by student name, email, or app no.",
                          controller: searchController,
                        ),
                        SizedBox(width: AppSizes.smallGap,),
                        Expanded(child: CustomButton(height: 4.25.h,text: "Export CSV", onTap: (){}))

                      ],
                    ),
                    SizedBox(height: AppSizes.smallGap),
                    StatusButtonRow(
                      items: statusList,
                      selectedIndex: selectedStatus,
                      onSelected: (index) {
                        setState(() {
                          selectedStatus = index;
                        });
                      },
                    ),
                    SizedBox(height: AppSizes.sectionGap),
                  ],
                ),
              ]),
            ),
          ),
          Consumer<AdmissionViewModel>(
            builder: (context, provider, child) {
              // 1. Loading / Shimmer State
              if (provider.applicationsLoading) {
                return SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding,
                  ),
                  sliver: SliverList.builder(
                    itemCount: 4,
                    itemBuilder: (context, index) =>
                    const CustomSkeletonCard(),
                  ),
                );
              }

              // 2. Error State
              if (provider.errorMessage != null) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(provider.errorMessage!),
                    ),
                  ),
                );
              }

              // Filter applicationList dynamically based on search & status
              final searchText = searchController.text.toLowerCase();
              final filteredList = provider.applicationList.where((app) {
                final studentName =
                (app.formData?['student_name'] ?? '').toString().toLowerCase();
                final email =
                (app.formData?['email'] ?? '').toString().toLowerCase();
                final appNumber =
                (app.applicationNumber ?? '').toLowerCase();

                final matchesSearch = studentName.contains(searchText) ||
                    email.contains(searchText) ||
                    appNumber.contains(searchText);

                if (selectedStatus == 0) return matchesSearch;

                final selectedStatusStr =
                statusList[selectedStatus].toLowerCase();
                final appStatusStr = (app.status ?? '').toLowerCase();

                return matchesSearch && (appStatusStr == selectedStatusStr);
              }).toList();

              // 3. Empty State
              if (filteredList.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("No admission applications found"),
                    ),
                  ),
                );
              }

              // 4. Data List
              return SliverPadding(
                padding: EdgeInsets.only(
                  left: AppSizes.screenPadding,
                  right: AppSizes.screenPadding,
                ),
                sliver: SliverList.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final app = filteredList[index];

                    final studentName =
                        app.formData?['student_name'] ?? "Unknown Student";
                    final grade = app.formData?['applied_class'] ??
                        app.formData?['grade'] ??
                        "N/A";
                    final email = app.formData?['email'] ?? "N/A";
                    final phone = app.formData?['phone'] ?? "N/A";

                    return Container(
                      margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                      child: CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    TextTitleWidget(
                                      title: studentName,
                                      color: color.primary,
                                    ),


                                  ],
                                ),
                                Row(
                                  children: [
                                    CustomStatusBadge(
                                      title: app.status?.toUpperCase() ?? "PENDING",
                                      size: AppSizes.cardTitle,
                                    ),
                                    SizedBox(width: AppSizes.itemGap),
                                    MoreMenu(
                                      items: const [
                                        MoreMenuAction.view,
                                        MoreMenuAction.delete,
                                      ],
                                      onSelected: (action) async {
                                        switch (action) {
                                          case MoreMenuAction.view:
                                            Navigator.pushNamed(
                                              context,
                                              RoutesName.view_admission,
                                              arguments: {'application': app},
                                            );
                                            break;

                                          case MoreMenuAction.delete:
                                            final confirmed = await confirmAction(
                                              context,
                                              title: "Delete Application",
                                              message:
                                              "Are you sure you want to delete this application?",
                                            );

                                            if (confirmed && context.mounted) {
                                              final success = await provider
                                                  .updateApplicationStatus(
                                                app.id!,
                                                status: "rejected",
                                              );
                                              if (success) _refreshList();
                                            }
                                            break;

                                          default:
                                            break;
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: AppSizes.itemGap),
                            _infoRow(context, "Grade", grade),
                            _infoRow(
                              context,
                              "Admission No",
                              app.applicationNumber ?? "N/A",
                            ),
                            _infoRow(context, "Email", email),
                            _infoRow(context, "Phone", phone),
                            _infoRow(
                              context,
                              "Date",
                              app.submittedAt != null
                                  ? formatDate(app.submittedAt!)
                                  : "N/A",
                            ),
                            SizedBox(height: AppSizes.itemGap),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          FloatingActionButton(
            heroTag: "admissionFormBuilder",
            backgroundColor: color.primary,
            onPressed: () {
              Navigator.pushNamed(
                context,
                RoutesName.admission_form_builder,
              );
            },
            child: Icon(
              Icons.add,
              color: color.cardBackground,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _infoRow(BuildContext context, String title, String value) {
  final color = context.Appcolor;
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 30.w,
          child: TextBodyStyleWidget(title: title),
        ),
        Expanded(
          child: TextBodyStyleWidget(
            title: value,
            color: color.primary,
          ),
        ),
      ],
    ),
  );
}