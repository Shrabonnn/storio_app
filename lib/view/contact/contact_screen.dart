import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/utils/app_sizes.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_app_bar.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/universal/custom_card2.dart';
import 'package:storio_app/widget/universal/custom_status_badge.dart';
import 'package:storio_app/widget/universal/search_text_field.dart';

import '../../data/model/Content/contact/contact_model.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/contact_view_model.dart';
import '../../widget/skeleton/contact_message_skeleton.dart';
import '../../widget/skeleton/custom_skeleton_card.dart';
import '../../widget/universal/custom_drop_down.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, String>> statusOptions = const [
    {"label": "All Status", "value": ""},
    {"label": "New", "value": "new"},
    {"label": "Read", "value": "read"},
    {"label": "Replied", "value": "replied"},
    {"label": "Archived", "value": "archived"},
  ];

  String selectedStatus = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadMessages();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _loadMessages({bool isFilterOrSearch = false}) {
    context.read<ContactViewModel>().getContactMessageApi(
      status: selectedStatus.isEmpty ? null : selectedStatus,
      search: searchController.text.trim().isEmpty
          ? null
          : searchController.text.trim(),
      isFilterOrSearch: isFilterOrSearch,
    );
  }

  String _formatTimeOrDate(DateTime? date) {
    if (date == null) return "-";

    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;

    if (isToday) {
      return DateFormat('h:mm a').format(date);
    }
    return DateFormat('MMM d').format(date);
  }

  Future<void> _openMessage(ContactMessageModel message) async {
    if (message.status == "new" && message.id != null) {
      context.read<ContactViewModel>().markAsRead(message.id!);
    }

    final result = await Navigator.pushNamed(
      context,
      RoutesName.contact_message_details,
      arguments: {"message": message},
    );

    // ডিটেইলস পেজ থেকে ফিরে আসলে UI আপডেট নিশ্চিত করতে
    if (result == true && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _loadMessages();
        },
        child: CustomScrollView(
          slivers: [
            const CustomSliverAppBar(
              title: "Contact Management",
              showBackButton: true,
            ),
            SliverPadding(
              padding: EdgeInsets.all(AppSizes.screenPadding),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Column(
                    children: [
                      // Search and Filter Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SearchTextField(
                              hinText: "Search Conversation",
                              controller: searchController,
                              onChanged: (value) {
                                _loadMessages(isFilterOrSearch: true);
                              },
                            ),
                          ),
                          SizedBox(width: AppSizes.smallGap),
                          CustomDropdown(
                            items: statusOptions
                                .map((e) => e['label']!)
                                .toList(),
                            initialValue: statusOptions.firstWhere(
                                  (e) => e['value'] == selectedStatus,
                            )['label']!,
                            width: 32.w,
                            height: 4.3.h,
                            onChanged: (value) {
                              final matched = statusOptions
                                  .firstWhere((e) => e['label'] == value);

                              setState(() {
                                selectedStatus = matched['value']!;
                              });

                              _loadMessages(isFilterOrSearch: true);
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: AppSizes.sectionGap),

                      Consumer<ContactViewModel>(
                        builder: (context, provider, child) {
                          return CustomCard(
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextTitleWidget(
                                      title: "Inbox",
                                      color: color.primary,
                                    ),
                                    CustomButton(
                                      text:
                                      "${provider.messageList.length} messages",
                                      onTap: () {},
                                      height: 4.h,
                                      width: 30.w,
                                    ),
                                  ],
                                ),
                                SizedBox(height: AppSizes.itemGap),

                                if (provider.loading)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: 4,
                                    itemBuilder: (context, index) =>
                                    const ContactMessageSkeleton(),
                                  )
                                else if (provider.errorMessage != null &&
                                    provider.messageList.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24,
                                    ),
                                    child: Center(
                                      child: TextBodyStyleWidget(
                                        title: provider.errorMessage!,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                else if (provider.messageList.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 24,
                                      ),
                                      child: Center(
                                        child: TextBodyStyleWidget(
                                          title: "No messages found",
                                          color: color.primary,
                                        ),
                                      ),
                                    )
                                  else
                                    ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics:
                                      const NeverScrollableScrollPhysics(),
                                      itemCount: provider.messageList.length,
                                      itemBuilder: (context, index) {
                                        final message =
                                        provider.messageList[index];

                                        final name = message.name ?? "-";
                                        final subject = message.subject ?? "-";
                                        final body = message.message ?? "-";
                                        final status = message.status ?? "new";
                                        final isNew = status == "new";

                                        return Container(
                                          margin: EdgeInsets.only(
                                            bottom: AppSizes.itemGap,
                                          ),
                                          // 🎯 ২. পুরো কার্ডেই ক্লিক করার ব্যবস্থা করা হয়েছে
                                          child: InkWell(
                                            onTap: () => _openMessage(message),
                                            borderRadius: BorderRadius.circular(8),
                                            child: CustomCard2(
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                  AppSizes.smallPadding,
                                                ),
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 22,
                                                      backgroundColor: isNew
                                                          ? color.primary
                                                          : Colors.grey.shade400,
                                                      child: TextTitleWidget(
                                                        title: name.isNotEmpty
                                                            ? name[0]
                                                            .toUpperCase()
                                                            : "?",
                                                        color:
                                                        color.cardBackground,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: AppSizes.smallGap,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          TextTitleWidget(
                                                            title: name,
                                                          ),
                                                          SizedBox(
                                                            height: AppSizes
                                                                .appbarGap,
                                                          ),
                                                          TextBodyStyleWidget(
                                                            title: subject,
                                                            maxLines: 2,
                                                          ),
                                                          SizedBox(
                                                            height: AppSizes
                                                                .appbarGap,
                                                          ),
                                                          TextBodyStyleWidget(
                                                            title: body,
                                                            maxLines: 2,
                                                            fontbold: false,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: AppSizes.smallGap,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                      children: [
                                                        TextBodyStyleWidget(
                                                          title:
                                                          _formatTimeOrDate(
                                                            message.submittedAt,
                                                          ),
                                                          color:
                                                          color.textPrimary,
                                                        ),
                                                        SizedBox(
                                                          height:
                                                          AppSizes.smallGap,
                                                        ),
                                                        CustomStatusBadge(
                                                          title: status
                                                              .toUpperCase(),
                                                          foregroundColor: color
                                                              .cardBackground,
                                                          backgroundColor: isNew
                                                              ? color
                                                              .cardBackground
                                                              : color.primary,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: AppSizes.smallGap,
                                                    ),
                                                    Icon(
                                                      Icons.chevron_right,
                                                      size: AppSizes.iconLarge,
                                                      color: color.primary,
                                                    ),
                                                  ],
                                                ),
                                              ),
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
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}