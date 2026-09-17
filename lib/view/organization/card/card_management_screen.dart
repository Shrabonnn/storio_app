import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/model/organization/card/card_model.dart';
import '../../../routes/routes_name.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/icon_list.dart';
import '../../../utils/snackbar_message.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../viewModel/organization/card_view_model.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/textStyle/text_title_style.dart';
import '../../../widget/universal/confirm_action.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_status_badge.dart';
import '../../../widget/universal/image_rectangle_widget.dart';
import '../../../widget/universal/more_menu.dart';
import '../../../widget/universal/search_text_field.dart';

class CardManagementScreen extends StatefulWidget {
  const CardManagementScreen({super.key});

  @override
  State<CardManagementScreen> createState() => _CardManagementScreenState();
}

class _CardManagementScreenState extends State<CardManagementScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Init data fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CardViewModel>().getCardsApi();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Refresh card list
  void _refreshCardList() {
    context.read<CardViewModel>().getCardsApi();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: "Card Management", showBackButton: true),

          // ============================================================
          // SEARCH SECTION
          // ============================================================
          SliverPadding(
            padding: EdgeInsets.only(
              top: AppSizes.screenPadding,
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SearchTextField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  hinText: "Search cards...",
                  controller: searchController,
                ),
                SizedBox(height: AppSizes.sectionGap),
              ]),
            ),
          ),

          // ============================================================
          // CARD LIST SECTION
          // ============================================================
          Consumer<CardViewModel>(
            builder: (context, provider, child) {
              // Loading state
              if (provider.isLoading) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }

              // Error state
              if (provider.errorMessage != null) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(provider.errorMessage!),
                    ),
                  ),
                );
              }

              // Filter display list by search text
              final searchText = searchController.text.trim().toLowerCase();
              final List<CardModel> displayList = searchText.isEmpty
                  ? provider.cards
                  : provider.cards.where((card) {
                final title = card.title?.toLowerCase() ?? "";
                final description = card.description?.toLowerCase() ?? "";
                final icon = card.icon?.toLowerCase() ?? "";

                return title.contains(searchText) ||
                    description.contains(searchText) ||
                    icon.contains(searchText);
              }).toList();

              // Empty list state
              if (displayList.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No cards found"),
                    ),
                  ),
                );
              }

              // Render list items
              return SliverPadding(
                padding: EdgeInsets.only(
                  left: AppSizes.screenPadding,
                  right: AppSizes.screenPadding,
                ),
                sliver: SliverList.builder(
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    final card = displayList[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                      child: CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ==========================================
                            // TOP ROW (IMAGE/ICON + TITLE + ACTIONS)
                            // ==========================================
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Card Image or Icon
                                _buildCardImageOrIcon(context, card),

                                SizedBox(width: AppSizes.itemGap),

                                // Card Title & Actions
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: TextTitleWidget(
                                          title: card.title ?? "",
                                          size: AppSizes.sectionTitle,
                                          color: color.primary,

                                        ),
                                      ),

                                      // Popup menu actions
                                      Column(
                                        crossAxisAlignment: .end,
                                        children: [
                                          MoreMenu(
                                            items: const [
                                              MoreMenuAction.edit,
                                              MoreMenuAction.delete,
                                            ],
                                            onSelected: (action) async {
                                              switch (action) {
                                              // Edit action
                                                case MoreMenuAction.edit:
                                                  final result =
                                                  await Navigator.pushNamed(
                                                    context,
                                                    RoutesName.add_new_card_manage,
                                                    arguments: {
                                                      'isEdit': true,
                                                      'card': card,
                                                    },
                                                  );

                                                  if (!mounted) return;

                                                  if (result == true) {
                                                    _refreshCardList();
                                                  }
                                                  break;

                                              // Delete action
                                                case MoreMenuAction.delete:
                                                  final confirmed =
                                                  await confirmAction(
                                                    context,
                                                    title: "Delete Card",
                                                    message:
                                                    "Are you sure you want to permanently delete this card?",
                                                  );

                                                  if (!mounted || !confirmed) return;
                                                  if (card.id == null) return;

                                                  final cardProvider =
                                                  context.read<CardViewModel>();

                                                  final success =
                                                  await cardProvider
                                                      .deleteCardApi(card.id!);

                                                  if (!mounted) return;

                                                  if (success) {
                                                    SnackBarMessage.showSnackBar(
                                                      context,
                                                      "Card deleted successfully",
                                                    );
                                                    _refreshCardList();
                                                  } else {
                                                    SnackBarMessage.showSnackBar(
                                                      context,
                                                      cardProvider.errorMessage ??
                                                          "Failed to delete card",
                                                    );
                                                  }
                                                  break;

                                                default:
                                                  break;
                                              }
                                            },
                                          ),


                                          SizedBox(height: AppSizes.smallGap,),
                                          // ==========================================
                                          // BOTTOM STATUS BADGE
                                          // ==========================================
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              if (card.image != null)
                                                CustomStatusBadge(
                                                  title: "IMAGE MODE",
                                                  size: AppSizes.cardTitle,
                                                )
                                              else if (card.icon != null &&
                                                  card.icon!.isNotEmpty)
                                                CustomStatusBadge(
                                                  title: "ICON MODE",
                                                  size: AppSizes.cardTitle,
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // ==========================================
                            // DESCRIPTION
                            // ==========================================
                            SizedBox(height: AppSizes.itemGap),

                            TextBodyStyleWidget(
                              title: card.description ?? "",
                              maxLines: 4,
                              fontbold: false,
                              size: AppSizes.cardTitle,
                            ),





                          ],
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
          SliverPadding(
            padding: EdgeInsets.only(
              top: AppSizes.screenPadding,
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([const SizedBox(height: 100)]),
            ),
          ),
        ],
      ),

      // ================================================================
      // ADD BUTTON
      // ================================================================
      floatingActionButton: FloatingActionButton(
        heroTag: "addCard",
        backgroundColor: color.primary,
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            RoutesName.add_new_card_manage,
          );

          if (!mounted) return;

          if (result == true) {
            _refreshCardList();
          }
        },
        child: Icon(Icons.add, color: color.cardBackground),
      ),
    );
  }

  // ================================================================
  // IMAGE OR ICON BUILDER
  // ================================================================
  Widget _buildCardImageOrIcon(BuildContext context, CardModel card) {
    final color = context.Appcolor;

    // Check valid image URL
    final bool hasValidImage = card.imageUrl != null &&
        card.imageUrl!.trim().isNotEmpty &&
        !card.imageUrl!.endsWith('/');

    // 1. Show Image if available
    if (hasValidImage) {
      return ImageRectangleWidget(
        imgPath: card.imageUrl!,
        isNetwork: true,
        width: 80,
        height: 80,
        borderRadius: AppSizes.cardRadius,
      );
    }

    // 2. Show Icon if available
    if (card.icon != null && card.icon!.trim().isNotEmpty) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color.lightVersionOfPrimaryLightVersion,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
        child: Center(
          child: Icon(
            _getIcon(card.icon!),
            color: color.primary,
            size: AppSizes.appBarIcon,
          ),
        ),
      );
    }

    // 3. Placeholder fallback
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color.lightVersionOfPrimaryLightVersion,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Icon(
        Icons.image_not_supported_outlined,
        color: color.primary,
        size: AppSizes.appBarIcon,
      ),
    );
  }

  // ================================================================
  // ICON MAPPING HELPER
  // ================================================================
  IconData _getIcon(String iconName) {
    final cleanName = iconName.toLowerCase().replaceAll('fa-', '');
    return IconList.iconMap[cleanName] ?? Icons.info_outline;
  }
}