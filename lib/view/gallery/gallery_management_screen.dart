import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_status_badge.dart';
import 'package:storio_app/widget/universal/search_text_field.dart';
import 'package:storio_app/widget/universal/status_button_row.dart';

import '../../routes/routes_name.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../viewModel/Content/gallery_view_model.dart';
import '../../widget/custom_button/view_button.dart';
import '../../widget/universal/confirm_action.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/image_card.dart';
import '../../widget/universal/more_menu.dart';

class GalleryManageScreen extends StatefulWidget {
  const GalleryManageScreen({super.key});

  @override
  State<GalleryManageScreen> createState() => _GalleryManageScreenState();
}

class _GalleryManageScreenState extends State<GalleryManageScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<String> statusList = [
    "All Images",
    "Visible",
    "Hidden",
    "Uncategorized",
  ];

  final List<String> dropDownActionList = [
    "Bulk Action",
    "Make Visible",
    "Make Hidden",
    "Delete Selected",
  ];
  String selectedDropDownAction = "Bulk Action";

  int selectedStatus = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<GalleryViewModel>().getGalleryApi();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _refreshGalleryList() {
    final provider = context.read<GalleryViewModel>();

    bool? visible;
    String? album;

    switch (selectedStatus) {
      case 1:
        visible = true;
        break;
      case 2:
        visible = false;
        break;
      case 3:
        album = "uncategorized";
        break;
    }

    provider.getGalleryApi(search: searchController.text, visible: visible, album: album);
  }

  Future<void> _handleBulkAction(String action) async {
    final provider = context.read<GalleryViewModel>();

    final ids = provider.galleryList.map((e) => e.id).whereType<int>().toList();

    if (ids.isEmpty) return;

    String apiAction;
    String confirmTitle;
    String confirmMessage;

    switch (action) {
      case "Make Visible":
        apiAction = "show";
        confirmTitle = "Make Visible";
        confirmMessage = "Do you want to make all ${ids.length} image(s) visible?";
        break;
      case "Make Hidden":
        apiAction = "hide";
        confirmTitle = "Make Hidden";
        confirmMessage = "Do you want to hide all ${ids.length} image(s)?";
        break;
      case "Delete Selected":
        apiAction = "delete";
        confirmTitle = "Delete Images";
        confirmMessage = "Do you want to permanently delete all ${ids.length} image(s)? This cannot be undone.";
        break;
      default:
        return;
    }

    final confirmed = await confirmAction(context, title: confirmTitle, message: confirmMessage);

    if (!mounted || !confirmed) return;

    final success = await provider.bulkAction(action: apiAction, imageIds: ids);

    if (!mounted) return;

    if (success) {
      _refreshGalleryList();
    } else {
      SnackBarMessage.showSnackBar(context, provider.actionError ?? "Bulk action failed");
    }
  }

  String _formatFileSize(int? bytes) {
    if (bytes == null) return "—";
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Gallery Management",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(left: AppSizes.screenPadding, right: AppSizes.screenPadding, top: AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: SearchTextField(
                            onChanged: (value) => _refreshGalleryList(),
                            hinText: "Search...",
                            controller: searchController,
                          ),
                        ),
                        SizedBox(width: AppSizes.appbarGap),
                        CustomDropdown(
                          items: dropDownActionList,
                          initialValue: selectedDropDownAction,
                          height: 4.5.h,
                          width: 32.w,
                          onChanged: (value) {
                            if (value == "Bulk Action") {
                              setState(() {
                                selectedDropDownAction = value.toString();
                              });
                              return;
                            }

                            Future.delayed(const Duration(milliseconds: 200), () async {
                              if (!mounted) return;

                              final provider = context.read<GalleryViewModel>();

                              if (provider.galleryList.isEmpty) {
                                SnackBarMessage.showSnackBar(context, "No images to update");
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
                    SizedBox(height: AppSizes.smallGap),
                    Row(
                      children: [
                        Flexible(
                          child: StatusButtonRow(
                            items: statusList,
                            selectedIndex: selectedStatus,
                            onSelected: (index) {
                              setState(() {
                                selectedStatus = index;
                              });
                              _refreshGalleryList();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.sectionGap),
                  ],
                ),
              ]),
            ),
          ),
          Consumer<GalleryViewModel>(
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

              if (provider.galleryList.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text("No images found")),
                );
              }

              return SliverPadding(
                padding: EdgeInsetsGeometry.only(left: AppSizes.screenPadding, right: AppSizes.screenPadding, bottom: AppSizes.screenPadding),
                sliver: SliverList.builder(
                  itemCount: provider.galleryList.length,
                  itemBuilder: (context, index) {
                    final image = provider.galleryList[index];

                    return ImageCard(
                      image: image.mediaData?.file != null
                          ? Image.network(
                        image.mediaData!.file!,
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
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomStatusBadge(
                                title: (image.isVisible ?? true) ? "Visible" : "Hidden",
                                size: AppSizes.cardTitle,
                              ),
                              Row(
                                children: [
                                  ViewButton(onTap: () {}),
                                  SizedBox(width: AppSizes.smallGap),
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
                                            RoutesName.edit_gallery_image,
                                            arguments: {'image': image},
                                          );

                                          if (!mounted) return;

                                          if (result == true) {
                                            _refreshGalleryList();
                                          }
                                          break;

                                        case MoreMenuAction.delete:
                                          final confirmed = await confirmAction(
                                            context,
                                            title: "Delete Image",
                                            message: "Are you sure you want to permanently delete this image?",
                                          );

                                          if (!mounted || !confirmed) return;

                                          final provider2 = context.read<GalleryViewModel>();
                                          final success = await provider2.deleteGalleryImage(image.id!);

                                          if (!mounted) return;

                                          if (success) {
                                            _refreshGalleryList();
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
                          SizedBox(height: AppSizes.smallGap),
                          Row(
                            children: [
                              Icon(Icons.photo_album_outlined, color: color.primary, size: AppSizes.icon),
                              SizedBox(width: AppSizes.appbarGap),
                              TextTitleWidget(title: image.albumName ?? "Uncategorized", color: color.primary),
                            ],
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          Row(
                            children: [
                              Icon(Icons.image, color: color.primary, size: AppSizes.icon),
                              SizedBox(width: AppSizes.appbarGap),
                              Flexible(
                                child: Text(image.imageTitle ?? image.mediaData?.fileName ?? "Untitled"),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          Row(
                            children: [
                              Icon(Icons.image_aspect_ratio, color: color.primary, size: AppSizes.icon),
                              SizedBox(width: AppSizes.appbarGap),
                              Flexible(child: Text(_formatFileSize(image.mediaData?.fileSize))),
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
              Navigator.pushNamed(context, RoutesName.manage_album);
            },
            child: Icon(Icons.grid_view_rounded, color: color.cardBackground),
          ),
          SizedBox(height: AppSizes.itemGap),
          FloatingActionButton(
            heroTag: "add",
            backgroundColor: color.primary,
            onPressed: () async {
              final result = await Navigator.pushNamed(context, RoutesName.gallery_add_image);

              if (!mounted) return;

              if (result == true) {
                _refreshGalleryList();
              }
            },
            child: Icon(Icons.add, color: color.cardBackground),
          ),
        ],
      ),
    );
  }
}