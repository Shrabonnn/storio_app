import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/calender_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_text_field.dart';

class AddNewEventCalender extends StatefulWidget {
  const AddNewEventCalender({super.key});

  @override
  State<AddNewEventCalender> createState() => _AddNewEventCalenderState();
}

class _AddNewEventCalenderState extends State<AddNewEventCalender> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  final List<String> levelList = [
    "School-Wide",
    "Primary",
    "Secondary",
    "College"
  ];

  String selectedLevel = "School-Wide";

  final List<String> categoryList = [
    "Academic Events",
    "Holiday & Breaks",
    "Examinations",
    "Festivals & Sports",
    "Admin Deadlines"
  ];

  String selectedCategory = "Academic Events";

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  // ============================================================
  // CATEGORY & LEVEL SLUG MAPPERS
  // ============================================================
  String _getCategorySlug(String category) {
    switch (category) {
      case "Holiday & Breaks":
        return "holiday";
      case "Examinations":
        return "examination";
      case "Festivals & Sports":
        return "festival";
      case "Admin Deadlines":
        return "admin";
      case "Academic Events":
      default:
        return "academic";
    }
  }

  String _getLevelSlug(String level) {
    switch (level) {
      case "Primary":
        return "primary";
      case "Secondary":
        return "secondary";
      case "College":
        return "college";
      case "School-Wide":
      default:
        return "school-wide";
    }
  }

  // ============================================================
  // DATE PICKER DIALOGS
  // ============================================================
  Future<void> _pickStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedStartDate = picked;
        startDateController.text =
        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _pickEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedEndDate = picked;
        endDateController.text =
        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // ============================================================
  // SUBMIT FORM ACTION
  // ============================================================
  Future<void> _submitEvent(CalendarViewModel viewModel) async {
    // Form Validation
    if (titleController.text.trim().isEmpty) {
      _showSnackBar("Please enter an event title");
      return;
    }
    if (_selectedStartDate == null) {
      _showSnackBar("Please select a start date");
      return;
    }

    final payload = {
      "title": titleController.text.trim(),
      "description": descriptionController.text.trim(),
      "start_date": _selectedStartDate?.toIso8601String(),
      "end_date": (_selectedEndDate ?? _selectedStartDate)?.toIso8601String(),
      "category": _getCategorySlug(selectedCategory),
      "level": _getLevelSlug(selectedLevel),
      "is_all_day": true,
    };

    final success = await viewModel.createEvent(payload);

    if (mounted) {
      if (success) {
        _showSnackBar("Event added successfully!");
        Navigator.pop(context, true); // Pop with true to trigger refresh
      } else {
        _showSnackBar(viewModel.errorMessage ?? "Failed to create event");
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: Consumer<CalendarViewModel>(
        builder: (context, viewModel, child) {
          return CustomScrollView(
            slivers: [
              const CustomSliverAppBar(
                title: "Add New Event",
                showBackButton: true,
              ),
              SliverPadding(
                padding: EdgeInsets.all(AppSizes.screenPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      children: [
                        // Title & Description Card
                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextBodyStyleWidget(
                                title: "Title",
                                color: color.textPrimary,
                                size: AppSizes.sectionTitle,
                              ),
                              SizedBox(height: AppSizes.appbarGap),
                              CustomTextFieldWidget(
                                hintText: "e.g. Enter event title",
                                controller: titleController,
                              ),
                              SizedBox(height: AppSizes.itemGap),
                              TextBodyStyleWidget(
                                title: "Description",
                                color: color.textPrimary,
                                size: AppSizes.sectionTitle,
                              ),
                              SizedBox(height: AppSizes.appbarGap),
                              CustomTextFieldWidget(
                                hintText: "e.g. Enter event description",
                                controller: descriptionController,
                                minLines: 4,
                                maxLines: 6,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: AppSizes.sectionGap),

                        // Start Date & End Date Card
                        CustomCard(
                          child: Row(
                            children: [
                              Flexible(
                                child: Column(
                                  children: [
                                    TextBodyStyleWidget(
                                      title: "Start Date",
                                      color: color.textPrimary,
                                      size: AppSizes.sectionTitle,
                                    ),
                                    SizedBox(height: AppSizes.appbarGap),
                                    GestureDetector(
                                      onTap: _pickStartDate,
                                      child: AbsorbPointer(
                                        child: CustomTextFieldWidget(
                                          hintText: "YYYY-MM-DD",
                                          controller: startDateController,
                                          isDatePicker: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: AppSizes.itemGap),
                              Flexible(
                                child: Column(
                                  children: [
                                    TextBodyStyleWidget(
                                      title: "End Date",
                                      color: color.textPrimary,
                                      size: AppSizes.sectionTitle,
                                    ),
                                    SizedBox(height: AppSizes.appbarGap),
                                    GestureDetector(
                                      onTap: _pickEndDate,
                                      child: AbsorbPointer(
                                        child: CustomTextFieldWidget(
                                          hintText: "YYYY-MM-DD",
                                          controller: endDateController,
                                          isDatePicker: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: AppSizes.sectionGap),

                        // Category & Level Selection Card
                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Column(
                                      children: [
                                        TextBodyStyleWidget(
                                          title: "Category",
                                          color: color.textPrimary,
                                          size: AppSizes.sectionTitle,
                                        ),
                                        SizedBox(height: AppSizes.appbarGap),
                                        CustomDropdown(
                                          items: categoryList,
                                          initialValue: selectedCategory,
                                          width: 100.w,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedCategory =
                                                  value.toString();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: AppSizes.itemGap),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        TextBodyStyleWidget(
                                          title: "Level",
                                          color: color.textPrimary,
                                          size: AppSizes.sectionTitle,
                                        ),
                                        SizedBox(height: AppSizes.appbarGap),
                                        CustomDropdown(
                                          items: levelList,
                                          initialValue: selectedLevel,
                                          width: 100.w,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedLevel = value.toString();
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: AppSizes.sectionGap),

                        // Actions (Cancel & Save)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                              text: "Cancel",
                              onTap: () {
                                Navigator.pop(context);
                              },
                              width: 30.w,
                              backgroundColor: color.cardBackground,
                              foregroundColor: color.primary,
                            ),
                            SizedBox(width: AppSizes.smallGap),
                            Flexible(
                              child: viewModel.isSubmitting
                                  ? const Center(
                                  child: CircularProgressIndicator())
                                  : CustomButton(
                                text: "Save Event",
                                onTap: () => _submitEvent(viewModel),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: AppSizes.sectionGap),
                      ],
                    )
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}