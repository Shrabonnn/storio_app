import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../data/model/organization/leader_message/leadership_message_model.dart';
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

class EditSectionLeadershipMessage extends StatefulWidget {
  const EditSectionLeadershipMessage({super.key, required this.message});

  final LeadershipMessageModel message;

  @override
  State<EditSectionLeadershipMessage> createState() =>
      _EditSectionLeadershipMessageState();
}

class _EditSectionLeadershipMessageState
    extends State<EditSectionLeadershipMessage> {
  final TextEditingController sectionTitleController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();

  String messageContent = "";
  String? selectedStatusValue;
  bool isSaving = false;

  // Profile Image State
  String? selectedImageUrl;
  int? selectedImageId;

  // Signature Image State
  String? selectedSignatureUrl;
  int? selectedSignatureId;

  @override
  void initState() {
    super.initState();

    _prefillFromModel(widget.message);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final viewModel = context.read<LeadershipMessageViewModel>();
      viewModel.getStatusChoices();

      if (widget.message.id != null) {
        await viewModel.getMessageDetail(widget.message.id!);
        if (!mounted) return;
        if (viewModel.messageDetail != null) {
          _prefillFromModel(viewModel.messageDetail!);
        }
      }
    });
  }

  void _prefillFromModel(LeadershipMessageModel message) {
    sectionTitleController.text = message.sectionTitle ?? '';
    fullNameController.text = message.name ?? '';
    roleController.text = message.role ?? '';
    companyController.text = message.company ?? '';
    messageContent = message.message ?? '';
    selectedStatusValue = message.status;

    selectedImageId = message.image;
    selectedImageUrl = message.imageData?.fileUrl;

    selectedSignatureId = message.signature;
    selectedSignatureUrl = message.signatureData?.fileUrl;

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    sectionTitleController.dispose();
    fullNameController.dispose();
    roleController.dispose();
    companyController.dispose();
    super.dispose();
  }

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

  Future<void> _openImagePicker() async {
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

  Future<void> _openSignaturePicker() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
      arguments: {
        "currentId": selectedSignatureId,
        "currentFileUrl": selectedSignatureUrl,
      },
    );

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        selectedSignatureId = result['id'] as int?;
        selectedSignatureUrl = result['file'] as String?;
      });
    }
  }

  Future<void> _handleUpdateMessage() async {
    if (fullNameController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter full name");
      return;
    }

    if (roleController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter role/title");
      return;
    }

    if (messageContent.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please write the message content");
      return;
    }

    if (widget.message.id == null) {
      SnackBarMessage.showSnackBar(context, "Message ID not found");
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

    final success = await viewModel.updateMessage(widget.message.id!, data);

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      SnackBarMessage.showSnackBar(context, "Leadership message updated successfully");
      Navigator.pop(context, true);
    } else {
      SnackBarMessage.showSnackBar(
        context,
        viewModel.errorMessage ?? "Failed to update leadership message",
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
            title: "Edit Section",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    // ==================================================
                    // Profile Photo
                    // ==================================================
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextBodyStyleWidget(
                                title: "Profile Photo",
                                color: color.primary,
                                size: AppSizes.sectionTitle,
                              ),
                              CustomButton(
                                width: 30.w,
                                text: "Select Image",
                                onTap: _openImagePicker,
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          if (selectedImageUrl != null && selectedImageUrl!.isNotEmpty)
                            Container(
                              width: 100.w,
                              height: 16.h,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                              ),
                              child: Image.network(
                                selectedImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, size: 50);
                                },
                              ),
                            )
                          else
                            TextBodyStyleWidget(
                              title: "Recommended size: 600x600px photo.",
                              size: AppSizes.cardTitle,
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // ==================================================
                    // Basic Info
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
                            hintText: "e.g. Chairman's Desk",
                            controller: sectionTitleController,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          TextBodyStyleWidget(
                            title: "Full Name*",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "John Doe",
                            controller: fullNameController,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          TextBodyStyleWidget(
                            title: "Role / Title*",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "e.g. Principal, Chairman",
                            controller: roleController,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          TextBodyStyleWidget(
                            title: "Institute / Company",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "e.g. Storio Academy",
                            controller: companyController,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          // Status Dropdown
                          TextBodyStyleWidget(
                            title: "Status",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          Consumer<LeadershipMessageViewModel>(
                            builder: (context, provider, child) {
                              if (provider.statusLoading) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              if (provider.statusChoices.isEmpty) {
                                return const Text("No status choices available");
                              }

                              final statusLabels =
                              provider.statusChoices.map((e) => e.label).toList();

                              selectedStatusValue ??= provider.statusChoices.first.value;

                              final selectedItem = provider.statusChoices.firstWhere(
                                    (e) => e.value == selectedStatusValue,
                                orElse: () => provider.statusChoices.first,
                              );

                              return CustomDropdown(
                                items: statusLabels,
                                initialValue: selectedItem.label,
                                width: 100.w,
                                onChanged: (value) {
                                  final match = provider.statusChoices.firstWhere(
                                        (e) => e.label == value,
                                    orElse: () => provider.statusChoices.first,
                                  );
                                  setState(() {
                                    selectedStatusValue = match.value;
                                  });
                                },
                              );
                            },
                          ),
                        ],
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
                            title: "Message*",
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
                            child: Padding(
                              padding: EdgeInsets.all(AppSizes.smallPadding),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextBodyStyleWidget(
                                title: "Digital Signature",
                                color: color.primary,
                                size: AppSizes.sectionTitle,
                              ),
                              CustomButton(
                                width: 30.w,
                                text: "Select Signature",
                                onTap: _openSignaturePicker,
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          if (selectedSignatureUrl != null && selectedSignatureUrl!.isNotEmpty)
                            Container(
                              width: 100.w,
                              height: 12.h,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                              ),
                              child: Image.network(
                                selectedSignatureUrl!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, size: 50);
                                },
                              ),
                            )
                          else
                            TextBodyStyleWidget(
                              title: "Recommended size: PNG transparent signature.",
                              size: AppSizes.cardTitle,
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
                          onTap: () => Navigator.pop(context),
                          width: 30.w,
                          backgroundColor: color.cardBackground,
                          foregroundColor: color.primary,
                        ),
                        SizedBox(width: AppSizes.appbarGap),
                        Flexible(
                          child: isSaving
                              ? const Center(child: CircularProgressIndicator())
                              : CustomButton(
                            text: "Update Message",
                            onTap: _handleUpdateMessage,
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