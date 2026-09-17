import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../data/model/user_manage/user/user_model.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/snackbar_message.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../viewModel/user_manage/user_view_model.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_card2.dart';
import '../../../widget/universal/custom_status_badge.dart';
import '../../../widget/universal/date_time_formate.dart';
import '../../../widget/universal/info_row_widget.dart';

class ViewUserDetails extends StatefulWidget {
  const ViewUserDetails({super.key, this.user});

  final ManageUserModel? user;

  @override
  State<ViewUserDetails> createState() => _ViewUserDetailsState();
}

class _ViewUserDetailsState extends State<ViewUserDetails> {
  ManageUserModel? user;
  bool isDeleting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (user == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is ManageUserModel) {
        user = args;
      } else if (widget.user != null) {
        user = widget.user;
      }
    }
  }



  // Confirmation dialog for delete action
  Future<void> _showDeleteDialog(BuildContext context) async {
    final color = context.Appcolor;

    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: TextBodyStyleWidget(
          title: "Delete User",
          size: AppSizes.sectionTitle,
          color: color.primary,
        ),
        content: const TextBodyStyleWidget(
          title: "Are you sure you want to delete this user?",
          fontbold: false,
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const TextBodyStyleWidget(
              title: "Cancel",
              fontbold: false,
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _handleDeleteUser();
            },
            child: const TextBodyStyleWidget(
              title: "Delete",
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  // Delete API action
  Future<void> _handleDeleteUser() async {
    if (user?.id == null) {
      SnackBarMessage.showSnackBar(context, "User ID not found");
      return;
    }

    setState(() {
      isDeleting = true;
    });

    final viewModel = context.read<UserViewModel>();
    final success = await viewModel.deleteUser(user!.id!);

    if (!mounted) return;

    setState(() {
      isDeleting = false;
    });

    if (success) {
      SnackBarMessage.showSnackBar(context, "User deleted successfully");
      Navigator.pop(context, true); // Pop back to list with success signal
    } else {
      SnackBarMessage.showSnackBar(
        context,
        viewModel.errorMessage ?? "Failed to delete user",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("User Details")),
        body: const Center(child: Text("User details not found.")),
      );
    }

    final fullName =
    "${user!.firstName ?? ''} ${user!.lastName ?? ''}".trim();
    final displayName =
    fullName.isNotEmpty ? fullName : (user!.username ?? "User Details");
    final roleName = (user!.role?.name ?? "NO ROLE").toUpperCase();
    final isActive = user!.isActive ?? false;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: displayName,
            subtitle: user!.email ?? "@${user!.username ?? ''}",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              top: AppSizes.screenPadding,
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CustomStatusBadge(
                                    title: roleName,
                                    size: AppSizes.cardTitle,
                                    backgroundColor: Colors.green.shade100,
                                  ),
                                  SizedBox(width: AppSizes.itemGap),
                                  CustomStatusBadge(
                                    title: isActive ? "ACTIVE" : "INACTIVE",
                                    size: AppSizes.cardTitle,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  // Edit Button
                                  GestureDetector(
                                    onTap: () async {
                                      final updated = await Navigator.pushNamed(
                                        context,
                                        RoutesName.add_new_user,
                                        arguments: {
                                          'isEdit': true,
                                          'user': user,
                                        },
                                      );

                                      if (updated == true && mounted) {
                                        Navigator.pop(context, true);
                                      }
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: AppSizes.iconLarge,
                                      color: color.primary,
                                    ),
                                  ),
                                  SizedBox(width: AppSizes.itemGap),

                                  // Delete Button
                                  isDeleting
                                      ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                      : GestureDetector(
                                    onTap: () => _showDeleteDialog(context),
                                    child: Icon(
                                      Icons.delete_outline_outlined,
                                      size: AppSizes.iconLarge,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.smallGap),
                          CustomCard2(
                            child: Padding(
                              padding: EdgeInsets.all(AppSizes.contentPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InfoRowWidget(
                                    icon: Icons.person_outline,
                                    title: "Username",
                                    value: "@${user!.username ?? 'N/A'}",
                                  ),
                                  SizedBox(height: AppSizes.smallGap),
                                  InfoRowWidget(
                                    icon: Icons.email_outlined,
                                    title: "Email",
                                    value: user!.email ?? "N/A",
                                  ),
                                  SizedBox(height: AppSizes.smallGap),
                                  InfoRowWidget(
                                    icon: Icons.badge_outlined,
                                    title: "Role",
                                    value: user!.role?.name ?? "N/A",
                                  ),
                                  SizedBox(height: AppSizes.smallGap),
                                  InfoRowWidget(
                                    icon: Icons.phone,
                                    title: "Phone Number",
                                    value: user!.phoneNumber ?? "N/A",
                                  ),
                                  SizedBox(height: AppSizes.smallGap),
                                  InfoRowWidget(
                                    icon: Icons.location_on_outlined,
                                    title: "Address",
                                    value: user!.address ?? "N/A",
                                  ),
                                  SizedBox(height: AppSizes.smallGap),
                                  InfoRowWidget(
                                    icon: Icons.calendar_month_outlined,
                                    title: "Joined",
                                    value: formatDate(user!.dateJoined),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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