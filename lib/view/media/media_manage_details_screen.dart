import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_sizes.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';

import '../../viewModel/Media/media_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_image_picker.dart';
import '../../widget/universal/custom_text_field.dart';

class MediaManageDetailsScreen extends StatefulWidget {
  const MediaManageDetailsScreen({
    super.key,
  });


  @override
  State<MediaManageDetailsScreen> createState() =>
      _MediaManageDetailsScreenState();
}

class _MediaManageDetailsScreenState extends State<MediaManageDetailsScreen> {

  int? _initialAttachmentId;
  String? _initialAttachmentUrl;
  bool _initialSelectionApplied = false;

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController captionController = TextEditingController();
  final TextEditingController altTextController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  bool isUploadSelected = false;

  String? selectedFileTypeLabel;
  String? selectedFileTypeFilter;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await context.read<MediaViewModel>().getMediaList();
      context.read<MediaViewModel>().getFileTypeChoices();

      _applyInitialSelection();
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialSelectionApplied) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is Map<String, dynamic>) {
        _initialAttachmentId = args['currentId'] as int?;
        _initialAttachmentUrl = args['currentFileUrl'] as String?;
      }

      _initialSelectionApplied = true;
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    titleController.dispose();
    captionController.dispose();
    altTextController.dispose();
    searchController.dispose();



    super.dispose();
  }

  // ============================================================
  // Use Selected File


  void _applyInitialSelection() {
    debugPrint("INITIAL ATTACHMENT ID: $_initialAttachmentId");

    if (_initialAttachmentId == null) return;
    if (!mounted) return;

    final viewModel = context.read<MediaViewModel>();

    debugPrint("LIBRARY ITEMS COUNT: ${viewModel.libraryItems.length}");
    debugPrint("LIBRARY ITEM IDS: ${viewModel.libraryItems.map((e) => e.id).toList()}");

    final match = viewModel.libraryItems.where(
          (item) => item.id == _initialAttachmentId,
    );

    debugPrint("MATCH FOUND: ${match.isNotEmpty}");

    if (match.isEmpty) return;

    final item = match.first;

    viewModel.selectFromLibrary(item);

    titleController.text = item.title ?? '';
    descriptionController.text = item.description ?? '';
    captionController.text = item.caption ?? '';
    altTextController.text = item.altText ?? '';

    setState(() {
      isUploadSelected = false;
    });
  }

  Future<void> _useSelectedFile() async {
    final viewModel = context.read<MediaViewModel>();

    if (isUploadSelected) {
      if (viewModel.selectedLocalFile == null) {
        SnackBarMessage.showSnackBar(context, "Please select an image");
        return;
      }

      final localFile = viewModel.selectedLocalFile!; // pop এর আগে save রাখো
      final media = await viewModel.uploadMedia(
        file: localFile,
        title: titleController.text.trim().isEmpty ? null : titleController.text.trim(),
        description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
        altText: altTextController.text.trim().isEmpty ? null : altTextController.text.trim(),
        caption: captionController.text.trim().isEmpty ? null : captionController.text.trim(),
      );

      if (!mounted) return;

      if (media != null) {
        Navigator.pop(context, {
          "id": media.id,
          "file": media.file,
          "localPath": localFile.path
        });
      } else {
        SnackBarMessage.showSnackBar(
          context,
          viewModel.uploadError ?? "Upload failed",
        );
      }
    } else {
      if (viewModel.selectedLibraryMedia == null) {
        SnackBarMessage.showSnackBar(
          context,
          "Please select an image from library",
        );
        return;
      }

      Navigator.pop(context, {
        "id": viewModel.selectedLibraryMedia!.id,
        "file": viewModel.selectedLibraryMedia!.file,
      });
    }
  }




  // Delete Selected

  Future<void> _deleteSelected() async {
    final viewModel = context.read<MediaViewModel>();
    final selected = viewModel.selectedLibraryMedia;

    if (selected?.id == null) {
      SnackBarMessage.showSnackBar(context, "Please select a file to delete");
      return;
    }

    final success = await viewModel.deleteMedia(selected!.id!);

    if (!mounted) return;

    if (success) {
      SnackBarMessage.showSnackBar(context, "File deleted");
      titleController.clear();
      descriptionController.clear();
      captionController.clear();
      altTextController.clear();
    } else {
      SnackBarMessage.showSnackBar(
        context,
        viewModel.deleteError ?? "Delete failed",
      );
    }
  }

   // Delete Selected
  Future<void> _updateSelected() async {
    final viewModel = context.read<MediaViewModel>();
    final selected = viewModel.selectedLibraryMedia;

    if (selected?.id == null) {
      SnackBarMessage.showSnackBar(context, "Please select a file to update");
      return;
    }

    final success = await viewModel.updateMedia(
      id: selected!.id!,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      altText: altTextController.text.trim(),
      caption: captionController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      SnackBarMessage.showSnackBar(context, "File updated");
    } else {
      SnackBarMessage.showSnackBar(
        context,
        viewModel.updateError ?? "Update failed",
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
            title: "Media Manage Details",
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
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 4.5.h,
                                  child: TextField(
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      hintText: "Search...",
                                      prefixIcon: const Icon(
                                        Icons.search,
                                      ),
                                      filled: true,
                                      fillColor:
                                      color.cardBackground,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                          AppSizes.buttonRadius,
                                        ),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    onSubmitted: (value) {
                                      context.read<MediaViewModel>().getMediaList(
                                        search: value.trim(),
                                        fileType: selectedFileTypeFilter,
                                      );
                                    },
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: AppSizes.appbarGap,
                              ),

                              // ---------------- Dynamic File Type Dropdown ----------------
                              Consumer<MediaViewModel>(
                                builder: (context, viewModel, child) {
                                  if (viewModel.fileTypesLoading) {
                                    return SizedBox(
                                      height: 4.5.h,
                                      width: 25.w,
                                      child: const Center(
                                        child: SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  final choices = viewModel.fileTypeChoices;

                                  if (choices.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  final labels =
                                  choices.map((e) => e["label"]!).toList();

                                  return CustomDropdown(
                                    items: labels,
                                    initialValue:
                                    selectedFileTypeLabel ?? labels.first,
                                    width: 25.w,
                                    height: 4.5.h,
                                    onChanged: (value) {
                                      final matched = choices.firstWhere(
                                            (item) => item["label"] == value,
                                      );

                                      setState(() {
                                        selectedFileTypeLabel = matched["label"];
                                        selectedFileTypeFilter =
                                        (matched["value"]!.isEmpty)
                                            ? null
                                            : matched["value"];
                                      });

                                      context.read<MediaViewModel>().getMediaList(
                                        search: searchController.text.trim(),
                                        fileType: selectedFileTypeFilter,
                                      );

                                      debugPrint(
                                        "Selected media type: $selectedFileTypeFilter",
                                      );
                                    },
                                  );
                                },
                              ),

                              SizedBox(
                                width: AppSizes.appbarGap,
                              ),

                              Container(
                                height: 4.5.h,
                                width: 25.w,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius:
                                  BorderRadius.circular(
                                    AppSizes.buttonRadius,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Upload
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isUploadSelected = true;
                                          });

                                          context
                                              .read<MediaViewModel>()
                                              .clearSelection();
                                        },
                                        child: AnimatedContainer(
                                          duration:
                                          const Duration(
                                            milliseconds: 200,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isUploadSelected
                                                ? color.primary
                                                : Colors.transparent,
                                            borderRadius:
                                            BorderRadius.circular(
                                              AppSizes.buttonRadius,
                                            ),
                                          ),
                                          alignment:
                                          Alignment.center,
                                          child:
                                          TextBodyStyleWidget(
                                            title: "Upload",
                                            color: isUploadSelected
                                                ? color.cardBackground
                                                : Colors.black,
                                            size:
                                            AppSizes.cardSubTitle,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Library
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isUploadSelected = false;
                                          });

                                          context
                                              .read<MediaViewModel>()
                                              .clearSelection();
                                        },
                                        child: AnimatedContainer(
                                          duration:
                                          const Duration(
                                            milliseconds: 200,
                                          ),
                                          decoration: BoxDecoration(
                                            color: !isUploadSelected
                                                ? color.primary
                                                : Colors.transparent,
                                            borderRadius:
                                            BorderRadius.circular(
                                              AppSizes.buttonRadius,
                                            ),
                                          ),
                                          alignment:
                                          Alignment.center,
                                          child:
                                          TextBodyStyleWidget(
                                            title: "Library",
                                            size:
                                            AppSizes.cardSubTitle,
                                            color: !isUploadSelected
                                                ? color.cardBackground
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),


                        ],
                      ),
                      SizedBox(
                        height: AppSizes.sectionGap,
                      ),
                      CustomCard(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            // Upload or Library


                            isUploadSelected
                                ? Column(
                              children: [
                                CustomImagePicker(
                                  title: "Upload Image",
                                  subtitle: "Choose your image",
                                  supportedText: "Supported: JPG • PNG",
                                  maxSizeText: "Maximum file size: 20 MB",
                                  onImageSelected: (file) {
                                    if (file == null) return;

                                    context
                                        .read<MediaViewModel>()
                                        .pickLocalFile(File(file.path));
                                  },
                                ),
                                _buildUploadPreview(),
                              ],
                            )
                                : _buildLibrary(),


                          ],
                        ),
                      ),
                      SizedBox(
                        height: AppSizes.sectionGap,
                      ),


                      // Use Selected File Button

                      Consumer<MediaViewModel>(
                        builder: (context, viewModel, child) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: viewModel.isUploading
                                  ? null
                                  : _useSelectedFile,
                              child: viewModel.isUploading
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text(
                                "Use Selected File",
                              ),
                            ),
                          );
                        },
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



  Widget _buildUploadPreview() {
    return Consumer<MediaViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.selectedLocalFile == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.only(top: AppSizes.itemGap),
          child: Container(
            width: 100.w,
            height: 18.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.file(
              viewModel.selectedLocalFile!,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }


  // Library


  Widget _buildLibrary() {
    final color = context.Appcolor;

    return Consumer<MediaViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.libraryLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (viewModel.libraryError != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: TextBodyStyleWidget(
              title: "Failed to load media: ${viewModel.libraryError}",
              color: Colors.red,
            ),
          );
        }

        if (viewModel.libraryItems.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: TextBodyStyleWidget(
              title: "No media found",
              color: color.primary,
            ),
          );
        }

        final selected = viewModel.selectedLibraryMedia;


        final effectiveSelectedId = selected?.id ?? _initialAttachmentId;


        final effectivePreviewUrl = selected?.file ?? _initialAttachmentUrl;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.libraryItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                childAspectRatio: 1.5,
              ),
              itemBuilder: (context, index) {
                final item = viewModel.libraryItems[index];
                final isSelected = effectiveSelectedId == item.id;

                return InkWell(
                  onTap: () {
                    viewModel.selectFromLibrary(item);

                    titleController.text = item.title ?? '';
                    descriptionController.text = item.description ?? '';
                    captionController.text = item.caption ?? '';
                    altTextController.text = item.altText ?? '';
                  },
                  child: Card(
                    elevation: 2,
                    color: color.cardBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.lightGreenAccent
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: (item.fileType == "image" &&
                        item.file != null &&
                        item.file!.isNotEmpty)
                        ? Image.network(
                      item.file!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        );
                      },
                    )
                        : Container(
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: Icon(
                        _iconForFileType(item.fileType),
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: AppSizes.sectionGap),

            TextBodyStyleWidget(
              title: "Attachment Details",
              color: color.primary,
              size: AppSizes.sectionTitle,
            ),

            SizedBox(height: AppSizes.appbarGap),

            Container(
              width: 100.w,
              height: 18.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              ),
              clipBehavior: Clip.antiAlias,
              child: (effectivePreviewUrl != null &&
                  effectivePreviewUrl.isNotEmpty)
                  ? Image.network(
                effectivePreviewUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/institute.png',
                    fit: BoxFit.cover,
                  );
                },
              )
                  : Image.asset(
                'assets/images/institute.png',
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: AppSizes.itemGap),

            TextBodyStyleWidget(
              title: "Title",
              color: color.primary,
              size: AppSizes.cardTitle,
            ),
            SizedBox(height: AppSizes.appbarGap),
            CustomTextFieldWidget(
              hintText: "Title",
              controller: titleController,
            ),

            SizedBox(height: AppSizes.itemGap),

            TextBodyStyleWidget(
              title: "Alt/description",
              color: color.primary,
              size: AppSizes.cardTitle,
            ),
            SizedBox(height: AppSizes.appbarGap),
            CustomTextFieldWidget(
              hintText: "Description...",
              controller: descriptionController,
            ),

            SizedBox(height: AppSizes.itemGap),

            TextBodyStyleWidget(
              title: "Alt Text",
              color: color.primary,
              size: AppSizes.cardTitle,
            ),
            SizedBox(height: AppSizes.appbarGap),
            CustomTextFieldWidget(
              hintText: "Alt text (for accessibility)...",
              controller: altTextController,
            ),

            SizedBox(height: AppSizes.itemGap),


            TextBodyStyleWidget(
              title: "Caption",
              color: color.primary,
              size: AppSizes.cardTitle,
            ),
            SizedBox(height: AppSizes.appbarGap),
            CustomTextFieldWidget(
              hintText: "Caption",
              controller: captionController,
            ),



            const Divider(),


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _fileInfoRow(
                  title: "Full Name",
                  value: selected?.fileName ?? "—",
                ),
                SizedBox(height: AppSizes.appbarGap),
                _fileInfoRow(
                  title: "File Type",
                  value: selected?.fileType ?? "—",
                ),
                SizedBox(height: AppSizes.appbarGap),
                _fileInfoRow(
                  title: "Size",
                  value: selected?.fileSizeDisplay ?? "—",
                ),
              ],
            ),

            SizedBox(height: AppSizes.sectionGap),

            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    height: 4.h,
                    text: viewModel.isUpdating ? "Updating..." : "Update",
                    backgroundColor: color.primary,
                    onTap: (viewModel.isUpdating || selected == null)
                        ? null
                        : _updateSelected,
                    size: AppSizes.cardTitle,
                  ),
                ),
                SizedBox(width: AppSizes.sectionGap),
                Expanded(
                  child: CustomButton(
                    height: 4.h,
                    text: viewModel.isDeleting ? "Deleting..." : "Delete Permanently",
                    backgroundColor: Colors.red,
                    onTap: (viewModel.isDeleting || selected == null)
                        ? null
                        : _deleteSelected,
                    size: AppSizes.cardTitle,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }



  IconData _iconForFileType(String? type) {
    switch (type) {
      case "document":
        return Icons.description;
      case "video":
        return Icons.videocam;
      case "audio":
        return Icons.audiotrack;
      case "archive":
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }

  // ============================================================
  // File Info Row
  // ============================================================

  Widget _fileInfoRow({
    required String title,
    required String value,
  }) {
    final color = context.Appcolor;

    return RichText(
      text: TextSpan(
        text: "$title: ",
        style: TextStyle(
          color: color.primary,
          fontSize: AppSizes.cardSubTitle,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}