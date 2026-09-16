import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';
import 'package:storio_app/widget/custom_button/view_button.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/universal/custom_card2.dart';
import 'package:storio_app/widget/universal/custom_status_badge.dart';
import 'package:storio_app/widget/universal/confirm_action.dart';

import '../../../utils/app_sizes.dart';
import '../../../utils/snackbar_message.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../viewModel/organization/important_view_model.dart';
import '../../../widget/universal/custom_app_bar.dart';

class EducationBoardNotices extends StatefulWidget {
  const EducationBoardNotices({super.key});

  @override
  State<EducationBoardNotices> createState() => _EducationBoardNoticesState();
}

class _EducationBoardNoticesState extends State<EducationBoardNotices> {
  final List<Map<String, String>> educationBoards = [
    {"name": "Dhaka", "value": "dhaka"},
    {"name": "Rajshahi", "value": "rajshahi"},
    {"name": "Comilla", "value": "comilla"},
    {"name": "Jessore", "value": "jessore"},
    {"name": "Chittagong", "value": "chittagong"},
    {"name": "Barisal", "value": "barisal"},
    {"name": "Sylhet", "value": "sylhet"},
    {"name": "Dinajpur", "value": "dinajpur"},
    {"name": "Mymensingh", "value": "mymensingh"},
    {"name": "Madrasah", "value": "madrasah"},
    {"name": "Technical", "value": "technical"},
  ];

  // Default Dhaka
  String selectedBoard = "dhaka";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<ImportantLinkViewModel>();

      // Important links load
      viewModel.getImportantLinkApi();

      // Default Dhaka notices load
      viewModel.fetchBoardNoticesApi(selectedBoard);
    });
  }

  Future<void> _openUrl(String? url) async {
    if (url == null || url.trim().isEmpty) {
      if (!mounted) return;

      SnackBarMessage.showSnackBar(context, "URL is not available");
      return;
    }

    final uri = Uri.tryParse(url);

    if (uri == null) {
      if (!mounted) return;

      SnackBarMessage.showSnackBar(context, "Invalid URL");
      return;
    }

    try {
      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success && mounted) {
        SnackBarMessage.showSnackBar(context, "Could not open the link");
      }
    } catch (e) {
      if (!mounted) return;

      SnackBarMessage.showSnackBar(context, "Could not open the link");
    }
  }

  Future<void> _fetchLatestNotices() async {
    final viewModel = context.read<ImportantLinkViewModel>();

    await viewModel.fetchBoardNoticesApi(selectedBoard);

    if (!mounted) return;

    if (viewModel.errorMessage != null) {
      SnackBarMessage.showSnackBar(context, viewModel.errorMessage!);
    }
  }

  Future<void> _deleteImportantLink(int id, String title) async {
    final confirmed = await confirmAction(
      context,
      title: "Delete Important Link",
      message: "Are you sure you want to permanently delete \"$title\"?",
    );

    if (!mounted || !confirmed) {
      return;
    }

    final viewModel = context.read<ImportantLinkViewModel>();

    final success = await viewModel.deleteImportantLink(id);

    if (!mounted) return;

    if (success) {
      SnackBarMessage.showSnackBar(
        context,
        "Important link deleted successfully",
      );
    } else {
      SnackBarMessage.showSnackBar(
        context,
        viewModel.errorMessage ?? "Failed to delete important link",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Consumer<ImportantLinkViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              const CustomSliverAppBar(
                title: "Education Board Notices",
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

                    // EDUCATION BOARD SELECTION

                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextTitleWidget(
                            title: "Select Education Board (Single)",
                            color: color.primary,
                          ),

                          SizedBox(height: AppSizes.smallGap),

                          GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: educationBoards.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 6,
                                  childAspectRatio: 4.5,
                                ),
                            itemBuilder: (context, index) {
                              final board = educationBoards[index];

                              return CustomCard2(
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: board["value"]!,
                                      groupValue: selectedBoard,
                                      onChanged: (value) {
                                        if (value == null) return;

                                        setState(() {
                                          selectedBoard = value;
                                        });
                                      },
                                    ),

                                    Flexible(
                                      child: TextBodyStyleWidget(
                                        title: board["name"]!,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          SizedBox(height: AppSizes.itemGap),

                          CustomButton(
                            text: viewModel.boardNoticesLoading
                                ? "Fetching..."
                                : "Fetch Latest Notices",
                            onTap: viewModel.boardNoticesLoading
                                ? null
                                : _fetchLatestNotices,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),


                    // LATEST 5 EDUCATION BOARD NOTICES

                    TextTitleWidget(
                      title: "Latest 5 Notices",
                      color: color.primary,
                    ),

                    SizedBox(height: AppSizes.smallGap),

                    if (viewModel.boardNoticesLoading)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: const Center(child: CircularProgressIndicator()),
                      )
                    else if (viewModel.boardNotices.isEmpty)
                      CustomCard2(
                        child: Padding(
                          padding: EdgeInsets.all(AppSizes.itemGap),
                          child: Center(
                            child: TextBodyStyleWidget(
                              title: "No notices found for the selected board.",
                              color: color.secondary,
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(

                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),

                        // শুধু latest 5
                        itemCount: viewModel.boardNotices.length > 5
                            ? 5
                            : viewModel.boardNotices.length,

                        itemBuilder: (context, index) {
                          final notice = viewModel.boardNotices[index];

                          final itemCount= viewModel.boardNotices.length > 5
                              ? 5
                              : viewModel.boardNotices.length;


                          return Container(
                            margin: EdgeInsets.only(
                              bottom: index < itemCount-1 ?AppSizes.smallGap : 0,
                            ),
                            child: CustomCard2(
                              child: Padding(
                                padding: EdgeInsets.all(AppSizes.smallPadding),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextBodyStyleWidget(
                                            title: notice.title ?? "",
                                            maxLines: 2,
                                            color: color.primary,
                                          ),

                                          SizedBox(height: AppSizes.smallGap),

                                          TextBodyStyleWidget(
                                            title: notice.publishDate ?? "",
                                            maxLines: 1,
                                            color: color.secondary,
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(width: AppSizes.itemGap),

                                    ViewButton(
                                      onTap: () {
                                        _openUrl(notice.url);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                    SizedBox(height: AppSizes.sectionGap),


                    // IMPORTANT LINKS HEADER

                    CustomCard(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      color.lightVersionOfPrimaryLightVersion,
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.buttonRadius,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    AppSizes.buttonRadius,
                                  ),
                                  child: Icon(
                                    Icons.link,
                                    size: AppSizes.appBarIcon,
                                    color: color.primary,
                                  ),
                                ),
                              ),

                              SizedBox(width: AppSizes.itemGap),

                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextTitleWidget(
                                      title: "Important Links",
                                      color: color.primary,
                                    ),

                                    SizedBox(height: AppSizes.appbarGap),

                                    TextBodyStyleWidget(
                                      title:
                                          "Manage quick access links for your institution",
                                      fontbold: false,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: AppSizes.itemGap),

                          CustomButton(
                            text: "Add New Link",
                            onTap: () async {
                              final result = await Navigator.pushNamed(
                                context,
                                RoutesName.add_new_links,
                              );

                              if (!mounted) return;

                              if (result == true) {
                                viewModel.getImportantLinkApi();
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),


                    // IMPORTANT LINKS LIST

                    if (viewModel.loading)
                      const Center(child: CircularProgressIndicator())
                    else if (viewModel.linkList.isEmpty)
                      CustomCard2(
                        child: Padding(
                          padding: EdgeInsets.all(AppSizes.itemGap),
                          child: Center(
                            child: TextBodyStyleWidget(
                              title: "No Important Links Found",
                              color: color.secondary,
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.linkList.length,
                        itemBuilder: (context, index) {
                          final link = viewModel.linkList[index];

                          return Container(
                            margin: EdgeInsets.only(
                                bottom: AppSizes.smallGap,
                            ),
                            child: CustomCard2(
                              child: Padding(
                                padding: EdgeInsets.all(AppSizes.smallPadding),
                                child: Row(
                                  children: [
                                    // Link icon
                                    Container(
                                      decoration: BoxDecoration(
                                        color: color.cardBackground.withValues(
                                          alpha: 0.7,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppSizes.buttonRadius,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                          AppSizes.buttonRadius,
                                        ),
                                        child: Icon(
                                          Icons.language_outlined,
                                          size: AppSizes.appBarIcon,
                                          color: color.secondary,
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: AppSizes.smallGap),

                                    // Title + URL
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextBodyStyleWidget(
                                            title: link.title ?? "",
                                            maxLines: 1,
                                            color: color.primary,
                                          ),

                                          SizedBox(height: AppSizes.smallGap),

                                          TextBodyStyleWidget(
                                            title: link.url ?? "",
                                            maxLines: 2,
                                            color: color.secondary,
                                            fontbold: false,
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(width: AppSizes.itemGap),

                                    // EDIT
                                    GestureDetector(
                                      onTap: link.id == null
                                          ? null
                                          : () async {
                                              final result =
                                                  await Navigator.pushNamed(
                                                    context,
                                                    RoutesName.add_new_links,
                                                    arguments: {
                                                      'isEdit': true,
                                                      'link': link,
                                                    },
                                                  );

                                              if (!mounted) {
                                                return;
                                              }

                                              if (result == true) {
                                                viewModel.getImportantLinkApi();
                                              }
                                            },
                                      child: Icon(
                                        Icons.edit,
                                        size: AppSizes.iconLarge,
                                        color: color.primary,
                                      ),
                                    ),

                                    SizedBox(width: AppSizes.itemGap),

                                    // DELETE
                                    GestureDetector(
                                      onTap: link.id == null
                                          ? null
                                          : () {
                                              _deleteImportantLink(
                                                link.id!,
                                                link.title ?? "",
                                              );
                                            },
                                      child: Icon(
                                        Icons.delete_outline_outlined,
                                        size: AppSizes.iconLarge,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                    SizedBox(height: 15.h),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
