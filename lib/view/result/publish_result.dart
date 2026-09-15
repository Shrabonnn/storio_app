import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/universal/custom_card2.dart';

import '../../utils/app_sizes.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/exam_result_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_text_field.dart';
import '../../widget/universal/status_button_row.dart';

class PublishResult extends StatefulWidget {
  const PublishResult({
    super.key,
    this.defaultExamType,
  });

  final String? defaultExamType;

  @override
  State<PublishResult> createState() => _PublishResultState();
}

class _PublishResultState extends State<PublishResult> {
  final TextEditingController examNameController = TextEditingController();
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController academicYearController = TextEditingController();
  final TextEditingController totalExamineesController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController failController = TextEditingController();
  final TextEditingController aplusController = TextEditingController();
  final TextEditingController agradeController = TextEditingController();

  // Selected file/image states
  String? selectedFilePath;
  String? selectedFileName;

  final List<Map<String, String>> examTypeTabs = const [
    {"label": "School Result", "value": "school"},
    {"label": "Public Result", "value": "public"},
    {"label": "Admission Result", "value": "admission"},
  ];

  int selectedStatus = 0;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    if (widget.defaultExamType != null) {
      final index = examTypeTabs.indexWhere(
            (e) => e['value'] == widget.defaultExamType,
      );
      if (index != -1) {
        selectedStatus = index;
      }
    }

    // Auto calculate Fail count when Total or Passed changes
    totalExamineesController.addListener(_updateFailCount);
    passController.addListener(_updateFailCount);
  }

  void _updateFailCount() {
    final totalText = totalExamineesController.text.trim();
    final passText = passController.text.trim();

    if (totalText.isEmpty) {
      if (failController.text.isNotEmpty) {
        failController.text = "";
      }
      return;
    }

    final total = int.tryParse(totalText) ?? 0;
    final pass = int.tryParse(passText) ?? 0;

    int fail = total - pass;
    if (fail < 0) {
      fail = 0;
    }

    final calculatedFailStr = fail.toString();
    if (failController.text != calculatedFailStr) {
      failController.text = calculatedFailStr;
    }
  }

  @override
  void dispose() {
    totalExamineesController.removeListener(_updateFailCount);
    passController.removeListener(_updateFailCount);
    examNameController.dispose();
    classNameController.dispose();
    academicYearController.dispose();
    totalExamineesController.dispose();
    passController.dispose();
    failController.dispose();
    aplusController.dispose();
    agradeController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    SnackBarMessage.showSnackBar(context, message);
  }

  // File Picker Method
  Future<void> _pickFile() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
    );

    if (result != null && result is String) {
      setState(() {
        selectedFilePath = result;
        selectedFileName = result.split('/').last;
      });
    }
  }

  // Remove Selected File
  void _removeFile() {
    setState(() {
      selectedFilePath = null;
      selectedFileName = null;
    });
  }

  // ============================================================
  // Save (Create) Result with Validation
  // ============================================================

  Future<void> _handleSave() async {
    if (examNameController.text.trim().isEmpty) {
      _showMessage("Please enter exam name");
      return;
    }

    if (academicYearController.text.trim().isEmpty) {
      _showMessage("Please enter academic year");
      return;
    }

    if (totalExamineesController.text.trim().isEmpty) {
      _showMessage("Please enter total examinees");
      return;
    }

    final totalExaminees = int.tryParse(totalExamineesController.text.trim()) ?? 0;
    final passed = int.tryParse(passController.text.trim()) ?? 0;
    final failed = int.tryParse(failController.text.trim()) ?? 0;

    // 1. Pass cannot be greater than Total examinees
    if (passed > totalExaminees) {
      _showMessage("Passed examinees ($passed) cannot exceed total examinees ($totalExaminees)");
      return;
    }

    // 2. Public Result Grade Validations
    if (selectedStatus == 1) {
      final aplus = int.tryParse(aplusController.text.trim()) ?? 0;
      final agrade = int.tryParse(agradeController.text.trim()) ?? 0;

      // A+ cannot exceed total passed
      if (aplus > passed) {
        _showMessage("GPA A+ recipients ($aplus) cannot exceed total passed examinees ($passed)");
        return;
      }

      // A+ and A combined cannot exceed total passed
      if ((aplus + agrade) > passed) {
        final maxAgradeAllowed = passed - aplus;
        _showMessage(
          "GPA A recipients cannot exceed $maxAgradeAllowed (Passed: $passed, A+: $aplus)",
        );
        return;
      }
    }

    final viewModel = context.read<ExamResultViewModel>();

    setState(() {
      isSaving = true;
    });

    final Map<String, dynamic> data = {
      "exam_type": examTypeTabs[selectedStatus]['value'],
      "exam_name": examNameController.text.trim(),
      "year": academicYearController.text.trim(),
      "total_examinees": totalExaminees,
      "passed": passed,
      "failed": failed,
      "file_url": selectedFilePath ?? "",
    };

    if (classNameController.text.trim().isNotEmpty) {
      data["class_name"] = classNameController.text.trim();
    }

    if (selectedStatus == 1) {
      data["aplus_count"] = int.tryParse(aplusController.text.trim()) ?? 0;
      data["agrade_count"] = int.tryParse(agradeController.text.trim()) ?? 0;
    }

    final success = await viewModel.createExamResult(data);

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      _showMessage("Result published successfully");
      Navigator.pop(context, true);
    } else {
      _showMessage(viewModel.errorMessage ?? "Failed to publish result");
    }
  }

  // Reusable File Picker UI Section
  Widget _buildFilePickerSection(dynamic color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.file_copy_outlined,
              size: AppSizes.icon,
              color: color.primary,
            ),
            SizedBox(width: AppSizes.appbarGap),
            TextBodyStyleWidget(
              title: "Result Sheet (PDF / Image)",
              color: color.primary,
              size: AppSizes.cardTitle,
            ),
          ],
        ),
        SizedBox(height: AppSizes.appbarGap),
        if (selectedFilePath == null)
          GestureDetector(
            onTap: _pickFile,
            child: CustomCard2(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: TextBodyStyleWidget(
                    title: "Browse File",
                    size: AppSizes.cardTitle,
                  ),
                ),
              ),
            ),
          )
        else
          CustomCard2(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  Icon(
                    selectedFileName?.toLowerCase().endsWith('.pdf') == true
                        ? Icons.picture_as_pdf
                        : Icons.insert_drive_file,
                    color: color.primary,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextBodyStyleWidget(
                      title: selectedFileName ?? "Selected File",
                      size: AppSizes.cardTitle,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: _removeFile,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Publish Results",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: [
                      StatusButtonRow(
                        items: examTypeTabs.map((e) => e['label']!).toList(),
                        selectedIndex: selectedStatus,
                        onSelected: (index) {
                          setState(() {
                            selectedStatus = index;
                          });
                        },
                        onTap: (status) {},
                      ),
                      SizedBox(height: AppSizes.sectionGap),
                    ],
                  ),

                  // School Result
                  if (selectedStatus == 0)
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextTitleWidget(
                            title: "Publish New Result",
                            color: color.primary,
                          ),
                          TextBodyStyleWidget(title: "School Level"),
                          Divider(
                            color: color.lightVersionOfPrimaryLightVersion,
                            height: 1,
                          ),
                          SizedBox(height: AppSizes.smallGap),
                          TextBodyStyleWidget(
                            title: "Exam Name",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "e.g. Annual Exam",
                            controller: examNameController,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          TextBodyStyleWidget(
                            title: "Class Name",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "e.g. Class Ten",
                            controller: classNameController,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          TextBodyStyleWidget(
                            title: "Academic Year",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "2026",
                            controller: academicYearController,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          TextBodyStyleWidget(
                            title: "Total Examinees",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "100",
                            controller: totalExamineesController,
                            isInputOnlyNumber: true,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          Row(
                            children: [
                              Flexible(
                                child: Column(
                                  children: [
                                    TextBodyStyleWidget(
                                      title: "Passed",
                                      color: color.primary,
                                      size: AppSizes.cardTitle,
                                    ),
                                    SizedBox(height: AppSizes.appbarGap),
                                    CustomTextFieldWidget(
                                      hintText: "70",
                                      controller: passController,
                                      isInputOnlyNumber: true,
                                    ),
                                    SizedBox(height: AppSizes.itemGap),
                                  ],
                                ),
                              ),
                              SizedBox(width: AppSizes.smallGap),
                              Flexible(
                                child: Column(
                                  children: [
                                    TextBodyStyleWidget(
                                      title: "Failed (Auto)",
                                      color: color.primary,
                                      size: AppSizes.cardTitle,
                                    ),
                                    SizedBox(height: AppSizes.appbarGap),
                                    CustomTextFieldWidget(
                                      hintText: "30",
                                      controller: failController,
                                      isInputOnlyNumber: true,
                                    ),
                                    SizedBox(height: AppSizes.itemGap),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          _buildFilePickerSection(color),
                        ],
                      ),
                    ),

                  // Public Result
                  if (selectedStatus == 1)
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextTitleWidget(
                            title: "Publish New Result",
                            color: color.primary,
                          ),
                          TextBodyStyleWidget(title: "Public Level"),
                          Divider(
                            color: color.lightVersionOfPrimaryLightVersion,
                            height: 1,
                          ),
                          SizedBox(height: AppSizes.smallGap),
                          TextBodyStyleWidget(
                            title: "Exam Name",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "e.g. S.S.C H.S.C",
                            controller: examNameController,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          TextBodyStyleWidget(
                            title: "Academic Year",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "2026",
                            controller: academicYearController,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          TextBodyStyleWidget(
                            title: "Total Examinees",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "100",
                            controller: totalExamineesController,
                            isInputOnlyNumber: true,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          Row(
                            children: [
                              Flexible(
                                child: Column(
                                  children: [
                                    TextBodyStyleWidget(
                                      title: "Passed",
                                      color: color.primary,
                                      size: AppSizes.cardTitle,
                                    ),
                                    SizedBox(height: AppSizes.appbarGap),
                                    CustomTextFieldWidget(
                                      hintText: "70",
                                      controller: passController,
                                      isInputOnlyNumber: true,
                                    ),
                                    SizedBox(height: AppSizes.itemGap),
                                  ],
                                ),
                              ),
                              SizedBox(width: AppSizes.smallGap),
                              Flexible(
                                child: Column(
                                  children: [
                                    TextBodyStyleWidget(
                                      title: "Failed (Auto)",
                                      color: color.primary,
                                      size: AppSizes.cardTitle,
                                    ),
                                    SizedBox(height: AppSizes.appbarGap),
                                    CustomTextFieldWidget(
                                      hintText: "30",
                                      controller: failController,
                                      isInputOnlyNumber: true,
                                    ),
                                    SizedBox(height: AppSizes.itemGap),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          TextBodyStyleWidget(
                            title: "GPA A+ Recipients",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "0",
                            controller: aplusController,
                            isInputOnlyNumber: true,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          TextBodyStyleWidget(
                            title: "GPA A Recipients",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "0",
                            controller: agradeController,
                            isInputOnlyNumber: true,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          _buildFilePickerSection(color),
                        ],
                      ),
                    ),

                  // Admission Result
                  if (selectedStatus == 2)
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextTitleWidget(
                            title: "Publish New Result",
                            color: color.primary,
                          ),
                          TextBodyStyleWidget(title: "Admission Level"),
                          Divider(
                            color: color.lightVersionOfPrimaryLightVersion,
                            height: 1,
                          ),
                          SizedBox(height: AppSizes.smallGap),
                          TextBodyStyleWidget(
                            title: "Exam Name",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "e.g. Admission Test 2024",
                            controller: examNameController,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          TextBodyStyleWidget(
                            title: "Program/Class",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "e.g. Class Ten",
                            controller: classNameController,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          TextBodyStyleWidget(
                            title: "Academic Year",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "2026",
                            controller: academicYearController,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          TextBodyStyleWidget(
                            title: "Total Examinees",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "100",
                            controller: totalExamineesController,
                            isInputOnlyNumber: true,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          Row(
                            children: [
                              Flexible(
                                child: Column(
                                  children: [
                                    TextBodyStyleWidget(
                                      title: "Passed",
                                      color: color.primary,
                                      size: AppSizes.cardTitle,
                                    ),
                                    SizedBox(height: AppSizes.appbarGap),
                                    CustomTextFieldWidget(
                                      hintText: "70",
                                      controller: passController,
                                      isInputOnlyNumber: true,
                                    ),
                                    SizedBox(height: AppSizes.itemGap),
                                  ],
                                ),
                              ),
                              SizedBox(width: AppSizes.smallGap),
                              Flexible(
                                child: Column(
                                  children: [
                                    TextBodyStyleWidget(
                                      title: "Failed (Auto)",
                                      color: color.primary,
                                      size: AppSizes.cardTitle,
                                    ),
                                    SizedBox(height: AppSizes.appbarGap),
                                    CustomTextFieldWidget(
                                      hintText: "30",
                                      controller: failController,
                                      isInputOnlyNumber: true,
                                    ),
                                    SizedBox(height: AppSizes.itemGap),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          _buildFilePickerSection(color),
                        ],
                      ),
                    ),

                  SizedBox(height: AppSizes.sectionGap),

                  // Bottom Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: "Publish Result",
                          onTap: isSaving ? null : _handleSave,
                        ),
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
}