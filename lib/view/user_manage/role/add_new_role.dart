import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../data/model/user_manage/role/role_permission_model.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/snackbar_message.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../viewModel/user_manage/role_view_model.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/textStyle/text_title_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_text_field.dart';
import '../../../widget/universal/search_text_field.dart';

class AddNewRole extends StatefulWidget {
  const AddNewRole({
    super.key,
    this.isEdit = false,
    this.role,
  });

  final bool isEdit;
  final RoleModel? role;

  @override
  State<AddNewRole> createState() => _AddNewRoleState();
}

class _AddNewRoleState extends State<AddNewRole> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  // Selected Permission IDs Store
  final Set<int> selectedPermissionIds = {};

  bool isSaving = false;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
  }

  void _initData() {
    if (isInitialized) return;

    final viewModel = context.read<RoleViewModel>();

    // Fetch permissions list if empty
    if (viewModel.permissionsList.isEmpty) {
      viewModel.fetchPermissionsApi();
    }

    // Populate Arguments if passed via Route Modal
    RoleModel? currentRole = widget.role;
    bool isEditMode = widget.isEdit;

    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs is Map<String, dynamic>) {
      if (routeArgs['role'] is RoleModel) {
        currentRole = routeArgs['role'] as RoleModel;
      }
      if (routeArgs['isEdit'] is bool) {
        isEditMode = routeArgs['isEdit'] as bool;
      }
    }

    // Populate Edit Mode Data
    if (isEditMode && currentRole != null) {
      nameController.text = currentRole.name ?? '';
      if (currentRole.permissions != null) {
        selectedPermissionIds.addAll(currentRole.permissions!);
      }
    }

    setState(() {
      isInitialized = true;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // GROUP PERMISSIONS BY APP LABEL / MODEL
  // ============================================================
  Map<String, List<PermissionModel>> _groupPermissions(
      List<PermissionModel> permissions,
      ) {
    final Map<String, List<PermissionModel>> grouped = {};

    for (var p in permissions) {
      final category = (p.appLabel ?? 'General').toUpperCase();
      grouped.putIfAbsent(category, () => []).add(p);
    }

    return grouped;
  }

  // Helper: Get Permission Model by ID
  PermissionModel? _getPermissionById(
      List<PermissionModel> allPermissions,
      int id,
      ) {
    try {
      return allPermissions.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // SAVE / UPDATE ROLE ACTION
  // ============================================================
  Future<void> _handleSaveRole(RoleModel? currentRole) async {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter role name");
      return;
    }

    setState(() {
      isSaving = true;
    });

    final Map<String, dynamic> data = {
      "name": name,
      "permissions": selectedPermissionIds.toList(),
    };

    final viewModel = context.read<RoleViewModel>();
    bool success = false;

    if (widget.isEdit && currentRole?.id != null) {
      success = await viewModel.updateRoleApi(currentRole!.id!, data);
    } else {
      success = await viewModel.createRoleApi(data);
    }

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      SnackBarMessage.showSnackBar(
        context,
        widget.isEdit
            ? "Role updated successfully!"
            : "Role created successfully!",
      );
      Navigator.pop(context, true);
    } else {
      SnackBarMessage.showSnackBar(
        context,
        viewModel.errorMessage ??
            (widget.isEdit
                ? "Failed to update role"
                : "Failed to create role"),
      );
    }
  }

  // ============================================================
  // MAIN BUILD METHOD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    // Check Route Arguments for Edit Mode Role
    RoleModel? currentRole = widget.role;
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs is Map<String, dynamic> && routeArgs['role'] is RoleModel) {
      currentRole = routeArgs['role'] as RoleModel;
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: widget.isEdit ? "Edit Role Details" : "Create New Role",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Consumer<RoleViewModel>(
                  builder: (context, viewModel, child) {
                    final allPermissions = viewModel.permissionsList;
                    final groupedPermissions =
                    _groupPermissions(allPermissions);

                    return Column(
                      children: [
                        // =====================================================
                        // ROLE NAME INPUT
                        // =====================================================
                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextBodyStyleWidget(
                                title: "Role Name *",
                                color: color.primary,
                                size: AppSizes.sectionTitle,
                              ),
                              SizedBox(height: AppSizes.appbarGap),
                              CustomTextFieldWidget(
                                hintText: "Enter role name (e.g. Manager)",
                                controller: nameController,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: AppSizes.sectionGap),

                        // =====================================================
                        // ASSIGNED PERMISSIONS DISPLAY
                        // =====================================================
                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  TextBodyStyleWidget(
                                    title: "Assigned Permissions",
                                    color: color.primary,
                                    size: AppSizes.sectionTitle,
                                  ),
                                  SizedBox(width: AppSizes.smallGap),
                                  Text(
                                    "(${selectedPermissionIds.length} selected)",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSizes.appbarGap),
                              Container(
                                height: 22.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: color.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.buttonRadius,
                                  ),
                                ),
                                child: selectedPermissionIds.isEmpty
                                    ? Padding(
                                  padding: EdgeInsets.all(
                                    AppSizes.contentPadding,
                                  ),
                                  child: const Text(
                                    "No permissions selected.",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                                    : ListView.builder(
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppSizes.smallPadding,
                                  ),
                                  itemCount: selectedPermissionIds.length,
                                  itemBuilder: (context, index) {
                                    final permId = selectedPermissionIds
                                        .elementAt(index);
                                    final permission = _getPermissionById(
                                      allPermissions,
                                      permId,
                                    );

                                    // ✅ FIXED: Material দিয়ে Wrap করা হয়েছে
                                    return Material(
                                      color: Colors.transparent,
                                      child: ListTile(
                                        dense: true,
                                        contentPadding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        title: TextBodyStyleWidget(
                                          title: permission?.name ??
                                              "Permission #$permId",
                                          fontbold: false,
                                          size: AppSizes.cardTitle,
                                        ),
                                        trailing: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedPermissionIds
                                                  .remove(permId);
                                            });
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: AppSizes.icon,
                                            color: color.primary,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: AppSizes.sectionGap),

                        // =====================================================
                        // ASSIGN PERMISSIONS SECTION
                        // =====================================================
                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextBodyStyleWidget(
                                title: "Assign Permissions",
                                color: color.primary,
                                size: AppSizes.sectionTitle,
                              ),
                              SizedBox(height: AppSizes.appbarGap),

                              // SEARCH INPUT
                              Row(
                                children: [
                                  Expanded(
                                    child: SearchTextField(
                                      hinText: "Search Permissions...",
                                      controller: searchController,
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: AppSizes.smallGap),

                              // PERMISSION LIST CONTAINER
                              Container(
                                height: 45.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: color.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.buttonRadius,
                                  ),
                                ),
                                child: viewModel.isLoading
                                    ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                    : ListView(
                                  padding: EdgeInsets.zero,
                                  children: groupedPermissions.entries
                                      .map((entry) {
                                    final category = entry.key;
                                    final permissionList = entry.value;

                                    // SEARCH FILTER
                                    final filteredList = permissionList
                                        .where((permission) {
                                      final query = searchController.text
                                          .toLowerCase();
                                      final nameMatch = (permission.name ??
                                          '')
                                          .toLowerCase()
                                          .contains(query);
                                      final codeMatch = (permission
                                          .codename ??
                                          '')
                                          .toLowerCase()
                                          .contains(query);
                                      return nameMatch || codeMatch;
                                    }).toList();

                                    if (filteredList.isEmpty) {
                                      return const SizedBox();
                                    }

                                    // CHECK IF ALL CATEGORY ITEMS ARE SELECTED
                                    final allSelected = filteredList.every(
                                          (permission) =>
                                      permission.id != null &&
                                          selectedPermissionIds
                                              .contains(permission.id),
                                    );

                                    return Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        // CATEGORY HEADER
                                        Container(
                                          padding: EdgeInsets.all(
                                            AppSizes.contentPadding,
                                          ),
                                          decoration: BoxDecoration(
                                            color: color
                                                .lightVersionOfPrimaryLightVersion,
                                            border: Border(
                                              bottom: BorderSide(
                                                color: color
                                                    .lightVersionOfPrimaryLightVersion,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: TextTitleWidget(
                                                  title: category,
                                                  color: color.primary,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    if (allSelected) {
                                                      for (final p
                                                      in filteredList) {
                                                        if (p.id != null) {
                                                          selectedPermissionIds
                                                              .remove(
                                                              p.id);
                                                        }
                                                      }
                                                    } else {
                                                      for (final p
                                                      in filteredList) {
                                                        if (p.id != null) {
                                                          selectedPermissionIds
                                                              .add(p.id!);
                                                        }
                                                      }
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  allSelected
                                                      ? "Unselect All"
                                                      : "Select All",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // PERMISSION CHECKBOXES
                                        ...filteredList.map((permission) {
                                          final permId = permission.id;
                                          final isSelected =
                                              permId != null &&
                                                  selectedPermissionIds
                                                      .contains(permId);

                                          // ✅ FIXED: Material দিয়ে Wrap করা হয়েছে
                                          return Material(
                                            color: Colors.transparent,
                                            child: CheckboxListTile(
                                              dense: true,
                                              value: isSelected,
                                              activeColor: color.primary,
                                              controlAffinity:
                                              ListTileControlAffinity
                                                  .leading,
                                              title: TextBodyStyleWidget(
                                                title: permission.name ??
                                                    "N/A",
                                                color: color.primary,
                                                fontbold: false,
                                              ),
                                              onChanged: (_) {
                                                if (permId == null) return;
                                                setState(() {
                                                  if (isSelected) {
                                                    selectedPermissionIds
                                                        .remove(permId);
                                                  } else {
                                                    selectedPermissionIds
                                                        .add(permId);
                                                  }
                                                });
                                              },
                                            ),
                                          );
                                        }),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: AppSizes.sectionGap),

                        // =====================================================
                        // ACTION BUTTONS (CANCEL / SAVE)
                        // =====================================================
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
                                text: isSaving
                                    ? (widget.isEdit ? "Updating..." : "Creating..." )
                                    : (widget.isEdit ? "Update" : "Create"),
                                onTap:  isSaving? null : ()=>_handleSaveRole(currentRole),
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