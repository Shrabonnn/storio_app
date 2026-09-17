import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../data/model/user_manage/user/user_model.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/snackbar_message.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../viewModel/user_manage/user_view_model.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_drop_down.dart';
import '../../../widget/universal/custom_text_field.dart';

class AddNewUser extends StatefulWidget {
  const AddNewUser({
    super.key,
    this.isEdit = false,
    this.user,
  });

  final bool isEdit;
  final ManageUserModel? user;

  @override
  State<AddNewUser> createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController firstNameController =
  TextEditingController();

  final TextEditingController lastNameController =
  TextEditingController();

  final TextEditingController usernameController =
  TextEditingController();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController phoneController =
  TextEditingController();

  final TextEditingController addressController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  final TextEditingController confirmPasswordController =
  TextEditingController();

  // ============================================================
  // STATE
  // ============================================================

  final List<String> statusList = [
    "Active",
    "Inactive",
  ];

  String selectedStatus = "Active";

  int? selectedRoleId;
  String? selectedRoleName;

  bool isSaving = false;
  bool isInitialized = false;

  // Effective edit mode.
  // This is useful when edit data comes through route arguments.
  bool _isEditMode = false;

  ManageUserModel? _currentUser;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initData();
    });
  }

  void _initData() {
    if (isInitialized) return;

    final userViewModel = context.read<UserViewModel>();

    // Fetch roles if not already loaded.
    if (userViewModel.roleList.isEmpty) {
      userViewModel.fetchRoles();
    }

    // ------------------------------------------------------------
    // Get user/edit data from constructor or route arguments
    // ------------------------------------------------------------

    ManageUserModel? currentUser = widget.user;
    bool isEditMode = widget.isEdit;

    final routeArgs = ModalRoute.of(context)?.settings.arguments;

    if (routeArgs is Map<String, dynamic>) {
      if (routeArgs['user'] is ManageUserModel) {
        currentUser = routeArgs['user'] as ManageUserModel;
      }

      if (routeArgs['isEdit'] is bool) {
        isEditMode = routeArgs['isEdit'] as bool;
      }
    }

    _currentUser = currentUser;
    _isEditMode = isEditMode;

    // ------------------------------------------------------------
    // Populate edit data
    // ------------------------------------------------------------

    if (_isEditMode && currentUser != null) {
      firstNameController.text = currentUser.firstName ?? '';
      lastNameController.text = currentUser.lastName ?? '';
      usernameController.text = currentUser.username ?? '';
      emailController.text = currentUser.email ?? '';
      phoneController.text = currentUser.phoneNumber ?? '';
      addressController.text = currentUser.address ?? '';

      selectedStatus =
      (currentUser.isActive ?? true) ? "Active" : "Inactive";

      selectedRoleId = currentUser.role?.id;
      selectedRoleName = currentUser.role?.name;
    }

    setState(() {
      isInitialized = true;
    });
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  // ============================================================
  // SAVE USER
  // ADD + EDIT
  // ============================================================

  Future<void> _handleSaveUser() async {
    final userViewModel = context.read<UserViewModel>();

    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();

    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // ============================================================
    // VALIDATION
    // ============================================================

    if (username.isEmpty) {
      SnackBarMessage.showSnackBar(
        context,
        "Please enter username",
      );
      return;
    }

    if (email.isEmpty) {
      SnackBarMessage.showSnackBar(
        context,
        "Please enter email address",
      );
      return;
    }

    if (phone.isEmpty) {
      SnackBarMessage.showSnackBar(
        context,
        "Please enter phone number",
      );
      return;
    }

    // Password is required only while creating user.
    if (!_isEditMode) {
      if (password.isEmpty) {
        SnackBarMessage.showSnackBar(
          context,
          "Please enter password",
        );
        return;
      }

      if (password.length < 8) {
        SnackBarMessage.showSnackBar(
          context,
          "Password must be at least 8 characters",
        );
        return;
      }

      if (password != confirmPassword) {
        SnackBarMessage.showSnackBar(
          context,
          "Passwords do not match",
        );
        return;
      }
    }

    // Role is optional according to API documentation.
    // So we don't force the user to select a role.

    setState(() {
      isSaving = true;
    });

    bool success = false;

    try {
      // ==========================================================
      // CREATE USER
      // ==========================================================

      if (!_isEditMode) {
        success = await userViewModel.createUser(
          username: username,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          phoneNumber: phone,
          firstName: firstName.isEmpty ? null : firstName,
          lastName: lastName.isEmpty ? null : lastName,
          address: address.isEmpty ? null : address,
          roleId: selectedRoleId,
        );
      }

      // ==========================================================
      // UPDATE USER
      // ==========================================================

      else {
        if (_currentUser?.id == null) {
          SnackBarMessage.showSnackBar(
            context,
            "User ID not found",
          );
          return;
        }

        final int userId = _currentUser!.id!;

        // --------------------------------------------------------
        // User information update
        // --------------------------------------------------------

        final Map<String, dynamic> updateData = {
          "first_name": firstName,
          "last_name": lastName,
          "username": username,
          "email": email,
          "phone_number": phone,
          "address": address,
          "is_active": selectedStatus == "Active",
        };

        success = await userViewModel.updateUser(
          userId,
          updateData,
        );

        // --------------------------------------------------------
        // Update role separately
        // --------------------------------------------------------

        if (success && selectedRoleId != _currentUser!.role?.id) {
          final roleSuccess = await userViewModel.assignRole(
            userId,
            selectedRoleId,
          );

          if (!roleSuccess) {
            success = false;
          }
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }

    // ============================================================
    // RESULT
    // ============================================================

    if (!mounted) return;

    if (success) {
      SnackBarMessage.showSnackBar(
        context,
        _isEditMode
            ? "User updated successfully!"
            : "User created successfully!",
      );

      Navigator.pop(context, true);
    } else {
      SnackBarMessage.showSnackBar(
        context,
        userViewModel.errorMessage ??
            (_isEditMode
                ? "Failed to update user"
                : "Failed to create user"),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ======================================================
          // APP BAR
          // ======================================================

          CustomSliverAppBar(
            title: _isEditMode
                ? "Edit User Details"
                : "Add New User",
            showBackButton: true,
          ),

          SliverPadding(
            padding: EdgeInsets.all(
              AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Consumer<UserViewModel>(
                    builder: (context, userVM, child) {
                      final rolesList = userVM.roleList;

                      final roleNames = rolesList
                          .map((role) => role.name ?? '')
                          .where((name) => name.isNotEmpty)
                          .toList();

                      // =================================================
                      // DEFAULT ROLE FOR ADD MODE
                      // =================================================

                      if (!_isEditMode &&
                          selectedRoleId == null &&
                          rolesList.isNotEmpty &&
                          isInitialized) {
                        selectedRoleId = rolesList.first.id;
                        selectedRoleName = rolesList.first.name;
                      }

                      return Column(
                        children: [
                          // =================================================
                          // USER INFORMATION CARD
                          // =================================================

                          CustomCard(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                // =================================================
                                // FIRST NAME
                                // =================================================

                                TextBodyStyleWidget(
                                  title: "First Name",
                                  color: color.primary,
                                  size: AppSizes.sectionTitle,
                                ),

                                SizedBox(
                                  height: AppSizes.appbarGap,
                                ),

                                CustomTextFieldWidget(
                                  hintText: "John",
                                  controller:
                                  firstNameController,

                                ),

                                SizedBox(
                                  height: AppSizes.itemGap,
                                ),

                                // =================================================
                                // LAST NAME
                                // =================================================

                                TextBodyStyleWidget(
                                  title: "Last Name",
                                  color: color.primary,
                                  size: AppSizes.sectionTitle,
                                ),

                                SizedBox(
                                  height: AppSizes.appbarGap,
                                ),

                                CustomTextFieldWidget(
                                  hintText: "Doe",
                                  controller:
                                  lastNameController,

                                ),

                                SizedBox(
                                  height: AppSizes.itemGap,
                                ),

                                // =================================================
                                // USERNAME
                                // =================================================

                                TextBodyStyleWidget(
                                  title: "Username *",
                                  color: color.primary,
                                  size: AppSizes.sectionTitle,
                                ),

                                SizedBox(
                                  height: AppSizes.appbarGap,
                                ),

                                CustomTextFieldWidget(
                                  hintText: "johndoe",
                                  controller:
                                  usernameController,

                                ),

                                SizedBox(
                                  height: AppSizes.itemGap,
                                ),

                                // =================================================
                                // EMAIL
                                // =================================================

                                TextBodyStyleWidget(
                                  title: "Email *",
                                  color: color.primary,
                                  size: AppSizes.sectionTitle,
                                ),

                                SizedBox(
                                  height: AppSizes.appbarGap,
                                ),

                                CustomTextFieldWidget(
                                  hintText:
                                  "user@gmail.com",
                                  controller:
                                  emailController,

                                ),

                                SizedBox(
                                  height: AppSizes.itemGap,
                                ),

                                // =================================================
                                // PHONE
                                // =================================================

                                TextBodyStyleWidget(
                                  title: "Phone Number *",
                                  color: color.primary,
                                  size: AppSizes.sectionTitle,
                                ),

                                SizedBox(
                                  height: AppSizes.appbarGap,
                                ),

                                CustomTextFieldWidget(
                                  hintText:
                                  "01XXXXXXXXX",
                                  controller:
                                  phoneController,

                                ),

                                SizedBox(
                                  height: AppSizes.itemGap,
                                ),

                                // =================================================
                                // ADDRESS
                                // =================================================

                                TextBodyStyleWidget(
                                  title: "Address",
                                  color: color.primary,
                                  size: AppSizes.sectionTitle,
                                ),

                                SizedBox(
                                  height: AppSizes.appbarGap,
                                ),

                                CustomTextFieldWidget(
                                  hintText:
                                  "Dhanmondi, Dhaka",
                                  controller:
                                  addressController,

                                ),

                                SizedBox(
                                  height: AppSizes.itemGap,
                                ),

                                // =================================================
                                // PASSWORD
                                // =================================================

                                // Password creation is only required
                                // while creating a user.
                                if (!_isEditMode) ...[
                                  TextBodyStyleWidget(
                                    title: "Password *",
                                    color: color.primary,
                                    size:
                                    AppSizes.sectionTitle,
                                  ),

                                  SizedBox(
                                    height:
                                    AppSizes.appbarGap,
                                  ),

                                  CustomTextFieldWidget(
                                    hintText:
                                    "Secure password",
                                    controller:
                                    passwordController,

                                  ),

                                  SizedBox(
                                    height: AppSizes.itemGap,
                                  ),

                                  TextBodyStyleWidget(
                                    title:
                                    "Confirm Password *",
                                    color: color.primary,
                                    size:
                                    AppSizes.sectionTitle,
                                  ),

                                  SizedBox(
                                    height:
                                    AppSizes.appbarGap,
                                  ),

                                  CustomTextFieldWidget(
                                    hintText:
                                    "Confirm secure password",
                                    controller:
                                    confirmPasswordController,
                                    obscureText: true,
                                  ),

                                  SizedBox(
                                    height:
                                    AppSizes.itemGap,
                                  ),
                                ],

                                // =================================================
                                // ROLE
                                // =================================================

                                TextBodyStyleWidget(
                                  title: "Role",
                                  color: color.primary,
                                  size: AppSizes.sectionTitle,
                                ),

                                SizedBox(
                                  height: AppSizes.appbarGap,
                                ),

                                userVM.loading &&
                                    rolesList.isEmpty
                                    ? const Center(
                                  child:
                                  CircularProgressIndicator(),
                                )
                                    : CustomDropdown(
                                  items: roleNames.isEmpty
                                      ? [
                                    "No Roles Available"
                                  ]
                                      : roleNames,
                                  initialValue:
                                  selectedRoleName ??
                                      (roleNames
                                          .isNotEmpty
                                          ? roleNames
                                          .first
                                          : ""),
                                  width: 100.w,
                                  onChanged: (value) {
                                    final selectedName =
                                    value.toString();

                                    final matchedRole =
                                    rolesList
                                        .cast<
                                        UserRoleModel?>()
                                        .firstWhere(
                                          (role) =>
                                      role?.name ==
                                          selectedName,
                                      orElse: () =>
                                      null,
                                    );

                                    setState(() {
                                      selectedRoleName =
                                          matchedRole?.name;

                                      selectedRoleId =
                                          matchedRole?.id;
                                    });
                                  },
                                ),

                                SizedBox(
                                  height: AppSizes.itemGap,
                                ),

                                // =================================================
                                // STATUS
                                // =================================================

                                // Status is mainly relevant for edit,
                                // but keeping it visible for both modes
                                // is okay.
                                TextBodyStyleWidget(
                                  title: "Status",
                                  color: color.primary,
                                  size: AppSizes.sectionTitle,
                                ),

                                SizedBox(
                                  height: AppSizes.appbarGap,
                                ),

                                CustomDropdown(
                                  items: statusList,
                                  initialValue:
                                  selectedStatus,
                                  width: 100.w,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedStatus =
                                          value.toString();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: AppSizes.sectionGap,
                          ),

                          // =================================================
                          // BUTTONS
                          // =================================================

                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                text: "Cancel",
                                onTap: () =>
                                    Navigator.pop(context),
                                width: 30.w,
                                backgroundColor:
                                color.cardBackground,
                                foregroundColor:
                                color.primary,
                              ),

                              SizedBox(
                                width: AppSizes.appbarGap,
                              ),

                              Flexible(
                                child: CustomButton(
                                  text: isSaving
                                      ? (_isEditMode
                                      ? "Updating..."
                                      : "Creating...")
                                      : (_isEditMode
                                      ? "Update User"
                                      : "Create User"),
                                  onTap: isSaving
                                      ? null
                                      : _handleSaveUser,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: AppSizes.sectionGap,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}