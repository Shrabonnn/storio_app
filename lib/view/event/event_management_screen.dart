import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/viewModel/Content/event_view_model.dart';
import 'package:storio_app/widget/custom_button/view_button.dart';
import 'package:storio_app/widget/universal/more_menu.dart';

import '../../routes/routes_name.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/confirm_action.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_status_badge.dart';
import '../../widget/universal/date_time_formate.dart';
import '../../widget/universal/image_card.dart';
import '../../widget/universal/search_text_field.dart';

class EventManagementScreen extends StatefulWidget {
  const EventManagementScreen({super.key});

  @override
  State<EventManagementScreen> createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<EventViewModel>();
      await provider.getEventApi();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _refreshEventApi() {
    final provider = context.read<EventViewModel>();
    provider.getEventApi(search: searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Event Management",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(
              top: AppSizes.screenPadding,
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Expanded(
                          child: SearchTextField(
                            onChanged: (value) {
                              final provider = context.read<EventViewModel>();
                              provider.getEventApi(search: value);
                            },
                            hinText: "Search",
                            controller: searchController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.sectionGap),
                  ],
                ),
              ]),
            ),
          ),
          Consumer<EventViewModel>(builder: (context, provider, child) {
            if (provider.loading) {
              return const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            if (provider.errorMessage != null) {
              return SliverToBoxAdapter(
                child: Center(child: Text(provider.errorMessage!)),
              );
            }

            if (provider.eventList.isEmpty) {
              return const SliverToBoxAdapter(
                child: Center(child: Text("No activity posts found")),
              );
            }

            return SliverPadding(
              padding: EdgeInsetsGeometry.only(
                left: AppSizes.screenPadding,
                right: AppSizes.screenPadding,
              ),
              sliver: SliverList.builder(
                itemCount: provider.eventList.length,
                itemBuilder: (context, index) {
                  final event = provider.eventList[index];
                  final imageUrl = event.featuredImageDetail?.file;

                  return ImageCard(
                    image: (imageUrl != null && imageUrl.isNotEmpty)
                        ? Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 18.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset(
                            "assets/images/institute.png",
                            width: double.infinity,
                            height: 18.h,
                            fit: BoxFit.cover,
                          ),
                    )
                        : Image.asset(
                      "assets/images/institute.png",
                      width: double.infinity,
                      height: 18.h,
                      fit: BoxFit.cover,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            CustomStatusBadge(
                              title: event.status ?? "",
                              size: AppSizes.cardTitle,
                            ),
                            Row(
                              children: [
                                ViewButton(onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RoutesName.view_event,
                                    arguments: {'event': event},
                                  );
                                }),
                                MoreMenu(
                                  items: [
                                    MoreMenuAction.edit,
                                    MoreMenuAction.delete,
                                  ],
                                  onSelected: (action) async {
                                    switch (action) {
                                      case MoreMenuAction.edit:
                                        final result = await Navigator.pushNamed(
                                          context,
                                          RoutesName.edit_event,
                                          arguments: {
                                            'isEdit': true,
                                            'event': event,
                                          },
                                        );

                                        if (!mounted) return;

                                        if (result == true) {
                                          _refreshEventApi();
                                        }
                                        break;

                                      case MoreMenuAction.archive:
                                        throw UnimplementedError();

                                      case MoreMenuAction.view:
                                        throw UnimplementedError();

                                      case MoreMenuAction.delete:
                                        final confirmed = await confirmAction(
                                          context,
                                          title: "Delete Event",
                                          message:
                                          "Are you sure you want to permanently delete this event?",
                                        );

                                        if (!mounted || !confirmed) return;

                                        final provider2 =
                                        context.read<EventViewModel>();
                                        final success =
                                        await provider2.deleteEvent(event.id!);

                                        if (!mounted) return;

                                        if (!success) {
                                          SnackBarMessage.showSnackBar(
                                            context,
                                            provider2.actionError ??
                                                "Failed to delete",
                                          );
                                        }
                                        break;

                                      case MoreMenuAction.changePassword:
                                        throw UnimplementedError();

                                      case MoreMenuAction.suspend:
                                        throw UnimplementedError();
                                      case MoreMenuAction.publish:
                                        // TODO: Handle this case.
                                        throw UnimplementedError();
                                    }
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                        TextTitleWidget(
                          title: event.title ?? "",
                          color: color.primary,
                          maxLines: 1,
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        Row(
                          children: [
                            Icon(Icons.calendar_month_outlined,
                                color: color.primary, size: AppSizes.icon),
                            SizedBox(width: AppSizes.appbarGap),
                            Flexible(
                              child: TextBodyStyleWidget(
                                title: event.startDate != null
                                    ? "${formatDate(event.startDate)}. ${formatTime(event.startDate)}"
                                    : "",
                                maxLines: 1,
                                size: AppSizes.cardTitle,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                color: color.primary, size: AppSizes.icon),
                            SizedBox(width: AppSizes.appbarGap),
                            Flexible(
                              child: TextBodyStyleWidget(
                                title: event.location ?? "",
                                maxLines: 1,
                                size: AppSizes.cardTitle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          })
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "addCategory",
            backgroundColor: color.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.manage_event_category);
            },
            child: Icon(Icons.grid_view_rounded, color: color.cardBackground),
          ),
          SizedBox(height: AppSizes.itemGap),
          FloatingActionButton(
            heroTag: "add",
            backgroundColor: color.primary,
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                RoutesName.add_new_event,
              );

              if (!mounted) return;

              if (result == true) {
                _refreshEventApi();
              }
            },
            child: Icon(Icons.add, color: color.cardBackground),
          ),
        ],
      ),
    );
  }
}