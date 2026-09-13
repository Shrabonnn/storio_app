import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/data/model/Content/promotion/promotion_model.dart';
import 'package:storio_app/utils/snackbar_message.dart';
import 'package:storio_app/viewModel/Content/promotion_view_model.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';

import 'package:storio_app/widget/custom_button/view_button.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/image_card.dart';
import 'package:storio_app/widget/universal/custom_drop_down.dart';
import 'package:storio_app/widget/universal/custom_status_badge.dart';
import 'package:storio_app/widget/universal/more_menu.dart';
import 'package:storio_app/widget/universal/search_text_field.dart';

import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../widget/dashboard/stat_card.dart';
import '../../widget/universal/confirm_action.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/date_time_formate.dart';

class PromotionManagementScreen extends StatefulWidget {
  const PromotionManagementScreen({super.key});

  @override
  State<PromotionManagementScreen> createState() =>
      _PromotionManagementScreenState();
}

class _PromotionManagementScreenState extends State<PromotionManagementScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<String> statusItem = ["All", "Published", "Draft", "Archived"];

  String selectedStatus = "All";
  String selectedType = "All";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPromotions();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // Load Promotions
  // ============================================================

  void _loadPromotions() {
    final provider = context.read<PromotionViewModel>();

    provider.getManagementPromotion(
      search: searchController.text.trim().isEmpty
          ? null
          : searchController.text.trim(),
      status: selectedStatus == "All" ? null : selectedStatus.toLowerCase(),
      type: selectedType == "All" ? null : selectedType.toLowerCase(),
    );
  }


  // Publish Promotion


  Future<void> _publishPromotion(PromotionModel promotion) async {
    if (promotion.id == null) return;

    final confirmed = await confirmAction(
      context,
      title: "Publish Promotion",
      message: "Are you sure you want to publish this promotion?",
    );

    if (!mounted || !confirmed) return;

    final viewModel = context.read<PromotionViewModel>();

    final result = await viewModel.publishPromotionApi(promotion.id!);

    if (!mounted) return;

    SnackBarMessage.showSnackBar(
      context,
      result != null
          ? "Promotion published successfully"
          : (viewModel.errorMessage ?? "Failed to publish promotion"),
    );
  }


  // Archive Promotion


  Future<void> _archivePromotion(PromotionModel promotion) async {
    if (promotion.id == null) return;

    final confirmed = await confirmAction(
      context,
      title: "Archive Promotion",
      message: "Are you sure you want to archive this promotion?",
    );

    if (!mounted || !confirmed) return;

    final viewModel = context.read<PromotionViewModel>();

    final result = await viewModel.archivePromotionApi(promotion.id!);

    if (!mounted) return;

    SnackBarMessage.showSnackBar(
      context,
      result != null
          ? "Promotion archived successfully"
          : (viewModel.errorMessage ?? "Failed to archive promotion"),
    );
  }


  // Permanently Delete Promotion


  Future<void> _confirmDelete(PromotionModel promotion) async {
    if (promotion.id == null) return;

    final confirmed = await confirmAction(
      context,
      title: "Delete Promotion",
      message: "Are you sure you want to permanently delete this promotion?",
    );

    if (!mounted || !confirmed) return;

    final viewModel = context.read<PromotionViewModel>();

    final success = await viewModel.permanentlyDeletePromotionApi(
      promotion.id!,
    );

    if (!mounted) return;

    SnackBarMessage.showSnackBar(
      context,
      success
          ? "Promotion deleted permanently"
          : (viewModel.errorMessage ?? "Failed to delete promotion"),
    );

    if (success) {
      _loadPromotions();
    }
  }


  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: Consumer<PromotionViewModel>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [

              // App Bar

              CustomSliverAppBar(
                title: "Promotion Management",
                showBackButton: true,
              ),

              SliverPadding(
                padding: EdgeInsets.all(AppSizes.screenPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([

                    // Search & Filters

                    Row(
                      children: [
                        Expanded(
                          child: SearchTextField(
                            controller: searchController,
                            hinText: "Search promotions...",
                            onChanged: (value) {
                              _loadPromotions();
                            },
                          ),
                        ),

                        SizedBox(width: AppSizes.smallGap),

                        Row(
                          children: [
                            CustomButton(height: 4.5.h,width:12.w,text: "Bin", onTap: (){}),
                            SizedBox(width: AppSizes.smallGap,),
                            CustomDropdown(
                              items: statusItem,
                              initialValue: selectedStatus,
                              width: 27.w,
                              height: 4.5.h,
                              onChanged: (value) {
                                if (value == null) return;

                                setState(() {
                                  selectedStatus = value;
                                });

                                _loadPromotions();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: AppSizes.sectionGap),


                    // Stats

                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            label: "Live Now",
                            value: provider.promotionList
                                .where((e) => e.isLive == true)
                                .length
                                .toString(),
                          ),
                        ),

                        SizedBox(width: AppSizes.smallGap),

                        Expanded(
                          child: StatCard(
                            label: "Draft",
                            value: provider.promotionList
                                .where((e) => e.status == "draft")
                                .length
                                .toString(),
                          ),
                        ),

                        SizedBox(width: AppSizes.smallGap),

                        Expanded(
                          child: StatCard(
                            label: "Total Views",
                            value: provider.promotionList
                                .fold<int>(
                                  0,
                                  (sum, item) => sum + (item.viewCount ?? 0),
                                )
                                .toString(),
                          ),
                        ),

                        SizedBox(width: AppSizes.smallGap),

                        Expanded(
                          child: StatCard(
                            label: "Total Clicks",
                            value: provider.promotionList
                                .fold<int>(
                                  0,
                                  (sum, item) => sum + (item.clickCount ?? 0),
                                )
                                .toString(),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSizes.sectionGap),


                    // Loading

                    if (provider.loading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: CircularProgressIndicator(),
                        ),
                      ),

                    // ==================================================
                    // Error
                    // ==================================================
                    if (!provider.loading && provider.errorMessage != null)
                      Center(
                        child: TextBodyStyleWidget(
                          title: provider.errorMessage!,
                        ),
                      ),

                    // ==================================================
                    // Empty
                    // ==================================================
                    if (!provider.loading &&
                        provider.errorMessage == null &&
                        provider.promotionList.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: TextBodyStyleWidget(
                            title: "No promotions found",
                          ),
                        ),
                      ),
                  ]),
                ),
              ),

              // ==========================================================
              // Promotion List
              // ==========================================================
              if (!provider.loading && provider.promotionList.isNotEmpty)
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding,
                  ),
                  sliver: SliverList.builder(
                    itemCount: provider.promotionList.length,
                    itemBuilder: (context, index) {
                      final PromotionModel promotion =
                          provider.promotionList[index];

                      return ImageCard(
                        image: _buildPromotionImage(promotion),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ============================================
                            // Status + Menu
                            // ============================================
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomStatusBadge(
                                  title: promotion.status ?? "",
                                  size: AppSizes.cardTitle,
                                ),

                                Row(
                                  children: [
                                    MoreMenu(
                                      items: [
                                        MoreMenuAction.edit,
                                        MoreMenuAction.publish,
                                        MoreMenuAction.archive,
                                        MoreMenuAction.delete,
                                      ],

                                      onSelected: (action) async {
                                        switch (action) {
                                          // =================================
                                          // Edit
                                          // =================================

                                          case MoreMenuAction.edit:
                                            final result =
                                                await Navigator.pushNamed(
                                                  context,
                                                  RoutesName.edit_promotion,
                                                  arguments: {
                                                    'promotion' :promotion
                                                  },
                                                );

                                            if (!mounted) return;

                                            if (result == true) {
                                              _loadPromotions();
                                            }
                                            break;

                                          // =================================
                                          // Publish
                                          // =================================

                                          case MoreMenuAction.publish:
                                            await _publishPromotion(promotion);
                                            break;

                                          // =================================
                                          // Archive
                                          // =================================

                                          case MoreMenuAction.archive:
                                            await _archivePromotion(promotion);
                                            break;

                                          // =================================
                                          // Delete
                                          // =================================

                                          case MoreMenuAction.delete:
                                            await _confirmDelete(promotion);
                                            break;

                                          // =================================
                                          // Unused Actions
                                          // =================================

                                          case MoreMenuAction.view:
                                          case MoreMenuAction.changePassword:
                                          case MoreMenuAction.suspend:
                                            break;
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: AppSizes.smallGap),

                            // ============================================
                            // Title
                            // ============================================
                            TextTitleWidget(
                              title: promotion.title ?? "-",
                              color: color.primary,
                              maxLines: 1,
                            ),

                            SizedBox(height: AppSizes.smallGap),

                            // ============================================
                            // Subtitle
                            // ============================================
                            if (promotion.subtitle != null &&
                                promotion.subtitle!.isNotEmpty)
                              TextBodyStyleWidget(
                                title: promotion.subtitle!,
                                maxLines: 2,
                              ),

                            SizedBox(height: AppSizes.smallGap),

                            // ============================================
                            // Date
                            // ============================================
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: AppSizes.iconSmall,
                                  color: Colors.grey.shade600,
                                ),

                                SizedBox(width: AppSizes.appbarGap),

                                Flexible(
                                  child: TextBodyStyleWidget(
                                    title:
                                        "${formatDate(promotion.startDate)} → "
                                        "${formatDate(promotion.endDate)}",
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: AppSizes.smallGap),

                            // ============================================
                            // Views + Clicks
                            // ============================================
                            Row(
                              children: [
                                Icon(
                                  Icons.visibility_outlined,
                                  size: AppSizes.iconSmall,
                                  color: Colors.grey.shade600,
                                ),

                                SizedBox(width: AppSizes.appbarGap),

                                TextBodyStyleWidget(
                                  title: "${promotion.viewCount ?? 0}",
                                ),

                                SizedBox(width: AppSizes.smallGap),

                                Icon(
                                  Icons.touch_app_outlined,
                                  size: AppSizes.iconSmall,
                                  color: Colors.grey.shade600,
                                ),

                                SizedBox(width: AppSizes.appbarGap),

                                TextBodyStyleWidget(
                                  title: "${promotion.clickCount ?? 0}",
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              SliverPadding(
                padding: EdgeInsets.only(bottom: AppSizes.sectionGap),
              ),
            ],
          );
        },
      ),

      // ================================================================
      // Add Promotion
      // ================================================================
      floatingActionButton: FloatingActionButton(
        heroTag: "add",
        backgroundColor: color.primary,
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            RoutesName.add_promotion,
          );

          if (!mounted) return;

          if (result == true) {
            _loadPromotions();
          }
        },
        child: Icon(Icons.add, color: color.cardBackground),
      ),
    );
  }

  // ============================================================
  // Promotion Image
  // ============================================================

  Widget _buildPromotionImage(PromotionModel promotion) {
    final imageUrl = promotion.imageDetail?.file;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: double.infinity,
        height: 18.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/images/institute.png",
            width: double.infinity,
            height: 18.h,
            fit: BoxFit.cover,
          );
        },
      );
    }

    return Image.asset(
      "assets/images/institute.png",
      width: double.infinity,
      height: 18.h,
      fit: BoxFit.cover,
    );
  }
}
