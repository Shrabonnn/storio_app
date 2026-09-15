import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/custom_button/view_button.dart';
import 'package:storio_app/widget/universal/image_circle_widget.dart';
import 'package:storio_app/widget/universal/image_rectangle_widget.dart';

import '../../../routes/routes_name.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/snackbar_message.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../viewModel/organization/team_member_view_model.dart';

import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/textStyle/text_title_style.dart';
import '../../../widget/universal/confirm_action.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_status_badge.dart';
import '../../../widget/universal/more_menu.dart';
import '../../../widget/universal/search_text_field.dart';
import '../../../widget/universal/status_button_row.dart';

class TeamManagementScreen extends StatefulWidget {
  const TeamManagementScreen({super.key});

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen> {
  final TextEditingController searchController = TextEditingController();
  int selectedStatus = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<TeamViewModel>();
      viewModel.fetchManagementSections();
      viewModel.fetchManagementMembers();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterMembers(TeamViewModel viewModel) {
    int? sectionId;
    if (selectedStatus > 0 &&
        selectedStatus - 1 < viewModel.managementSections.length) {
      sectionId = viewModel.managementSections[selectedStatus - 1].id;
    }

    viewModel.fetchManagementMembers(
      search: searchController.text.trim(),
      sectionId: sectionId,
    );
  }

  void _refreshMemberList() {
    final viewModel = context.read<TeamViewModel>();
    _filterMembers(viewModel);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Consumer<TeamViewModel>(
      builder: (context, viewModel, child) {
        final List<String> statusList = [
          "All",
          ...viewModel.managementSections.map((s) => s.name ?? ""),
        ];

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              const CustomSliverAppBar(
                title: "Team Management",
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
                                controller: searchController,
                                hinText: "Search by name, title, role...",
                                onChanged: (value) {
                                  _filterMembers(viewModel);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.itemGap),
                        StatusButtonRow(
                          items: statusList,
                          selectedIndex: selectedStatus,
                          onSelected: (index) {
                            setState(() {
                              selectedStatus = index;
                            });
                            _filterMembers(viewModel);
                          },
                        ),
                        SizedBox(height: AppSizes.sectionGap),
                      ],
                    ),
                  ]),
                ),
              ),

              if (viewModel.isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (viewModel.managementMembers.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: TextBodyStyleWidget(title: "No team members found."),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: AppSizes.screenPadding,
                    right: AppSizes.screenPadding,
                  ),
                  sliver: SliverList.builder(
                    itemCount: viewModel.managementMembers.length,
                    itemBuilder: (context, index) {
                      final member = viewModel.managementMembers[index];
                      final bool isVisible = member.isVisible ?? false;

                      return Container(
                        margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                        child: CustomCard(
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  member.imageShape == 'square'
                                      ? ImageRectangleWidget(
                                    imgPath:
                                    member.imageData?.fileUrl ?? "",
                                    isNetwork: true,
                                  )
                                      : ImageCircleWidget(
                                    imgPath:
                                    member.imageData?.fileUrl ?? "",
                                    isNetwork: true,
                                  ),
                                  SizedBox(width: AppSizes.smallGap),

                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              TextTitleWidget(
                                                title: member.fullname ?? "",
                                                size: AppSizes.sectionTitle,
                                                color: color.primary,
                                              ),
                                              SizedBox(
                                                height: AppSizes.smallGap,
                                              ),
                                              TextBodyStyleWidget(
                                                title: "${member.role}",
                                                size: AppSizes.cardTitle,
                                                color: color.primary,
                                              ),
                                              SizedBox(
                                                height: AppSizes.smallGap,
                                              ),
                                              TextBodyStyleWidget(
                                                title:
                                                "${member.sectionName ?? ''}",
                                                size: AppSizes.cardTitle,
                                                color: color.primary,
                                              ),
                                            ],
                                          ),
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
                                                      RoutesName.view_team_manage,
                                                      arguments: {
                                                        'member':member
                                                      },
                                                    );
                                                  },
                                                ),
                                                SizedBox(
                                                  width: AppSizes.smallGap,
                                                ),
                                                MoreMenu(
                                                  items: [
                                                    MoreMenuAction.edit,
                                                    isVisible
                                                        ? MoreMenuAction.hide
                                                        : MoreMenuAction.show,
                                                    MoreMenuAction.delete,
                                                  ],
                                                  onSelected: (action) async {
                                                    switch (action) {
                                                      case MoreMenuAction.edit:
                                                        final result =
                                                        await Navigator.pushNamed(
                                                          context,
                                                          RoutesName.edit_team_member,
                                                          arguments: {
                                                            'isEdit': true,
                                                            'member': member,
                                                          },
                                                        );

                                                        if (!mounted) return;

                                                        if (result == true) {
                                                          _refreshMemberList();
                                                        }
                                                        break;

                                                      case MoreMenuAction.hide:
                                                      case MoreMenuAction.show:
                                                        if (member.id == null) return;

                                                        final teamViewModel = context.read<TeamViewModel>();
                                                        final newVisibility = !isVisible;

                                                        // updateTeamMember মেথড কল করে is_visible স্টেটমেন্ট আপডেট
                                                        final success = await teamViewModel.updateTeamMember(
                                                          member.id!,
                                                          {'is_visible': newVisibility},
                                                          isPartial: true,
                                                        );

                                                        if (!mounted) return;

                                                        if (success) {
                                                          SnackBarMessage.showSnackBar(
                                                            context,
                                                            newVisibility
                                                                ? "Member is now visible"
                                                                : "Member is now hidden",
                                                          );
                                                        } else {
                                                          SnackBarMessage.showSnackBar(
                                                            context,
                                                            teamViewModel.errorMessage ??
                                                                "Failed to update visibility",
                                                          );
                                                        }
                                                        break;

                                                      case MoreMenuAction.delete:
                                                        final confirmed =
                                                        await confirmAction(
                                                          context,
                                                          title: "Delete Member",
                                                          message:
                                                          "Are you sure you want to permanently delete this team member?",
                                                        );

                                                        if (!mounted || !confirmed) {
                                                          return;
                                                        }

                                                        if (member.id == null) return;

                                                        final teamViewModel = context.read<TeamViewModel>();

                                                        // ViewModel-এর সঠিক মেথড deleteTeamMember কল করা হয়েছে
                                                        final success = await teamViewModel.deleteTeamMember(member.id!);

                                                        if (!mounted) return;

                                                        if (success) {
                                                          SnackBarMessage.showSnackBar(
                                                            context,
                                                            "Team member deleted successfully",
                                                          );
                                                        } else {
                                                          SnackBarMessage.showSnackBar(
                                                            context,
                                                            teamViewModel.errorMessage ??
                                                                "Failed to delete member",
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
                                            SizedBox(height: AppSizes.itemGap),
                                            CustomStatusBadge(
                                              size: AppSizes.cardTitle,
                                              title: isVisible
                                                  ? "VISIBLE"
                                                  : "HIDDEN",
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              if (member.designation != null &&
                                  member.designation!.isNotEmpty) ...[
                                SizedBox(height: AppSizes.itemGap),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.file_copy_outlined,
                                      color: color.primary,
                                      size: AppSizes.icon,
                                    ),
                                    SizedBox(width: AppSizes.appbarGap),
                                    Flexible(
                                      child: TextBodyStyleWidget(
                                        title: member.designation!,
                                        color: color.primary,
                                        fontbold: false,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],

                              if (member.experience != null &&
                                  member.experience!.isNotEmpty) ...[
                                SizedBox(height: AppSizes.appbarGap),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.workspace_premium,
                                      color: color.primary,
                                      size: AppSizes.icon,
                                    ),
                                    SizedBox(width: AppSizes.appbarGap),
                                    Flexible(
                                      child: TextBodyStyleWidget(
                                        title: member.experience!,
                                        color: color.primary,
                                        fontbold: false,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),




              //space

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
                        SizedBox(height: 15.h),

                      ],
                    ),
                  ]),
                ),
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
                  Navigator.pushNamed(context, RoutesName.manage_team_section);
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
                    RoutesName.add_new_team_member,
                  );
                  if (result == true) {
                    _refreshMemberList();
                  }
                },
                child: Icon(Icons.add, color: color.cardBackground),
              ),
            ],
          ),
        );
      },
    );
  }
}