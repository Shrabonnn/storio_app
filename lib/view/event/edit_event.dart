import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:storio_app/data/model/Content/event/event_model.dart';
import 'package:storio_app/utils/snackbar_message.dart';
import 'package:storio_app/viewModel/Content/event_view_model.dart';
import 'package:storio_app/widget/universal/custom_drop_down.dart';

import '../../data/model/form_field/form_feild_data.dart';
import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/institute_profile/Institute_overview_screen.dart';
import '../../widget/institute_profile/infrastructure_drop_down.dart';
import '../../widget/quill/editor_icon.dart';
import '../../widget/quill/editor_option.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_text_field.dart';

class EditEvent extends StatefulWidget {
  const EditEvent({
    super.key,
    required this.event,
  });

  final EventModel event;

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  // =========================
  // Controllers
  // =========================

  final TextEditingController titleController =
  TextEditingController();

  final TextEditingController startDateController =
  TextEditingController();

  final TextEditingController startTimeController =
  TextEditingController();

  final TextEditingController endDateController =
  TextEditingController();

  final TextEditingController endTimeController =
  TextEditingController();

  final TextEditingController locationController =
  TextEditingController();

  final TextEditingController excerptController =
  TextEditingController();

  final TextEditingController metaTitleController =
  TextEditingController();

  final TextEditingController metaDescriptionController =
  TextEditingController();

  // =========================
  // Event data
  // =========================

  String eventContent = "";

  String selectedStatus = "draft";

  int? selectedCategoryId;

  String? selectedImageUrl;
  int? selectedImageId;

  bool isFeatured = false;

  bool isSaving = false;

  // =========================
  // SEO
  // =========================

  bool isEventSettingSeoExpanded = false;

  // =========================
  // Status
  // =========================

  final List<String> statusList = [
    "Draft",
    "Published",
    "Archived",
  ];

  // =========================
  // Init
  // =========================

  @override
  void initState() {
    super.initState();

    _prefillEvent();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<EventViewModel>().getCategoryApi();
    });
  }

  // =========================
  // Prefill Event
  // =========================

  void _prefillEvent() {
    final event = widget.event;

    titleController.text = event.title ?? '';

    locationController.text = event.location ?? '';

    excerptController.text = event.excerpt ?? '';

    eventContent = event.content ?? '';

    metaTitleController.text = event.seoTitle ?? '';

    metaDescriptionController.text =
        event.seoDescription ?? '';

    selectedStatus = event.status ?? "draft";

    isFeatured = event.isFeatured ?? false;

    // Existing category
    if (event.categories != null &&
        event.categories!.isNotEmpty) {
      selectedCategoryId = event.categories!.first;
    }

    // Existing featured image
    selectedImageId = event.featuredImage;

    if (event.featuredImageDetail != null) {
      selectedImageUrl =
          event.featuredImageDetail!.file;
    }

    // Start date & time
    if (event.startDate != null) {
      final startDate = event.startDate!.toLocal();

      startDateController.text =
          DateFormat("dd MMM yyyy").format(startDate);

      startTimeController.text =
          DateFormat("hh:mm a").format(startDate);
    }

    // End date & time
    if (event.endDate != null) {
      final endDate = event.endDate!.toLocal();

      endDateController.text =
          DateFormat("dd MMM yyyy").format(endDate);

      endTimeController.text =
          DateFormat("hh:mm a").format(endDate);
    }
  }

  // =========================
  // Content
  // =========================

  Future<void> _openContentDetails() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.content_details,
      arguments: {
        "content": eventContent,
      },
    );

    if (!mounted) return;

    if (result is String) {
      setState(() {
        eventContent = result;
      });
    }
  }

  // =========================
  // Media
  // =========================

  Future<void> _openMediaManage() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
      arguments: {
        "currentId": selectedImageId,
        "currentFileUrl": selectedImageUrl,
      },
    );

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        selectedImageId = result['id'] as int?;
        selectedImageUrl = result['file'] as String?;
      });
    }
  }

  // =========================
  // Date Time
  // =========================

  DateTime? _getDateTime({
    required TextEditingController dateController,
    required TextEditingController timeController,
  }) {
    if (dateController.text.trim().isEmpty) {
      return null;
    }

    try {
      final date = DateFormat("dd MMM yyyy")
          .parse(dateController.text.trim());

      if (timeController.text.trim().isEmpty) {
        return date;
      }

      final time = DateFormat("hh:mm a")
          .parse(timeController.text.trim());

      return DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    } catch (e) {
      return null;
    }
  }

  // =========================
  // Update Event
  // =========================

  Future<void> _handleUpdateEvent() async {
    if (titleController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(
        context,
        "Please enter event title",
      );
      return;
    }

    if (eventContent.trim().isEmpty) {
      SnackBarMessage.showSnackBar(
        context,
        "Please enter event description",
      );
      return;
    }

    if (startDateController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(
        context,
        "Please select start date",
      );
      return;
    }

    if (selectedCategoryId == null) {
      SnackBarMessage.showSnackBar(
        context,
        "Please select event category",
      );
      return;
    }

    if (widget.event.id == null) {
      SnackBarMessage.showSnackBar(
        context,
        "Event ID not found",
      );
      return;
    }

    final startDateTime = _getDateTime(
      dateController: startDateController,
      timeController: startTimeController,
    );

    if (startDateTime == null) {
      SnackBarMessage.showSnackBar(
        context,
        "Invalid start date or time",
      );
      return;
    }

    final endDateTime = _getDateTime(
      dateController: endDateController,
      timeController: endTimeController,
    );

    if (endDateController.text.trim().isNotEmpty &&
        endDateTime == null) {
      SnackBarMessage.showSnackBar(
        context,
        "Invalid end date or time",
      );
      return;
    }

    final viewModel = context.read<EventViewModel>();

    setState(() {
      isSaving = true;
    });

    final Map<String, dynamic> data = {
      "title": titleController.text.trim(),
      "content": eventContent.trim(),
      "excerpt": excerptController.text.trim(),
      "location": locationController.text.trim(),
      "start_date": startDateTime.toIso8601String(),
      "end_date": endDateTime?.toIso8601String(),
      "status": selectedStatus,
      "is_featured": isFeatured,
      "featured_image": selectedImageId,
      "categories": [selectedCategoryId],
      "seo_title": metaTitleController.text.trim(),
      "seo_description": metaDescriptionController.text.trim(),
    };

    final updatedEvent = await viewModel.updateEvent(
      widget.event.id!,
      data,
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (updatedEvent != null) {
      SnackBarMessage.showSnackBar(
        context,
        "Event updated successfully",
      );

      Navigator.pop(context, true);
    } else {
      SnackBarMessage.showSnackBar(
        context,
        viewModel.actionError ??
            "Failed to update event",
      );
    }
  }

  // =========================
  // Dispose
  // =========================

  @override
  void dispose() {
    titleController.dispose();
    startDateController.dispose();
    startTimeController.dispose();
    endDateController.dispose();
    endTimeController.dispose();
    locationController.dispose();
    excerptController.dispose();
    metaTitleController.dispose();
    metaDescriptionController.dispose();

    super.dispose();
  }

  // =========================
  // Build
  // =========================

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBar(
            title: "Edit Event",
            showBackButton: true,
          ),

          SliverPadding(
            padding: EdgeInsets.all(
              AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: [
                      // ==================================================
                      // Basic Information
                      // ==================================================

                      CustomCard(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            TextBodyStyleWidget(
                              title: "Event Title",
                              color: color.primary,
                              size: AppSizes.sectionTitle,
                            ),

                            SizedBox(
                              height: AppSizes.appbarGap,
                            ),

                            CustomTextFieldWidget(
                              hintText:
                              "e.g. Annual Sports Day 2026",
                              controller: titleController,
                            ),

                            SizedBox(
                              height: AppSizes.itemGap,
                            ),

                            // Start Date & Time
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      TextBodyStyleWidget(
                                        title:
                                        "Start Date *",
                                        color:
                                        color.primary,
                                        size:
                                        AppSizes.cardTitle,
                                      ),

                                      SizedBox(
                                        height:
                                        AppSizes.appbarGap,
                                      ),

                                      CustomTextFieldWidget(
                                        hintText:
                                        "dd MMM yyyy",
                                        controller:
                                        startDateController,
                                        isDatePicker: true,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  width:
                                  AppSizes.smallGap,
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      TextBodyStyleWidget(
                                        title:
                                        "Start Time *",
                                        color:
                                        color.primary,
                                        size:
                                        AppSizes.cardTitle,
                                      ),

                                      SizedBox(
                                        height:
                                        AppSizes.appbarGap,
                                      ),

                                      CustomTextFieldWidget(
                                        hintText:
                                        "2:30 PM",
                                        controller:
                                        startTimeController,
                                        isTimePicker: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: AppSizes.itemGap,
                            ),

                            // End Date & Time
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      TextBodyStyleWidget(
                                        title:
                                        "End Date",
                                        color:
                                        color.primary,
                                        size:
                                        AppSizes.cardTitle,
                                      ),

                                      SizedBox(
                                        height:
                                        AppSizes.appbarGap,
                                      ),

                                      CustomTextFieldWidget(
                                        hintText:
                                        "dd MMM yyyy",
                                        controller:
                                        endDateController,
                                        isDatePicker: true,
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  width:
                                  AppSizes.smallGap,
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      TextBodyStyleWidget(
                                        title:
                                        "End Time",
                                        color:
                                        color.primary,
                                        size:
                                        AppSizes.cardTitle,
                                      ),

                                      SizedBox(
                                        height:
                                        AppSizes.appbarGap,
                                      ),

                                      CustomTextFieldWidget(
                                        hintText:
                                        "4:30 PM",
                                        controller:
                                        endTimeController,
                                        isTimePicker: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: AppSizes.itemGap,
                            ),

                            // Location
                            TextBodyStyleWidget(
                              title: "Location",
                              color: color.primary,
                              size: AppSizes.sectionTitle,
                            ),

                            SizedBox(
                              height: AppSizes.appbarGap,
                            ),

                            CustomTextFieldWidget(
                              hintText:
                              "e.g. Auditorium, School Field, Online",
                              controller: locationController,
                            ),

                            SizedBox(
                              height: AppSizes.itemGap,
                            ),

                            // Excerpt
                            TextBodyStyleWidget(
                              title: "Excerpt",
                              color: color.primary,
                              size: AppSizes.sectionTitle,
                            ),

                            SizedBox(
                              height: AppSizes.appbarGap,
                            ),

                            CustomTextFieldWidget(
                              hintText:
                              "Short event description",
                              controller: excerptController,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: AppSizes.sectionGap,
                      ),

                      // ==================================================
                      // Featured Image
                      // ==================================================

                      CustomCard(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child:
                                  TextBodyStyleWidget(
                                    title:
                                    "Featured Image",
                                    color:
                                    color.primary,
                                    size:
                                    AppSizes.sectionTitle,
                                  ),
                                ),

                                SizedBox(
                                  width:
                                  AppSizes.appbarGap,
                                ),

                                CustomButton(
                                  height: 4.h,
                                  width: 30.w,
                                  text: "Change Image",
                                  onTap:
                                  _openMediaManage,
                                ),
                              ],
                            ),

                            SizedBox(
                              height: AppSizes.itemGap,
                            ),

                            Container(
                              width: double.infinity,
                              height: 20.h,
                              decoration:
                              BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(
                                  AppSizes.cardRadius,
                                ),
                              ),
                              clipBehavior:
                              Clip.antiAlias,
                              child:
                              _buildFeaturedImage(),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: AppSizes.sectionGap,
                      ),

                      // ==================================================
                      // Event Description
                      // ==================================================

                      CustomCard(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            TextBodyStyleWidget(
                              title:
                              "Event Description",
                              color: color.primary,
                              size:
                              AppSizes.sectionTitle,
                            ),

                            SizedBox(
                              height: AppSizes.appbarGap,
                            ),

                            SingleChildScrollView(
                              scrollDirection:
                              Axis.horizontal,
                              child: Padding(
                                padding:
                                EdgeInsets.symmetric(
                                  horizontal:
                                  AppSizes.smallPadding,
                                  vertical: 8,
                                ),
                                child: Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: [
                                    editorOption(
                                      "paragraph",
                                    ),
                                    editorOption(
                                      "Default",
                                    ),
                                    editorOption(
                                      "14px",
                                    ),
                                    editorIcon("B"),
                                    editorIcon("I"),
                                    editorIcon("U"),
                                    editorIcon("S"),
                                    const Text(
                                      "x²",
                                      style:
                                      TextStyle(
                                        fontSize: 14,
                                        color:
                                        Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Container(
                                      width: 1,
                                      height: 25,
                                      color: Colors
                                          .grey
                                          .shade300,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(
                              height: AppSizes.appbarGap,
                            ),

                            Divider(
                              height: 1,
                              color:
                              Colors.grey.shade300,
                            ),

                            SizedBox(
                              height: AppSizes.appbarGap,
                            ),

                            GestureDetector(
                              onTap:
                              _openContentDetails,
                              child: Padding(
                                padding:
                                EdgeInsets.all(
                                  AppSizes.smallPadding,
                                ),
                                child:
                                TextBodyStyleWidget(
                                  title: eventContent
                                      .isEmpty
                                      ? "Write event description here..."
                                      : eventContent,
                                  size:
                                  AppSizes.cardTitle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: AppSizes.sectionGap,
                      ),

                      // ==================================================
                      // Status
                      // ==================================================

                      CustomCard(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            TextBodyStyleWidget(
                              title: "Status",
                              color: color.primary,
                              size:
                              AppSizes.sectionTitle,
                            ),

                            SizedBox(
                              height: AppSizes.appbarGap,
                            ),

                            CustomDropdown(
                              items: statusList,
                              initialValue:
                              _statusLabel(
                                selectedStatus,
                              ),
                              width: 100.w,
                              onChanged: (value) {
                                setState(() {
                                  selectedStatus =
                                      value
                                          .toString()
                                          .toLowerCase();
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: AppSizes.sectionGap,
                      ),

                      // ==================================================
                      // Category
                      // ==================================================

                      CustomCard(
                        child:
                        Consumer<EventViewModel>(
                          builder:
                              (context, provider, child) {
                            if (provider.categoryLoading) {
                              return const Center(
                                child:
                                Padding(
                                  padding:
                                  EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child:
                                  CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (provider
                                .categoryList.isEmpty) {
                              return Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  TextBodyStyleWidget(
                                    title:
                                    "Category",
                                    color:
                                    color.primary,
                                    size:
                                    AppSizes.sectionTitle,
                                  ),

                                  SizedBox(
                                    height:
                                    AppSizes.appbarGap,
                                  ),

                                  TextBodyStyleWidget(
                                    title:
                                    "No category available",
                                    color:
                                    color.primary,
                                  ),
                                ],
                              );
                            }

                            final categoryItems =
                            provider.categoryList
                                .map(
                                  (item) =>
                              item.name ?? "",
                            )
                                .where(
                                  (name) =>
                              name.isNotEmpty,
                            )
                                .toList();

                            String selectedCategory =
                                categoryItems.first;

                            for (final category
                            in provider
                                .categoryList) {
                              if (category.id ==
                                  selectedCategoryId) {
                                selectedCategory =
                                    category.name ?? "";
                                break;
                              }
                            }

                            return Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                TextBodyStyleWidget(
                                  title: "Category",
                                  color:
                                  color.primary,
                                  size:
                                  AppSizes.sectionTitle,
                                ),

                                SizedBox(
                                  height:
                                  AppSizes.appbarGap,
                                ),

                                CustomDropdown(
                                  items:
                                  categoryItems,
                                  initialValue:
                                  selectedCategory,
                                  width: 100.w,
                                  onChanged:
                                      (value) {
                                    final selected =
                                    provider
                                        .categoryList
                                        .firstWhere(
                                          (item) =>
                                      item.name ==
                                          value,
                                    );

                                    setState(() {
                                      selectedCategoryId =
                                          selected.id;
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      SizedBox(
                        height: AppSizes.sectionGap,
                      ),

                      // ==================================================
                      // Featured
                      // ==================================================

                      CustomCard(
                        child: Row(
                          children: [
                            Checkbox(
                              value: isFeatured,
                              onChanged: (value) {
                                setState(() {
                                  isFeatured =
                                      value ?? false;
                                });
                              },
                            ),

                            Expanded(
                              child:
                              TextBodyStyleWidget(
                                title:
                                "Featured Event",
                                fontbold: false,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: AppSizes.sectionGap,
                      ),

                      // ==================================================
                      // SEO Settings
                      // ==================================================

                      CustomCard(
                        child:
                        InstituteOverviewScreen(
                          title: "SEO Settings",
                          showIcon: true,
                          userIcon:
                          isEventSettingSeoExpanded
                              ? Icons.remove
                              : Icons.keyboard_arrow_down,
                          onTap: () {
                            setState(() {
                              isEventSettingSeoExpanded =
                              !isEventSettingSeoExpanded;
                            });
                          },
                          isExpanded:
                          isEventSettingSeoExpanded,
                          expandableChild:
                          InfrastructureDropDown(
                            fields: [
                              FormFieldData(
                                title:
                                "Meta Title",
                                hint:
                                "SEO Title",
                                controller:
                                metaTitleController,
                              ),
                              FormFieldData(
                                title:
                                "Meta Description",
                                hint:
                                "SEO Description",
                                controller:
                                metaDescriptionController,
                              ),
                            ],
                            onSave: () {},
                          ),
                        ),
                      ),

                      SizedBox(
                        height: AppSizes.sectionGap,
                      ),

                      // ==================================================
                      // Buttons
                      // ==================================================

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(
                            text: "Cancel",
                            onTap: () {
                              Navigator.pop(context);
                            },
                            width: 30.w,
                            backgroundColor:
                            color.cardBackground,
                            foregroundColor:
                            color.primary,
                          ),

                          SizedBox(
                            width:
                            AppSizes.appbarGap,
                          ),

                          Flexible(
                            child: CustomButton(
                              text: isSaving
                                  ? "Updating..."
                                  : "Update Event",
                              onTap: isSaving
                                  ? null
                                  : _handleUpdateEvent,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: AppSizes.sectionGap,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // Status Label
  // =========================

  String _statusLabel(String value) {
    switch (value.toLowerCase()) {
      case "published":
        return "Published";

      case "archived":
        return "Archived";

      case "draft":
      default:
        return "Draft";
    }
  }

  // =========================
  // Featured Image
  // =========================

  Widget _buildFeaturedImage() {
    if (selectedImageUrl != null &&
        selectedImageUrl!.isNotEmpty) {
      return Image.network(
        selectedImageUrl!,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) {
          return Image.asset(
            'assets/images/institute.png',
            fit: BoxFit.cover,
          );
        },
      );
    }

    return Image.asset(
      'assets/images/institute.png',
      fit: BoxFit.cover,
    );
  }
}