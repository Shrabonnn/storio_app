import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../data/model/organization/staff/staff_model.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/snackbar_message.dart';
import '../../../utils/theme/theme_ext.dart'; // আপনার প্রজেক্টের সঠিক পাথ ব্যবহার করুন
import '../../../viewModel/organization/staff_view_model.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_drop_down.dart';
import '../../../widget/universal/custom_text_field.dart';
import '../../../widget/universal/date_time_formate.dart';

class EditStaff extends StatefulWidget {
  const EditStaff({super.key, required this.staff});

  final StaffModel staff;

  @override
  State<EditStaff> createState() => _EditStaffState();
}

class _EditStaffState extends State<EditStaff> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController joiningDateController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  String? selectedStatus;
  int? selectedDepartmentId;
  String? selectedImageUrl;
  int? selectedProfilePicId;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    // Population from StaffModel
    fullNameController.text = widget.staff.name ?? '';
    emailController.text = widget.staff.email ?? '';
    phoneController.text = widget.staff.phone ?? '';
    roleController.text = widget.staff.role ?? '';
    joiningDateController.text = formatDate(widget.staff.joiningDate);
    bioController.text = widget.staff.bio ?? '';

    selectedStatus = widget.staff.status;
    selectedDepartmentId = widget.staff.departmentId ?? widget.staff.department;
    selectedProfilePicId = widget.staff.profilePic ?? widget.staff.profilePicData?.id;
    selectedImageUrl = widget.staff.profilePicData?.fileUrl;

    // Load dynamic dropdown data (Departments & Statuses) from ViewModel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<StaffViewModel>();
      viewModel.getStatusChoices();
      viewModel.getDepartmentApi();
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    roleController.dispose();
    joiningDateController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> _openMediaManage() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
      arguments: {
        "currentId": selectedProfilePicId,
        "currentFileUrl": selectedImageUrl,
      },
    );

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        selectedProfilePicId = result['id'] as int?;
        selectedImageUrl = result['file'] as String?;
      });
    }
  }

  Future<void> _handleUpdateStaff() async {
    if (fullNameController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter full name");
      return;
    }

    if (emailController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter email address");
      return;
    }

    if (widget.staff.id == null) {
      SnackBarMessage.showSnackBar(context, "Staff ID not found");
      return;
    }

    final viewModel = context.read<StaffViewModel>();

    setState(() {
      isSaving = true;
    });

    // Formatting date to ISO/String format for API
    String? formattedDate;
    if (joiningDateController.text.trim().isNotEmpty) {
      try {
        DateTime parsed = DateFormat('dd MMM yyyy').parse(joiningDateController.text.trim());
        formattedDate = DateFormat('yyyy-MM-dd').format(parsed);
      } catch (_) {
        try {
          DateTime parsed = DateTime.parse(joiningDateController.text.trim());
          formattedDate = DateFormat('yyyy-MM-dd').format(parsed);
        } catch (_) {
          formattedDate = joiningDateController.text.trim();
        }
      }
    }

    // Payload Map as required by StaffViewModel.updateStaff(id, data)
    final Map<String, dynamic> payload = {
      "name": fullNameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": phoneController.text.trim(),
      "role": roleController.text.trim(),
      "department": selectedDepartmentId,
      "status": selectedStatus,
      "joining_date": formattedDate,
      "bio": bioController.text.trim(),
      "profile_pic": selectedProfilePicId,
    };

    final success = await viewModel.updateStaff(widget.staff.id!, payload);

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      SnackBarMessage.showSnackBar(context, "Staff profile updated successfully");
      Navigator.pop(context, true);
    } else {
      SnackBarMessage.showSnackBar(
        context,
        viewModel.errorMessage ?? "Failed to update staff profile",
      );
    }
  }

  Widget _buildProfileImage() {
    if (selectedImageUrl != null && selectedImageUrl!.isNotEmpty) {
      return Image.network(
        selectedImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/institute.png',
            fit: BoxFit.cover,
          );
        },
      );
    }

    return Image.asset(
      'assets/images/institute.png',
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBar(
            title: "Edit Staff",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Consumer<StaffViewModel>(
                  builder: (context, viewModel, child) {
                    // Prepared Department list items
                    final departmentItems = viewModel.departmentList
                        .map((dept) => dept.name ?? '')
                        .where((name) => name.isNotEmpty)
                        .toList();

                    // Selected Department Name
                    String? currentDeptName;
                    if (selectedDepartmentId != null && viewModel.departmentList.isNotEmpty) {
                      final match = viewModel.departmentList.where((d) => d.id == selectedDepartmentId);
                      if (match.isNotEmpty) {
                        currentDeptName = match.first.name;
                      }
                    }

                    // Prepared Status items
                    final statusItems = viewModel.statusChoices.isNotEmpty
                        ? viewModel.statusChoices.map((s) => s.value).toList()
                        : ["active", "inactive", "on_leave"];

                    return Column(
                      children: [
                        // Profile Photo Card
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
                              SizedBox(height: AppSizes.smallGap),
                              Container(
                                width: 100.w,
                                height: 16.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: _buildProfileImage(),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: AppSizes.sectionGap),

                        // Personal & Professional Details
                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Full Name
                              TextBodyStyleWidget(
                                title: "Full Name",
                                color: color.primary,
                                size: AppSizes.sectionTitle,
                              ),
                              SizedBox(height: AppSizes.appbarGap),
                              CustomTextFieldWidget(
                                hintText: "John Doe",
                                controller: fullNameController,
                              ),
                              SizedBox(height: AppSizes.itemGap),

                              // Email
                              TextBodyStyleWidget(
                                title: "Email",
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
                                title: "Phone",
                                color: color.primary,
                                size: AppSizes.cardTitle,
                              ),
                              SizedBox(height: AppSizes.appbarGap),
                              CustomTextFieldWidget(
                                hintText: "01XXXXXXXXX",
                                controller: phoneController,
                              ),
                              SizedBox(height: AppSizes.itemGap),

                              // Role
                              TextBodyStyleWidget(
                                title: "Role",
                                color: color.primary,
                                size: AppSizes.cardTitle,
                              ),
                              SizedBox(height: AppSizes.appbarGap),
                              CustomTextFieldWidget(
                                hintText: "Enter Role",
                                controller: roleController,
                              ),
                              SizedBox(height: AppSizes.itemGap),

                              // Department Dropdown
                              if (departmentItems.isNotEmpty) ...[
                                TextBodyStyleWidget(
                                  title: "Department",
                                  color: color.primary,
                                  size: AppSizes.cardTitle,
                                ),
                                SizedBox(height: AppSizes.appbarGap),
                                CustomDropdown(
                                  items: departmentItems,
                                  initialValue: currentDeptName,
                                  width: 100.w,
                                  onChanged: (val) {
                                    if (val != null) {
                                      final selectedDept = viewModel.departmentList
                                          .firstWhere((d) => d.name == val.toString());
                                      setState(() {
                                        selectedDepartmentId = selectedDept.id;
                                      });
                                    }
                                  },
                                ),
                                SizedBox(height: AppSizes.itemGap),
                              ],

                              // Status Dropdown
                              TextBodyStyleWidget(
                                title: "Status",
                                color: color.primary,
                                size: AppSizes.sectionTitle,
                              ),
                              SizedBox(height: AppSizes.appbarGap),
                              CustomDropdown(
                                items: statusItems,
                                initialValue: selectedStatus ?? (statusItems.isNotEmpty ? statusItems.first : null),
                                width: 100.w,
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedStatus = value.toString();
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: AppSizes.sectionGap),

                        // Joining Date & Bio
                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Joining Date
                              TextBodyStyleWidget(
                                title: "Joining Date",
                                color: color.primary,
                                size: AppSizes.cardTitle,
                              ),
                              SizedBox(height: AppSizes.appbarGap),
                              CustomTextFieldWidget(
                                hintText: "08/08/2026",
                                controller: joiningDateController,
                                isDatePicker: true,
                              ),
                              SizedBox(height: AppSizes.itemGap),

                              // Bio
                              TextBodyStyleWidget(
                                title: "Bio",
                                color: color.primary,
                                size: AppSizes.cardTitle,
                              ),
                              SizedBox(height: AppSizes.appbarGap),
                              CustomTextFieldWidget(
                                minLines: 4,
                                maxLines: 5,
                                hintText: "Write a short bio",
                                controller: bioController,
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
                              child: CustomButton(
                                text: isSaving ? "Updating..." : "Update Staff",
                                onTap: isSaving ? null : _handleUpdateStaff,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: AppSizes.sectionGap),
                      ],
                    );
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}