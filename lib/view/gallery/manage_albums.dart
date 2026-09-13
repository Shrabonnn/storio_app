import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_sizes.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/gallery_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/confirm_action.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_text_field.dart';

class ManageAlbums extends StatefulWidget {
  const ManageAlbums({super.key});

  @override
  State<ManageAlbums> createState() => _ManageAlbumsState();
}

class _ManageAlbumsState extends State<ManageAlbums> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  int? selectedParentId;
  int? editingAlbumId;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<GalleryViewModel>().getAlbumApi();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _startEditing(
      int id,
      String? name,
      String? description,
      int? parent,
      ) {
    setState(() {
      editingAlbumId = id;
      nameController.text = name ?? '';
      descriptionController.text = description ?? '';
      selectedParentId = parent;
    });
  }

  void _resetForm() {
    setState(() {
      editingAlbumId = null;
      selectedParentId = null;
      nameController.clear();
      descriptionController.clear();
    });
  }

  Future<void> _handleSaveAlbum() async {
    if (nameController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(
        context,
        "Please enter an album name",
      );
      return;
    }

    final provider = context.read<GalleryViewModel>();

    setState(() {
      isSaving = true;
    });

    final data = <String, dynamic>{
      "name": nameController.text.trim(),
      "description": descriptionController.text.trim(),
      "parent": selectedParentId,
    };

    final success = editingAlbumId != null
        ? await provider.updateAlbum(
      editingAlbumId!,
      data,
    )
        : await provider.createAlbum(
      data,
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success != null) {
      SnackBarMessage.showSnackBar(
        context,
        editingAlbumId != null
            ? "Album updated"
            : "Album added",
      );

      _resetForm();
      provider.getAlbumApi();
    } else {
      SnackBarMessage.showSnackBar(
        context,
        provider.albumErrorMessage ?? "Failed to save album",
      );
    }
  }

  Future<void> _handleDeleteAlbum(
      int id,
      String name,
      ) async {
    final confirmed = await confirmAction(
      context,
      title: "Delete Album",
      message: "Are you sure you want to delete '$name'?",
    );

    if (!mounted || !confirmed) return;

    final provider = context.read<GalleryViewModel>();

    final success = await provider.deleteAlbum(id);

    if (!mounted) return;

    if (success) {
      if (editingAlbumId == id) {
        _resetForm();
      }

      provider.getAlbumApi();
    } else {
      SnackBarMessage.showSnackBar(
        context,
        provider.albumErrorMessage ?? "Failed to delete album",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Manage Albums",
            showBackButton: true,
          ),

          SliverPadding(
            padding: EdgeInsets.all(
              AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: [
                      // =========================
                      // CREATE / EDIT ALBUM
                      // =========================
                      CustomCard(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            TextTitleWidget(
                              title: editingAlbumId != null
                                  ? "Edit Album"
                                  : "Manage Album",
                              size: AppSizes.sectionTitle,
                              color: color.primary,
                            ),

                            SizedBox(
                              height: AppSizes.sectionGap,
                            ),

                            // Name
                            TextBodyStyleWidget(
                              title: "Name",
                              color: color.primary,
                              size: AppSizes.cardTitle,
                            ),

                            SizedBox(
                              height: AppSizes.appbarGap,
                            ),

                            CustomTextFieldWidget(
                              hintText: "New Album",
                              controller: nameController,
                            ),

                            SizedBox(
                              height: AppSizes.itemGap,
                            ),

                            // Description
                            TextBodyStyleWidget(
                              title: "Description",
                              color: color.primary,
                              size: AppSizes.cardTitle,
                            ),

                            SizedBox(
                              height: AppSizes.appbarGap,
                            ),

                            CustomTextFieldWidget(
                              hintText:
                              "Write your album description",
                              controller: descriptionController,
                              minLines: 3,
                              maxLines: 5,
                            ),

                            SizedBox(
                              height: AppSizes.itemGap,
                            ),

                            // Parent Album
                            TextBodyStyleWidget(
                              title: "Parent Album (Optional)",
                              color: color.primary,
                              size: AppSizes.cardTitle,
                            ),

                            SizedBox(
                              height: AppSizes.appbarGap,
                            ),

                            Consumer<GalleryViewModel>(
                              builder: (
                                  context,
                                  provider,
                                  child,
                                  ) {
                                if (provider.albumLoading) {
                                  return const Center(
                                    child:
                                    CircularProgressIndicator(),
                                  );
                                }

                                final selectableAlbums =
                                provider.albumList
                                    .where(
                                      (album) =>
                                  album.id !=
                                      editingAlbumId,
                                )
                                    .toList();

                                final labels = [
                                  "No Parent",
                                  ...selectableAlbums.map(
                                        (album) =>
                                    album.name ?? "",
                                  ),
                                ];

                                String currentLabel =
                                    "No Parent";

                                if (selectedParentId != null) {
                                  final parentAlbum =
                                  selectableAlbums
                                      .where(
                                        (album) =>
                                    album.id ==
                                        selectedParentId,
                                  )
                                      .toList();

                                  if (parentAlbum.isNotEmpty) {
                                    currentLabel =
                                        parentAlbum.first.name ??
                                            "No Parent";
                                  }
                                }

                                return CustomDropdown(
                                  items: labels,
                                  initialValue: currentLabel,

                                  // Important:
                                  // Don't use 100.w here.
                                  width: double.infinity,

                                  height: 4.5.h,
                                  onChanged: (value) {
                                    if (value == "No Parent") {
                                      setState(() {
                                        selectedParentId = null;
                                      });
                                      return;
                                    }

                                    final matchedAlbum =
                                    selectableAlbums
                                        .where(
                                          (album) =>
                                      album.name ==
                                          value,
                                    )
                                        .toList();

                                    if (matchedAlbum.isNotEmpty) {
                                      setState(() {
                                        selectedParentId =
                                            matchedAlbum.first.id;
                                      });
                                    }
                                  },
                                );
                              },
                            ),

                            SizedBox(
                              height: AppSizes.sectionGap,
                            ),

                            // Buttons
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.end,
                              children: [
                                if (editingAlbumId != null) ...[
                                  CustomButton(
                                    text: "Cancel",
                                    width: 25.w,
                                    backgroundColor:
                                    color.cardBackground,
                                    foregroundColor:
                                    color.primary,
                                    onTap: isSaving
                                        ? null
                                        : _resetForm,
                                  ),

                                  SizedBox(
                                    width: AppSizes.smallGap,
                                  ),
                                ],

                                CustomButton(
                                  text: isSaving
                                      ? "Saving..."
                                      : editingAlbumId != null
                                      ? "Update Album"
                                      : "Add Album",
                                  width: 30.w,
                                  onTap: isSaving
                                      ? null
                                      : _handleSaveAlbum,
                                ),
                              ],
                            ),

                            SizedBox(
                              height: AppSizes.appbarGap,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: AppSizes.sectionGap,
                      ),

                      // =========================
                      // EXISTING ALBUMS
                      // =========================
                      Consumer<GalleryViewModel>(
                        builder: (
                            context,
                            provider,
                            child,
                            ) {
                          return CustomCard(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                TextTitleWidget(
                                  title:
                                  "Existing Albums (${provider.albumList.length})",
                                  color: color.primary,
                                  size:
                                  AppSizes.sectionTitle,
                                ),

                                SizedBox(
                                  height: AppSizes.itemGap,
                                ),

                                if (provider.albumLoading)
                                  const Padding(
                                    padding:
                                    EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Center(
                                      child:
                                      CircularProgressIndicator(),
                                    ),
                                  )

                                else if (
                                provider.albumErrorMessage !=
                                    null)
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child:
                                    TextBodyStyleWidget(
                                      title: provider
                                          .albumErrorMessage!,
                                      color: Colors.red,
                                    ),
                                  )

                                else if (
                                  provider.albumList.isEmpty)
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child:
                                      TextBodyStyleWidget(
                                        title:
                                        "No albums yet",
                                        color:
                                        color.primary,
                                      ),
                                    )

                                  else
                                    ListView.separated(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics:
                                      const NeverScrollableScrollPhysics(),
                                      itemCount:
                                      provider.albumList.length,
                                      separatorBuilder:
                                          (context, index) =>
                                      const Divider(),
                                      itemBuilder:
                                          (context, index) {
                                        final album =
                                        provider.albumList[
                                        index];

                                        return CustomCard2(
                                          child: Padding(
                                            padding:
                                            EdgeInsets.all(
                                              AppSizes
                                                  .smallPadding,
                                            ),
                                            child: Row(
                                              children: [
                                                // Album information
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      TextTitleWidget(
                                                        title:
                                                        "${album.name ?? ''} (${album.totalImages ?? 0})",
                                                        color: color
                                                            .primary,
                                                        maxLines: 1,
                                                      ),

                                                      SizedBox(
                                                        height: AppSizes
                                                            .appbarGap,
                                                      ),

                                                      TextBodyStyleWidget(
                                                        title:
                                                        (album
                                                            .description
                                                            ?.isNotEmpty ==
                                                            true)
                                                            ? album
                                                            .description!
                                                            : "/${album.slug ?? ''}",
                                                        maxLines: 2,
                                                        size: AppSizes
                                                            .cardTitle,
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                SizedBox(
                                                  width: AppSizes
                                                      .smallGap,
                                                ),

                                                // Edit
                                                IconButton(
                                                  onPressed:
                                                  album.id ==
                                                      null
                                                      ? null
                                                      : () =>
                                                      _startEditing(
                                                        album.id!,
                                                        album.name,
                                                        album.description,
                                                        album.parent,
                                                      ),
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: color
                                                        .primary,
                                                    size: AppSizes
                                                        .iconLarge,
                                                  ),
                                                ),

                                                // Delete
                                                IconButton(
                                                  onPressed:
                                                  album.id ==
                                                      null
                                                      ? null
                                                      : () =>
                                                      _handleDeleteAlbum(
                                                        album.id!,
                                                        album.name ??
                                                            '',
                                                      ),
                                                  icon: Icon(
                                                    Icons
                                                        .delete_outline,
                                                    color:
                                                    Colors.red,
                                                    size: AppSizes
                                                        .iconLarge,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                              ],
                            ),
                          );
                        },
                      ),

                      SizedBox(
                        height: AppSizes.appbarGap,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}