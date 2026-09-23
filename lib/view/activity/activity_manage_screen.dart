import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';
import 'package:storio_app/widget/custom_button/view_button.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/universal/bottom_height_widget.dart';
import 'package:storio_app/widget/universal/custom_status_badge.dart';
import 'package:storio_app/widget/universal/more_menu.dart';

import '../../routes/routes_name.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../viewModel/Content/activity_view_model.dart';
import '../../widget/universal/confirm_action.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/image_card.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/search_text_field.dart';
import '../../widget/universal/status_button_row.dart';

class ActivityManageScreen extends StatefulWidget {
  const ActivityManageScreen({super.key});

  @override
  State<ActivityManageScreen> createState() => _ActivityManageScreenState();
}

class _ActivityManageScreenState extends State<ActivityManageScreen> {
  final TextEditingController searchController = TextEditingController();

  int selectedStatus = 0;

  final List<String> dropDownStatusList = [
    "Bulk Action",
    "Publish Selected",
    "Move to Drafts",
    "Move to Bin",
  ];
  String selectedDropDownList = "Bulk Action";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<ActivityViewModel>();
      await provider.getStatusChoices();
      await provider.getActivityApi();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _refreshActivityList() {
    final provider = context.read<ActivityViewModel>();
    provider.getActivityApi(
      status: selectedStatus == 0 ? null : provider.statusChoices[selectedStatus - 1].value,
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
            title: "Activity Manage",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(top: AppSizes.screenPadding, left: AppSizes.screenPadding, right: AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SearchTextField(
                            onChanged: (value) {
                              final provider = context.read<ActivityViewModel>();
                              final statusValue = selectedStatus == 0
                                  ? null
                                  : provider.statusChoices[selectedStatus - 1].value;

                              provider.getActivityApi(status: statusValue, search: value);
                            },
                            hinText: "Search",
                            controller: searchController,
                          ),
                        ),
                        SizedBox(width: AppSizes.appbarGap),
                        CustomDropdown(
                          items: dropDownStatusList,
                          initialValue: selectedDropDownList,
                          width: 32.w,
                          height: 4.5.h,
                          onChanged: (value) {
                            if (value == "Bulk Action") {
                              setState(() {
                                selectedDropDownList = value.toString();
                              });
                              return;
                            }

                            Future.delayed(const Duration(milliseconds: 200), () async {
                              if (!mounted) return;

                              final provider = context.read<ActivityViewModel>();

                              if (provider.activityList.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("No blog posts to update")),
                                );
                                return;
                              }

                              await _handleBulkAction(value.toString());

                              if (!mounted) return;
                              setState(() {
                                selectedDropDownList = "Bulk Action";
                              });
                            });
                          },
                        ),


                      ],
                    ),
                    SizedBox(height: AppSizes.smallGap),
                    Consumer<ActivityViewModel>(
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

                            provider.getActivityApi(status: statusValue, search: searchController.text);
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
          Consumer<ActivityViewModel>(
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

              if (provider.activityList.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text("No activity posts found")),
                );
              }

              return SliverPadding(
                padding: EdgeInsetsGeometry.only(left: AppSizes.screenPadding, right: AppSizes.screenPadding),
                sliver: SliverList.builder(
                  itemCount: provider.activityList.length,
                  itemBuilder: (context, index) {
                    final activity = provider.activityList[index];
                    final categoryName =
                    (activity.categoriesData != null && activity.categoriesData!.isNotEmpty)
                        ? activity.categoriesData!.first.name ?? "—"
                        : "—";

                    return ImageCard(
                      image: activity.featuredImageData?.file != null
                          ? Image.network(
                        activity.featuredImageData!.file!,
                        width: double.infinity,
                        height: 18.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          "assets/images/institute.png",
                          width: double.infinity,
                          height: 18.h,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Image.asset(
                        "assets/images/institute.png",
                        width: double.infinity,
                        height: 18.h,
                        fit: BoxFit.cover,
                      ),
                      status: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomStatusBadge(
                            title: (activity.statusDisplay ?? activity.status)!.toUpperCase() ?? "",
                            size: AppSizes.sectionTitle,
                          ),
                          Row(
                            children: [
                              ViewButton(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RoutesName.view_notice,
                                    arguments: {'activity': activity},
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
                                      final result = await Navigator.pushNamed(
                                         context,
                                         RoutesName.edit_activity_manage_details,
                                         arguments: {'activity': activity},
                                       );

                                       if (!mounted) return;

                                       if (result == true) {
                                         _refreshActivityList();
                                       }
                                      break;

                                    case MoreMenuAction.delete:
                                      final confirmed = await confirmAction(
                                        context,
                                        title: "Delete Activity",
                                        message: "Are you sure you want to permanently delete this activity post?",
                                      );

                                      if (!mounted || !confirmed) return;

                                      final provider2 = context.read<ActivityViewModel>();
                                      final success = await provider2.deleteActivity(activity.id!);

                                      if (!mounted) return;

                                      if (success) {
                                        _refreshActivityList();
                                      } else {
                                        SnackBarMessage.showSnackBar(
                                          context,
                                          provider2.actionError ?? "Failed to delete",
                                        );
                                      }
                                      break;

                                    case MoreMenuAction.view:
                                      break;

                                    case MoreMenuAction.archive:
                                    case MoreMenuAction.changePassword:
                                    case MoreMenuAction.suspend:
                                      break;
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

                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSizes.smallPadding),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [

                            TextBodyStyleWidget(
                              title: activity.title ?? "",
                              size: AppSizes.sectionTitle,
                              color: color.textPrimary,
                            ),

                            SizedBox(height: AppSizes.smallGap,),
                            Row(
                              children: [
                                Icon(Icons.category, color: color.primary, size: AppSizes.icon),
                                SizedBox(width: AppSizes.appbarGap),
                                TextBodyStyleWidget(
                                  title: "Category",
                                  size: AppSizes.cardTitle,

                                ),
                                const Spacer(),
                                TextBodyStyleWidget(title:categoryName),
                              ],
                            ),
                            SizedBox(height: AppSizes.appbarGap),
                            Row(
                              children: [
                                Icon(Icons.person, color: color.primary, size: AppSizes.icon),
                                SizedBox(width: AppSizes.appbarGap),
                                TextBodyStyleWidget(
                                  title: "Author",
                                  size: AppSizes.cardTitle,

                                ),
                                const Spacer(),
                                TextBodyStyleWidget(title:activity.author ?? "—"),
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
          BottomHeightWidget(),

        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "addCategory",
            backgroundColor: color.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.activity_manage_category);
            },
            child: Icon(Icons.grid_view_rounded, color: color.cardBackground),
          ),
          SizedBox(height: AppSizes.itemGap),
          FloatingActionButton(
            heroTag: "add",
            backgroundColor: color.primary,
            onPressed: () async {
              final result = await Navigator.pushNamed(context, RoutesName.activity_manage_details);

              if (!mounted) return;

              if (result == true) {
                _refreshActivityList();
              }
            },
            child: Icon(Icons.add, color: color.cardBackground),
          ),
        ],
      ),
    );
  }


  Future<void> _handleBulkAction(String action) async {
    final provider = context.read<ActivityViewModel>();

    final postIds = provider.activityList
        .map((blog) => blog.id)
        .whereType<int>()
        .toList();

    if (postIds.isEmpty) return;

    String apiAction;
    String confirmTitle;
    String confirmMessage;

    switch (action) {
      case "Publish Selected":
        apiAction = "publish";
        confirmTitle = "Publish Blog Posts";
        confirmMessage = "Do you want to publish all ${postIds.length} blog post(s)?";
        break;
      case "Move to Drafts":
        apiAction = "draft";
        confirmTitle = "Move to Draft";
        confirmMessage = "Do you want to move all ${postIds.length} blog post(s) to draft?";
        break;
      case "Move to Bin":
        apiAction = "delete";
        confirmTitle = "Move to Bin";
        confirmMessage = "Do you want to move all ${postIds.length} blog post(s) to bin?";
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

    final success = await provider.bulkAction(action: apiAction, postIds: postIds);

    if (!mounted) return;

    if (success) {
      _refreshActivityList();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? "Bulk action failed")),
      );
    }
  }
}