import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../data/model/Content/activity/activity_model.dart';
import '../../data/model/form_field/form_feild_data.dart';
import '../../routes/routes_name.dart';
import '../../utils/app_sizes.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/activity_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/institute_profile/Institute_overview_screen.dart';
import '../../widget/institute_profile/infrastructure_drop_down.dart';
import '../../widget/quill/editor_icon.dart';
import '../../widget/quill/editor_option.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_text_field.dart';

class EditActivityManageDetailsScreen extends StatefulWidget {
  final ActivityModel activity;

  const EditActivityManageDetailsScreen({super.key, required this.activity});

  @override
  State<EditActivityManageDetailsScreen> createState() =>
      _EditActivityManageDetailsScreenState();
}

class _EditActivityManageDetailsScreenState
    extends State<EditActivityManageDetailsScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorNameController = TextEditingController();

  final TextEditingController metaTitleController = TextEditingController();
  final TextEditingController metaDescriptionController =
      TextEditingController();
  final TextEditingController metaSummaryController = TextEditingController();

  String activityContent = "";

  int? selectedCategoryId;
  String? selectedStatusValue;

  bool isFeatured = false;
  bool isUpdating = false;

  File? selectedImage;
  String? selectedImageUrl;
  int? selectedAttachmentId;

  bool isActivitySettingSeoExpanded = false;

  @override
  void initState() {
    super.initState();

    _prefillFromModel(widget.activity);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final viewModel = context.read<ActivityViewModel>();

      viewModel.getStatusChoices();
      viewModel.getCategoryApi();
    });
  }

  // ============================================================
  // SET EXISTING ACTIVITY DATA
  // ============================================================

  void _prefillFromModel(ActivityModel activity) {
    titleController.text = activity.title ?? '';
    authorNameController.text = activity.author ?? '';

    activityContent = activity.content ?? '';

    metaTitleController.text = activity.seoTitle ?? '';
    metaDescriptionController.text = activity.seoDescription ?? '';
    metaSummaryController.text = activity.excerpt ?? '';

    selectedStatusValue = activity.status;

    isFeatured = activity.isFeatured ?? false;

    // Existing featured image
    selectedAttachmentId = activity.featuredImageData?.id;
    selectedImageUrl = activity.featuredImageData?.file;

    // Existing category
    selectedCategoryId =
        (activity.categories != null && activity.categories!.isNotEmpty)
        ? activity.categories!.first
        : null;

    if (mounted) {
      setState(() {});
    }
  }

  // ============================================================
  // OPEN CONTENT DETAILS
  // ============================================================

  Future<void> _openContentDetails() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.content_details,
      arguments: {"content": activityContent},
    );

    if (!mounted) return;

    if (result is String) {
      setState(() {
        activityContent = result;
      });
    }
  }

  // ============================================================
  // OPEN MEDIA MANAGE
  // ============================================================

  Future<void> _openMediaManage() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
      arguments: {
        "currentId": selectedAttachmentId,
        "currentFileUrl": selectedImageUrl,
      },
    );

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        selectedAttachmentId = result['id'] as int?;
        selectedImageUrl = result['file'] as String?;
        selectedImage = null;
      });
    }
  }

  // ============================================================
  // UPDATE ACTIVITY
  // ============================================================

  Future<void> _handleUpdateActivity() async {
    if (titleController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter activity title");
      return;
    }

    if (activityContent.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter activity content");
      return;
    }

    if (selectedStatusValue == null || selectedStatusValue!.isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please select activity status");
      return;
    }

    final provider = context.read<ActivityViewModel>();

    setState(() {
      isUpdating = true;
    });

    final data = <String, dynamic>{
      "title": titleController.text.trim(),
      "content": activityContent.trim(),
      "excerpt": metaSummaryController.text.trim(),
      "author": authorNameController.text.trim(),
      "status": selectedStatusValue,

      "categories": selectedCategoryId != null ? [selectedCategoryId] : [],

      "seo_title": metaTitleController.text.trim(),
      "seo_description": metaDescriptionController.text.trim(),

      "is_featured": isFeatured,

      "gallery_images": selectedAttachmentId != null
          ? [
              {"image_id": selectedAttachmentId, "caption": "", "order": 1},
            ]
          : [],
    };

    final updated = await provider.updateActivity(widget.activity.id!, data);

    if (!mounted) return;

    setState(() {
      isUpdating = false;
    });

    if (updated != null) {
      SnackBarMessage.showSnackBar(context, "Activity updated successfully");

      Navigator.pop(context, true);
    } else {
      SnackBarMessage.showSnackBar(
        context,
        provider.actionError ?? "Failed to update activity",
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    authorNameController.dispose();

    metaTitleController.dispose();
    metaDescriptionController.dispose();
    metaSummaryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Edit Activity Manage Details",
            showBackButton: true,
          ),

          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    // ==================================================
                    // TITLE
                    // ==================================================
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
                            hintText: "e.g., Annual Tech Conference 2026",
                            controller: titleController,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // ==================================================
                    // CATEGORY
                    // ==================================================
                    Consumer<ActivityViewModel>(
                      builder: (context, provider, child) {
                        return CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextBodyStyleWidget(
                                title: "Category",
                                color: color.primary,
                                size: AppSizes.sectionTitle,
                              ),

                              SizedBox(height: AppSizes.appbarGap),

                              if (provider.categoryLoading)
                                const Center(child: CircularProgressIndicator())
                              else if (provider.categoryList.isEmpty)
                                TextBodyStyleWidget(
                                  title: "No categories yet",
                                  size: AppSizes.cardTitle,
                                )
                              else
                                CustomDropdown(
                                  items: provider.categoryList
                                      .map((e) => e.name ?? "")
                                      .toList(),

                                  initialValue:
                                      selectedCategoryId != null &&
                                          provider.categoryList.any(
                                            (e) => e.id == selectedCategoryId,
                                          )
                                      ? provider.categoryList
                                            .firstWhere(
                                              (e) => e.id == selectedCategoryId,
                                            )
                                            .name
                                      : provider.categoryList.first.name,

                                  width: 100.w,

                                  onChanged: (value) {
                                    final match = provider.categoryList
                                        .firstWhere((e) => e.name == value);

                                    setState(() {
                                      selectedCategoryId = match.id;
                                    });
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // ==================================================
                    // FEATURED IMAGE
                    // ==================================================
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextBodyStyleWidget(
                                title: "Featured Image",
                                color: color.primary,
                                size: AppSizes.sectionTitle,
                              ),

                              SizedBox(width: AppSizes.appbarGap),

                              CustomButton(
                                height: 4.h,
                                width: 30.w,
                                text: "Change Image",
                                onTap: _openMediaManage,
                              ),
                            ],
                          ),

                          SizedBox(height: AppSizes.itemGap),

                          if (selectedImage != null)
                            Container(
                              width: double.infinity,
                              height: 20.h,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.cardRadius,
                                ),
                              ),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          else if (selectedImageUrl != null &&
                              selectedImageUrl!.isNotEmpty)
                            Container(
                              width: double.infinity,
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
                                  return const Center(
                                    child: Icon(Icons.broken_image),
                                  );
                                },
                              ),
                            )
                          else
                            TextBodyStyleWidget(
                              title: "No featured image selected.",
                              size: AppSizes.cardTitle,
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // ==================================================
                    // CONTENT
                    // ==================================================
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBodyStyleWidget(
                            title: "Content*",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),

                          SizedBox(height: AppSizes.appbarGap),

                          Column(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSizes.smallPadding,
                                    vertical: 8,
                                  ),
                                  child: Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: [
                                      editorOption("paragraph"),
                                      editorOption("Default"),
                                      editorOption("14px"),
                                      editorIcon("B"),
                                      editorIcon("I"),
                                      editorIcon("U"),
                                      editorIcon("S"),

                                      const Text(
                                        "x²",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                      ),

                                      const SizedBox(width: 6),

                                      Container(
                                        width: 1,
                                        height: 25,
                                        color: Colors.grey.shade300,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: AppSizes.appbarGap),

                              Divider(height: 1, color: Colors.grey.shade300),

                              SizedBox(height: AppSizes.appbarGap),

                              GestureDetector(
                                onTap: _openContentDetails,
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    AppSizes.smallPadding,
                                  ),
                                  child: TextBodyStyleWidget(
                                    title: activityContent.isEmpty
                                        ? "Write content here..."
                                        : _stripHtml(activityContent),
                                    size: AppSizes.cardTitle,
                                    maxLines: 4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // ==================================================
                    // ACTIVITY SETTINGS
                    // ==================================================
                    CustomCard(
                      child: Column(
                        children: [
                          InstituteOverviewScreen(
                            title: "Activity Screen",
                            isExpanded: true,
                            child: Consumer<ActivityViewModel>(
                              builder: (context, provider, child) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // AUTHOR
                                    TextBodyStyleWidget(
                                      title: "Author Name",
                                      color: color.primary,
                                      size: AppSizes.cardTitle,
                                    ),

                                    SizedBox(height: AppSizes.appbarGap),

                                    CustomTextFieldWidget(
                                      hintText: "e.g. Hasibul Islam",
                                      controller: authorNameController,
                                    ),

                                    SizedBox(height: AppSizes.itemGap),

                                    // STATUS
                                    TextBodyStyleWidget(
                                      title: "Status",
                                      color: color.primary,
                                      size: AppSizes.cardTitle,
                                    ),

                                    SizedBox(height: AppSizes.appbarGap),

                                    if (provider.statusLoading)
                                      const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    else if (provider.statusChoices.isEmpty)
                                      TextBodyStyleWidget(
                                        title: "No status available",
                                        size: AppSizes.cardTitle,
                                      )
                                    else
                                      CustomDropdown(
                                        items: provider.statusChoices
                                            .map((e) => e.label)
                                            .toList(),

                                        initialValue:
                                            selectedStatusValue != null &&
                                                provider.statusChoices.any(
                                                  (e) =>
                                                      e.value ==
                                                      selectedStatusValue,
                                                )
                                            ? provider.statusChoices
                                                  .firstWhere(
                                                    (e) =>
                                                        e.value ==
                                                        selectedStatusValue,
                                                  )
                                                  .label
                                            : provider
                                                  .statusChoices
                                                  .first
                                                  .label,

                                        width: 100.w,
                                        height: 4.5.h,

                                        onChanged: (value) {
                                          final match = provider.statusChoices
                                              .firstWhere(
                                                (e) => e.label == value,
                                              );

                                          setState(() {
                                            selectedStatusValue = match.value;
                                          });
                                        },
                                      ),

                                    SizedBox(height: AppSizes.itemGap),

                                    // FEATURED
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: isFeatured,
                                          side: BorderSide(
                                            color: color.primary,
                                          ),
                                          activeColor: color.primary,
                                          onChanged: isUpdating
                                              ? null
                                              : (value) {
                                                  setState(() {
                                                    isFeatured = value ?? false;
                                                  });
                                                },
                                        ),

                                        Expanded(
                                          child: TextBodyStyleWidget(
                                            title: "Mark as Featured",
                                            fontbold: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // ==================================================
                    // SEO SETTINGS
                    // ==================================================
                    CustomCard(
                      child: InstituteOverviewScreen(
                        title: "SEO Settings",
                        showIcon: true,
                        userIcon: isActivitySettingSeoExpanded
                            ? Icons.remove
                            : Icons.keyboard_arrow_down,
                        onTap: () {
                          setState(() {
                            isActivitySettingSeoExpanded =
                                !isActivitySettingSeoExpanded;
                          });
                        },
                        isExpanded: isActivitySettingSeoExpanded,
                        expandableChild: InfrastructureDropDown(
                          fields: [
                            FormFieldData(
                              title: "Meta Title",
                              hint: "SEO Title",
                              controller: metaTitleController,
                            ),

                            FormFieldData(
                              title: "Meta Description",
                              hint: "SEO Description",
                              controller: metaDescriptionController,
                            ),

                            FormFieldData(
                              title: "Excerpt/Short Summary",
                              hint: "Brief Summary",
                              controller: metaSummaryController,
                            ),
                          ],

                          onSave: () {
                            setState(() {
                              isActivitySettingSeoExpanded = false;
                            });
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // ==================================================
                    // BUTTONS
                    // ==================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          text: "Cancel",
                          onTap: isUpdating
                              ? null
                              : () => Navigator.pop(context),
                          width: 30.w,
                          backgroundColor: color.cardBackground,
                          foregroundColor: color.primary,
                        ),

                        SizedBox(width: AppSizes.appbarGap),

                        Flexible(
                          child: CustomButton(
                            text: isUpdating ? "Updating..." : "Update",
                            onTap: isUpdating ? null : _handleUpdateActivity,
                          ),
                        ),
                      ],
                    ),
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

// ============================================================
// REMOVE HTML FROM PREVIEW
// ============================================================

String _stripHtml(String html) {
  return html
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
