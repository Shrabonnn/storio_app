import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../data/model/organization/team/team_member_model.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/snackbar_message.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../viewModel/organization/team_member_view_model.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_drop_down.dart';
import '../../../widget/universal/custom_text_field.dart';

class EditTeamMember extends StatefulWidget {
  const EditTeamMember({super.key, required this.member});

  final TeamMemberModel member;

  @override
  State<EditTeamMember> createState() => _EditTeamMemberState();
}

class _EditTeamMemberState extends State<EditTeamMember> {
  // Text Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();

  // Loading & Media States
  bool isSaving = false;
  File? selectedImage;
  String? selectedImageUrl;
  int? selectedAttachmentId;

  // Selected API values
  int? selectedSectionId;
  String selectedImageShape = "square";
  bool isVisible = true;

  final List<String> imageShapeOptions = ["square", "circle"];

  @override
  void initState() {
    super.initState();

    // Populate data from TeamMemberModel
    fullNameController.text = widget.member.fullname ?? '';
    positionController.text = widget.member.designation ?? '';
    roleController.text = widget.member.role ?? '';
    experienceController.text = widget.member.experience ?? '';

    selectedSectionId = widget.member.section;
    selectedAttachmentId = widget.member.image;
    selectedImageShape = widget.member.imageShape ?? "square";
    isVisible = widget.member.isVisible ?? true;

    // Load existing image URL if available
    if (widget.member.imageData != null) {
      selectedImageUrl = widget.member.imageData?.fileUrl;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<TeamViewModel>();
      await provider.fetchManagementSections();

      if (mounted) {
        if (selectedSectionId == null && provider.managementSections.isNotEmpty) {
          setState(() {
            selectedSectionId = provider.managementSections.first.id;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    positionController.dispose();
    roleController.dispose();
    experienceController.dispose();
    super.dispose();
  }

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
        if (selectedImageUrl == null && result['localPath'] != null) {
          selectedImage = File(result['localPath']);
        } else {
          selectedImage = null;
        }
      });
    }
  }

  void _showMessage(String message) {
    SnackBarMessage.showSnackBar(context, message);
  }

  Future<void> _handleUpdateMember() async {
    if (fullNameController.text.trim().isEmpty) {
      _showMessage("Please enter full name");
      return;
    }

    if (positionController.text.trim().isEmpty) {
      _showMessage("Please enter designation");
      return;
    }

    if (selectedSectionId == null) {
      _showMessage("Please select a section");
      return;
    }

    if (widget.member.id == null) {
      _showMessage("Team member ID not found");
      return;
    }

    setState(() {
      isSaving = true;
    });

    final Map<String, dynamic> payload = {
      "fullname": fullNameController.text.trim(),
      "designation": positionController.text.trim(),
      "role": roleController.text.trim(),
      "experience": experienceController.text.trim(),
      "section": selectedSectionId,
      "image": selectedAttachmentId,
      "image_shape": selectedImageShape,
      "is_visible": isVisible,
    };

    final viewModel = context.read<TeamViewModel>();
    final success = await viewModel.updateTeamMember(widget.member.id!, payload);

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      _showMessage("Team member updated successfully!");
      Navigator.pop(context, true);
    } else {
      _showMessage(viewModel.errorMessage ?? "Failed to update team member");
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBar(
            title: "Edit Member",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    // Card 1: Profile Photo & Shape Selection
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
                                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                              ),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          else if (selectedImageUrl != null && selectedImageUrl!.isNotEmpty)
                            Container(
                              width: 100.w,
                              height: 20.h,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppSizes.cardRadius),
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
                              title: "Recommended size: 600x600px square photo.",
                              size: AppSizes.cardTitle,
                              maxLines: 2,
                            ),
                          SizedBox(height: AppSizes.itemGap),

                          // Image Shape Dropdown
                          TextBodyStyleWidget(
                            title: "Image Shape*",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomDropdown(
                            items: imageShapeOptions,
                            initialValue: selectedImageShape,
                            width: 100.w,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedImageShape = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // Card 2: Basic Information Form
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBodyStyleWidget(
                            title: "Full Name*",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "e.g. John Doe",
                            controller: fullNameController,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          TextBodyStyleWidget(
                            title: "Designation*",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "e.g. Chief Executive Officer",
                            controller: positionController,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          TextBodyStyleWidget(
                            title: "Section*",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          Consumer<TeamViewModel>(
                            builder: (context, provider, child) {
                              if (provider.isLoading &&
                                  provider.managementSections.isEmpty) {
                                return const SizedBox(
                                  height: 48,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final sections = provider.managementSections;
                              if (sections.isEmpty) {
                                return const Text("No sections available");
                              }

                              final sectionNames =
                              sections.map((e) => e.name ?? "").toList();

                              final selectedSec = sections.firstWhere(
                                    (e) => e.id == selectedSectionId,
                                orElse: () => sections.first,
                              );

                              return CustomDropdown(
                                items: sectionNames,
                                initialValue: selectedSec.name ?? "",
                                width: 100.w,
                                onChanged: (value) {
                                  final match = sections.firstWhere(
                                        (e) => e.name == value,
                                    orElse: () => sections.first,
                                  );
                                  setState(() {
                                    selectedSectionId = match.id;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // Card 3: Additional Details
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBodyStyleWidget(
                            title: "Role / Description",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "Role details...",
                            controller: roleController,
                            minLines: 2,
                            maxLines: 5,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          TextBodyStyleWidget(
                            title: "Experience / Background",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "Write about experience...",
                            controller: experienceController,
                            minLines: 2,
                            maxLines: 5,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                activeColor: color.primary,
                                value: isVisible,
                                onChanged: (value) {
                                  setState(() {
                                    isVisible = value ?? false;
                                  });
                                },
                              ),
                              SizedBox(width: AppSizes.smallGap),
                              Flexible(
                                child: TextBodyStyleWidget(
                                  title: "Make this member visible to the public",
                                  color: color.primary,
                                  size: AppSizes.cardTitle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // Action Buttons
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
                          child: CustomButton(
                            text: isSaving ? "Updating...":"Update Member",
                            onTap: isSaving ? null :_handleUpdateMember,
                          )
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