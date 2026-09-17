import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_status_badge.dart';
import 'package:storio_app/widget/universal/more_menu.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/model/Content/contact/contact_model.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../utils/snackbar_message.dart';
import '../../viewModel/Content/contact_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/universal/confirm_action.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_card2.dart';

class ContactMessageDetails extends StatefulWidget {
  const ContactMessageDetails({super.key, required this.message});

  final ContactMessageModel message;

  @override
  State<ContactMessageDetails> createState() => _ContactMessageDetailsState();
}

class _ContactMessageDetailsState extends State<ContactMessageDetails> {
  late ContactMessageModel message;
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    message = widget.message;

    // ডিটেইলস খুললেই "new" থাকলে ব্যাকএন্ডে "read" মার্ক হয়ে যাবে
    if (message.status == "new" && message.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _markAsRead(silently: true);
      });
    }
  }

  void _showMessage(String text) {
    SnackBarMessage.showSnackBar(context, text);
  }

  String _formatDateTime(DateTime? date) {
    if (date == null) return "-";
    return DateFormat('d MMM yyyy, h:mm a').format(date);
  }

  Future<void> _markAsRead({bool silently = false}) async {
    if (message.id == null || isBusy) return;

    if (!silently) setState(() => isBusy = true);

    final viewModel = context.read<ContactViewModel>();
    final success = await viewModel.markAsRead(message.id!);

    if (!mounted) return;

    if (!silently) setState(() => isBusy = false);

    if (success) {
      setState(() {
        message.status = "read";
      });
      if (!silently) _showMessage("Marked as Read");
    } else if (!silently) {
      _showMessage(viewModel.errorMessage ?? "Failed to mark as read");
    }
  }

  Future<void> _handleReply() async {
    final email = message.email;
    if (email == null || email.isEmpty) {
      _showMessage("No email address available");
      return;
    }

    final subject = Uri.encodeComponent("Re: ${message.subject ?? ''}");
    final mailUri = Uri.parse("mailto:$email?subject=$subject");

    final launched = await launchUrl(mailUri);

    if (!mounted) return;

    if (!launched) {
      _showMessage("Could not open an email app");
      return;
    }

    if (message.status != "replied" && message.id != null) {
      setState(() => isBusy = true);
      final viewModel = context.read<ContactViewModel>();
      final success = await viewModel.markAsReplied(message.id!);

      if (!mounted) return;
      setState(() => isBusy = false);

      if (success) {
        setState(() {
          message.status = "replied";
        });
      }
    }
  }

  Future<void> _handleArchive() async {
    if (message.id == null || isBusy) return;

    setState(() => isBusy = true);

    final viewModel = context.read<ContactViewModel>();
    final success = await viewModel.markAsArchived(message.id!);

    if (!mounted) return;

    setState(() => isBusy = false);

    if (success) {
      setState(() {
        message.status = "archived";
      });
      _showMessage("Message archived");
      Navigator.pop(context, true);
    } else {
      _showMessage(viewModel.errorMessage ?? "Failed to archive message");
    }
  }

  Future<void> _handleDelete() async {
    if (message.id == null) return;

    final confirmed = await confirmAction(
      context,
      title: "Delete Message",
      message: "Are you sure you want to permanently delete this message?",
    );

    if (!confirmed) return;
    if (!mounted) return;

    setState(() => isBusy = true);

    final viewModel = context.read<ContactViewModel>();
    final success = await viewModel.deleteContactMessage(message.id!);

    if (!mounted) return;

    setState(() => isBusy = false);

    if (success) {
      _showMessage("Message deleted successfully");
      Navigator.pop(context, true);
    } else {
      _showMessage(viewModel.errorMessage ?? "Failed to delete message");
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    final status = (message.status ?? "new").toLowerCase();
    final name = message.name ?? "-";
    final formattedDate = _formatDateTime(message.submittedAt);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBar(title: "Message Details", showBackButton: true),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status + More Menu
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomStatusBadge(
                            title: status.toUpperCase(),
                            size: AppSizes.cardTitle,
                          ),
                          MoreMenu(
                            items: const [
                              MoreMenuAction.delete,
                            ],
                            onSelected: (action) async {
                              if (action == MoreMenuAction.delete) {
                                await _handleDelete();
                              }
                            },
                          ),
                        ],
                      ),

                      // User Info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: color.primary,
                            child: TextTitleWidget(
                              title: name.isNotEmpty ? name[0].toUpperCase() : "?",
                              color: color.cardBackground,
                            ),
                          ),
                          SizedBox(width: AppSizes.smallGap),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextTitleWidget(
                                  title: name,
                                  color: color.primary,
                                ),
                                SizedBox(height: AppSizes.appbarGap),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.email_outlined,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: TextBodyStyleWidget(
                                        title: message.email ?? "-",
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSizes.appbarGap),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone_outlined,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    TextBodyStyleWidget(
                                      title: message.mobile != null && message.mobile!.isNotEmpty
                                          ? message.mobile!
                                          : "-",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSizes.smallGap),

                      // Date
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 15,
                            color: color.primary,
                          ),
                          const SizedBox(width: 4),
                          TextBodyStyleWidget(title: formattedDate),
                        ],
                      ),

                      SizedBox(height: AppSizes.itemGap),

                      // Message Body
                      CustomCard2(
                        child: Padding(
                          padding: EdgeInsets.all(AppSizes.smallPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextTitleWidget(
                                title: message.subject ?? "-",
                                color: color.primary,
                              ),
                              SizedBox(height: AppSizes.itemGap),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 4,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: color.secondary,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  SizedBox(width: AppSizes.smallGap),
                                  Expanded(
                                    child: TextBodyStyleWidget(
                                      title: message.message ?? "-",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: AppSizes.itemGap),

                      // Submitted Date Box
                      CustomCard2(
                        child: Padding(
                          padding: EdgeInsets.all(AppSizes.smallPadding),
                          child: Row(
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                color: color.primary,
                                size: 22,
                              ),
                              SizedBox(width: AppSizes.smallGap),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextBodyStyleWidget(
                                    title: "Submitted On",
                                    color: color.primary,
                                  ),
                                  TextBodyStyleWidget(
                                    title: formattedDate,
                                    color: color.primary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: AppSizes.itemGap),

                      // 🎯 ৩টি কার্যকরী অ্যাকশন বাটন
                      Row(
                        children: [
                          _buildStatusButton(
                            title: "Read",
                            targetStatus: "read",
                            currentStatus: status,
                            color: color,
                            onTap: () => _markAsRead(),
                          ),
                          SizedBox(width: AppSizes.smallGap),
                          _buildStatusButton(
                            title: "Replied",
                            targetStatus: "replied",
                            currentStatus: status,
                            color: color,
                            onTap: _handleReply,
                          ),
                          SizedBox(width: AppSizes.smallGap),
                          _buildStatusButton(
                            title: "Archived",
                            targetStatus: "archived",
                            currentStatus: status,
                            color: color,
                            onTap: _handleArchive,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton({
    required String title,
    required String targetStatus,
    required String currentStatus,
    required dynamic color,
    required VoidCallback onTap,
  }) {
    final bool isSelected = currentStatus == targetStatus;

    return Expanded(
      child: CustomButton(
        text: title,
        onTap: isBusy ? () {} : onTap,
        height: 4.5.h,
        backgroundColor: isSelected ? color.primary : color.cardBackground,
        foregroundColor: isSelected ? color.cardBackground : color.primary,
        borderSide: BorderSide(
          color: color.primary,
        ),
      ),
    );
  }
}