import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/custom_button/view_button.dart';
import 'package:storio_app/widget/universal/search_text_field.dart';

import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../viewModel/Content/blog_view_model.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/confirm_action.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_status_badge.dart';
import '../../widget/universal/date_time_formate.dart';
import '../../widget/universal/image_card.dart';
import '../../widget/universal/more_menu.dart';
import '../../widget/universal/status_button_row.dart';

class BlogManagementScreen extends StatefulWidget {
  const BlogManagementScreen({super.key});

  @override
  State<BlogManagementScreen> createState() => _BlogManagementScreenState();
}

class _BlogManagementScreenState extends State<BlogManagementScreen> {
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
      final provider = context.read<BlogViewModel>();
      await provider.getStatusChoices();
      await provider.getBlogApi();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Blog Management",
            showBackButton: true,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: SearchTextField(
                            onChanged: (value) {
                              final provider = context.read<BlogViewModel>();
                              final statusValue = selectedStatus == 0
                                  ? null
                                  : provider.statusChoices[selectedStatus - 1].value;

                              provider.getBlogApi(status: statusValue, search: value);
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

                              final provider = context.read<BlogViewModel>();

                              if (provider.blogList.isEmpty) {
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
                    Consumer<BlogViewModel>(
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
                          ...provider.statusChoices.map((e) => e.label ?? ""),
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

                            provider.getBlogApi(
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
          Consumer<BlogViewModel>(
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

              if (provider.blogList.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Text("No blog posts found"),
                  ),
                );
              }

              return SliverPadding(
                padding: EdgeInsets.only(
                  left: AppSizes.screenPadding,
                  right: AppSizes.screenPadding,
                ),
                sliver: SliverList.builder(
                  itemCount: provider.blogList.length,
                  itemBuilder: (context, index) {
                    final blog = provider.blogList[index];

                    return ImageCard(
                      image: blog.featuredImageData?.file != null
                          ? Image.network(
                        blog.featuredImageData!.file!,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomStatusBadge(
                                title: blog.statusDisplay ?? blog.status ?? "",
                                size: AppSizes.cardTitle,
                              ),
                              Row(
                                children: [
                                  ViewButton(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RoutesName.view_blog,
                                        arguments: {'blog': blog},
                                      );
                                    },
                                  ),
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
                                            RoutesName.edit_blog,
                                            arguments: {'blog': blog},
                                          );

                                          if (!mounted) return;

                                          if (result == true) {
                                            _refreshBlogList();
                                          }
                                          break;

                                      // Reused as "Move to Bin" for blog posts
                                        case MoreMenuAction.archive:

                                          break;

                                        case MoreMenuAction.delete:
                                          final confirmed = await confirmAction(
                                            context,
                                            title: "Delete Blog Post",
                                            message: "Are you sure you want to permanently delete this blog post?",
                                          );

                                          if (!mounted || !confirmed) return;

                                          final provider2 = context.read<BlogViewModel>();
                                          final success2 = await provider2.deleteBlog(blog.id!);

                                          if (!mounted) return;

                                          if (success2) {
                                            _refreshBlogList();
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(provider2.errorMessage ?? "Failed to delete")),
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
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.smallGap),
                          TextTitleWidget(
                            title: blog.title ?? "",
                            color: color.primary,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          TextBodyStyleWidget(
                            title: blog.excerpt?.isNotEmpty == true ? blog.excerpt! : (blog.content ?? ""),
                            maxLines: 4,
                          ),
                          SizedBox(height: AppSizes.smallGap),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person, size: AppSizes.icon,color: color.primary,),
                                  SizedBox(width: AppSizes.appbarGap),
                                  TextBodyStyleWidget(title: blog.author ?? ""),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.calendar_month_outlined, size: AppSizes.icon,color: color.primary,),
                                  SizedBox(width: AppSizes.appbarGap),
                                  TextBodyStyleWidget(
                                    title: blog.publishDate != null
                                        ? formatDate(blog.publishDate!)
                                        : (blog.createDate != null ? formatDate(blog.createDate!) : ""),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
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
            heroTag: "addCategory",
            backgroundColor: color.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.manage_blog_category);
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
              final result = await Navigator.pushNamed(context, RoutesName.add_blog);

              if (!mounted) return;

              if (result == true) {
                _refreshBlogList();
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

  void _refreshBlogList() {
    final provider = context.read<BlogViewModel>();
    provider.getBlogApi(
      status: selectedStatus == 0 ? null : provider.statusChoices[selectedStatus - 1].value,
      search: searchController.text,
    );
  }

  Future<void> _handleBulkAction(String action) async {
    final provider = context.read<BlogViewModel>();

    final postIds = provider.blogList
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
      _refreshBlogList();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage ?? "Bulk action failed")),
      );
    }
  }
}