import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../data/model/organization/team/team_member_model.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/snackbar_message.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../viewModel/organization/team_member_view_model.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card2.dart';
import '../../../widget/universal/custom_status_badge.dart';
import '../../../widget/universal/image_card.dart';
import '../../../widget/universal/info_row_widget.dart';

class ViewTeamScreen extends StatefulWidget {
  const ViewTeamScreen({super.key, required this.member});

  final TeamMemberModel member;

  @override
  State<ViewTeamScreen> createState() => _ViewTeamScreenState();
}

class _ViewTeamScreenState extends State<ViewTeamScreen> {
  bool isDeleting = false;

  // Confirmation dialog for delete action
  Future<void> _showDeleteDialog(BuildContext context) async {
    final color = context.Appcolor;

    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: TextBodyStyleWidget(
          title: "Delete Member",
          size: AppSizes.sectionTitle,
          color: color.primary,
        ),
        content: TextBodyStyleWidget(
          title: "Are you sure you want to delete this team member?",
          fontbold: false,
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: TextBodyStyleWidget(
              title: "Cancel",
              fontbold: false,
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _handleDeleteMember();
            },
            child: const TextBodyStyleWidget(
              title: "Delete",
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  // Delete API action
  Future<void> _handleDeleteMember() async {
    if (widget.member.id == null) {
      SnackBarMessage.showSnackBar(context, "Member ID not found");
      return;
    }

    setState(() {
      isDeleting = true;
    });

    final viewModel = context.read<TeamViewModel>();
    final success = await viewModel.deleteTeamMember(widget.member.id!);

    if (!mounted) return;

    setState(() {
      isDeleting = false;
    });

    if (success) {
      SnackBarMessage.showSnackBar(context, "Member deleted successfully");
      Navigator.pop(context, true); // Pop back to list with success signal
    } else {
      SnackBarMessage.showSnackBar(
        context,
        viewModel.errorMessage ?? "Failed to delete member",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    final imageUrl = widget.member.imageData?.fileUrl;
    final isVisible = widget.member.isVisible ?? true;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: widget.member.fullname ?? "Team Member Details",
            subtitle: widget.member.designation ?? "",
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
                    ImageCard(
                      image: _buildMemberImage(imageUrl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomStatusBadge(
                                title: isVisible ? "VISIBLE" : "HIDDEN",
                                size: AppSizes.cardTitle,
                              ),
                              Row(
                                children: [
                                  // Edit Button
                                  GestureDetector(
                                    onTap: () async {
                                      final updated = await Navigator.pushNamed(
                                        context,
                                        RoutesName.edit_team_member,
                                        arguments: {
                                          'member' :widget.member
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
                                      color: Colors.redAccent,
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
                                  // Designation
                                  InfoRowWidget(
                                    icon: Icons.badge_outlined,
                                    title: "Designation",
                                    value: widget.member.designation ?? "N/A",
                                  ),
                                  SizedBox(height: AppSizes.smallGap),

                                  // Description / Role
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.file_copy_outlined,
                                        color: color.primary,
                                        size: AppSizes.icon,
                                      ),
                                      SizedBox(width: AppSizes.appbarGap),
                                      Flexible(
                                        child: TextBodyStyleWidget(
                                          title:
                                          "Detailed Description: ${widget.member.role ?? 'N/A'}",
                                          color: color.primary,
                                          fontbold: false,
                                          maxLines: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: AppSizes.appbarGap),

                                  // Experience
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.workspace_premium,
                                        color: color.primary,
                                        size: AppSizes.icon,
                                      ),
                                      SizedBox(width: AppSizes.appbarGap),
                                      Flexible(
                                        child: TextBodyStyleWidget(
                                          title:
                                          "Experience / Background: ${widget.member.experience ?? 'N/A'}",
                                          color: color.primary,
                                          fontbold: false,
                                          maxLines: 25,
                                        ),
                                      ),
                                    ],
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

  Widget _buildMemberImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: 16.h,
        fit: BoxFit.fitHeight,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/images/person.png",
            width: double.infinity,
            height: 16.h,
            fit: BoxFit.cover,
          );
        },
      );
    }

    return Image.asset(
      "assets/images/person.png",
      width: double.infinity,
      height: 16.h,
      fit: BoxFit.cover,
    );
  }
}