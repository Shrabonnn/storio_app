import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../data/model/Content/testimonial/testimonial_model.dart';
import '../../routes/routes_name.dart';
import '../../utils/app_sizes.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/testimonial_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_text_field.dart';

class EditTestimonial extends StatefulWidget {
  const EditTestimonial({super.key, required this.testimonial});

  final TestimonialModel testimonial;

  @override
  State<EditTestimonial> createState() => _EditTestimonialState();
}

class _EditTestimonialState extends State<EditTestimonial> {
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
  String selectedStatus = "Draft";

  int? selectedPhotoId;
  String? selectedPhotoUrl;

  bool isSaving = false;

  // Get Rating Label


  String _getRatingLabel(int? ratingValue) {
    switch (ratingValue) {
      case 5:
        return "5 Star";
      case 4:
        return "4 Star";
      case 3:
        return "3 Star";
      case 2:
        return "2 Star";
      case 1:
        return "1 Star";
      default:
        return "5 Star";
    }
  }


  // Get Rating Value


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


  // Get Status Label


  String _getStatusLabel(String? statusValue) {
    switch (statusValue) {
      case "active":
        return "Active";
      case "inactive":
        return "InActive";
      case "draft":
        return "Draft";
      default:
        return "Draft";
    }
  }


  // Get Status Value


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


  // Open Media Manage


  Future<void> _openMediaManage() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
      arguments: {
        "currentId": selectedPhotoId,
        "currentFileUrl": selectedPhotoUrl,
      },
    );

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        selectedPhotoId = result['id'] as int?;
        selectedPhotoUrl = result['file'] as String?;
      });
    }
  }


  // Update Testimonial


  Future<void>  _handleUpdateTestimonial() async {
    if (nameController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter testimonial name");
      return;
    }

    if (messageController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter testimonial message");
      return;
    }

    if (selectedStatus.isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please select testimonial status");
      return;
    }

    if (widget.testimonial.id == null) {
      SnackBarMessage.showSnackBar(context, "Testimonial ID not found");
      return;
    }

    final viewModel = context.read<TestimonialViewModel>();

    setState(() {
      isSaving = true;
    });

    final success = await viewModel.updateTestimonial(widget.testimonial.id!, {
      "name": nameController.text.trim(),
      "designation": designationController.text.trim().isEmpty
          ? null
          : designationController.text.trim(),
      "organization": organizationController.text.trim().isEmpty
          ? null
          : organizationController.text.trim(),
      "message": messageController.text.trim(),
      "rating": _getRatingValue(),
      "photo": selectedPhotoId,
      "status": _getStatusValue(),
    });

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      SnackBarMessage.showSnackBar(context, "Testimonial updated successfully");

      Navigator.pop(context, true);
    } else {
      SnackBarMessage.showSnackBar(
        context,
        viewModel.errorMessage ?? "Failed to update testimonial",
      );
    }
  }



  @override
  void initState() {
    super.initState();

    // Existing testimonial data
    nameController.text = widget.testimonial.name ?? "";

    designationController.text = widget.testimonial.designation ?? "";

    organizationController.text = widget.testimonial.organization ?? "";

    messageController.text = widget.testimonial.message ?? "";

    selectedRating = _getRatingLabel(widget.testimonial.rating);

    selectedStatus = _getStatusLabel(widget.testimonial.status);

    // Existing photo
    selectedPhotoId = widget.testimonial.photo;

    selectedPhotoUrl = widget.testimonial.photoData?.fileUrl;
  }




  @override
  void dispose() {
    nameController.dispose();
    designationController.dispose();
    organizationController.dispose();
    messageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: "Edit Testimonial", showBackButton: true),

          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [

                    // Testimonial Information

                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Image

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
                                child: ClipOval(child: _buildProfileImage()),
                              ),
                            ),
                          ),

                          SizedBox(height: AppSizes.itemGap),

                          Center(
                            child: CustomButton(
                              height: 4.h,
                              width: 35.w,
                              text: "Change Photo",
                              onTap: _openMediaManage,
                            ),
                          ),

                          SizedBox(height: AppSizes.sectionGap),


                          // Name

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


                          // Designation

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


                          // Organization

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


                          // Status + Rating

                          Row(
                            children: [

                              // Status

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
                                          "Selected status: ${_getStatusValue()}",
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: AppSizes.appbarGap),


                              // Rating

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
                                          "Selected rating: ${_getRatingValue()}",
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: AppSizes.itemGap),


                          // Message

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


                    // Buttons

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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

                        Flexible(
                          child: CustomButton(
                            text: isSaving ? "Updating..." : "Edit Testimonial",
                            onTap: isSaving ? null : _handleUpdateTestimonial,
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
        ],
      ),
    );
  }


  // Profile Image


  Widget _buildProfileImage() {
    if (selectedPhotoUrl != null && selectedPhotoUrl!.isNotEmpty) {
      return Image.network(
        selectedPhotoUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset("assets/images/person.png", fit: BoxFit.cover);
        },
      );
    }

    return Image.asset("assets/images/person.png", fit: BoxFit.cover);
  }
}
