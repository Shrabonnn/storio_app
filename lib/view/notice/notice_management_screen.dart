import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/snackbar_message.dart';
import 'package:storio_app/widget/custom_button/view_button.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/skeleton/status_row_skeleton.dart';

import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/notice_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/confirm_action.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_status_badge.dart';
import '../../widget/universal/date_time_formate.dart';
import '../../widget/universal/image_card.dart';
import '../../widget/universal/more_menu.dart';
import '../../widget/universal/search_text_field.dart';
import '../../widget/universal/status_button_row.dart';

class NoticeManagementScreen extends StatefulWidget {
  const NoticeManagementScreen({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  State<NoticeManagementScreen> createState() => _NoticeManagementScreenState();
}

class _NoticeManagementScreenState extends State<NoticeManagementScreen> {
  final TextEditingController searchController = TextEditingController();

  int selectedStatus = 0;

  // drop down
  final List<String> dropDownStatusList = [
    "Bulk Action",
    "Publish",
    "Archive",
    "Draft",
    "Bin",
    "Restore",
    "Delete All",
  ];
  String selectedDropDownList = "Bulk Action";

  Set<int> selectedNoticeIds = {};
  bool isSelectionMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<NoticeViewModel>();
      await provider.getStatusChoices();
      await provider.getNoticeApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Notice Board",
            showBackButton: widget.showBackButton,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(
              top: AppSizes.screenPadding,
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: SearchTextField(
                            onChanged: (value) {
                              final provider = context.read<NoticeViewModel>();
                              final statusValue = selectedStatus == 0
                                  ? null
                                  : provider
                                        .statusChoices[selectedStatus - 1]
                                        .value;

                              provider.getNoticeApi(
                                status: statusValue,
                                search: value,
                              );
                            },
                            hinText: "Search...",
                            controller: searchController,
                          ),
                        ),
                        SizedBox(width: AppSizes.appbarGap),
                        CustomDropdown(
                          items: dropDownStatusList,
                          initialValue: selectedDropDownList,
                          height: 4.5.h,
                          width: 32.w,
                          onChanged: (value) {
                            if (value == "Bulk Action") {
                              setState(() {
                                selectedDropDownList = value.toString();
                              });
                              return;
                            }

                            Future.delayed(
                              const Duration(milliseconds: 200),
                              () async {
                                if (!mounted) return;

                                final provider = context
                                    .read<NoticeViewModel>();

                                if (provider.noticeList.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("No notices to update"),
                                    ),
                                  );
                                  return;
                                }

                                await _handleBulkAction(value.toString());

                                if (!mounted) return;
                                setState(() {
                                  selectedDropDownList = "Bulk Action";
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.smallGap),
                    Consumer<NoticeViewModel>(
                      builder: (context, provider, child) {
                        if (provider.statusLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: StatusRowSkeleton(),
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

                            final statusValue = index == 0
                                ? null
                                : provider.statusChoices[index - 1].value;

                            provider.getNoticeApi(
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
          Consumer<NoticeViewModel>(
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

              if (provider.noticeList.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text("No notices found")),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.only(
                  left: AppSizes.screenPadding,
                  right: AppSizes.screenPadding,
                ),
                sliver: SliverList.builder(
                  itemCount: provider.noticeList.length,
                  itemBuilder: (context, index) {
                    final notice = provider.noticeList[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                      child: CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomStatusBadge(
                                  title: notice.status!.toUpperCase() ?? "",
                                  size: AppSizes.sectionTitle,
                                ),

                                Row(
                                  children: [
                                    ViewButton(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          RoutesName.view_notice,
                                          arguments: {'notice': notice},
                                        );
                                      },
                                    ),
                                    SizedBox(width: AppSizes.sectionGap,),


                                    MoreMenu(
                                      items: const [
                                        MoreMenuAction.edit,
                                        MoreMenuAction.archive,
                                        MoreMenuAction.delete,
                                      ],
                                      onSelected: (action) async {
                                        switch (action) {
                                          case MoreMenuAction.edit:
                                            final result =
                                                await Navigator.pushNamed(
                                                  context,
                                                  RoutesName.edit_notice,
                                                  arguments: {'notice': notice},
                                                );

                                            if (!mounted) return;

                                            if (result == true) {
                                              _refreshNoticeList();
                                            }
                                            break;

                                          case MoreMenuAction.archive:
                                            final confirmed = await confirmAction(
                                              context,
                                              title: "Archive Notice",
                                              message:
                                                  "Are you sure you want to archive this notice?",
                                            );

                                            if (!mounted || !confirmed) return;

                                            final provider = context
                                                .read<NoticeViewModel>();
                                            final success = await provider
                                                .archiveNotice(notice.id!);

                                            if (!mounted) return;

                                            if (success) {
                                              _refreshNoticeList();
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    provider.errorMessage ??
                                                        "Failed to archive",
                                                  ),
                                                ),
                                              );
                                            }
                                            break;

                                          case MoreMenuAction.delete:
                                            final confirmed = await confirmAction(
                                              context,
                                              title: "Delete Notice",
                                              message:
                                                  "Are you sure you want to move this notice to bin?",
                                            );

                                            if (!mounted || !confirmed) return;

                                            final provider2 = context
                                                .read<NoticeViewModel>();
                                            final success2 = await provider2
                                                .bulkAction(
                                                  action: "delete",
                                                  noticeIds: [notice.id!],
                                                );

                                            if (!mounted) return;

                                            if (success2) {
                                              _refreshNoticeList();
                                            } else {
                                              SnackBarMessage.showSnackBar(
                                                context,
                                                provider2.errorMessage ??
                                                    "Failed to delete",
                                              );
                                            }
                                            break;
                                          case MoreMenuAction.view:
                                            break;

                                          case MoreMenuAction.changePassword:
                                            throw UnimplementedError();

                                          case MoreMenuAction.suspend:
                                            throw UnimplementedError();
                                          case MoreMenuAction.publish:
                                            // TODO: Handle this case.
                                            throw UnimplementedError();
                                          case MoreMenuAction.hide:
                                            // TODO: Handle this case.
                                            throw UnimplementedError();
                                          case MoreMenuAction.show:
                                            // TODO: Handle this case.
                                            throw UnimplementedError();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: AppSizes.itemGap),

                            TextTitleWidget(
                              title: notice.title ?? "",
                              color: color.textPrimary,
                              maxLines: 1,
                            ),

                            SizedBox(height: AppSizes.appbarGap),

                            TextBodyStyleWidget(
                              title: notice.content ?? "",
                              maxLines: 3,
                              size: AppSizes.cardTitle,
                            ),

                            SizedBox(height: AppSizes.appbarGap),

                            Divider(
                              color: color.lightVersionOfPrimaryLightVersion,
                              height: 1,
                            ),


                            SizedBox(height: AppSizes.appbarGap),

                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: color.primary,
                                  size: AppSizes.iconLarge,
                                ),

                                SizedBox(width: AppSizes.appbarGap),

                                Flexible(
                                  child: TextBodyStyleWidget(
                                    title:
                                        "Last Updated: ${notice.updateDate != null ? '${formatDate(notice.updateDate!)} · ${formatTime(notice.updateDate!)}' : ''}",
                                    maxLines: 1,
                                    size: AppSizes.cardTitle,
                                    fontbold: false,
                                  ),
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
          ),
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
                RoutesName.add_new_notice,
              );

              if (!mounted) return;

              if (result == true) {
                final provider = context.read<NoticeViewModel>();
                provider.getNoticeApi(
                  status: selectedStatus == 0
                      ? null
                      : provider.statusChoices[selectedStatus - 1].value,
                  search: searchController.text,
                );
              }
            },

            child: Icon(Icons.add, color: color.cardBackground),
          ),
        ],
      ),
    );
  }

  void _refreshNoticeList() {
    final provider = context.read<NoticeViewModel>();
    provider.getNoticeApi(
      status: selectedStatus == 0
          ? null
          : provider.statusChoices[selectedStatus - 1].value,
      search: searchController.text,
    );
  }

  Future<void> _handleBulkAction(String action) async {
    final provider = context.read<NoticeViewModel>();

    List<int> noticeIds;

    if (action == "Restore" || action == "Delete All") {
      final binnedNotices = await provider.fetchBinnedNoticeIds();

      if (binnedNotices.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Bin is empty")));
        return;
      }

      noticeIds = binnedNotices;
    } else {
      noticeIds = provider.noticeList
          .map((notice) => notice.id)
          .whereType<int>()
          .toList();

      if (noticeIds.isEmpty) return;
    }

    String apiAction;
    String confirmTitle;
    String confirmMessage;

    switch (action) {
      case "Publish":
        apiAction = "publish";
        confirmTitle = "Publish Notices";
        confirmMessage =
            "Do you want to publish all ${noticeIds.length} notice(s)?";
        break;
      case "Archive":
        apiAction = "archive";
        confirmTitle = "Archive Notices";
        confirmMessage =
            "Do you want to archive all ${noticeIds.length} notice(s)?";
        break;
      case "Draft":
        apiAction = "draft";
        confirmTitle = "Move to Draft";
        confirmMessage =
            "Do you want to move all ${noticeIds.length} notice(s) to draft?";
        break;
      case "Bin":
        apiAction = "delete";
        confirmTitle = "Move to Bin";
        confirmMessage =
            "Do you want to move all ${noticeIds.length} notice(s) to bin?";
        break;
      case "Restore":
        apiAction = "restore";
        confirmTitle = "Restore Notices";
        confirmMessage =
            "Do you want to restore all ${noticeIds.length} notice(s)?";
        break;
      case "Delete All":
        apiAction = "permanent_delete";
        confirmTitle = "Delete Permanently";
        confirmMessage =
            "Do you want to permanently delete all ${noticeIds.length} notice(s)? This cannot be undone.";
        break;
      default:
        return;
    }

    final confirmed = await confirmAction(
      context,
      title: confirmTitle,
      message: confirmMessage,
    );

    if (!mounted || !confirmed) return;

    final success = await provider.bulkAction(
      action: apiAction,
      noticeIds: noticeIds,
    );

    if (!mounted) return;

    if (success) {
      _refreshNoticeList();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? "Bulk action failed")),
      );
    }
  }
}
