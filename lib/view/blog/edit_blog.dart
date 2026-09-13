import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../data/model/Content/blog/blog_model.dart';
import '../../data/model/form_field/form_feild_data.dart';
import '../../routes/routes_name.dart';
import '../../utils/app_sizes.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/blog_view_model.dart';
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
import '../../widget/universal/date_time_formate.dart';

class EditBlog extends StatefulWidget {
  const EditBlog({super.key, required this.blog});

  final BlogModel blog;

  @override
  State<EditBlog> createState() => _EditBlogState();
}

class _EditBlogState extends State<EditBlog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController slugController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController excerptController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController publishDateController = TextEditingController();
  final TextEditingController publishTimeController = TextEditingController();
  final TextEditingController seoTitleController = TextEditingController();
  final TextEditingController seoDescController = TextEditingController();

  String blogContent = "";
  bool isSaving = false;
  bool isFeatured = false;

  File? selectedImage;
  String? selectedImageUrl;
  int? selectedAttachmentId;

  String? selectedStatusValue;

  int? selectedCategoryId;

  bool isSeoExpanded = false;

  @override
  void initState() {
    super.initState();


    _prefillFromModel(widget.blog);


    titleController.addListener(_onTitleChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final viewModel = context.read<BlogViewModel>();

      viewModel.getStatusChoices();
      viewModel.getCategoryApi();

      if (widget.blog.id != null) {
        await viewModel.getBlogDetail(widget.blog.id!);

        if (!mounted) return;

        if (viewModel.blogDetail != null) {
          _prefillFromModel(viewModel.blogDetail!);
        }
      }
    });
  }

  void _onTitleChanged() {
    if (slugController.text.trim().isEmpty) {
      final generated = _slugify(titleController.text);
      slugController.text = generated;
    }
  }

  String _slugify(String text) {
    var slug = text.trim().toLowerCase();
    slug = slug.replaceAll(RegExp(r'[^a-z0-9\s-]'), '');
    slug = slug.replaceAll(RegExp(r'\s+'), '-');
    slug = slug.replaceAll(RegExp(r'-+'), '-');
    slug = slug.replaceAll(RegExp(r'^-+|-+$'), '');
    return slug;
  }

  @override
  void dispose() {
    titleController.removeListener(_onTitleChanged);
    titleController.dispose();
    slugController.dispose();
    authorController.dispose();
    excerptController.dispose();
    tagsController.dispose();
    publishDateController.dispose();
    publishTimeController.dispose();
    seoTitleController.dispose();
    seoDescController.dispose();
    super.dispose();
  }

  // ============================================================
  // Prefill Fields From Model
  // ============================================================

  void _prefillFromModel(BlogModel blog) {
    titleController.text = blog.title ?? '';
    slugController.text = blog.slug ?? '';
    authorController.text = blog.author ?? '';
    excerptController.text = blog.excerpt ?? '';
    tagsController.text = (blog.tags ?? []).join(', ');
    seoTitleController.text = blog.seoTitle ?? '';
    seoDescController.text = blog.seoDescription ?? '';

    blogContent = blog.content ?? '';
    isFeatured = blog.isFeatured ?? false;
    selectedStatusValue = blog.status;

    selectedAttachmentId = blog.featuredImage;
    selectedImageUrl = blog.featuredImageData?.file;

    selectedCategoryId =
    (blog.categories != null && blog.categories!.isNotEmpty)
        ? blog.categories!.first
        : selectedCategoryId;

    if (blog.publishDate != null) {
      publishDateController.text = formatDate(blog.publishDate);
      publishTimeController.text = formatTime(blog.publishDate);
    }

    if (mounted) setState(() {});
  }

  // ============================================================
  // Open Content Details
  // ============================================================

  Future<void> _openContentDetails() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.content_details,
      arguments: {"content": blogContent},
    );

    if (!mounted) return;

    if (result is String) {
      setState(() {
        blogContent = result;
      });
    }
  }

  // ============================================================
  // Open Media Manage Details
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
  // Helpers
  // ============================================================

  List<String> _parseTags() {
    return tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  String _plainTextFromHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  DateTime? _getPublishDateTime() {
    final date = publishDateController.text.trim();
    if (date.isEmpty) return null;

    try {
      final parsedDate = DateFormat('dd MMM yyyy').parse(date);
      final time = publishTimeController.text.trim();

      if (time.isNotEmpty) {
        final parsedTime = DateFormat('hh:mm a').parse(time);
        return DateTime(
          parsedDate.year,
          parsedDate.month,
          parsedDate.day,
          parsedTime.hour,
          parsedTime.minute,
        );
      }

      return parsedDate;
    } catch (e) {
      return null;
    }
  }



  // ============================================================
  // Update Blog
  // ============================================================

  Future<void> _handleUpdateBlog() async {
    if (titleController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context,"Please enter blog title");
      return;
    }

    if (slugController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context,
        "Please enter a URL slug (auto-generate failed, likely due to non-English title)",
      );
      return;
    }

    if (authorController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context,"Please enter author name");
      return;
    }

    if (blogContent.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context,"Please write blog content");
      return;
    }

    if (_plainTextFromHtml(blogContent).length < 10) {
      SnackBarMessage.showSnackBar(context,"Content must be at least 10 characters long");
      return;
    }

    if (selectedStatusValue == null || selectedStatusValue!.isEmpty) {
      SnackBarMessage.showSnackBar(context,"Please select status");
      return;
    }

    if (widget.blog.id == null) {
      SnackBarMessage.showSnackBar(context,"Blog ID not found");
      return;
    }

    if (selectedStatusValue == "published" &&
        publishDateController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context,"Please select a publish date");
      return;
    }

    if (selectedStatusValue == "scheduled" &&
        (publishDateController.text.trim().isEmpty ||
            publishTimeController.text.trim().isEmpty)) {
      SnackBarMessage.showSnackBar(context,"Please select publish date and time for scheduling");
      return;
    }

    final viewModel = context.read<BlogViewModel>();

    setState(() {
      isSaving = true;
    });

    final Map<String, dynamic> data = {
      "title": titleController.text.trim(),
      "slug": slugController.text.trim(),
      "content": blogContent.trim(),
      "excerpt": excerptController.text.trim(),
      "author": authorController.text.trim(),
      "status": selectedStatusValue,
      "tags": _parseTags(),
      "categories": selectedCategoryId != null ? [selectedCategoryId] : [],
      "is_featured": isFeatured,
    };

    if (selectedAttachmentId != null) {
      data["featured_image"] = selectedAttachmentId;
    }

    if (seoTitleController.text.trim().isNotEmpty) {
      data["seo_title"] = seoTitleController.text.trim();
    }

    if (seoDescController.text.trim().isNotEmpty) {
      data["seo_description"] = seoDescController.text.trim();
    }

    if (selectedStatusValue == "published" ||
        selectedStatusValue == "scheduled") {
      final publishDate = _getPublishDateTime();
      if (publishDate != null) {
        data["publish_date"] = publishDate.toUtc().toIso8601String();
      }
    }

    final success = await viewModel.updateBlog(widget.blog.id!, data);

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      SnackBarMessage.showSnackBar(context,"Blog post updated successfully");
      Navigator.pop(context, true);
    } else {
      SnackBarMessage.showSnackBar(context,viewModel.errorMessage ?? "Failed to update blog post");
    }
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Edit Blog Post",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // ==================================================
                  // Title / Author
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
                          hintText: "e.g. Post Title",
                          controller: titleController,
                        ),
                        SizedBox(height: AppSizes.itemGap),
                        TextBodyStyleWidget(
                          title: "URL Slug*",
                          color: color.primary,
                          size: AppSizes.sectionTitle,
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(
                          hintText: "auto-generated-from-title",
                          controller: slugController,
                        ),
                        SizedBox(height: AppSizes.itemGap),
                        TextBodyStyleWidget(
                          title: "Author*",
                          color: color.primary,
                          size: AppSizes.sectionTitle,
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(
                          hintText: "e.g. John Doe",
                          controller: authorController,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSizes.sectionGap),

                  // ==================================================
                  // Featured Image
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
                        Container(
                          width: 100.w,
                          height: 20.h,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(AppSizes.cardRadius),
                          ),
                          child: _buildFeaturedImage(),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSizes.sectionGap),

                  // ==================================================
                  // Content
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
                                SizedBox(width: 6),
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
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(AppSizes.smallPadding),
                            child: TextBodyStyleWidget(
                              title: blogContent.isEmpty
                                  ? "Write content here..."
                                  : blogContent,
                              size: AppSizes.cardTitle,
                              maxLines: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSizes.sectionGap),

                  // ==================================================
                  // Status
                  // ==================================================

                  CustomCard(
                    child: Consumer<BlogViewModel>(
                      builder: (context, provider, child) {
                        if (provider.statusLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (provider.statusChoices.isEmpty) {
                          return TextBodyStyleWidget(
                            title: "No status available",
                            color: color.primary,
                          );
                        }

                        final statusChoices = provider.statusChoices
                            .where((item) => item.value != "binned")
                            .toList();

                        final statusItems =
                        statusChoices.map((item) => item.label).toList();

                        String? selectedLabel;
                        for (final item in statusChoices) {
                          if (item.value == selectedStatusValue) {
                            selectedLabel = item.label;
                            break;
                          }
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextBodyStyleWidget(
                              title: "Status*",
                              color: color.primary,
                              size: AppSizes.sectionTitle,
                            ),
                            SizedBox(height: AppSizes.appbarGap),
                            CustomDropdown(
                              items: statusItems,
                              initialValue: selectedLabel ?? statusItems.first,
                              width: 100.w,
                              onChanged: (value) {
                                final selectedChoice = statusChoices
                                    .firstWhere((item) => item.label == value);

                                setState(() {
                                  selectedStatusValue = selectedChoice.value;

                                  if (selectedChoice.value == "draft") {
                                    publishDateController.clear();
                                    publishTimeController.clear();
                                  }

                                  if (selectedChoice.value == "published") {
                                    publishTimeController.clear();
                                  }
                                });
                              },
                            ),
                            SizedBox(height: AppSizes.itemGap),

                            // published -> শুধু Publish Date
                            if (selectedStatusValue == "published")
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextBodyStyleWidget(
                                    title: "Publish Date",
                                    color: color.primary,
                                    size: AppSizes.cardTitle,
                                  ),
                                  SizedBox(height: AppSizes.appbarGap),
                                  CustomTextFieldWidget(
                                    hintText: "yyyy-mm-dd",
                                    controller: publishDateController,
                                    isDatePicker: true,
                                  ),
                                ],
                              )

                            // scheduled -> Publish Date + Time দুইটাই
                            else if (selectedStatusValue == "scheduled")
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        TextBodyStyleWidget(
                                          title: "Publish Date",
                                          color: color.primary,
                                          size: AppSizes.cardTitle,
                                        ),
                                        SizedBox(height: AppSizes.appbarGap),
                                        CustomTextFieldWidget(
                                          hintText: "yyyy-mm-dd",
                                          controller: publishDateController,
                                          isDatePicker: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: AppSizes.smallGap),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        TextBodyStyleWidget(
                                          title: "Time",
                                          color: color.primary,
                                          size: AppSizes.cardTitle,
                                        ),
                                        SizedBox(height: AppSizes.appbarGap),
                                        CustomTextFieldWidget(
                                          hintText: "2:30 PM",
                                          controller: publishTimeController,
                                          isTimePicker: true,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        );
                      },
                    ),
                  ),

                  SizedBox(height: AppSizes.sectionGap),

                  // ==================================================
                  // Category
                  // ==================================================

                  CustomCard(
                    child: Consumer<BlogViewModel>(
                      builder: (context, provider, child) {
                        if (provider.categoryLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (provider.categoryList.isEmpty) {
                          return TextBodyStyleWidget(
                            title: "No category available",
                            color: color.primary,
                          );
                        }

                        final categories = provider.categoryList;
                        final categoryItems =
                        categories.map((e) => e.name ?? "").toList();

                        String? selectedLabel;
                        for (final item in categories) {
                          if (item.id == selectedCategoryId) {
                            selectedLabel = item.name;
                            break;
                          }
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextBodyStyleWidget(
                              title: "Category",
                              color: color.primary,
                              size: AppSizes.sectionTitle,
                            ),
                            SizedBox(height: AppSizes.appbarGap),
                            CustomDropdown(
                              items: categoryItems,
                              initialValue: selectedLabel ?? categoryItems.first,
                              width: 100.w,
                              onChanged: (value) {
                                final matched = categories
                                    .firstWhere((item) => item.name == value);

                                setState(() {
                                  selectedCategoryId = matched.id;
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  SizedBox(height: AppSizes.sectionGap),

                  // ==================================================
                  // Excerpt
                  // ==================================================

                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBodyStyleWidget(
                          title: "Excerpt",
                          color: color.primary,
                          size: AppSizes.sectionTitle,
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(
                          hintText: "A short summary of the post...",
                          controller: excerptController,
                          minLines: 3,
                          maxLines: 6,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSizes.sectionGap),

                  // ==================================================
                  // Tags
                  // ==================================================

                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBodyStyleWidget(
                          title: "Add Tags",
                          color: color.primary,
                          size: AppSizes.sectionTitle,
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(
                          hintText: "tag1, tag2, tag3",
                          controller: tagsController,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSizes.sectionGap),

                  // ==================================================
                  // Is Featured
                  // ==================================================

                  CustomCard(
                    child: Row(
                      children: [
                        Checkbox(
                          value: isFeatured,
                          side: BorderSide(color: color.primary),
                          activeColor: color.primary,
                          onChanged: (value) {
                            setState(() {
                              isFeatured = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: TextBodyStyleWidget(
                            title: "Mark as Featured Post",
                            fontbold: false,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSizes.sectionGap),

                  // ==================================================
                  // SEO Settings
                  // ==================================================

                  CustomCard(
                    child: InstituteOverviewScreen(
                      title: "SEO Settings",
                      showIcon: true,
                      userIcon: isSeoExpanded
                          ? Icons.remove
                          : Icons.keyboard_arrow_down,
                      onTap: () {
                        setState(() {
                          isSeoExpanded = !isSeoExpanded;
                        });
                      },
                      isExpanded: isSeoExpanded,
                      expandableChild: InfrastructureDropDown(
                        fields: [
                          FormFieldData(
                            title: "Meta Title",
                            hint: "SEO Title",
                            controller: seoTitleController,
                          ),
                          FormFieldData(
                            title: "Meta Description",
                            hint: "SEO Description",
                            controller: seoDescController,
                          ),
                        ],
                        onSave: () {},
                      ),
                    ),
                  ),

                  SizedBox(height: AppSizes.sectionGap),

                  // ==================================================
                  // Buttons
                  // ==================================================

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
                          text: isSaving ? "Updating..." : "Update Post",
                          onTap: isSaving ? () {} : _handleUpdateBlog,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSizes.sectionGap),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedImage() {
    if (selectedImage != null) {
      return Image.file(selectedImage!, fit: BoxFit.cover);
    }

    if (selectedImageUrl != null && selectedImageUrl!.isNotEmpty) {
      return Image.network(
        selectedImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/images/institute.png', fit: BoxFit.cover);
        },
      );
    }

    return Image.asset('assets/images/institute.png', fit: BoxFit.cover);
  }
}