import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/snackbar_message.dart';
import 'package:storio_app/widget/skeleton/user_skeleton.dart';

import '../../../data/model/user_manage/user/user_model.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../viewModel/user_manage/user_view_model.dart';
import '../../../widget/custom_button/view_button.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/textStyle/text_title_style.dart';
import '../../../widget/universal/confirm_action.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_status_badge.dart';
import '../../../widget/universal/custom_text_field.dart';
import '../../../widget/universal/date_time_formate.dart';
import '../../../widget/universal/info_row_widget.dart';
import '../../../widget/universal/more_menu.dart';
import '../../../widget/universal/search_text_field.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserViewModel>().fetchUsers(
        isFilterOrSearch: false
      );
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: Consumer<UserViewModel>(
        builder: (context, userVM, child) {
          final filteredUsers = userVM.userList.where((user) {
            final fullName = "${user.firstName ?? ''} ${user.lastName ?? ''}".toLowerCase();
            final username = (user.username ?? '').toLowerCase();
            final email = (user.email ?? '').toLowerCase();
            final query = searchQuery.toLowerCase();

            return fullName.contains(query) ||
                username.contains(query) ||
                email.contains(query);
          }).toList();

          return CustomScrollView(
            slivers: [
              const CustomSliverAppBar(
                title: "User Management",
                showBackButton: true,
              ),

              // Search Bar Section
              SliverPadding(
                padding: EdgeInsets.only(
                  top: AppSizes.screenPadding,
                  left: AppSizes.screenPadding,
                  right: AppSizes.screenPadding,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      children: [
                        Expanded(
                          child: SearchTextField(
                            controller: searchController,
                            hinText: "Search users...",
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.sectionGap),
                  ]),
                ),
              ),

              // Users List / Loading / Empty States
              if (userVM.loading)
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
                  sliver: SliverList.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) => const UserSkeleton(),
                  ),
                )
              else if (filteredUsers.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: Text("No users found")),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding,
                  ),
                  sliver: SliverList.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];

                      final fullName = "${user.firstName ?? ''} ${user.lastName ?? ''}".trim();
                      final displayName =
                      fullName.isNotEmpty ? fullName : (user.username ?? "Unknown");
                      final avatarChar =
                      displayName.isNotEmpty ? displayName[0].toUpperCase() : "?";
                      final isActive = user.isActive ?? false;

                      return Container(
                        margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                        child: CustomCard(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // User Initial Avatar
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: color.primary,
                                      border: Border.all(
                                        color: color.lightVersionOfPrimaryLightVersion,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: TextTitleWidget(
                                        title: avatarChar,
                                        color: color.cardBackground,
                                        size: 19.sp,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: AppSizes.smallGap),

                                  // User Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextTitleWidget(
                                          title: displayName,
                                          size: AppSizes.sectionTitle,
                                          color: color.primary,
                                        ),
                                        SizedBox(height: AppSizes.appbarGap),
                                        TextBodyStyleWidget(
                                          title: "@${user.username ?? ''}",
                                          size: AppSizes.cardTitle,
                                          color: color.primary,
                                        ),
                                        SizedBox(height: AppSizes.appbarGap),
                                        TextBodyStyleWidget(
                                          title: (user.role?.name ?? "No Role").toUpperCase(),
                                          size: AppSizes.cardTitle,
                                          color: color.primary,
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(width: AppSizes.sectionGap),

                                  // Actions & Status
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          ViewButton(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                RoutesName.view_user_details,
                                                arguments: {
                                                  'user':user
                                                }, // সরাসরি user অবজেক্ট পাস
                                              );
                                            },
                                          ),
                                          MoreMenu(
                                            items: const [
                                              MoreMenuAction.edit,
                                              MoreMenuAction.view,
                                              MoreMenuAction.changePassword,
                                              MoreMenuAction.suspend,
                                              MoreMenuAction.delete,
                                            ],
                                            onSelected: (action) {
                                              _handleMenuAction(
                                                context,
                                                action,
                                                user,
                                                userVM,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: AppSizes.smallGap),
                                      CustomStatusBadge(
                                        title: isActive ? "ACTIVE" : "INACTIVE",
                                        size: AppSizes.cardTitle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: AppSizes.itemGap),

                              InfoRowWidget(
                                icon: Icons.email_outlined,
                                title: "Email",
                                value: user.email ?? "N/A",
                              ),
                              SizedBox(height: AppSizes.appbarGap),
                              InfoRowWidget(
                                icon: Icons.calendar_month_outlined,
                                title: "Joined",
                                value: formatDate(user.dateJoined),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "add",
        backgroundColor: color.primary,
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            RoutesName.add_new_user,
          );
          if (result == true && mounted) {
            context.read<UserViewModel>().fetchUsers();
          }
        },
        child: Icon(
          Icons.add,
          color: color.cardBackground,
        ),
      ),
    );
  }

  void _handleMenuAction(
      BuildContext context,
      MoreMenuAction action,
      ManageUserModel user,
      UserViewModel userVM,
      ) {
    switch (action) {
      case MoreMenuAction.edit:
        Navigator.pushNamed(
          context,
          RoutesName.add_new_user,
          arguments: {
            'isEdit': true,
            'user': user,
          },
        );
        break;

      case MoreMenuAction.view:
        Navigator.pushNamed(
          context,
          RoutesName.view_user_details,
          arguments: user,
        );
        break;

      case MoreMenuAction.suspend:
        if (user.id != null) {
          final newStatus = !(user.isActive ?? true);
          userVM.updateUser(user.id!, {'is_active': newStatus});
        }
        break;

      case MoreMenuAction.delete:
        if (user.id != null) {
          _showDeleteDialog(context, user.id!, userVM);
        }
        break;

      case MoreMenuAction.changePassword:

        if (user.id != null) {
          _showChangePasswordDialog(
            context,
            user.id!,
            userVM,
          );
        }
        break ;

      default:
        break;
    }
  }





  void _showDeleteDialog(
      BuildContext context,
      int userId,
      UserViewModel userVM,
      ) async {
    final isConfirmed = await confirmAction(
      context,
      title: "Delete User",
      message: "Are you sure you want to delete this user?",
    );

    if (isConfirmed) {
      await userVM.deleteUser(userId);
    }
  }

  void _showChangePasswordDialog(
      BuildContext context,
      int userId,
      UserViewModel userVM,
      ) {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        final color = context.Appcolor;
        return Padding(
          padding:  EdgeInsets.all(AppSizes.cardPadding),
          child: AlertDialog(

            backgroundColor:color.cardBackground,
            title: const Text("Change Password"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextFieldWidget(
                  controller: newPasswordController,
                  hintText: "New Password",
                  obscureText: true,
                ),

                SizedBox(height: AppSizes.sectionGap),

                CustomTextFieldWidget(
                  controller: confirmPasswordController,
                  hintText: "Confirm New Password",
                  obscureText: true,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child:  TextTitleWidget(title: "Cancel"),
              ),

              TextButton(
                onPressed: () async {
                  final newPassword =
                  newPasswordController.text.trim();

                  final confirmPassword =
                  confirmPasswordController.text.trim();

                  if (newPassword.isEmpty ||
                      confirmPassword.isEmpty) {
                    SnackBarMessage.showSnackBar(context,
                          "Please enter both passwords",
                    );
                    return;
                  }

                  if (newPassword != confirmPassword) {
                    SnackBarMessage.showSnackBar(context,
                          "Passwords do not match",
                    );
                    return;
                  }

                  if (newPassword.length < 8) {
                    SnackBarMessage.showSnackBar(context, "Password must be at least 8 characters");
                    return;
                  }

                  Navigator.pop(dialogContext);

                  final success = await userVM.resetUserPassword(
                    userId,
                    newPassword,
                    confirmPassword,
                  );

                  if (!context.mounted) return;

                  SnackBarMessage.showSnackBar(context,  success ? "Password changed successfully"
                      : userVM.errorMessage ??
                      "Failed to change password",);
                },
                child:  TextTitleWidget(title: "Change"),
              ),
            ],
          ),
        );
      },
    );
  }

}

