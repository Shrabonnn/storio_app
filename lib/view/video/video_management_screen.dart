import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/image_card.dart';

import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../utils/snackbar_message.dart';
import '../../viewModel/Content/reel_view_model.dart';
import '../../widget/skeleton/custom_skeleton_card.dart';
import '../../widget/universal/confirm_action.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_status_badge.dart';
import '../../widget/universal/search_text_field.dart';
import '../../widget/universal/status_button_row.dart';

class VideoManagementScreen extends StatefulWidget {
  const VideoManagementScreen({super.key});

  @override
  State<VideoManagementScreen> createState() => _VideoManagementScreenState();
}

class _VideoManagementScreenState extends State<VideoManagementScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<String> statusList = ["All Content", "Long Form", "Reels"];

  int selectedStatus = 0;

  // index -> API "type" filter value
  String? _typeForIndex(int index) {
    switch (index) {
      case 1:
        return "video"; // Long Form
      case 2:
        return "reel"; // Reels
      default:
        return null; // All Content
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ReelViewModel>().getReelApi(isFilterOrSearch: false);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _refreshReelList() {
    final provider = context.read<ReelViewModel>();
    provider.getReelApi(
      type: _typeForIndex(selectedStatus),
      search: searchController.text,
      isFilterOrSearch: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Video Management",
            subtitle: "Reels & Media",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(
              left: AppSizes.screenPadding,
              top: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
            ),
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

                        context.read<ReelViewModel>().getReelApi(
                          type: _typeForIndex(index),
                          search: searchController.text,
                          isFilterOrSearch: true,
                        );
                      },
                    ),
                    SizedBox(height: AppSizes.sectionGap),
                    Row(
                      children: [
                        Expanded(
                          child: SearchTextField(
                            onChanged: (value) {
                              context.read<ReelViewModel>().getReelApi(
                                type: _typeForIndex(selectedStatus),
                                search: value,
                                isFilterOrSearch: true,
                              );
                            },
                            hinText: 'Search videos...',
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
          Consumer<ReelViewModel>(
            builder: (context, provider, child) {
              if (provider.loading) {
                return SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding,
                    vertical: AppSizes.sectionGap,
                  ),
                  sliver: SliverList.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) => const CustomSkeletonCard(),
                  ),
                );
              }

              if (provider.errorMessage != null) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.sectionGap,
                    ),
                    child: Center(child: Text(provider.errorMessage!)),
                  ),
                );
              }

              if (provider.reelList.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.sectionGap,
                    ),
                    child: const Center(child: Text("No videos found")),
                  ),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.screenPadding,
                  vertical: AppSizes.sectionGap,
                ),
                sliver: SliverList.builder(
                  itemCount: provider.reelList.length,
                  itemBuilder: (context, index) {
                    final reel = provider.reelList[index];

                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSizes.itemGap),
                      child: ImageCard(
                        image: (reel.thumbnail != null &&
                            reel.thumbnail!.isNotEmpty)
                            ? Image.network(
                          reel.thumbnail!,
                          width: double.infinity,
                          height: 18.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextTitleWidget(
                                    title: reel.title ?? "",
                                    color: color.primary,
                                  ),
                                ),
                                CustomStatusBadge(
                                  title: reel.status == "active"
                                      ? "Active"
                                      : "Draft",
                                  size: AppSizes.cardTitle,
                                ),
                              ],
                            ),
                            SizedBox(height: AppSizes.itemGap),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.remove_red_eye_outlined,
                                      size: AppSizes.icon,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: AppSizes.appbarGap),
                                    TextBodyStyleWidget(
                                      title: "${reel.views ?? 0}",
                                    ),
                                    SizedBox(width: AppSizes.itemGap),
                                    Icon(
                                      Icons.favorite_border_outlined,
                                      size: AppSizes.icon,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: AppSizes.appbarGap),
                                    TextBodyStyleWidget(
                                      title: "${reel.likes ?? 0}",
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final result =
                                        await Navigator.pushNamed(
                                          context,
                                          RoutesName.add_new_video,
                                          arguments: {
                                            "isEdit": true,
                                            "reel": reel,
                                          },
                                        );

                                        if (!mounted) return;

                                        if (result == true) {
                                          _refreshReelList();
                                        }
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        size: AppSizes.iconLarge,
                                        color: color.primary,
                                      ),
                                    ),
                                    SizedBox(width: AppSizes.smallGap),
                                    InkWell(
                                      onTap: () async {
                                        final confirmed = await confirmAction(
                                          context,
                                          title: "Delete Video",
                                          message:
                                          "Are you sure you want to permanently delete this video?",
                                        );

                                        if (!mounted || !confirmed) return;

                                        final success = await context
                                            .read<ReelViewModel>()
                                            .deleteReel(reel.id!);

                                        if (!mounted) return;

                                        if (success) {
                                          _refreshReelList();
                                        } else {
                                          SnackBarMessage.showSnackBar(
                                            context,
                                            context
                                                .read<ReelViewModel>()
                                                .errorMessage ??
                                                "Failed to delete",
                                          );
                                        }
                                      },
                                      child: Icon(
                                        Icons.delete_outline_outlined,
                                        size: AppSizes.iconLarge,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
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
                RoutesName.add_new_video,
              );

              if (!mounted) return;

              if (result == true) {
                _refreshReelList();
              }
            },
            child: Icon(Icons.add, color: color.cardBackground),
          ),
        ],
      ),
    );
  }
}