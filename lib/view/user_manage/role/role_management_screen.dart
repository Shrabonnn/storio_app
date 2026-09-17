import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storio_app/widget/skeleton/contact_message_skeleton.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/snackbar_message.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../viewModel/user_manage/role_view_model.dart';
import '../../../widget/textStyle/text_title_style.dart';
import '../../../widget/universal/confirm_action.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_card2.dart';

class RoleManagementScreen extends StatefulWidget {
  const RoleManagementScreen({super.key});

  @override
  State<RoleManagementScreen> createState() => _RoleManagementScreenState();
}

class _RoleManagementScreenState extends State<RoleManagementScreen> {
  @override
  void initState() {
    super.initState();

    // ============================================================
    // FETCH INITIAL ROLES & PERMISSIONS
    // ============================================================
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<RoleViewModel>();
      viewModel.fetchRolesApi();
      viewModel.fetchPermissionsApi();
    });
  }

  // Refresh role list
  void _refreshRoleList() {
    final viewModel = context.read<RoleViewModel>();
    viewModel.fetchRolesApi();
    viewModel.fetchPermissionsApi();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Role & Permission Management",
            showBackButton: true,
          ),

          // ============================================================
          // ROLE LIST SECTION
          // ============================================================
          Consumer<RoleViewModel>(
            builder: (context, provider, child) {
              // Loading State
              if (provider.isLoading && provider.rolesList.isEmpty) {
                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.screenPadding),
                  sliver: SliverList.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) => const ContactMessageSkeleton(),
                  ),
                );
              }

              // Error State
              if (provider.errorMessage != null && provider.rolesList.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(provider.errorMessage!),
                    ),
                  ),
                );
              }

              // Empty List State
              if (provider.rolesList.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text("No roles found"),
                    ),
                  ),
                );
              }

              final rolesList = provider.rolesList;
              final totalPermissionsCount = provider.permissionsList.length;

              return SliverPadding(
                padding: EdgeInsets.only(
                  top: AppSizes.screenPadding,
                  left: AppSizes.screenPadding,
                  right: AppSizes.screenPadding,
                ),
                sliver: SliverList.builder(
                  itemCount: rolesList.length,
                  itemBuilder: (context, index) {
                    final role = rolesList[index];
                    final assignedPermissions = role.permissions?.length ?? 0;

                    return Container(
                      margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                      child: CustomCard(
                        child: Padding(
                          padding: EdgeInsets.all(AppSizes.cardPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ==========================================
                              // HEADER ROW (NAME & ACTIONS)
                              // ==========================================
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.security_outlined,
                                          size: AppSizes.icon,
                                          color: color.primary,
                                        ),
                                        SizedBox(width: AppSizes.smallGap),
                                        Expanded(
                                          child: TextTitleWidget(
                                            title: role.name ?? "N/A",
                                            size: AppSizes.sectionTitle,
                                            color: color.primary,
                                          ),
                                        ),

                                        // Edit & Delete Action Buttons
                                        Row(
                                          children: [
                                            // EDIT ROLE
                                            GestureDetector(
                                              onTap: () async {
                                                final result = await Navigator.pushNamed(
                                                  context,
                                                  RoutesName.add_new_role,
                                                  arguments: {
                                                    'isEdit': true,
                                                    'role': role,
                                                  },
                                                );

                                                if (result == true) {
                                                  _refreshRoleList();
                                                }
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                size: AppSizes.icon,
                                                color: color.primary,
                                              ),
                                            ),
                                            SizedBox(width: AppSizes.itemGap),

                                            // DELETE ROLE
                                            GestureDetector(
                                              onTap: () async {
                                                final confirmed = await confirmAction(
                                                  context,
                                                  title: "Delete Role",
                                                  message: "Are you sure you want to delete '${role.name}'?",
                                                );

                                                if (!mounted || !confirmed) return;

                                                if (role.id == null) return;

                                                final success = await context
                                                    .read<RoleViewModel>()
                                                    .deleteRoleApi(role.id!);

                                                if (!mounted) return;

                                                if (success) {
                                                  SnackBarMessage.showSnackBar(
                                                    context,
                                                    "Role deleted successfully!",
                                                  );
                                                } else {
                                                  SnackBarMessage.showSnackBar(
                                                    context,
                                                    provider.errorMessage ?? "Failed to delete role",
                                                  );
                                                }
                                              },
                                              child:  Icon(
                                                Icons.delete_outline_outlined,
                                                size: AppSizes.icon,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: AppSizes.itemGap),

                              // ==========================================
                              // PERMISSION STATS
                              // ==========================================
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: TextTitleWidget(
                                      title: "Permissions: ",
                                      color: color.primary,
                                      maxLines: 2,
                                    ),
                                  ),
                                  TextTitleWidget(
                                    title: totalPermissionsCount > 0
                                        ? "$assignedPermissions / $totalPermissionsCount"
                                        : "$assignedPermissions",
                                    color: color.primary,
                                  ),
                                ],
                              ),

                              SizedBox(height: AppSizes.smallGap),

                              // ==========================================
                              // USER ASSIGNED STATS
                              // ==========================================
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: TextTitleWidget(
                                      title: "Users assigned: ",
                                      color: color.primary,
                                      maxLines: 2,
                                    ),
                                  ),
                                  TextTitleWidget(
                                    title: "${role.userCount ?? 0}",
                                    color: color.primary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // ============================================================
          // BOTTOM SPACING
          // ============================================================
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),

      // ================================================================
      // ADD ROLE BUTTON
      // ================================================================
      floatingActionButton: FloatingActionButton(
        heroTag: "add",
        backgroundColor: color.primary,
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            RoutesName.add_new_role,
          );

          if (result == true) {
            _refreshRoleList();
          }
        },
        child: Icon(
          Icons.add,
          color: color.cardBackground,
        ),
      ),
    );
  }
}