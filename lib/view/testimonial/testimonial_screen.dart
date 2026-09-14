import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:storio_app/utils/snackbar_message.dart';
import 'package:storio_app/widget/custom_button/view_button.dart';
import 'package:storio_app/widget/universal/custom_status_badge.dart';
import 'package:storio_app/widget/universal/more_menu.dart';

import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../viewModel/Content/testimonial_view_model.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/confirm_action.dart';
import '../../widget/universal/image_circle_widget.dart';
import '../../widget/universal/search_text_field.dart';
import '../../widget/universal/status_button_row.dart';

class TestimonialScreen extends StatefulWidget {
  const TestimonialScreen({super.key, this.showBackButton = true});

  final bool showBackButton;

  @override
  State<TestimonialScreen> createState() => _TestimonialScreenState();
}

class _TestimonialScreenState extends State<TestimonialScreen> {
  final TextEditingController searchController = TextEditingController();

  // ============================================================
  // STATUS
  // ============================================================

  int selectedStatus = 0;

  final List<String> statusList = ["All", "Active", "Inactive", "Draft"];

  // ============================================================
  // BULK ACTION
  // ============================================================

  final List<String> bulkActionList = [
    "Bulk Action",
    "Activate",
    "Deactivate",
    "Delete",
  ];

  String selectedBulkAction = "Bulk Action";

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TestimonialViewModel>().getManagementTestimonials();
    });
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ======================================================
          // APP BAR
          // ======================================================
          CustomSliverAppBar(
            title: "Testimonials",
            subtitle: "Manage user feedback and customer reviews",
            showBackButton: widget.showBackButton,
          ),

          // ======================================================
          // SEARCH + BULK ACTION
          // ======================================================
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
                    // SEARCH
                    Expanded(
                      child: SearchTextField(
                        onChanged: (value) {
                          _refreshTestimonialList(search: value);
                        },
                        hinText: "Search...",
                        controller: searchController,
                      ),
                    ),




                  ],
                ),

                SizedBox(height: AppSizes.smallGap),

                // ==================================================
                // STATUS FILTER
                // ==================================================
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    StatusButtonRow(
                      items: statusList,
                      selectedIndex: selectedStatus,
                      onSelected: (index) {
                        setState(() {
                          selectedStatus = index;
                        });

                        _refreshTestimonialList();
                      },
                    ),
                  ],
                ),

                SizedBox(height: AppSizes.sectionGap),
              ]),
            ),
          ),

          // ======================================================
          // TESTIMONIAL LIST
          // ======================================================
          Consumer<TestimonialViewModel>(
            builder: (context, provider, child) {
              // --------------------------------------------------
              // LOADING
              // --------------------------------------------------

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

              // --------------------------------------------------
              // ERROR
              // --------------------------------------------------

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

              // --------------------------------------------------
              // EMPTY
              // --------------------------------------------------

              if (provider.testimonialList.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No testimonials found"),
                    ),
                  ),
                );
              }

              // --------------------------------------------------
              // LIST
              // --------------------------------------------------

              return SliverPadding(
                padding: EdgeInsets.only(
                  left: AppSizes.screenPadding,
                  right: AppSizes.screenPadding,
                ),
                sliver: SliverList.builder(
                  itemCount: provider.testimonialList.length,

                  itemBuilder: (context, index) {
                    final testimonial = provider.testimonialList[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: AppSizes.sectionGap),

                      child: CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            // ==================================
                            // TOP ROW
                            // ==================================
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                // PHOTO
                                /*Container(
                                  width: 80,
                                  height: 80,

                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: color.primary,
                                      width: 1,
                                    ),
                                  ),

                                  child: CircleAvatar(
                                    backgroundImage:
                                        testimonial.photoData?.fileUrl != null
                                        ? NetworkImage(
                                            testimonial.photoData!.fileUrl!,
                                          )
                                        : const AssetImage(
                                                "assets/images/person.png",
                                              )
                                              as ImageProvider,
                                  ),
                                ),*/
                                ImageCircleWidget(
                                  imgPath: testimonial.photoData?.fileUrl ?? "",
                                  isNetwork: true,
                                ),

                                SizedBox(width: AppSizes.itemGap),

                                // -------------------------------
                                // CONTENT
                                // -------------------------------
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,


                                    children: [
                                      // NAME + ACTIONS
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,

                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: .start,

                                              children: [
                                                SizedBox(height: AppSizes.appbarGap),

                                                TextTitleWidget(
                                                  title: testimonial.name ?? "",
                                                  color: color.primary,
                                                  maxLines: 1,
                                                ),
                                                SizedBox(height: AppSizes.appbarGap),
                                                // DESIGNATION
                                                TextBodyStyleWidget(
                                                  title: testimonial.designation ?? "",
                                                  color: color.primary,
                                                  maxLines: 1,
                                                ),

                                                SizedBox(height: AppSizes.appbarGap),

                                                // ORGANIZATION

                                                if(testimonial.organization!=null)
                                                TextBodyStyleWidget(
                                                  title: testimonial.organization ?? "",
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(width: AppSizes.smallGap),

                                          Row(
                                            children: [
                                              // VIEW
                                              ViewButton(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    RoutesName.view_testimonial,
                                                    arguments: {
                                                      'testimonial': testimonial,
                                                    },
                                                  );
                                                },
                                              ),

                                              SizedBox(
                                                width: AppSizes.smallGap,
                                              ),

                                              // MORE MENU
                                              MoreMenu(
                                                items: const [
                                                  MoreMenuAction.edit,
                                                  MoreMenuAction.delete,
                                                ],

                                                onSelected: (action) async {
                                                  switch (action) {
                                                    // ----------------
                                                    // EDIT
                                                    // ----------------

                                                    case MoreMenuAction.edit:
                                                      final result = await Navigator.pushNamed(context,
                                                            RoutesName.edit_testimonial,
                                                            arguments: {
                                                              'testimonial': testimonial,},
                                                          );

                                                      if (!mounted) return;

                                                      if (result == true) {
                                                        _refreshTestimonialList();
                                                      }

                                                      break;

                                                    // ----------------
                                                    // DELETE
                                                    // ----------------

                                                    case MoreMenuAction.delete:
                                                      final confirmed =
                                                          await confirmAction(
                                                            context,
                                                            title:
                                                                "Delete Testimonial",
                                                            message:
                                                                "Are you sure you want to delete this testimonial?",
                                                          );

                                                      if (!mounted ||
                                                          !confirmed) {
                                                        return;
                                                      }

                                                      final success = await context
                                                          .read<
                                                            TestimonialViewModel
                                                          >()
                                                          .deleteTestimonial(
                                                            testimonial.id!,
                                                          );

                                                      if (!mounted) return;

                                                      if (success) {
                                                        _refreshTestimonialList();
                                                      } else {
                                                        SnackBarMessage.showSnackBar(
                                                          context,
                                                          context
                                                                  .read<
                                                                    TestimonialViewModel
                                                                  >()
                                                                  .errorMessage ??
                                                              "Failed to delete testimonial",
                                                        );
                                                      }

                                                      break;

                                                    // ----------------
                                                    // OTHER CASES
                                                    // ----------------

                                                    case MoreMenuAction.publish:
                                                    case MoreMenuAction.archive:
                                                    case MoreMenuAction.view:
                                                    case MoreMenuAction
                                                        .changePassword:
                                                    case MoreMenuAction.suspend:
                                                      break;
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: AppSizes.itemGap),




                                      // RATING + STATUS
                                      Row(
                                        children: [
                                          // STARS
                                          _buildRating(testimonial.rating ?? 0),

                                          const Spacer(),

                                          // STATUS
                                          CustomStatusBadge(
                                            title:
                                              testimonial.status!.toUpperCase(),

                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: AppSizes.itemGap),

                            // ==================================
                            // MESSAGE
                            // ==================================
                            TextBodyStyleWidget(
                              title: testimonial.message ?? "",
                              maxLines: 4,
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

          // ======================================================
          // BOTTOM SPACE
          // ======================================================
          SliverPadding(padding: EdgeInsets.only(bottom: AppSizes.sectionGap)),
        ],
      ),

      // ==========================================================
      // ADD BUTTON
      // ==========================================================
      floatingActionButton: FloatingActionButton(
        heroTag: "add_testimonial",
        backgroundColor: color.primary,

        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            RoutesName.add_new_testimonial,
          );

          if (!mounted) return;

          if (result == true) {
            _refreshTestimonialList();
          }
        },

        child: Icon(Icons.add, color: color.cardBackground),
      ),
    );
  }

  // ============================================================
  // RATING
  // ============================================================

  Widget _buildRating(int rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }



  // ============================================================
  // STATUS API VALUE
  // ============================================================

  String? _getStatusValue() {
    switch (selectedStatus) {
      case 0:
        return null;

      case 1:
        return "active";

      case 2:
        return "inactive";

      case 3:
        return "draft";

      default:
        return null;
    }
  }

  // ============================================================
  // REFRESH LIST
  // ============================================================

  void _refreshTestimonialList({String? search}) {
    final provider = context.read<TestimonialViewModel>();

    provider.getManagementTestimonials(
      search: search ?? searchController.text,
      status: _getStatusValue(),
    );
  }

  // ============================================================
  // BULK ACTION
  // ============================================================

  Future<void> _handleBulkAction(String action) async {
    final provider = context.read<TestimonialViewModel>();

    // ----------------------------------------------
    // GET ALL CURRENT LIST IDS
    // ----------------------------------------------

    final testimonialIds = provider.testimonialList
        .map((testimonial) => testimonial.id)
        .whereType<int>()
        .toList();

    if (testimonialIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No testimonials to update")),
      );

      return;
    }

    String apiAction;
    String confirmTitle;
    String confirmMessage;

    // ----------------------------------------------
    // ACTION MAPPING
    // ----------------------------------------------

    switch (action) {
      case "Activate":
        apiAction = "activate";

        confirmTitle = "Activate Testimonials";

        confirmMessage =
            "Do you want to activate all ${testimonialIds.length} testimonial(s)?";

        break;

      case "Deactivate":
        apiAction = "deactivate";

        confirmTitle = "Deactivate Testimonials";

        confirmMessage =
            "Do you want to deactivate all ${testimonialIds.length} testimonial(s)?";

        break;

      case "Delete":
        apiAction = "delete";

        confirmTitle = "Delete Testimonials";

        confirmMessage =
            "Do you want to permanently delete all ${testimonialIds.length} testimonial(s)? This cannot be undone.";

        break;

      default:
        return;
    }

    // ----------------------------------------------
    // CONFIRM
    // ----------------------------------------------

    final confirmed = await confirmAction(
      context,
      title: confirmTitle,
      message: confirmMessage,
    );

    if (!mounted || !confirmed) return;

    // ----------------------------------------------
    // API
    // ----------------------------------------------

    final success = await provider.bulkOperation(
      ids: testimonialIds,
      action: apiAction,
    );

    if (!mounted) return;

    if (success) {
      _refreshTestimonialList();
    } else {
      SnackBarMessage.showSnackBar(
        context,
        provider.errorMessage ?? "Bulk action failed",
      );
    }
  }
}
