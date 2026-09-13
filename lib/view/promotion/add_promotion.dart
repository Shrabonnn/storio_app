import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/data/model/Content/promotion/promotion_model.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_sizes.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/promotion_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_text_field.dart';

class AddPromotion extends StatefulWidget {
  const AddPromotion({super.key});

  @override
  State<AddPromotion> createState() => _AddPromotionState();
}

class _AddPromotionState extends State<AddPromotion> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController badgeTextController = TextEditingController();
  final TextEditingController ctaLabelController = TextEditingController();
  final TextEditingController ctaUrlController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController priorityController = TextEditingController(
    text: "0",
  );



  final List<Map<String, String>> _statusChoices = const [
    {"value": "draft", "label": "Draft"},
    {"value": "published", "label": "Published"},
    {"value": "archived", "label": "Archived"},
  ];



  String selectedStatus = "draft";

  bool ctaIsExternal = false;
  bool isSaving = false;

  File? selectedImage;
  String? selectedImageUrl;
  int? selectedAttachmentId;

  @override
  void dispose() {
    titleController.dispose();
    subtitleController.dispose();
    descriptionController.dispose();
    badgeTextController.dispose();
    ctaLabelController.dispose();
    ctaUrlController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    priorityController.dispose();
    super.dispose();
  }

  // ============================================================
  // Open Media Manage Details
  // ============================================================

  Future<void> _openMediaManage() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
    );

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        selectedAttachmentId = result['id'] as int?;
        selectedImageUrl = result['file'] as String?;

        if (selectedImageUrl == null && result['localPath'] != null) {
          selectedImage = File(result['localPath']);
        } else {
          selectedImage = null;
        }
      });
    }
  }
  // Format Date
  // ============================================================

  String? _formatDateForApi(String displayDate) {
    if (displayDate.trim().isEmpty) return null;

    try {
      final parsed = DateFormat('dd MMM yyyy').parse(displayDate.trim());
      return DateFormat('yyyy-MM-dd').format(parsed);
    } catch (e) {
      return null;
    }
  }

  // ============================================================
  // Create Promotion Model
  // ============================================================

  PromotionModel _buildPromotionModel() {
    final startDate = _formatDateForApi(startDateController.text);
    final endDate = _formatDateForApi(endDateController.text);

    return PromotionModel(
      title: titleController.text.trim(),
      subtitle: subtitleController.text.trim(),
      description: descriptionController.text.trim(),
      badgeText: badgeTextController.text.trim(),

      image: selectedAttachmentId,



      ctaLabel: ctaLabelController.text.trim(),
      ctaUrl: ctaUrlController.text.trim(),
      ctaIsExternal: ctaIsExternal,

      status: selectedStatus,

      startDate: startDate != null ? DateTime.tryParse(startDate) : null,

      endDate: endDate != null ? DateTime.tryParse(endDate) : null,

      priority: int.tryParse(priorityController.text.trim()) ?? 0,
    );
  }

  // Create Promotion

  Future<void> _handleCreatePromotion() async {
    if (titleController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter a title");
      return;
    }

    final viewModel = context.read<PromotionViewModel>();

    setState(() {
      isSaving = true;
    });

    try {

      final PromotionModel promotion = _buildPromotionModel();


      final Map<String, dynamic> data = promotion.toCreateJson();


      final result = await viewModel.createPromotionApi(data);

      if (!mounted) return;

      if (result != null) {
        SnackBarMessage.showSnackBar(context, "Promotion created successfully");
        Navigator.pop(context, true);
      } else {
        SnackBarMessage.showSnackBar(context, viewModel.errorMessage ?? "Failed to create promotion");
      }
    } catch (e) {
      if (!mounted) return;

      SnackBarMessage.showSnackBar(context, "Something went wrong");
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  // Build

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: "Create Promotion", showBackButton: true),

          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // Title / Subtitle / Description

                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextBodyStyleWidget(
                        title: "Title*",
                        color: color.primary,
                        size: AppSizes.sectionTitle,
                      ),

                      SizedBox(height: AppSizes.appbarGap),

                      CustomTextFieldWidget(
                        hintText: "e.g. Summer 2026 Admissions Open!",
                        controller: titleController,
                      ),

                      SizedBox(height: AppSizes.itemGap),

                      TextBodyStyleWidget(
                        title: "Subtitle",
                        color: color.primary,
                        size: AppSizes.sectionTitle,
                      ),

                      SizedBox(height: AppSizes.appbarGap),

                      CustomTextFieldWidget(
                        hintText: "Short highlight line",
                        controller: subtitleController,
                      ),

                      SizedBox(height: AppSizes.itemGap),

                      TextBodyStyleWidget(
                        title: "Description",
                        color: color.primary,
                        size: AppSizes.sectionTitle,
                      ),

                      SizedBox(height: AppSizes.appbarGap),

                      CustomTextFieldWidget(
                        hintText: "Full promotion details...",
                        controller: descriptionController,
                        minLines: 3,
                        maxLines: 6,
                      ),

                      SizedBox(height: AppSizes.itemGap),

                      TextBodyStyleWidget(
                        title: "Badge Text",
                        color: color.primary,
                        size: AppSizes.sectionTitle,
                      ),

                      SizedBox(height: AppSizes.appbarGap),

                      CustomTextFieldWidget(
                        hintText: "e.g. NEW, FEATURED",
                        controller: badgeTextController,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSizes.sectionGap),

               // Featured Image
                 CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextBodyStyleWidget(
                            title: "Promotion Image",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),

                          SizedBox(width: AppSizes.appbarGap),

                          CustomButton(
                            height: 4.h,
                            width: 30.w,
                            text: "Select Image",
                            onTap: _openMediaManage,
                          ),
                        ],
                      ),

                      SizedBox(height: AppSizes.itemGap),

                      if (selectedImage != null)
                        Container(
                          width: 100.w,
                          height: 20.h,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppSizes.cardRadius,
                            ),
                          ),
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        )
                      else if (selectedImageUrl != null)
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
                          title: "Recommended size: 1200x600px for banners.",
                          size: AppSizes.cardTitle,
                          maxLines: 2,
                        ),
                    ],
                  ),
                ),

                SizedBox(height: AppSizes.sectionGap),


                // Status

                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      TextBodyStyleWidget(
                        title: "Status*",
                        color: color.primary,
                        size: AppSizes.sectionTitle,
                      ),

                      SizedBox(height: AppSizes.appbarGap),

                      CustomDropdown(
                        items: _statusChoices.map((e) => e["label"]!).toList(),

                        initialValue: _statusChoices.firstWhere(
                          (e) => e["value"] == selectedStatus,
                        )["label"]!,

                        width: 100.w,

                        onChanged: (value) {
                          final matched = _statusChoices.firstWhere(
                            (e) => e["label"] == value,
                          );

                          setState(() {
                            selectedStatus = matched["value"]!;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSizes.sectionGap),

                // ==================================================
                // Call To Action
                // ==================================================
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextBodyStyleWidget(
                        title: "CTA Label",
                        color: color.primary,
                        size: AppSizes.sectionTitle,
                      ),

                      SizedBox(height: AppSizes.appbarGap),

                      CustomTextFieldWidget(
                        hintText: "e.g. Apply Now",
                        controller: ctaLabelController,
                      ),

                      SizedBox(height: AppSizes.itemGap),

                      TextBodyStyleWidget(
                        title: "CTA URL",
                        color: color.primary,
                        size: AppSizes.sectionTitle,
                      ),

                      SizedBox(height: AppSizes.appbarGap),

                      CustomTextFieldWidget(
                        hintText: "/admission or https://...",
                        controller: ctaUrlController,
                      ),

                      SizedBox(height: AppSizes.itemGap),

                      Row(
                        children: [
                          Expanded(
                            child: TextBodyStyleWidget(
                              title: "Open in new tab (external link)",
                              color: color.primary,
                              size: AppSizes.cardTitle,
                            ),
                          ),

                          Switch(
                            value: ctaIsExternal,
                            activeColor: color.primary,
                            onChanged: (value) {
                              setState(() {
                                ctaIsExternal = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSizes.sectionGap),


                // Schedule
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextBodyStyleWidget(
                                  title: "Start Date",
                                  color: color.primary,
                                  size: AppSizes.cardTitle,
                                ),

                                SizedBox(height: AppSizes.appbarGap),

                                CustomTextFieldWidget(
                                  hintText: "yyyy-mm-dd",
                                  controller: startDateController,
                                  isDatePicker: true,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: AppSizes.smallGap),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextBodyStyleWidget(
                                  title: "End Date",
                                  color: color.primary,
                                  size: AppSizes.cardTitle,
                                ),

                                SizedBox(height: AppSizes.appbarGap),

                                CustomTextFieldWidget(
                                  hintText: "yyyy-mm-dd",
                                  controller: endDateController,
                                  isDatePicker: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSizes.itemGap),

                      TextBodyStyleWidget(
                        title: "Priority",
                        color: color.primary,
                        size: AppSizes.cardTitle,
                      ),

                      SizedBox(height: AppSizes.appbarGap),

                      CustomTextFieldWidget(
                        hintText: "0",
                        controller: priorityController,
                        isInputOnlyNumber: true,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSizes.sectionGap),


                // Button

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: "Cancel",
                      width: 30.w,
                      backgroundColor: color.cardBackground,
                      foregroundColor: color.primary,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),

                    SizedBox(width: AppSizes.appbarGap),

                    Flexible(
                      child: CustomButton(
                        text: isSaving ? "Saving..." : "Create Promotion",

                        onTap: isSaving ? () {} : _handleCreatePromotion,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSizes.sectionGap),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
