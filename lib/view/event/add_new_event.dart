import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../data/model/Content/event/event_model.dart';
import '../../routes/routes_name.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/event_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/quill/editor_icon.dart';
import '../../widget/quill/editor_option.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_text_field.dart';

class AddNewEvent extends StatefulWidget {
  const AddNewEvent({
    super.key,
    this.isEdit = false,
    this.event,
  });

  final bool isEdit;
  final EventModel? event;

  @override
  State<AddNewEvent> createState() => _AddNewEventState();
}

class _AddNewEventState extends State<AddNewEvent> {
  // ============================================================
  // Controllers
  // ============================================================

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

  // ============================================================
  // Event Data
  // ============================================================

  String eventContent = "";

  String selectedStatus = "draft";

  int? selectedCategoryId;

  bool isFeatured = false;

  bool isSaving = false;

  // ============================================================
  // Image
  // ============================================================

  File? selectedImage;

  String? selectedImageUrl;

  int? selectedImageId;

  // ============================================================
  // SEO
  // ============================================================

  bool isEventSettingSeoExpanded = false;

  // ============================================================
  // Status List
  // Event API docs don't have status-choice endpoint
  // ============================================================

  final List<String> statusList = [
    "Draft",
    "Published",
    "Archived",
  ];

  // ============================================================
  // Init
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<EventViewModel>().getCategoryApi();
    });

    if (widget.isEdit && widget.event != null) {
      _prefillEvent(widget.event!);
    }
  }

  // ============================================================
  // Prefill Edit Event
  // ============================================================

  void _prefillEvent(EventModel event) {
    titleController.text = event.title ?? "";

    locationController.text = event.location ?? "";

    excerptController.text = event.excerpt ?? "";

    metaTitleController.text = event.seoTitle ?? "";

    metaDescriptionController.text =
        event.seoDescription ?? "";

    eventContent = event.content ?? "";

    selectedStatus = event.status ?? "draft";

    isFeatured = event.isFeatured ?? false;

    selectedCategoryId =
    event.categories != null &&
        event.categories!.isNotEmpty
        ? event.categories!.first
        : null;

    selectedImageId = event.featuredImage;

    selectedImageUrl =
        event.featuredImageDetail?.file;

    // Start Date
    if (event.startDate != null) {
      final startDate = event.startDate!.toLocal();

      startDateController.text =
          DateFormat("dd MMM yyyy").format(startDate);

      startTimeController.text =
          DateFormat("hh:mm a").format(startDate);
    }

    // End Date
    if (event.endDate != null) {
      final endDate = event.endDate!.toLocal();

      endDateController.text =
          DateFormat("dd MMM yyyy").format(endDate);

      endTimeController.text =
          DateFormat("hh:mm a").format(endDate);
    }
  }

  // ============================================================
  // Open Content Details
  // ============================================================

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

  // ============================================================
  // Open Media Manage
  // ============================================================

  Future<void> _openMediaManage() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
    );

    debugPrint("MEDIA MANAGE RESULT: $result");

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        selectedImageId = result['id'] as int?;

        selectedImageUrl =
        result['file'] as String?;

        if (result['localPath'] != null &&
            selectedImageUrl == null) {
          selectedImage =
              File(result['localPath']);
        } else {
          selectedImage = null;
        }
      });
    }
  }

  // ============================================================
  // Parse Date + Time
  // ============================================================

  DateTime? _getDateTime(
      String dateText,
      String timeText,
      ) {
    if (dateText.trim().isEmpty) {
      return null;
    }

    try {
      final date =
      DateFormat("dd MMM yyyy").parse(
        dateText.trim(),
      );

      if (timeText.trim().isEmpty) {
        return date;
      }

      final time =
      DateFormat("hh:mm a").parse(
        timeText.trim(),
      );

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

  // ============================================================
  // Save Event
  // ============================================================

  Future<void> _handleSaveEvent() async {
    // ----------------------------------------------------------
    // Validation
    // ----------------------------------------------------------

    if (titleController.text.trim().isEmpty) {
      _showMessage("Please enter event title");
      return;
    }

    if (startDateController.text.trim().isEmpty) {
      _showMessage("Please select start date");
      return;
    }

    if (startTimeController.text.trim().isEmpty) {
      _showMessage("Please select start time");
      return;
    }

    if (eventContent.trim().isEmpty) {
      _showMessage("Please enter event description");
      return;
    }

    if (selectedCategoryId == null) {
      _showMessage("Please select event category");
      return;
    }

    final startDateTime = _getDateTime(
      startDateController.text,
      startTimeController.text,
    );

    final endDateTime = _getDateTime(
      endDateController.text,
      endTimeController.text,
    );

    if (startDateTime == null) {
      _showMessage("Invalid start date or time");
      return;
    }

    if (endDateController.text.trim().isNotEmpty &&
        endDateTime == null) {
      _showMessage("Invalid end date or time");
      return;
    }

    if (endDateTime != null &&
        endDateTime.isBefore(startDateTime)) {
      _showMessage(
        "End date/time cannot be before start date/time",
      );
      return;
    }

    // ----------------------------------------------------------
    // Loading
    // ----------------------------------------------------------

    setState(() {
      isSaving = true;
    });

    final viewModel = context.read<EventViewModel>();

    // ----------------------------------------------------------
    // Request Data
    // ----------------------------------------------------------

    final Map<String, dynamic> data = {
      "title": titleController.text.trim(),
      "content": eventContent.trim(),
      "excerpt": excerptController.text.trim(),
      "location": locationController.text.trim(),
      "start_date":
      startDateTime.toUtc().toIso8601String(),
      "end_date":
      endDateTime?.toUtc().toIso8601String(),
      "status": selectedStatus,
      "is_featured": isFeatured,
      "featured_image": selectedImageId,
      "categories": [selectedCategoryId],
      "seo_title":
      metaTitleController.text.trim(),
      "seo_description":
      metaDescriptionController.text.trim(),
    };

    // ----------------------------------------------------------
    // Create
    // ----------------------------------------------------------

    final EventModel? result =
    await viewModel.createEvent(data);

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (result != null) {
      _showMessage(
        widget.isEdit
            ? "Event updated successfully"
            : "Event created successfully",
      );

      Navigator.pop(context, true);
    } else {
      _showMessage(
        viewModel.actionError ??
            "Failed to save event",
      );
    }
  }

  // ============================================================
  // Snackbar
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // Dispose
  // ============================================================

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
            title: widget.isEdit
                ? "Edit Event"
                : "Create New Event",
            showBackButton: true,
          ),

          SliverPadding(
            padding: EdgeInsets.all(
              AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // ==================================================
                  // BASIC INFORMATION
                  // ==================================================

                  CustomCard(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        // Event Title
                        TextBodyStyleWidget(
                          title: "Event Title*",
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

                        // ------------------------------------------
                        // Start Date & Time
                        // ------------------------------------------

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

                        // ------------------------------------------
                        // End Date & Time
                        // ------------------------------------------

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
                                    "5:00 PM",
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

                        // ------------------------------------------
                        // Location
                        // ------------------------------------------

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
                          controller:
                          locationController,
                        ),

                        SizedBox(
                          height: AppSizes.itemGap,
                        ),

                        // ------------------------------------------
                        // Excerpt
                        // ------------------------------------------

                        TextBodyStyleWidget(
                          title: "Short Description",
                          color: color.primary,
                          size: AppSizes.sectionTitle,
                        ),

                        SizedBox(
                          height: AppSizes.appbarGap,
                        ),

                        CustomTextFieldWidget(
                          hintText:
                          "Write a short description",
                          controller:
                          excerptController,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: AppSizes.sectionGap,
                  ),

                  // ==================================================
                  // CONTENT
                  // ==================================================

                  CustomCard(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        TextBodyStyleWidget(
                          title: "Event Description",
                          color: color.primary,
                          size: AppSizes.sectionTitle,
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
                                editorOption("paragraph"),
                                editorOption("Default"),
                                editorOption("14px"),

                                editorIcon("B"),
                                editorIcon("I"),
                                editorIcon("U"),
                                editorIcon("S"),

                                const Text(
                                  "x²",
                                  style: TextStyle(
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
                                  color:
                                  Colors.grey.shade300,
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
                          child: Container(
                            width: double.infinity,
                            padding:
                            EdgeInsets.all(
                              AppSizes.smallPadding,
                            ),
                            child:
                            TextBodyStyleWidget(
                              title: eventContent.isEmpty
                                  ? "Write event description here..."
                                  : eventContent,
                              size:
                              AppSizes.cardTitle,
                              maxLines: 5,
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
                  // STATUS
                  // ==================================================

                  CustomCard(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        TextBodyStyleWidget(
                          title: "Status",
                          color: color.primary,
                          size: AppSizes.sectionTitle,
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
                  // CATEGORY
                  // ==================================================

                  CustomCard(
                    child:
                    Consumer<EventViewModel>(
                      builder:
                          (
                          context,
                          provider,
                          child,
                          ) {
                        if (provider.categoryLoading) {
                          return const Center(
                            child:
                            CircularProgressIndicator(),
                          );
                        }

                        if (provider
                            .categoryList
                            .isEmpty) {
                          return Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              TextBodyStyleWidget(
                                title: "Category",
                                color:
                                color.primary,
                                size: AppSizes
                                    .sectionTitle,
                              ),
                              SizedBox(
                                height:
                                AppSizes.appbarGap,
                              ),
                              TextBodyStyleWidget(
                                title:
                                "No category available",
                                color:
                                color.secondary,
                              ),
                            ],
                          );
                        }

                        final categoryItems =
                        provider.categoryList
                            .map(
                              (category) =>
                          category.name ??
                              "",
                        )
                            .toList();

                        String? selectedCategoryName;

                        for (final category
                        in provider.categoryList) {
                          if (category.id ==
                              selectedCategoryId) {
                            selectedCategoryName =
                                category.name;
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
                              size: AppSizes
                                  .sectionTitle,
                            ),

                            SizedBox(
                              height:
                              AppSizes.appbarGap,
                            ),

                            CustomDropdown(
                              items: categoryItems,
                              initialValue:
                              selectedCategoryName ??
                                  categoryItems
                                      .first,
                              width: 100.w,
                              onChanged: (value) {
                                final selected =
                                provider
                                    .categoryList
                                    .firstWhere(
                                      (category) =>
                                  category.name ==
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
                  // FEATURED EVENT
                  // ==================================================

                  CustomCard(
                    child: Row(
                      children: [
                        Checkbox(
                          value: isFeatured,
                          side: BorderSide(
                            color: color.primary,
                          ),
                          activeColor:
                          color.primary,
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
                            "Mark this event as featured",
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
                  // FEATURED IMAGE
                  // ==================================================

                  CustomCard(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          children: [
                            Flexible(
                              child:
                              TextBodyStyleWidget(
                                title:
                                "Featured Image",
                                color:
                                color.primary,
                                size: AppSizes
                                    .sectionTitle,
                              ),
                            ),

                            SizedBox(
                              width:
                              AppSizes.appbarGap,
                            ),

                            CustomButton(
                              height: 4.h,
                              width: 30.w,
                              text:
                              selectedImageId !=
                                  null
                                  ? "Change Image"
                                  : "Select Image",
                              onTap:
                              _openMediaManage,
                            ),
                          ],
                        ),

                        SizedBox(
                          height: AppSizes.itemGap,
                        ),

                        if (selectedImage != null)
                          Container(
                            width: 100.w,
                            height: 20.h,
                            clipBehavior:
                            Clip.antiAlias,
                            decoration:
                            BoxDecoration(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                AppSizes.cardRadius,
                              ),
                            ),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        else if (selectedImageUrl !=
                            null)
                          Container(
                            width: 100.w,
                            height: 20.h,
                            clipBehavior:
                            Clip.antiAlias,
                            decoration:
                            BoxDecoration(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                AppSizes.cardRadius,
                              ),
                            ),
                            child: Image.network(
                              selectedImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (
                                  context,
                                  error,
                                  stackTrace,
                                  ) {
                                return const Icon(
                                  Icons
                                      .broken_image,
                                );
                              },
                            ),
                          )
                        else
                          TextBodyStyleWidget(
                            title:
                            "Recommended size: 1200x600px for banners, 600x600px for cards.",
                            size:
                            AppSizes.cardTitle,
                            maxLines: 2,
                          ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: AppSizes.sectionGap,
                  ),

                  // ==================================================
                  // SEO SETTINGS
                  // ==================================================

                  CustomCard(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isEventSettingSeoExpanded =
                              !isEventSettingSeoExpanded;
                            });
                          },
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              TextBodyStyleWidget(
                                title:
                                "SEO Settings",
                                color:
                                color.primary,
                                size: AppSizes
                                    .sectionTitle,
                              ),
                              Icon(
                                isEventSettingSeoExpanded
                                    ? Icons.remove
                                    : Icons
                                    .keyboard_arrow_down,
                                color:
                                color.primary,
                              ),
                            ],
                          ),
                        ),

                        if (isEventSettingSeoExpanded)
                          Padding(
                            padding:
                            EdgeInsets.only(
                              top: AppSizes.itemGap,
                            ),
                            child: Column(
                              children: [
                                CustomTextFieldWidget(
                                  hintText:
                                  "SEO Title",
                                  controller:
                                  metaTitleController,
                                ),

                                SizedBox(
                                  height:
                                  AppSizes.itemGap,
                                ),

                                CustomTextFieldWidget(
                                  hintText:
                                  "SEO Description",
                                  controller:
                                  metaDescriptionController,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: AppSizes.sectionGap,
                  ),

                  // ==================================================
                  // BUTTONS
                  // ==================================================

                  Row(
                    children: [
                      CustomButton(
                        text: "Cancel",
                        width: 30.w,
                        backgroundColor:
                        color.cardBackground,
                        foregroundColor:
                        color.primary,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),

                      SizedBox(
                        width: AppSizes.appbarGap,
                      ),

                      Expanded(
                        child: CustomButton(
                          text: isSaving
                              ? "Saving..."
                              : widget.isEdit
                              ? "Update Event"
                              : "Save Event",
                          onTap: isSaving
                              ? () {}
                              : _handleSaveEvent,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: AppSizes.sectionGap,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Status Label
  // ============================================================

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
}