import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/viewModel/organization/staff_view_model.dart';
import 'package:storio_app/widget/custom_button/view_button.dart';
import 'package:storio_app/widget/universal/date_time_formate.dart';
import 'package:storio_app/widget/universal/image_circle_widget.dart';
import 'package:storio_app/widget/universal/status_button_row.dart';

import '../../../routes/routes_name.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/snackbar_message.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/textStyle/text_title_style.dart';
import '../../../widget/universal/confirm_action.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_status_badge.dart';
import '../../../widget/universal/more_menu.dart';
import '../../../widget/universal/search_text_field.dart';

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen> {
  final TextEditingController searchController = TextEditingController();

  int selectedStatus = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<StaffViewModel>();
      await provider.getStatusChoices();
      await provider.getStaffApi();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _refreshStaffList() {
    final provider = context.read<StaffViewModel>();
    provider.getStaffApi(
      status: selectedStatus == 0
          ? null
          : provider.statusChoices[selectedStatus - 1].value,
      search: searchController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Staff Management",
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
                        Expanded(
                          child: SearchTextField(
                            onChanged: (value) {
                              final provider = context.read<StaffViewModel>();
                              final statusValue = selectedStatus == 0
                                  ? null
                                  : provider
                                  .statusChoices[selectedStatus - 1].value;

                              provider.getStaffApi(
                                status: statusValue,
                                search: value,
                              );
                            },
                            hinText: "Search staff...",
                            controller: searchController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.itemGap),
                    Consumer<StaffViewModel>(
                      builder: (context, provider, child) {
                        if (provider.statusLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final displayList = [
                          "All",
                          ...provider.statusChoices.map((e) => e.label),
                        ];

                        return StatusButtonRow(
                          items: displayList,
                          selectedIndex: selectedStatus,
                          onSelected: (index) {
                            setState(() {
                              selectedStatus = index;
                            });
                            final statusValue = selectedStatus == 0
                                ? null
                                : provider
                                .statusChoices[selectedStatus - 1].value;

                            provider.getStaffApi(
                              status: statusValue,
                              search: searchController.text,
                            );
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
          Consumer<StaffViewModel>(
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
                  child: Center(
                    child: Text(provider.errorMessage!),
                  ),
                );
              }

              if (provider.staffList.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text("No staff found"),
                  ),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.only(
                  left: AppSizes.screenPadding,
                  right: AppSizes.screenPadding,
                ),
                sliver: SliverList.builder(
                  itemCount: provider.staffList.length,
                  itemBuilder: (context, index) {
                    final staff = provider.staffList[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                      child: CustomCard(
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ImageCircleWidget(
                                  imgPath: staff.profilePicData?.fileUrl ?? "",
                                  isNetwork: true,
                                ),
                                SizedBox(width: AppSizes.itemGap),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          TextTitleWidget(
                                            title: staff.name ?? "",
                                            size: AppSizes.sectionTitle,
                                            color: color.primary,
                                          ),
                                          SizedBox(height: AppSizes.smallGap),
                                          TextBodyStyleWidget(
                                            title: staff.role ?? "",
                                            size: AppSizes.cardTitle,
                                            color: color.primary,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              ViewButton(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    RoutesName.view_staff_manage,
                                                    arguments: {'staff': staff},
                                                  );
                                                },
                                              ),
                                              SizedBox(width: AppSizes.itemGap),
                                              MoreMenu(
                                                items: const [
                                                  MoreMenuAction.edit,
                                                  MoreMenuAction.delete,
                                                ],
                                                onSelected: (action) async {
                                                  switch (action) {
                                                    case MoreMenuAction.edit:
                                                      final result =
                                                      await Navigator.pushNamed(
                                                        context,
                                                        RoutesName.edit_staff,
                                                        arguments: {
                                                          'isEdit': true,
                                                          'staff': staff,
                                                        },
                                                      );

                                                      if (!mounted) return;

                                                      if (result == true) {
                                                        _refreshStaffList();
                                                      }
                                                      break;

                                                    case MoreMenuAction.delete:
                                                      final confirmed = await confirmAction(
                                                        context,
                                                        title: "Delete Staff",
                                                        message: "Are you sure you want to permanently delete this staff member?",
                                                      );

                                                      if (!mounted || !confirmed) {
                                                        return;
                                                      }

                                                      if (staff.id == null) return;

                                                      final staffProvider = context.read<StaffViewModel>();
                                                      final success = await staffProvider.deleteStaff(staff.id!);

                                                      if (!mounted) return;

                                                      if (success) {
                                                        SnackBarMessage.showSnackBar(
                                                          context,
                                                          "Staff deleted successfully",
                                                        );
                                                        _refreshStaffList();
                                                      } else {
                                                        SnackBarMessage.showSnackBar(
                                                          context,
                                                          staffProvider.errorMessage ??
                                                              "Failed to delete staff",
                                                        );
                                                      }
                                                      break;

                                                    default:
                                                      break;
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: AppSizes.sectionGap),
                                          if (staff.status != null)
                                            CustomStatusBadge(
                                              size: AppSizes.cardTitle,
                                              title: staff.status!.toUpperCase(),
                                            ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSizes.itemGap),
                            Row(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  color: color.primary,
                                  size: AppSizes.icon,
                                ),
                                SizedBox(width: AppSizes.appbarGap),
                                TextBodyStyleWidget(
                                  title: staff.email ?? "",
                                  color: color.primary,
                                  fontbold: false,
                                ),
                              ],
                            ),
                            SizedBox(height: AppSizes.appbarGap),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: color.primary,
                                  size: AppSizes.icon,
                                ),
                                SizedBox(width: AppSizes.appbarGap),
                                TextBodyStyleWidget(
                                  title: staff.phone ?? "",
                                  color: color.primary,
                                  fontbold: false,
                                ),
                              ],
                            ),
                            SizedBox(height: AppSizes.appbarGap),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: color.primary,
                                  size: AppSizes.icon,
                                ),
                                SizedBox(width: AppSizes.appbarGap),
                                TextBodyStyleWidget(
                                  title: formatDate(staff.joiningDate),
                                  color: color.primary,
                                  fontbold: false,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "addCategory",
            backgroundColor: color.primary,
            onPressed: () {
              Navigator.pushNamed(
                context,
                RoutesName.manage_staff_department,
              );
            },
            child: Icon(
              Icons.grid_view_rounded,
              color: color.cardBackground,
            ),
          ),
          SizedBox(height: AppSizes.itemGap),
          FloatingActionButton(
            heroTag: "add",
            backgroundColor: color.primary,
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                RoutesName.add_new_staff_manage,
              );

              if (!mounted) return;

              if (result == true) {
                _refreshStaffList();
              }
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