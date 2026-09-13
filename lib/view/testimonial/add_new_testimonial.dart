import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/testimonial_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_text_field.dart';

class AddNewTestimonial extends StatefulWidget {
  const AddNewTestimonial({super.key});

  @override
  State<AddNewTestimonial> createState() => _AddNewTestimonialState();
}

class _AddNewTestimonialState extends State<AddNewTestimonial> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final List<String> ratingItems = [
    "5 Star",
    "4 Star",
    "3 Star",
    "2 Star",
    "1 Star",
  ];

  final List<String> statusItems = ["Active", "InActive", "Draft"];

  String selectedRating = "5 Star";
  String selectedStatus = "Active";

  // Media Manage থেকে selected photo-এর ID
  int? selectedPhotoId;

  // Preview-এর জন্য
  String? selectedPhotoUrl;

  bool isSaving = false;

  @override
  void dispose() {
    nameController.dispose();
    designationController.dispose();
    organizationController.dispose();
    messageController.dispose();

    super.dispose();
  }

  // ============================================================
  // Open Media Manage
  // ============================================================

  Future<void> _openMediaManage() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
    );

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        selectedPhotoId = result['id'] as int?;
        selectedPhotoUrl = result['file'] as String?;
      });

      debugPrint("Selected photo ID: $selectedPhotoId");
      debugPrint("Selected photo URL: $selectedPhotoUrl");
    }
  }

  // ============================================================
  // Get Rating Value
  // ============================================================

  int _getRatingValue() {
    switch (selectedRating) {
      case "5 Star":
        return 5;
      case "4 Star":
        return 4;
      case "3 Star":
        return 3;
      case "2 Star":
        return 2;
      case "1 Star":
        return 1;
      default:
        return 5;
    }
  }

  // ============================================================
  // Get Status Value
  // ============================================================

  String _getStatusValue() {
    switch (selectedStatus) {
      case "Active":
        return "active";
      case "Draft":
        return "draft";
      case "InActive":
        return "inactive";
      default:
        return "draft";
    }
  }

  // ============================================================
  // Save Testimonial
  // ============================================================

  Future<void> _handleSaveTestimonial() async {
    // Name validation
    if (nameController.text.trim().isEmpty) {
      _showMessage("Please enter testimonial name");
      return;
    }

    // Message validation
    if (messageController.text.trim().isEmpty) {
      _showMessage("Please enter testimonial message");
      return;
    }

    final viewModel = context.read<TestimonialViewModel>();

    setState(() {
      isSaving = true;
    });

    final success = await viewModel.createTestimonial(
      name: nameController.text.trim(),
      designation: designationController.text.trim().isEmpty
          ? null
          : designationController.text.trim(),
      organization: organizationController.text.trim().isEmpty
          ? null
          : organizationController.text.trim(),
      message: messageController.text.trim(),
      rating: _getRatingValue(),
      photo: selectedPhotoId,
      status: _getStatusValue(),
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      _showMessage("Testimonial created successfully");

      // true পাঠালে আগের TestimonialScreen refresh করবে
      Navigator.pop(context, true);
    } else {
      _showMessage(viewModel.errorMessage ?? "Failed to create testimonial");
    }
  }

  // ============================================================
  // Snackbar
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
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
          // ========================================================
          // App Bar
          // ========================================================
          CustomSliverAppBar(
            title: "Add New Testimonial",
            showBackButton: true,
          ),

          // ========================================================
          // Body
          // ========================================================
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ==================================================
                // Testimonial Information
                // ==================================================
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =================================================
                      // Photo
                      // =================================================
                      Center(
                        child: GestureDetector(
                          onTap: _openMediaManage,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: color.primary,
                                width: 1,
                              ),
                            ),
                            child: ClipOval(
                              child: selectedPhotoUrl != null
                                  ? Image.network(
                                      selectedPhotoUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Image.asset(
                                              "assets/images/person.png",
                                              fit: BoxFit.cover,
                                            );
                                          },
                                    )
                                  : Image.asset(
                                      "assets/images/person.png",
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: AppSizes.itemGap),

                      // =================================================
                      // Select Photo Button
                      // =================================================
                      Center(
                        child: CustomButton(
                          text: selectedPhotoId == null
                              ? "Select Photo"
                              : "Change Photo",
                          height: 4.h,
                          width: 35.w,
                          onTap: _openMediaManage,
                        ),
                      ),

                      SizedBox(height: AppSizes.sectionGap),

                      // =================================================
                      // Name
                      // =================================================
                      TextBodyStyleWidget(
                        title: "Name*",
                        color: color.primary,
                        size: AppSizes.cardTitle,
                      ),

                      SizedBox(height: AppSizes.appbarGap),

                      CustomTextFieldWidget(
                        hintText: "e.g. Dr. Alan Grant",
                        controller: nameController,
                      ),

                      SizedBox(height: AppSizes.itemGap),

                      // =================================================
                      // Designation
                      // =================================================
                      TextBodyStyleWidget(
                        title: "Designation",
                        color: color.primary,
                        size: AppSizes.cardTitle,
                      ),

                      SizedBox(height: AppSizes.appbarGap),

                      CustomTextFieldWidget(
                        hintText: "e.g. Guest Lecturer",
                        controller: designationController,
                      ),

                      SizedBox(height: AppSizes.itemGap),

                      // =================================================
                      // Organization
                      // =================================================
                      TextBodyStyleWidget(
                        title: "Organization",
                        color: color.primary,
                        size: AppSizes.cardTitle,
                      ),

                      SizedBox(height: AppSizes.appbarGap),

                      CustomTextFieldWidget(
                        hintText: "e.g. Institute of Paleontology",
                        controller: organizationController,
                      ),

                      SizedBox(height: AppSizes.itemGap),

                      // =================================================
                      // Status + Rating
                      // =================================================
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // =========================
                          // Status
                          // =========================
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextBodyStyleWidget(
                                  title: "Status",
                                  color: color.primary,
                                  size: AppSizes.cardTitle,
                                ),

                                SizedBox(height: AppSizes.appbarGap),

                                CustomDropdown(
                                  items: statusItems,
                                  initialValue: selectedStatus,
                                  width: 100.w,
                                  height: 4.5.h,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedStatus = value.toString();
                                    });

                                    debugPrint(
                                      "Selected status: $_getStatusValue()",
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: AppSizes.appbarGap),

                          // =========================
                          // Rating
                          // =========================
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextBodyStyleWidget(
                                  title: "Rating",
                                  color: color.primary,
                                  size: AppSizes.cardTitle,
                                ),

                                SizedBox(height: AppSizes.appbarGap),

                                CustomDropdown(
                                  items: ratingItems,
                                  initialValue: selectedRating,
                                  width: 100.w,
                                  height: 4.5.h,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRating = value.toString();
                                    });

                                    debugPrint(
                                      "Selected rating: $_getRatingValue()",
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSizes.itemGap),

                      // =================================================
                      // Message
                      // =================================================
                      TextBodyStyleWidget(
                        title: "Testimonial Message*",
                        color: color.primary,
                        size: AppSizes.cardTitle,
                      ),

                      SizedBox(height: AppSizes.appbarGap),

                      CustomTextFieldWidget(
                        hintText: "Write testimonial message...",
                        minLines: 5,
                        maxLines: 5,
                        controller: messageController,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSizes.sectionGap),

                // ==================================================
                // Buttons
                // ==================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // =========================
                    // Cancel
                    // =========================
                    CustomButton(
                      text: "Cancel",
                      width: 30.w,
                      backgroundColor: color.cardBackground,
                      foregroundColor: color.primary,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),

                    SizedBox(width: AppSizes.appbarGap),

                    // =========================
                    // Add Testimonial
                    // =========================
                    Flexible(
                      child: CustomButton(
                        text: isSaving ? "Saving..." : "Add Testimonial",
                        onTap: isSaving ? () {} : _handleSaveTestimonial,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSizes.sectionGap),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
