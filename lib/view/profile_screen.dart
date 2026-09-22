import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_sizes.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_text_field.dart';
import '../viewModel/Authenticaion/auth_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool isEditing = false;
  bool isSaving = false;

  int? selectedMediaId;
  String? selectedMediaUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _loadProfileData() {
    final authViewModel = context.read<AuthViewModel>();
    final currentUser = authViewModel.currentUser;

    if (currentUser != null) {
      _populateControllers();
      final slug = currentUser.slug ?? currentUser.username;
      if (slug.isNotEmpty) {
        authViewModel.fetchUserProfileApi(slug).then((_) {
          if (mounted) {
            _populateControllers();
          }
        });
      }
    }
  }

  void _populateControllers() {
    final user = context.read<AuthViewModel>().currentUser;
    if (user != null) {
      _firstNameController.text = user.firstName ?? '';
      _lastNameController.text = user.lastName ?? '';
      _phoneController.text = user.phoneNumber ?? '';
      _addressController.text = user.address ?? '';
    }
  }

  Future<void> _pickProfileImage() async {
    final currentUser = context.read<AuthViewModel>().currentUser;
    if (currentUser == null) return;

    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
      arguments: {
        'currentId': selectedMediaId,
        'currentFileUrl': selectedMediaUrl ?? currentUser.profilePicture,
      },
    );

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        selectedMediaId = result['id'] as int?;
        selectedMediaUrl = result['file'] as String?;
      });
    }
  }

  Future<void> _handleProfileUpdate() async {
    final authViewModel = context.read<AuthViewModel>();
    final currentUser = authViewModel.currentUser;

    if (currentUser == null) return;

    final slug = currentUser.slug ?? currentUser.username;

    setState(() => isSaving = true);

    final fields = <String, String>{
      "first_name": _firstNameController.text.trim(),
      "last_name": _lastNameController.text.trim(),
      "phone_number": _phoneController.text.trim(),
      "address": _addressController.text.trim(),
    };

    if (selectedMediaId != null) {
      fields["profile_picture"] = selectedMediaId.toString();
    }

    final error = await authViewModel.updateUserProfileApi(slug, fields);

    if (!mounted) return;

    setState(() => isSaving = false);

    if (error == null) {
      setState(() {
        isEditing = false;
        selectedMediaId = null;
      });
      SnackBarMessage.showSnackBar(context, "Profile updated successfully!");
    } else {
      SnackBarMessage.showSnackBar(context, error);
    }
  }

  void _toggleEditMode() {
    if (isEditing) {
      // Cancel edit mode and reset values
      _populateControllers();
      setState(() {
        isEditing = false;
        selectedMediaId = null;
        selectedMediaUrl = null;
      });
    } else {
      setState(() {
        isEditing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: Consumer<AuthViewModel>(
        builder: (context, authViewModel, child) {
          final user = authViewModel.currentUser;
          final avatarUrl = selectedMediaUrl ?? user?.profilePicture;

          final firstName = user?.firstName?.isNotEmpty == true
              ? user!.firstName!
              : (user?.username ?? "N/A");
          final lastName = user?.lastName ?? "";
          final fullName = "$firstName $lastName".trim();

          return CustomScrollView(
            slivers: [
              CustomSliverAppBar(
                title: "User Profile",
                showBackButton: true,
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (authViewModel.loading && user == null)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else
                      Column(
                        children: [
                          // Profile Image Header
                          Column(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    width: 26.w,
                                    height: 26.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: color.primary,
                                        width: 2,
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: (avatarUrl != null && avatarUrl.isNotEmpty)
                                        ? Image.network(
                                      avatarUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Image.asset(
                                            'assets/images/person.png',
                                            fit: BoxFit.cover,
                                          ),
                                    )
                                        : Image.asset(
                                      'assets/images/person.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  if (isEditing)
                                    GestureDetector(
                                      onTap: _pickProfileImage,
                                      child: CircleAvatar(
                                        radius: 4.w,
                                        backgroundColor: color.primary,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 4.w,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 1.5.h),
                              TextTitleWidget(
                                title: fullName.isNotEmpty ? fullName : "User",
                                color: color.primary,
                                size: 18.sp,
                              ),
                              SizedBox(height: .5.h),
                              TextBodyStyleWidget(
                                title: user?.email ?? "no-email@domain.com",
                                color: Colors.grey.shade600,
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),

                          // Header Row & Edit Action Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: color.primary,
                                    size: 7.w,
                                  ),
                                  SizedBox(width: 2.w),
                                  TextTitleWidget(
                                    title: "Personal Information",
                                    color: color.primary,
                                    size: 15.sp,
                                  ),
                                ],
                              ),
                              CustomButton(
                                height: 4.h,
                                width: 28.w,
                                text: isEditing ? (isSaving ? "Saving..." : "Update") : "Edit Profile",
                                backgroundColor: isEditing ? color.active : color.primary,
                                onTap: isSaving
                                    ? null
                                    : (isEditing ? _handleProfileUpdate : _toggleEditMode),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),

                          // Form Cards or Dynamic View
                          CustomCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFieldRow(
                                  label: "First Name",
                                  value: user?.firstName ?? "N/A",
                                  controller: _firstNameController,
                                ),
                                const Divider(thickness: 0.7),
                                _buildFieldRow(
                                  label: "Last Name",
                                  value: user?.lastName ?? "N/A",
                                  controller: _lastNameController,
                                ),
                                const Divider(thickness: 0.7),
                                // Email non-editable
                                _buildStaticRow("Email Address", user?.email ?? "N/A"),
                                const Divider(thickness: 0.7),
                                _buildFieldRow(
                                  label: "Phone Number",
                                  value: user?.phoneNumber ?? "N/A",
                                  controller: _phoneController,
                                ),
                                const Divider(thickness: 0.7),
                                _buildFieldRow(
                                  label: "Address",
                                  value: user?.address ?? "N/A",
                                  controller: _addressController,
                                ),
                                if (user?.role != null) ...[
                                  const Divider(thickness: 0.7),
                                  _buildStaticRow("Role", user!.role!.name),
                                ],
                              ],
                            ),
                          ),

                          if (isEditing) ...[
                            SizedBox(height: 2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomButton(
                                  height: 4.h,
                                  width: 28.w,
                                  text: "Cancel",
                                  backgroundColor: Colors.grey.shade400,
                                  foregroundColor: Colors.black,
                                  onTap: isSaving ? null : _toggleEditMode,
                                ),
                              ],
                            ),
                          ],
                          SizedBox(height: 2.h),
                        ],
                      ),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Dynamic Helper Widgets
  Widget _buildFieldRow({
    required String label,
    required String value,
    required TextEditingController controller,
  }) {
    final color = context.Appcolor;

    if (!isEditing) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 0.8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextBodyStyleWidget(
              title: label,
              color: Colors.grey.shade700,
              fontbold: true,
            ),
            Flexible(
              child: TextBodyStyleWidget(
                title: value.isNotEmpty ? value : "N/A",
                color: color.primary,
                fontbold: false,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextBodyStyleWidget(
            title: label,
            color: color.primary,
            fontbold: true,
          ),
          SizedBox(height: 0.5.h),
          CustomTextFieldWidget(
            controller: controller,
            hintText: "Enter $label",
          ),
        ],
      ),
    );
  }

  Widget _buildStaticRow(String label, String value) {
    final color = context.Appcolor;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextBodyStyleWidget(
            title: label,
            color: Colors.grey.shade700,
            fontbold: true,
          ),
          Flexible(
            child: TextBodyStyleWidget(
              title: value,
              color: color.primary,
              fontbold: false,
            ),
          ),
        ],
      ),
    );
  }
}