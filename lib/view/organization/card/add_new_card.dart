import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/utils/icon_list.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/universal/status_button_row.dart';

import '../../../data/model/organization/card/card_model.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/snackbar_message.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../viewModel/organization/card_view_model.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_text_field.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({
    super.key,
    this.isEdit = false,
    this.card,
  });

  final bool isEdit;
  final CardModel? card;

  @override
  State<AddNewCard> createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  // Text Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Display Mode Options (0: Icon, 1: Image)
  final List<String> displayMode = [
    "Icon",
    "Image",
  ];

  int selectedStatus = 0;

  // Selected Icon State
  IconData selectedIcon = IconList.iconList[0];

  // Selected Image State
  String? selectedImageUrl;
  int? selectedImageId;

  // Loading State
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    // Populate data for edit mode
    if (widget.isEdit && widget.card != null) {
      final card = widget.card!;

      titleController.text = card.title ?? '';
      descriptionController.text = card.description ?? '';

      selectedImageId = card.image;
      selectedImageUrl = card.imageUrl;

      // Check existing Icon mode
      if (card.icon != null && card.icon!.trim().isNotEmpty) {
        selectedStatus = 0;
        selectedIcon = _getIconFromName(card.icon!);
      }
      // Check existing Image mode
      else if (card.image != null || card.imageUrl != null) {
        selectedStatus = 1;
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // ============================================================
  // MEDIA MANAGEMENT
  // ============================================================
  Future<void> _openMediaManage() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
      arguments: {
        "currentId": selectedImageId,
        "currentFileUrl": selectedImageUrl,
      },
    );

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        selectedImageId = result['id'] as int?;
        selectedImageUrl = result['file'] as String?;
      });
    }
  }

  // ============================================================
  // ICON MAPPING HELPERS
  // ============================================================

  // Get key name from IconData
  String _getIconName(IconData icon) {
    return IconList.iconMap.entries
        .firstWhere(
          (entry) => entry.value.codePoint == icon.codePoint,
      orElse: () => IconList.iconMap.entries.first,
    )
        .key;
  }

  // Get IconData from key name
  IconData _getIconFromName(String iconName) {
    final cleanName = iconName.toLowerCase().replaceAll('fa-', '');
    return IconList.iconMap[cleanName] ?? IconList.iconList[0];
  }

  // ============================================================
  // HELPER MESSAGES
  // ============================================================
  void _showMessage(String message) {
    SnackBarMessage.showSnackBar(context, message);
  }

  // ============================================================
  // SAVE / UPDATE CARD ACTION
  // ============================================================
  Future<void> _handleSaveCard() async {
    // Title validation
    if (titleController.text.trim().isEmpty) {
      _showMessage("Please enter card title");
      return;
    }

    // Description validation
    if (descriptionController.text.trim().isEmpty) {
      _showMessage("Please enter card description");
      return;
    }

    // Image mode validation
    if (selectedStatus == 1 && selectedImageId == null) {
      _showMessage("Please select an image");
      return;
    }

    setState(() {
      isSaving = true;
    });

    final Map<String, dynamic> data = {
      "title": titleController.text.trim(),
      "description": descriptionController.text.trim(),
      "order": widget.card?.order ?? 0,
    };

    // Prepare payload based on display mode
    if (selectedStatus == 0) {
      // Icon Mode
      data["icon"] = _getIconName(selectedIcon);
      data["image"] = null;
    } else {
      // Image Mode
      data["icon"] = "";
      data["image"] = selectedImageId;
    }

    final viewModel = context.read<CardViewModel>();
    bool success;

    if (widget.isEdit && widget.card != null) {
      success = await viewModel.updateCardApi(
        widget.card!.id!,
        data,
      );
    } else {
      success = await viewModel.createCardApi(data);
    }

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      _showMessage(
        widget.isEdit
            ? "Card updated successfully!"
            : "Card created successfully!",
      );

      Navigator.pop(context, true);
    } else {
      _showMessage(
        viewModel.errorMessage ??
            (widget.isEdit
                ? "Failed to update card"
                : "Failed to create card"),
      );
    }
  }

  // ============================================================
  // MAIN BUILD METHOD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: widget.isEdit ? "Edit Card" : "Create New Card",
            showBackButton: true,
          ),

          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ==================================================
                    // CARD DETAILS FORM SECTION
                    // ==================================================
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Title Input
                          TextBodyStyleWidget(
                            title: "Title*",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "Card Title",
                            controller: titleController,
                          ),

                          SizedBox(height: AppSizes.itemGap),

                          // Description Input
                          TextBodyStyleWidget(
                            title: "Description",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            minLines: 3,
                            maxLines: 5,
                            hintText: "Write a short description",
                            controller: descriptionController,
                          ),

                          SizedBox(height: AppSizes.itemGap),

                          // Display Mode Selector (Icon / Image)
                          TextBodyStyleWidget(
                            title: "Display Mode",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          StatusButtonRow(
                            items: displayMode,
                            selectedIndex: selectedStatus,
                            onSelected: (index) {
                              setState(() {
                                selectedStatus = index;
                              });

                              if (index == 1) {
                                _openMediaManage();
                              }
                            },
                          ),

                          // ==============================================
                          // ICON SELECTION GRID (ICON MODE)
                          // ==============================================
                          if (selectedStatus == 0) ...[
                            SizedBox(height: AppSizes.itemGap),
                            TextBodyStyleWidget(
                              title: "Select Icon",
                              color: color.primary,
                              size: AppSizes.sectionTitle,
                            ),
                            SizedBox(height: AppSizes.appbarGap),
                            GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 8,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1,
                              ),
                              itemCount: IconList.iconList.length,
                              itemBuilder: (context, index) {
                                final icon = IconList.iconList[index];
                                final isSelected = selectedIcon == icon;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIcon = icon;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? color.primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(
                                        AppSizes.buttonRadius,
                                      ),
                                    ),
                                    child: Icon(
                                      icon,
                                      color: isSelected
                                          ? color.cardBackground
                                          : Colors.blueGrey,
                                      size: AppSizes.icon,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],

                          // ==============================================
                          // IMAGE SELECTION (IMAGE MODE)
                          // ==============================================
                          if (selectedStatus == 1) ...[
                            SizedBox(height: AppSizes.itemGap),
                            TextBodyStyleWidget(
                              title: "Card Image",
                              color: color.primary,
                              size: AppSizes.sectionTitle,
                            ),
                            SizedBox(height: AppSizes.appbarGap),
                            Row(
                              children: [
                                CustomButton(
                                  height: 4.h,
                                  width: 35.w,
                                  text: selectedImageId != null
                                      ? "Change Image"
                                      : "Select Image",
                                  onTap: _openMediaManage,
                                ),
                              ],
                            ),
                            SizedBox(height: AppSizes.itemGap),
                            if (selectedImageUrl != null &&
                                selectedImageUrl!.isNotEmpty)
                              Container(
                                width: 100.w,
                                height: 20.h,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.cardRadius,
                                  ),
                                ),
                                child: Image.network(
                                  selectedImageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.broken_image);
                                  },
                                ),
                              )
                            else
                              TextBodyStyleWidget(
                                title: "Please select an image from media.",
                                size: AppSizes.cardTitle,
                              ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // ==================================================
                    // ACTION BUTTONS (CANCEL / SAVE)
                    // ==================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          text: "Cancel",
                          onTap: () => Navigator.pop(context),
                          width: 30.w,
                          backgroundColor: color.cardBackground,
                          foregroundColor: color.primary,
                        ),
                        SizedBox(width: AppSizes.appbarGap),
                        Flexible(
                          child: isSaving
                              ? const Center(
                            child: CircularProgressIndicator(),
                          )
                              : CustomButton(
                            text: widget.isEdit
                                ? "Update Card"
                                : "Save Card",
                            onTap: _handleSaveCard,
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