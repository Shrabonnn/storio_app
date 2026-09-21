import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../data/model/organization/staff/staff_model.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/snackbar_message.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../viewModel/organization/staff_view_model.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/textStyle/text_title_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_card2.dart';
import '../../../widget/universal/custom_text_field.dart';

class ManageStaffDepartment extends StatefulWidget {
  const ManageStaffDepartment({super.key});

  @override
  State<ManageStaffDepartment> createState() => _ManageStaffDepartmentState();
}

class _ManageStaffDepartmentState extends State<ManageStaffDepartment> {
  final TextEditingController departmentNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DepartmentModel? editingDepartment;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StaffViewModel>().getDepartmentApi();
    });
  }

  @override
  void dispose() {
    departmentNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void clearForm() {
    departmentNameController.clear();
    descriptionController.clear();
    setState(() {
      editingDepartment = null;
    });
  }

  void editDepartment(DepartmentModel department) {
    departmentNameController.text = department.name ?? '';
    descriptionController.text = department.description ?? '';
    setState(() {
      editingDepartment = department;
    });
  }

  Future<void> submitDepartment() async {
    if (departmentNameController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter department name");
      return;
    }

    final provider = context.read<StaffViewModel>();

    final data = {
      "name": departmentNameController.text.trim(),
      "description": descriptionController.text.trim(),
    };

    bool success;

    if (editingDepartment == null) {
      success = await provider.createDepartment(data);
    } else {
      if (editingDepartment!.id == null) return;
      success = await provider.updateDepartment(
        editingDepartment!.id!,
        data,
      );
    }

    if (!mounted) return;

    if (success) {
      final isCreating = editingDepartment == null;
      clearForm();
      provider.getDepartmentApi(); // Refresh department list

      SnackBarMessage.showSnackBar(
        context,
        isCreating
            ? "Department created successfully."
            : "Department updated successfully.",
      );
    } else {
      SnackBarMessage.showSnackBar(
        context,
        provider.departmentErrorMessage ?? "Something went wrong.",
      );
    }
  }

  Future<void> deleteDepartment(int id) async {
    final provider = context.read<StaffViewModel>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Department"),
          content: const Text(
            "Are you sure you want to delete this department?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final success = await provider.deleteDepartment(id);

    if (!mounted) return;

    SnackBarMessage.showSnackBar(
      context,
      success
          ? "Department deleted successfully."
          : provider.departmentErrorMessage ?? "Failed to delete department.",
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBar(
            title: "Manage Staff Departments",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    // =====================================================
                    // CREATE / EDIT DEPARTMENT FORM
                    // =====================================================
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBodyStyleWidget(
                            title: editingDepartment == null
                                ? "Create New Department"
                                : "Edit Department: ${editingDepartment?.name ?? ''}",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.sectionGap),

                          // Department Name
                          TextBodyStyleWidget(
                            title: "Department Name",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "e.g. Marketing, Accounts",
                            controller: departmentNameController,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          // Description
                          TextBodyStyleWidget(
                            title: "Description",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "Brief description of the department",
                            controller: descriptionController,
                            minLines: 4,
                            maxLines: 6,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // Submit & Cancel Buttons
                    Consumer<StaffViewModel>(
                      builder: (context, provider, child) {
                        return Row(
                          children: [
                            if (editingDepartment != null) ...[
                              CustomButton(
                                text: "Cancel",
                                width: 30.w,
                                onTap: clearForm,
                                backgroundColor: color.cardBackground,
                                foregroundColor: color.primary,
                              ),
                              SizedBox(width: AppSizes.appbarGap),
                            ],
                            Flexible(
                              child: CustomButton(
                                text: editingDepartment == null
                                    ? "Create Department"
                                    : "Update Department",
                                onTap: provider.departmentLoading
                                    ? null
                                    : submitDepartment,
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // =====================================================
                    // EXISTING DEPARTMENTS LIST
                    // =====================================================
                    Consumer<StaffViewModel>(
                      builder: (context, provider, child) {
                        if (provider.departmentLoading &&
                            provider.departmentList.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (provider.departmentList.isEmpty) {
                          return CustomCard(
                            child: Center(
                              child: TextBodyStyleWidget(
                                title: "No departments found.",
                                color: color.primary,
                              ),
                            ),
                          );
                        }

                        return CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextBodyStyleWidget(
                                title:
                                "Existing Departments (${provider.departmentList.length})",
                                color: color.primary,
                                size: AppSizes.sectionTitle,
                              ),
                              SizedBox(height: AppSizes.itemGap),
                              ListView.separated(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: provider.departmentList.length,
                                separatorBuilder: (context, index) {
                                  return const Divider();
                                },
                                itemBuilder: (context, index) {
                                  final dept = provider.departmentList[index];

                                  return CustomCard2(
                                    child: Padding(
                                      padding:
                                      EdgeInsets.all(AppSizes.smallPadding),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                TextTitleWidget(
                                                  title: dept.name ?? '',
                                                  color: color.primary,
                                                  maxLines: 1,
                                                ),
                                                SizedBox(
                                                    height: AppSizes.appbarGap),
                                                TextBodyStyleWidget(
                                                  title: dept.description ??
                                                      'No description provided.',
                                                  maxLines: 2,
                                                  size: AppSizes.cardTitle,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  editDepartment(dept);
                                                },
                                                icon: Icon(
                                                  Icons.edit,
                                                  size: AppSizes.iconLarge,
                                                  color: color.primary,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  if (dept.id != null) {
                                                    deleteDepartment(dept.id!);
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.delete_outline_outlined,
                                                  size: AppSizes.iconLarge,
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    SizedBox(height: AppSizes.appbarGap),
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