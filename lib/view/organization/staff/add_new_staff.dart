import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/viewModel/organization/staff_view_model.dart';

import '../../../routes/routes_name.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/snackbar_message.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_drop_down.dart';
import '../../../widget/universal/custom_text_field.dart';

class AddNewStaff extends StatefulWidget {
  const AddNewStaff({super.key});

  @override
  State<AddNewStaff> createState() => _AddNewStaffState();
}

class _AddNewStaffState extends State<AddNewStaff> {
  // Text Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController joinDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Loading & Media States
  bool isSaving = false;
  File? selectedImage;
  String? selectedImageUrl;
  int? selectedAttachmentId;

  // Selected API values
  String? selectedStatusValue;
  int? selectedDepartmentId;

  @override
  void initState() {
    super.initState();

    // ViewModel থেকে API কল
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<StaffViewModel>();

      // statusChoices এবং departmentList পাওয়ার জন্য মেথড কল
      await provider.getStatusChoices();
      await provider.getDepartmentApi();

      if (mounted) {
        // Status এর প্রথম Value সেট করা
        if (provider.statusChoices.isNotEmpty) {
          setState(() {
            selectedStatusValue = provider.statusChoices.first.value;
          });
        }

        // Department এর প্রথম ID সেট করা
        if (provider.departmentList.isNotEmpty) {
          setState(() {
            selectedDepartmentId = provider.departmentList.first.id;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    positionController.dispose();
    qualificationController.dispose();
    joinDateController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // ============================================================
  // Media Management (Profile Photo Selection)
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

  // ============================================================
  // Helpers
  // ============================================================
  void _showMessage(String message) {
    SnackBarMessage.showSnackBar(context, message);
  }

  // ============================================================
  // Save Staff Data
  // ============================================================
  Future<void> _handleSaveStaff() async {
    // Validations
    if (fullNameController.text.trim().isEmpty) {
      _showMessage("Please enter full name");
      return;
    }

    if (emailController.text.trim().isEmpty) {
      _showMessage("Please enter email address");
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      _showMessage("Please enter phone number");
      return;
    }

    if (positionController.text.trim().isEmpty) {
      _showMessage("Please enter position/role");
      return;
    }

    if (selectedStatusValue == null) {
      _showMessage("Please select a status");
      return;
    }

    if (selectedDepartmentId == null) {
      _showMessage("Please select a department");
      return;
    }

    final rawJoinDate = joinDateController.text.trim();
    if (rawJoinDate.isEmpty) {
      _showMessage("Please select join date");
      return;
    }

    // Format Join Date to yyyy-MM-dd format for API
    String formattedJoinDate = rawJoinDate;
    try {
      DateTime parsed = DateFormat('dd/MM/yyyy').parse(rawJoinDate);
      formattedJoinDate = DateFormat('yyyy-MM-dd').format(parsed);
    } catch (_) {
      try {
        DateTime parsed = DateFormat('dd MMM yyyy').parse(rawJoinDate);
        formattedJoinDate = DateFormat('yyyy-MM-dd').format(parsed);
      } catch (_) {
        try {
          DateTime parsed = DateTime.parse(rawJoinDate);
          formattedJoinDate = DateFormat('yyyy-MM-dd').format(parsed);
        } catch (_) {
          formattedJoinDate = rawJoinDate;
        }
      }
    }

    setState(() {
      isSaving = true;
    });

    // API Payload Data (Keys matched with backend expectations)
    final Map<String, dynamic> data = {
      "name": fullNameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": phoneController.text.trim(),
      "role": positionController.text.trim(),
      "status": selectedStatusValue,
      "department": selectedDepartmentId,
      "joining_date": formattedJoinDate,
      "bio": descriptionController.text.trim(),
    };

    if (selectedAttachmentId != null) {
      data["profile_pic"] = selectedAttachmentId;
    }

    // Call Provider Method
    final viewModel = context.read<StaffViewModel>();
    final success = await viewModel.createStaff(data);

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      _showMessage("Staff member created successfully!");
      Navigator.pop(context, true);
    } else {
      _showMessage(viewModel.errorMessage ?? "Failed to create staff member");
    }
  }

  // ============================================================
  // UI Build
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Create New Staff",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    // Profile Photo
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
                          else if (selectedImageUrl != null)
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
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // Personal & Job Details
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Full Name
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

                          // Email
                          TextBodyStyleWidget(
                            title: "Email*",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "user@gmail.com",
                            controller: emailController,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          // Phone
                          TextBodyStyleWidget(
                            title: "Phone*",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "01XXXXXXXXX",
                            controller: phoneController,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          // Position / Role
                          TextBodyStyleWidget(
                            title: "Position / Role*",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "e.g. Senior Manager",
                            controller: positionController,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          // Dynamic Status Dropdown
                          TextBodyStyleWidget(
                            title: "Status*",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          Consumer<StaffViewModel>(
                            builder: (context, provider, child) {
                              if (provider.statusLoading) {
                                return const SizedBox(
                                  height: 48,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final statusItems = provider.statusChoices;
                              if (statusItems.isEmpty) {
                                return const Text("No status choices available");
                              }

                              final statusLabels = statusItems.map((e) => e.label).toList();

                              final selectedItem = statusItems.firstWhere(
                                    (element) => element.value == selectedStatusValue,
                                orElse: () => statusItems.first,
                              );

                              return CustomDropdown(
                                items: statusLabels,
                                initialValue: selectedItem.label,
                                width: 100.w,
                                onChanged: (value) {
                                  final match = statusItems.firstWhere(
                                        (e) => e.label == value,
                                    orElse: () => statusItems.first,
                                  );
                                  setState(() {
                                    selectedStatusValue = match.value;
                                  });
                                },
                              );
                            },
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          // Dynamic Department Dropdown
                          TextBodyStyleWidget(
                            title: "Department*",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          Consumer<StaffViewModel>(
                            builder: (context, provider, child) {
                              if (provider.departmentLoading) {
                                return const SizedBox(
                                  height: 48,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final departments = provider.departmentList;
                              if (departments.isEmpty) {
                                return const Text("No departments available");
                              }

                              final departmentNames =
                              departments.map((e) => e.name ?? "").toList();

                              final selectedDept = departments.firstWhere(
                                    (e) => e.id == selectedDepartmentId,
                                orElse: () => departments.first,
                              );

                              return CustomDropdown(
                                items: departmentNames,
                                initialValue: selectedDept.name ?? "",
                                width: 100.w,
                                onChanged: (value) {
                                  final match = departments.firstWhere(
                                        (e) => e.name == value,
                                    orElse: () => departments.first,
                                  );
                                  setState(() {
                                    selectedDepartmentId = match.id;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // Qualification, Date & Bio
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Qualification
                          TextBodyStyleWidget(
                            title: "Qualification",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "e.g. MSC in Marketing",
                            controller: qualificationController,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          // Join Date
                          TextBodyStyleWidget(
                            title: "Join Date*",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "dd/mm/yyyy",
                            controller: joinDateController,
                            isDatePicker: true,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          // Description / Bio
                          TextBodyStyleWidget(
                            title: "Bio / Description",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            minLines: 4,
                            maxLines: 5,
                            hintText: "Write a short bio or description...",
                            controller: descriptionController,
                          ),
                          SizedBox(height: AppSizes.itemGap),
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
                          child: isSaving
                              ? const Center(child: CircularProgressIndicator())
                              : CustomButton(
                            text:  isSaving ? "Saving..." :"Save Staff",
                            onTap: isSaving ? null :_handleSaveStaff,
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