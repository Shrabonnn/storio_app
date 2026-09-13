import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_sizes.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/gallery_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_text_field.dart';

class AddGalleryImages extends StatefulWidget {
  const AddGalleryImages({super.key});

  @override
  State<AddGalleryImages> createState() => _AddGalleryImagesState();
}

class _AddGalleryImagesState extends State<AddGalleryImages> {
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController imageTitleController = TextEditingController();

  int? selectedMediaId;
  String? selectedMediaUrl;

  int? selectedAlbumId; // null = Uncategorized
  bool isVisible = true;
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
    tagsController.dispose();
    imageTitleController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia() async {
    final result = await Navigator.pushNamed(context, RoutesName.media_manage_details);

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        selectedMediaId = result['id'] as int?;
        selectedMediaUrl = result['file'] as String?;
      });
    }
  }

  Future<void> _handleSave() async {
    if (selectedMediaId == null) {
      SnackBarMessage.showSnackBar(context, "Please select an image");
      return;
    }

    final provider = context.read<GalleryViewModel>();

    setState(() => isSaving = true);

    final tags = tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final data = <String, dynamic>{
      "media": selectedMediaId,
      "image_title": imageTitleController.text.trim(),
      "album": selectedAlbumId,
      "tags": tags,
      "is_visible": isVisible,
    };

    final created = await provider.createGalleryImage(data);

    if (!mounted) return;

    setState(() => isSaving = false);

    if (created != null) {
      SnackBarMessage.showSnackBar(context, "Image added to gallery");
      Navigator.pop(context, true);
    } else {
      SnackBarMessage.showSnackBar(context, provider.actionError ?? "Failed to add image");
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Add Images",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image picker
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextBodyStyleWidget(title: "Gallery Image*", color: color.primary, size: AppSizes.cardTitle),
                                  SizedBox(width: AppSizes.appbarGap),
                                  CustomButton(
                                    height: 4.h,
                                    width: 30.w,
                                    text: "Select Image",
                                    onTap: _pickMedia,
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSizes.itemGap),
                              if (selectedMediaUrl != null)
                                Container(
                                  width: 100.w,
                                  height: 20.h,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                                  ),
                                  child: Image.network(
                                    selectedMediaUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                                  ),
                                )
                              else
                                TextBodyStyleWidget(
                                  title: "Select an image from the media library to add to the gallery.",
                                  size: AppSizes.cardTitle,
                                ),
                            ],
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          TextBodyStyleWidget(title: "Image Title (for SEO)", color: color.primary, size: AppSizes.cardTitle),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(hintText: "Optional title for the image", controller: imageTitleController),
                          SizedBox(height: AppSizes.itemGap),

                          TextBodyStyleWidget(title: "Tags (comma separated)", color: color.primary, size: AppSizes.cardTitle),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(hintText: "e.g., nature, travel, featured", controller: tagsController),
                          SizedBox(height: AppSizes.itemGap),

                          TextBodyStyleWidget(title: "Album", color: color.primary, size: AppSizes.cardTitle),
                          SizedBox(height: AppSizes.appbarGap),
                          Consumer<GalleryViewModel>(
                            builder: (context, provider, child) {
                              if (provider.albumLoading) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              final labels = ["Uncategorized", ...provider.albumList.map((e) => e.name ?? "")];

                              final currentLabel = selectedAlbumId != null
                                  ? provider.albumList.firstWhere((e) => e.id == selectedAlbumId).name ?? "Uncategorized"
                                  : "Uncategorized";

                              return CustomDropdown(
                                items: labels,
                                initialValue: currentLabel,
                                width: 100.w,
                                height: 4.5.h,
                                onChanged: (value) {
                                  if (value == "Uncategorized") {
                                    setState(() => selectedAlbumId = null);
                                    return;
                                  }
                                  final match = provider.albumList.firstWhere((e) => e.name == value);
                                  setState(() => selectedAlbumId = match.id);
                                },
                              );
                            },
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          Row(
                            children: [
                              Checkbox(
                                value: isVisible,
                                side: BorderSide(color: color.primary),
                                activeColor: color.primary,
                                onChanged: (value) {
                                  setState(() => isVisible = value ?? true);
                                },
                              ),
                              Expanded(
                                child: TextBodyStyleWidget(
                                  title: "Visible on public gallery",
                                  fontbold: false,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          text: "Cancel",
                          onTap: isSaving ? null : () => Navigator.pop(context),
                          width: 30.w,
                          backgroundColor: Colors.green.shade200,
                          foregroundColor: Colors.black,
                        ),
                        SizedBox(width: AppSizes.appbarGap),
                        Flexible(
                          child: CustomButton(
                            text: isSaving ? "Saving..." : "Save",
                            onTap: isSaving ? null : _handleSave,
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
        ],
      ),
    );
  }
}