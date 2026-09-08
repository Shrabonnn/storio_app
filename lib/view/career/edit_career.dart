import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/custom_drop_down.dart';

import '../../data/model/Content/career/career_model.dart';
import '../../routes/routes_name.dart';
import '../../utils/app_sizes.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/career_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/quill/editor_icon.dart';
import '../../widget/quill/editor_option.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_text_field.dart';
import '../../widget/universal/status_button_row.dart';

class EditJobCircular extends StatefulWidget {
  const EditJobCircular({super.key, required this.job});
  final CareerModel job;

  @override
  State<EditJobCircular> createState() => _EditJobCircularState();
}

class _EditJobCircularState extends State<EditJobCircular> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController vacancyCountController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController applicationMethodController = TextEditingController();

  final List<String> applicationMethod = ["Link", "Email"];
  int selectedMethod = 0;

  String? selectedJobType;
  String? selectedStatusValue;

  String jobDescription = "";

  File? selectedImage;
  String? selectedImageUrl;
  int? selectedAttachmentId;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    titleController.text = widget.job.title ?? '';
    companyNameController.text = widget.job.companyName ?? '';
    locationController.text = widget.job.location ?? '';
    vacancyCountController.text = widget.job.vacancy?.toString() ?? '';
    jobDescription = widget.job.description ?? '';
    selectedJobType = widget.job.jobType;
    selectedStatusValue = widget.job.status;

    if (widget.job.deadline != null) {
      deadlineController.text = DateFormat('MM/dd/yy').format(widget.job.deadline!);
    }

    final link = widget.job.applicationLink;
    if (link != null && link.isNotEmpty) {
      if (link.startsWith('mailto:')) {
        selectedMethod = 1;
        applicationMethodController.text = link.replaceFirst('mailto:', '');
      } else {
        selectedMethod = 0;
        applicationMethodController.text = link;
      }
    }

    if (widget.job.attachmentsData != null && widget.job.attachmentsData!.isNotEmpty) {
      selectedAttachmentId = widget.job.attachmentsData!.first.id;
      selectedImageUrl = widget.job.attachmentsData!.first.url;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<CareerViewModel>().getStatusChoices();
      context.read<CareerViewModel>().getTypeChoices();
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    companyNameController.dispose();
    locationController.dispose();
    vacancyCountController.dispose();
    deadlineController.dispose();
    applicationMethodController.dispose();
    super.dispose();
  }

  // ============================================================
  // Open Content Details
  // ============================================================
  Future<void> _openContentDetails() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.content_details,
      arguments: {
        "content": jobDescription,
      },
    );

    if (!mounted) return;

    if (result is String) {
      setState(() {
        jobDescription = result;
      });
    }
  }

  // ============================================================
  // Open Media Manage Details
  // ============================================================
  Future<void> _openMediaManage() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
      arguments: {
        "currentId": selectedAttachmentId,
        "currentFileUrl": selectedImageUrl,
      },
    );

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        selectedAttachmentId = result['id'] as int?;
        selectedImageUrl = result['file'] as String?;
        if (selectedImageUrl == null && result['localPath'] != null) {
          selectedImage = File(result['localPath']);
        } else {
          selectedImage = null;
        }
      });
    }
  }

  String? _getDeadlineIso() {
    final text = deadlineController.text.trim();

    if (text.isEmpty) return null;

    try {
      final parsed = DateFormat('dd MMM yyyy').parse(text);
      return DateFormat('yyyy-MM-dd').format(parsed);
    } catch (e) {
      return null;
    }
  }

  // ============================================================
  // Update Job
  // ============================================================
  Future<void> _handleUpdateJob() async {
    if (widget.job.id == null) {
      SnackBarMessage.showSnackBar(context, "Job ID not found");
      return;
    }

    if (titleController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter job title");
      return;
    }

    if (jobDescription.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter job description");
      return;
    }

    final deadlineIso = _getDeadlineIso();

    if (deadlineIso == null) {
      SnackBarMessage.showSnackBar(context, "Please select a valid application deadline");
      return;
    }

    final viewModel = context.read<CareerViewModel>();

    setState(() {
      isSaving = true;
    });

    String? applicationLink;
    final methodText = applicationMethodController.text.trim();
    if (methodText.isNotEmpty) {
      applicationLink = selectedMethod == 1 ? "mailto:$methodText" : methodText;
    }

    final data = <String, dynamic>{
      "title": titleController.text.trim(),
      "description": jobDescription.trim(),
      "deadline": deadlineIso,
      "status": selectedStatusValue ?? widget.job.status ?? "draft",
      "company_name": companyNameController.text.trim(),
      "location": locationController.text.trim(),
      "vacancy": int.tryParse(vacancyCountController.text.trim()) ?? widget.job.vacancy ?? 1,
    };

    if (selectedJobType != null) {
      data["job_type"] = selectedJobType;
    }
    if (applicationLink != null && applicationLink.isNotEmpty) {
      data["application_link"] = applicationLink;
    }
    if (selectedAttachmentId != null) {
      data["attachment_ids"] = [selectedAttachmentId];
    }

    final updated = await viewModel.updateJob(widget.job.id!, data);

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (updated != null) {
      SnackBarMessage.showSnackBar(context, "Job circular updated successfully");
      Navigator.pop(context, true);
    } else {
      SnackBarMessage.showSnackBar(context, viewModel.errorMessage ?? "Failed to update job circular");
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Edit Job Circular",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBodyStyleWidget(title: "Job Details", color: color.primary, size: AppSizes.screenTitle),
                          SizedBox(height: AppSizes.smallGap),

                          TextBodyStyleWidget(title: "Job Title*", color: color.primary, size: AppSizes.sectionTitle),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(hintText: "Job Title", controller: titleController),
                          SizedBox(height: AppSizes.itemGap),

                          TextBodyStyleWidget(title: "Company Name", color: color.primary, size: AppSizes.sectionTitle),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(hintText: "e.g. Brainicon Technology", controller: companyNameController),
                          SizedBox(height: AppSizes.itemGap),

                          TextBodyStyleWidget(title: "Location", color: color.primary, size: AppSizes.sectionTitle),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(hintText: "e.g. Dhaka", controller: locationController),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap),

                    // Attachment
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextBodyStyleWidget(title: "Attachment", color: color.primary, size: AppSizes.sectionTitle),
                              SizedBox(width: AppSizes.appbarGap),
                              CustomButton(
                                height: 4.h,
                                width: 30.w,
                                text: "Change Image",
                                onTap: _openMediaManage,
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          Container(
                            width: 100.w,
                            height: 20.h,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppSizes.cardRadius)),
                            clipBehavior: Clip.antiAlias,
                            child: selectedImage != null
                                ? Image.file(selectedImage!, fit: BoxFit.fitWidth)
                                : selectedImageUrl != null
                                ? Image.network(
                              selectedImageUrl!,
                              fit: BoxFit.fitWidth,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset('assets/images/institute.png', fit: BoxFit.fitWidth),
                            )
                                : Image.asset('assets/images/institute.png', fit: BoxFit.fitWidth),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap),

                    // Content / Description
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBodyStyleWidget(title: "Description*", color: color.primary, size: AppSizes.sectionTitle),
                          SizedBox(height: AppSizes.appbarGap),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: AppSizes.smallPadding, vertical: 8),
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
                                  const Text("x²", style: TextStyle(fontSize: 14, color: Colors.black87)),
                                  SizedBox(width: 6),
                                  Container(width: 1, height: 25, color: Colors.grey.shade300),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: AppSizes.appbarGap),
                          Divider(height: 1, color: Colors.grey.shade300),
                          SizedBox(height: AppSizes.appbarGap),

                          GestureDetector(
                            onTap: _openContentDetails,
                            child: Padding(
                              padding: EdgeInsets.all(AppSizes.smallPadding),
                              child: TextBodyStyleWidget(
                                title: jobDescription.isEmpty ? "Write content here..." : jobDescription,
                                size: AppSizes.cardTitle,
                                maxLines: 5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap),

                    // Configuration
                    CustomCard(
                      child: Consumer<CareerViewModel>(
                        builder: (context, provider, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextBodyStyleWidget(title: "Configuration", color: color.primary, size: AppSizes.screenTitle),
                              SizedBox(height: AppSizes.smallGap),

                              TextBodyStyleWidget(title: "Employment Type", color: color.primary, size: AppSizes.sectionTitle),
                              SizedBox(height: AppSizes.appbarGap),
                              if (provider.typeLoading)
                                const Center(child: CircularProgressIndicator())
                              else if (provider.typeChoices.isEmpty)
                                TextBodyStyleWidget(title: "No job types available", size: AppSizes.cardTitle)
                              else
                                CustomDropdown(
                                  width: 100.w,
                                  items: provider.typeChoices.map((e) => e.label).toList(),
                                  initialValue: (selectedJobType != null &&
                                      provider.typeChoices.any((e) => e.value == selectedJobType))
                                      ? provider.typeChoices.firstWhere((e) => e.value == selectedJobType).label
                                      : provider.typeChoices.first.label,
                                  onChanged: (value) {
                                    final match = provider.typeChoices.firstWhere((e) => e.label == value);
                                    setState(() {
                                      selectedJobType = match.value;
                                    });
                                  },
                                ),
                              SizedBox(height: AppSizes.itemGap),

                              TextBodyStyleWidget(title: "Status", color: color.primary, size: AppSizes.sectionTitle),
                              SizedBox(height: AppSizes.appbarGap),
                              if (provider.statusLoading)
                                const Center(child: CircularProgressIndicator())
                              else if (provider.statusChoices.isEmpty)
                                TextBodyStyleWidget(title: "No status available", size: AppSizes.cardTitle)
                              else
                                CustomDropdown(
                                  width: 100.w,
                                  items: provider.statusChoices.map((e) => e.label).toList(),
                                  initialValue: (selectedStatusValue != null &&
                                      provider.statusChoices.any((e) => e.value == selectedStatusValue))
                                      ? provider.statusChoices.firstWhere((e) => e.value == selectedStatusValue).label
                                      : provider.statusChoices.first.label,
                                  onChanged: (value) {
                                    final match = provider.statusChoices.firstWhere((e) => e.label == value);
                                    setState(() {
                                      selectedStatusValue = match.value;
                                    });
                                  },
                                ),
                              SizedBox(height: AppSizes.itemGap),

                              TextBodyStyleWidget(title: "Vacancy Count", color: color.primary, size: AppSizes.sectionTitle),
                              SizedBox(height: AppSizes.appbarGap),
                              CustomTextFieldWidget(hintText: "1", controller: vacancyCountController),
                              SizedBox(height: AppSizes.itemGap),

                              TextBodyStyleWidget(title: "Application Deadline*", color: color.primary, size: AppSizes.sectionTitle),
                              SizedBox(height: AppSizes.appbarGap),
                              CustomTextFieldWidget(
                                hintText: "mm/dd/yy",
                                controller: deadlineController,
                                isDatePicker: true,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap),

                    // Application Method
                    CustomCard(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              TextBodyStyleWidget(title: "Application Method", color: color.primary, size: AppSizes.sectionTitle),
                              SizedBox(width: AppSizes.sectionGap),
                              Flexible(
                                child: StatusButtonRow(
                                  items: applicationMethod,
                                  selectedIndex: selectedMethod,
                                  onSelected: (index) {
                                    setState(() {
                                      selectedMethod = index;
                                    });
                                  },
                                  onTap: (status) {},
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          if (selectedMethod == 0)
                            CustomTextFieldWidget(hintText: "https://forms.gle/...", controller: applicationMethodController),
                          if (selectedMethod == 1)
                            CustomTextFieldWidget(hintText: "hr@company.com", controller: applicationMethodController),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          text: "Cancel",
                          onTap: isSaving ? null : () => Navigator.pop(context),
                          width: 30.w,
                          backgroundColor: color.cardBackground,
                          foregroundColor: color.primary,
                        ),
                        SizedBox(width: AppSizes.appbarGap),
                        Flexible(
                          child: CustomButton(
                            text: isSaving ? "Updating..." : "Save",
                            onTap: isSaving ? null : _handleUpdateJob,
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
}