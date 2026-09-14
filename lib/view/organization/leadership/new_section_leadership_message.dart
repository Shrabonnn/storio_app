import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../routes/routes_name.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/snackbar_message.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../viewModel/organization/leadership_message_view_model.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/quill/editor_icon.dart';
import '../../../widget/quill/editor_option.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_drop_down.dart';
import '../../../widget/universal/custom_text_field.dart';

class NewSectionLeadershipMessage extends StatefulWidget {
  const NewSectionLeadershipMessage({super.key});

  @override
  State<NewSectionLeadershipMessage> createState() =>
      _NewSectionLeadershipMessageState();
}

class _NewSectionLeadershipMessageState
    extends State<NewSectionLeadershipMessage> {
  final TextEditingController sectionTitleController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();

  String messageContent = "";
  String? selectedStatusValue;
  bool isSaving = false;

  // Portrait photo
  File? selectedImage;
  String? selectedImageUrl;
  int? selectedImageId;

  // Digital signature
  File? selectedSignature;
  String? selectedSignatureUrl;
  int? selectedSignatureId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<LeadershipMessageViewModel>().getStatusChoices();
    });
  }

  @override
  void dispose() {
    sectionTitleController.dispose();
    fullNameController.dispose();
    roleController.dispose();
    companyController.dispose();
    super.dispose();
  }

  // ============================================================
  // Open Message Content Details
  // ============================================================

  Future<void> _openContentDetails() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.content_details,
      arguments: {"content": messageContent},
    );

    if (!mounted) return;

    if (result is String) {
      setState(() {
        messageContent = result;
      });
    }
  }

  // ============================================================
  // Open Media Manage — Portrait Photo
  // ============================================================

  Future<void> _openImagePicker() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
    );

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        selectedImageId = result['id'] as int?;
        selectedImageUrl = result['file'] as String?;
        if (selectedImageUrl == null && result['localPath'] != null) {
          selectedImage = File(result['localPath']);
        } else {
          selectedImage = null;
        }
      });
    }
  }

  // ============================================================
  // Open Media Manage — Digital Signature
  // ============================================================

  Future<void> _openSignaturePicker() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
    );

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        selectedSignatureId = result['id'] as int?;
        selectedSignatureUrl = result['file'] as String?;
        if (selectedSignatureUrl == null && result['localPath'] != null) {
          selectedSignature = File(result['localPath']);
        } else {
          selectedSignature = null;
        }
      });
    }
  }

  void _showMessage(String message) {
    SnackBarMessage.showSnackBar(context, message);
  }

  // ============================================================
  // Save Leadership Message
  // ============================================================

  Future<void> _handleSaveMessage() async {
    if (fullNameController.text.trim().isEmpty) {
      _showMessage("Please enter full name");
      return;
    }

    if (roleController.text.trim().isEmpty) {
      _showMessage("Please enter role/title");
      return;
    }

    if (messageContent.trim().isEmpty) {
      _showMessage("Please write the message content");
      return;
    }

    final viewModel = context.read<LeadershipMessageViewModel>();

    setState(() {
      isSaving = true;
    });

    final Map<String, dynamic> data = {
      "section_title": sectionTitleController.text.trim(),
      "name": fullNameController.text.trim(),
      "role": roleController.text.trim(),
      "company": companyController.text.trim(),
      "message": messageContent.trim(),
      "status": selectedStatusValue ?? "active",
    };

    if (selectedImageId != null) {
      data["image"] = selectedImageId;
    }

    if (selectedSignatureId != null) {
      data["signature"] = selectedSignatureId;
    }

    final success = await viewModel.createMessage(data);

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      _showMessage("Leadership message created successfully");
      Navigator.pop(context, true);
    } else {
      _showMessage(
        viewModel.errorMessage ?? "Failed to create leadership message",
      );
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
            title: "Create New Section",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // ==================================================
                  // Profile Photo
                  // ==================================================
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextBodyStyleWidget(
                              title: "Profile Photo",
                              color: color.primary,
                              size: AppSizes.sectionTitle,
                            ),
                            SizedBox(width: AppSizes.appbarGap),
                            CustomButton(
                              height: 4.h,
                              width: 30.w,
                              text: "Select Image",
                              onTap: _openImagePicker,
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
                            title: "Recommended size: 600x600px for photo.",
                            size: AppSizes.cardTitle,
                            maxLines: 2,
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSizes.sectionGap),

                  // ==================================================
                  // Section Title
                  // ==================================================
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBodyStyleWidget(
                          title: "Section Title",
                          color: color.primary,
                          size: AppSizes.sectionTitle,
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(
                          hintText: "e.g. Message from Chairman",
                          controller: sectionTitleController,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSizes.sectionGap),

                  // ==================================================
                  // Personal Information
                  // ==================================================
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBodyStyleWidget(
                          title: "Personal Information",
                          color: color.primary,
                          size: AppSizes.sectionTitle,
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        TextBodyStyleWidget(
                          title: "Full Name",
                          color: color.primary,
                          size: AppSizes.cardTitle,
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(
                          hintText: "e.g. John Doe",
                          controller: fullNameController,
                        ),
                        SizedBox(height: AppSizes.itemGap),
                        TextBodyStyleWidget(
                          title: "Role / Title",
                          color: color.primary,
                          size: AppSizes.cardTitle,
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(
                          hintText: "e.g. Managing Director",
                          controller: roleController,
                        ),
                        SizedBox(height: AppSizes.itemGap),
                        TextBodyStyleWidget(
                          title: "Company / Organization",
                          color: color.primary,
                          size: AppSizes.cardTitle,
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(
                          hintText: "e.g. ABC Group",
                          controller: companyController,
                        ),
                        SizedBox(height: AppSizes.itemGap),
                        Consumer<LeadershipMessageViewModel>(
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
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        )                      ],
                    ),
                  ),

                  SizedBox(height: AppSizes.sectionGap),

                  // ==================================================
                  // Message Content
                  // ==================================================
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBodyStyleWidget(
                          title: "Message Content",
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
                              title: messageContent.isEmpty
                                  ? "Write message content here..."
                                  : messageContent,
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
                  // Digital Signature
                  // ==================================================
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextBodyStyleWidget(
                              title: "Digital Signature",
                              color: color.primary,
                              size: AppSizes.sectionTitle,
                            ),
                            SizedBox(width: AppSizes.appbarGap),
                            CustomButton(
                              height: 4.h,
                              width: 30.w,
                              text: "Select Signature",
                              onTap: _openSignaturePicker,
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.itemGap),
                        if (selectedSignature != null)
                          Container(
                            width: 100.w,
                            height: 12.h,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppSizes.cardRadius,
                              ),
                            ),
                            child: Image.file(
                              selectedSignature!,
                              fit: BoxFit.contain,
                            ),
                          )
                        else if (selectedSignatureUrl != null)
                          Container(
                            width: 100.w,
                            height: 12.h,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppSizes.cardRadius,
                              ),
                            ),
                            child: Image.network(
                              selectedSignatureUrl!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image);
                              },
                            ),
                          )
                        else
                          TextBodyStyleWidget(
                            title: "Upload image of digital signature.",
                            size: AppSizes.cardTitle,
                            maxLines: 2,
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSizes.sectionGap),


                  // ==================================================
                  // Action Buttons
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
                          text: isSaving ? "Saving..." : "Save Section",
                          onTap: isSaving ? () {} : _handleSaveMessage,
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