import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../data/model/Content/notice/notice_model.dart';
import '../../routes/routes_name.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';

import '../../viewModel/Content/notice_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/quill/editor_icon.dart';
import '../../widget/quill/editor_option.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_text_field.dart';



class AddNewNotice extends StatefulWidget {
  const AddNewNotice({
    super.key,

  });



  @override
  State<AddNewNotice> createState() => _AddNewNoticeState();
}

class _AddNewNoticeState extends State<AddNewNotice> {
  final TextEditingController titleController =
  TextEditingController();

  final TextEditingController publishDateController =
  TextEditingController();

  final TextEditingController publishTimeController =
  TextEditingController();

  bool isShowPdf = false;
  bool isSaving = false;

  String noticeContent = "";

  File? selectedImage;
  String? selectedImageUrl;

  int? selectedAttachmentId;

  String? selectedStatusValue;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<NoticeViewModel>().getStatusChoices();
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    publishDateController.dispose();
    publishTimeController.dispose();

    super.dispose();
  }

  // ============================================================
  // Open Content Details
  // ============================================================

  Future<void> _openContentDetails() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.content_details,
      arguments: {
        "content": noticeContent,
      },
    );

    if (!mounted) return;

    if (result is String) {
      setState(() {
        noticeContent = result;
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
    );
    debugPrint("MEDIA MANAGE RESULT: $result");

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        selectedAttachmentId = result['id'] as int?;
        selectedImageUrl = result['file'] as String?;
        if (selectedImageUrl == null && result['localPath'] != null) {
          selectedImage = File(result['localPath']); // local file দিয়ে immediate preview
        } else {
          selectedImage = null;
        }
      });
    }
  }
  // ============================================================
  // Get Selected Status
  // ============================================================

  String _getSelectedStatus() {
    return selectedStatusValue ?? "draft";
  }

  // ============================================================
  // Get Publish Date
  // ============================================================

  DateTime? _getPublishDate() {
    final date = publishDateController.text.trim();

    if (date.isEmpty) {
      return null;
    }

    try {
      return DateFormat('dd MMM yyyy').parse(date);
    } catch (e) {
      return null;
    }
  }

  // ============================================================
  // Save Notice
  // ============================================================

  Future<void> _handleSaveNotice() async {
    if (titleController.text.trim().isEmpty) {
      _showMessage("Please enter notice title");
      return;
    }

    if (noticeContent.trim().isEmpty) {
      _showMessage("Please enter notice content");
      return;
    }

    if (selectedStatusValue == null) {
      _showMessage("Please select notice status");
      return;
    }

    final viewModel = context.read<NoticeViewModel>();

    setState(() {
      isSaving = true;
    });

    final success = await viewModel.createNoticeApi(
      title: titleController.text.trim(),
      content: noticeContent.trim(),
      status: _getSelectedStatus(),
      publishDate: _getPublishDate(),
      attachments: selectedAttachmentId != null
          ? [selectedAttachmentId!]
          : [],
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      _showMessage("Notice created successfully");

      Navigator.pop(context, true);
    } else {
      _showMessage(
        viewModel.errorMessage ?? "Failed to create notice",
      );
    }
  }

  // ============================================================
  // Show Snackbar
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
            title:"Create New Notice",
            showBackButton: true,
          ),

          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // ==================================================
                  // Title
                  // ==================================================

                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBodyStyleWidget(
                          title: "Title",
                          color: color.primary,
                          size: AppSizes.sectionTitle,
                        ),

                        SizedBox(height: AppSizes.appbarGap),

                        CustomTextFieldWidget(
                          hintText: "e.g. Notice Title",
                          controller: titleController,
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
                          title: "Content",
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

                        Divider(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),

                        SizedBox(height: AppSizes.appbarGap),

                        GestureDetector(
                          onTap: _openContentDetails,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(
                              AppSizes.smallPadding,
                            ),
                            child: TextBodyStyleWidget(
                              title: noticeContent.isEmpty
                                  ? "Write content here..."
                                  : noticeContent,
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
                    child: Consumer<NoticeViewModel>(
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

                        // Binned বাদ
                        final statusChoices = provider.statusChoices
                            .where((item) => item.value != "binned")
                            .toList();

                        final statusItems = statusChoices
                            .map((item) => item.label)
                            .toList();

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
                              title: "Status",
                              color: color.primary,
                              size: AppSizes.sectionTitle,
                            ),

                            SizedBox(height: AppSizes.appbarGap),

                            CustomDropdown(
                              items: statusItems,
                              initialValue: selectedLabel ?? statusItems.first,
                              width: 100.w,
                              onChanged: (value) {
                                final selectedChoice = statusChoices.firstWhere(
                                      (item) => item.label == value,
                                );

                                setState(() {
                                  selectedStatusValue = selectedChoice.value;

                                  // Status change করলে আগের date/time clear
                                  if (selectedChoice.value != "schedule") {
                                    publishTimeController.clear();
                                  }
                                });

                                debugPrint(
                                  "Selected status: ${selectedChoice.value}",
                                );

                              },
                            ),

                            SizedBox(height: AppSizes.itemGap),



                            if (selectedStatusValue == "draft" ||
                                selectedStatusValue == "published" ||
                                selectedStatusValue == "archived")
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextBodyStyleWidget(
                                    title: "Publish Date",
                                    color: color.primary,
                                    size: AppSizes.cardTitle,
                                  ),

                                  SizedBox(
                                    height: AppSizes.appbarGap,
                                  ),

                                  CustomTextFieldWidget(
                                    hintText: "yyyy-mm-dd",
                                    controller: publishDateController,
                                    isDatePicker: true,
                                  ),
                                ],
                              )

                            else if (selectedStatusValue  == "schedule")
                              Row(
                                children: [

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextBodyStyleWidget(
                                          title: "Publish Date",
                                          color: color.primary,
                                          size: AppSizes.cardTitle,
                                        ),

                                        SizedBox(
                                          height: AppSizes.appbarGap,
                                        ),

                                        CustomTextFieldWidget(
                                          hintText: "yyyy-mm-dd",
                                          controller: publishDateController,
                                          isDatePicker: true,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    width: AppSizes.smallGap,
                                  ),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextBodyStyleWidget(
                                          title: "Time",
                                          color: color.primary,
                                          size: AppSizes.cardTitle,
                                        ),

                                        SizedBox(
                                          height: AppSizes.appbarGap,
                                        ),

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
                  // PDF View Mode
                  // ==================================================

                  CustomCard(
                    child: Row(
                      children: [
                        Checkbox(
                          value: isShowPdf,
                          side: BorderSide(
                            color: color.primary,
                          ),
                          activeColor: color.primary,
                          onChanged: (value) {
                            setState(() {
                              isShowPdf = value ?? false;
                            });
                          },
                        ),

                        Expanded(
                          child: TextBodyStyleWidget(
                            title:
                            "Show PDF in view mode "
                                "(embed PDF viewer on public page "
                                "instead of showing only a download "
                                "button)",
                            fontbold: false,
                          ),
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
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            TextBodyStyleWidget(
                              title: "Featured Image",
                              color: color.primary,
                              size: AppSizes.sectionTitle,
                            ),

                            SizedBox(
                              width: AppSizes.appbarGap,
                            ),

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
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
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
                            title:
                            "Recommended size: 1200x600px "
                                "for banners, 600x600px for cards.",
                            size: AppSizes.cardTitle,
                            maxLines: 2,
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSizes.sectionGap),

                  // ==================================================
                  // Buttons
                  // ==================================================

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
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

                      SizedBox(
                        width: AppSizes.appbarGap,
                      ),

                      Flexible(
                        child: CustomButton(
                          text: isSaving
                              ? "Saving..."
                              : "Save Post",
                          onTap: isSaving
                              ? () {}
                              : _handleSaveNotice,
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
}