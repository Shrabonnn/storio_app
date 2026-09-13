import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/data/model/Content/event/event_model.dart';
import 'package:storio_app/widget/universal/custom_status_badge.dart';

import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/image_card.dart';
import '../../widget/universal/info_item_card.dart';

class ViewEventScreen extends StatefulWidget {
  const ViewEventScreen({super.key, required this.event});

  final EventModel event;

  @override
  State<ViewEventScreen> createState() => _ViewEventScreenState();
}

class _ViewEventScreenState extends State<ViewEventScreen> {
  // ============================================================
  // Date Time Formatter
  // ============================================================

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return "Not available";
    }

    return DateFormat("MMM dd, yyyy, hh:mm a").format(dateTime.toLocal());
  }

  // ============================================================
  // Status Formatter
  // ============================================================

  String _formatStatus(String? status) {
    if (status == null || status.isEmpty) {
      return "Draft";
    }

    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  // ============================================================
  // Featured Image
  // ============================================================

  Widget _buildFeaturedImage() {
    final imageUrl = widget.event.featuredImageDetail?.file;

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

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ======================================================
          // App Bar
          // ======================================================
          CustomSliverAppBar(
            title: widget.event.title ?? "Event Details",
            showBackButton: true,
          ),

          // ======================================================
          // Body
          // ======================================================
          SliverPadding(
            padding: EdgeInsets.only(
              top: AppSizes.screenPadding,
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
              bottom: AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    // ==================================================
                    // Main Event Card
                    // ==================================================
                    ImageCard(
                      image: _buildFeaturedImage(),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ============================================
                          // Status
                          // ============================================
                          CustomStatusBadge(
                            title: _formatStatus(widget.event.status),
                            size: AppSizes.cardTitle,
                          ),

                          SizedBox(height: AppSizes.smallGap),

                          // ============================================
                          // Start & End Date
                          // ============================================
                          Row(
                            children: [
                              Expanded(
                                child: InfoItemCard(
                                  title: "Start:",
                                  name: _formatDateTime(widget.event.startDate),
                                  icons: Icons.calendar_month_outlined,
                                ),
                              ),

                              SizedBox(width: AppSizes.smallGap),

                              Expanded(
                                child: InfoItemCard(
                                  title: "End:",
                                  name: _formatDateTime(widget.event.endDate),
                                  icons: Icons.watch_later_outlined,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: AppSizes.smallGap),

                          // ============================================
                          // Location
                          // ============================================
                          if (widget.event.location != null &&
                              widget.event.location!.isNotEmpty)
                            Row(
                              children: [
                                Expanded(
                                  child: InfoItemCard(
                                    title: "Location:",
                                    name: widget.event.location!,
                                    icons: Icons.location_on_outlined,
                                  ),
                                ),
                              ],
                            ),

                          // ============================================
                          // Excerpt
                          // ============================================
                          if (widget.event.excerpt != null &&
                              widget.event.excerpt!.isNotEmpty) ...[
                            SizedBox(height: AppSizes.smallGap),

                            CustomCard2(
                              child: Padding(
                                padding: EdgeInsets.all(
                                  AppSizes.contentPadding,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextTitleWidget(
                                      title: "Overview",
                                      color: color.primary,
                                      size: AppSizes.screenTitle,
                                    ),

                                    SizedBox(height: AppSizes.smallGap),

                                    TextBodyStyleWidget(
                                      title: widget.event.excerpt!,
                                      color: color.primary,
                                      size: AppSizes.cardTitle,
                                      maxLines: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          // ============================================
                          // Content
                          // ============================================
                          SizedBox(height: AppSizes.itemGap),

                          CustomCard2(
                            child: Padding(
                              padding: EdgeInsets.all(AppSizes.contentPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextTitleWidget(
                                    title: "Content",
                                    color: color.primary,
                                    size: AppSizes.screenTitle,
                                  ),

                                  SizedBox(height: AppSizes.smallGap),

                                  TextBodyStyleWidget(
                                    title:
                                        widget.event.content?.isNotEmpty == true
                                        ? widget.event.content!
                                        : "No content available",
                                    color: color.primary,
                                    size: AppSizes.cardTitle,
                                    maxLines: 100,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // ============================================
                          // Categories
                          // ============================================
                          if (widget.event.categoriesDetail != null &&
                              widget.event.categoriesDetail!.isNotEmpty) ...[
                            SizedBox(height: AppSizes.itemGap),

                            CustomCard2(
                              child: Padding(
                                padding: EdgeInsets.all(
                                  AppSizes.contentPadding,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextTitleWidget(
                                      title: "Categories",
                                      color: color.primary,
                                      size: AppSizes.screenTitle,
                                    ),

                                    SizedBox(height: AppSizes.smallGap),

                                    Wrap(
                                      spacing: AppSizes.smallGap,
                                      runSpacing: AppSizes.smallGap,
                                      children: widget.event.categoriesDetail!
                                          .map((category) {
                                            return CustomStatusBadge(
                                              title: category.name ?? "",
                                              size: AppSizes.cardTitle,
                                            );
                                          })
                                          .toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          // ============================================
                          // Featured Event
                          // ============================================
                          if (widget.event.isFeatured == true) ...[
                            SizedBox(height: AppSizes.itemGap),

                            CustomCard2(
                              child: Padding(
                                padding: EdgeInsets.all(
                                  AppSizes.contentPadding,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star_outline,
                                      color: color.primary,
                                      size: AppSizes.icon,
                                    ),

                                    SizedBox(width: AppSizes.smallGap),

                                    Expanded(
                                      child: TextBodyStyleWidget(
                                        title: "Featured Event",
                                        color: color.primary,
                                        size: AppSizes.cardTitle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          // ============================================
                          // Edit & Delete
                          // ============================================
                          SizedBox(height: AppSizes.itemGap),

                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  height: 4.5.h,
                                  size: AppSizes.cardTitle,
                                  text: "Edit Event",
                                  onTap: () async {
                                    final result = await Navigator.pushNamed(
                                      context,
                                      RoutesName.edit_event,
                                      arguments: widget.event,
                                    );

                                    if (!mounted) {
                                      return;
                                    }

                                    if (result == true) {
                                      Navigator.pop(context, true);
                                    }
                                  },
                                ),
                              ),

                              SizedBox(width: AppSizes.smallGap),

                              IconButton(
                                onPressed: () {
                                  // Delete event
                                  //
                                  // Delete API এখানে
                                  // পরে connect করবে।
                                },
                                icon: Icon(
                                  Icons.delete_outline,
                                  size: AppSizes.appBarIcon,
                                  color: Colors.red,
                                ),
                              ),
                            ],
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
