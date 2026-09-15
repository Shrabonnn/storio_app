import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/data/model/Content/result/exam_result_model.dart';
import 'package:storio_app/utils/snackbar_message.dart';
import 'package:storio_app/viewModel/Content/exam_result_view_model.dart';

import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_text_field.dart';
import '../../widget/universal/file_picker.dart';

class EditResult extends StatefulWidget {
  const EditResult({super.key, required this.examResult});
  final ExamResultModel examResult;

  @override
  State<EditResult> createState() => _EditResultState();
}

class _EditResultState extends State<EditResult> {
  final TextEditingController examNameController = TextEditingController();
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController academicaYearController = TextEditingController();
  final TextEditingController totalExaminessController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController failController = TextEditingController();
  final TextEditingController aplusController = TextEditingController();
  final TextEditingController agradeController = TextEditingController();

  File? selectedFile;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _populateExistingData();

    // Auto calculate Fail count when Total or Passed changes
    totalExaminessController.addListener(_updateFailCount);
    passController.addListener(_updateFailCount);
  }

  void _populateExistingData() {
    final result = widget.examResult;
    examNameController.text = result.examName ?? '';
    classNameController.text = result.className ?? '';
    academicaYearController.text = result.year ?? '';
    totalExaminessController.text = result.totalExaminees?.toString() ?? '';
    passController.text = result.passed?.toString() ?? '';
    failController.text = result.failed?.toString() ?? '';
    aplusController.text = result.aplusCount?.toString() ?? '';
    agradeController.text = result.agradeCount?.toString() ?? '';
  }

  // Auto calculate Fail count logic
  void _updateFailCount() {
    final totalText = totalExaminessController.text.trim();
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
    totalExaminessController.removeListener(_updateFailCount);
    passController.removeListener(_updateFailCount);
    examNameController.dispose();
    classNameController.dispose();
    academicaYearController.dispose();
    totalExaminessController.dispose();
    passController.dispose();
    failController.dispose();
    aplusController.dispose();
    agradeController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdateResult() async {
    // ---------------------------------------------------------
    // 1. Mandatory Input Validations
    // ---------------------------------------------------------
    if (examNameController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter exam name");
      return;
    }

    if (academicaYearController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter academic year");
      return;
    }

    if (totalExaminessController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter total examinees");
      return;
    }

    if (widget.examResult.id == null) {
      SnackBarMessage.showSnackBar(context, "Exam result ID not found");
      return;
    }

    final totalExaminees = int.tryParse(totalExaminessController.text.trim()) ?? 0;
    final passed = int.tryParse(passController.text.trim()) ?? 0;
    final failed = int.tryParse(failController.text.trim()) ?? 0;
    final examType = widget.examResult.examType ?? 'school';

    // ---------------------------------------------------------
    // 2. Pass cannot exceed Total examinees Validation
    // ---------------------------------------------------------
    if (passed > totalExaminees) {
      SnackBarMessage.showSnackBar(
        context,
        "Passed examinees ($passed) cannot exceed total examinees ($totalExaminees)",
      );
      return;
    }

    // ---------------------------------------------------------
    // 3. Public Result GPA Validations
    // ---------------------------------------------------------
    if (examType == 'public') {
      final aplus = int.tryParse(aplusController.text.trim()) ?? 0;
      final agrade = int.tryParse(agradeController.text.trim()) ?? 0;

      // A+ cannot exceed total passed
      if (aplus > passed) {
        SnackBarMessage.showSnackBar(
          context,
          "GPA A+ recipients ($aplus) cannot exceed total passed examinees ($passed)",
        );
        return;
      }

      // A+ and A combined cannot exceed total passed
      if ((aplus + agrade) > passed) {
        final maxAgradeAllowed = passed - aplus;
        SnackBarMessage.showSnackBar(
          context,
          "GPA A recipients cannot exceed $maxAgradeAllowed (Passed: $passed, A+: $aplus)",
        );
        return;
      }
    }

    setState(() {
      isSaving = true;
    });

    final viewModel = context.read<ExamResultViewModel>();

    final data = <String, dynamic>{
      "exam_type": examType,
      "exam_name": examNameController.text.trim(),
      "class_name": classNameController.text.trim(),
      "year": academicaYearController.text.trim(),
      "total_examinees": totalExaminees,
      "passed": passed,
      "failed": failed,
    };

    if (examType == 'public') {
      data["aplus_count"] = int.tryParse(aplusController.text.trim()) ?? 0;
      data["agrade_count"] = int.tryParse(agradeController.text.trim()) ?? 0;
    }

    final success = await viewModel.updateExamResult(
      widget.examResult.id!,
      data,
    );

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      SnackBarMessage.showSnackBar(context, "Exam result updated successfully");
      Navigator.pop(context, true);
    } else {
      SnackBarMessage.showSnackBar(
        context,
        viewModel.errorMessage ?? "Failed to update exam result",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    final examType = widget.examResult.examType ?? 'school';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBar(
            title: "Edit Result",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // School Result Edit Form
                if (examType == 'school')
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextTitleWidget(
                          title: "Edit School Result",
                          color: color.primary,
                        ),
                        const TextBodyStyleWidget(title: "School Level"),
                        Divider(
                          color: color.lightVersionOfPrimaryLightVersion,
                          height: 1,
                        ),
                        SizedBox(height: AppSizes.smallGap),

                        TextBodyStyleWidget(title: "Exam Name", color: color.primary, size: AppSizes.cardTitle),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "e.g. Annual Exam", controller: examNameController),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Class Name", color: color.primary, size: AppSizes.cardTitle),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "e.g. Class Ten", controller: classNameController),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Academic Year", color: color.primary, size: AppSizes.cardTitle),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "2026", controller: academicaYearController),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Total Examinees", color: color.primary, size: AppSizes.cardTitle),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(
                          hintText: "100",
                          controller: totalExaminessController,
                          isInputOnlyNumber: true,
                        ),
                        SizedBox(height: AppSizes.itemGap),

                        Row(
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextBodyStyleWidget(title: "Passed", color: color.primary, size: AppSizes.cardTitle),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextBodyStyleWidget(title: "Failed (Auto)", color: color.primary, size: AppSizes.cardTitle),
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

                        Row(
                          children: [
                            Icon(Icons.file_copy_outlined, size: AppSizes.icon, color: color.primary),
                            SizedBox(width: AppSizes.appbarGap),
                            TextBodyStyleWidget(title: "Result Sheet (PDF)", color: color.primary, size: AppSizes.cardTitle),
                          ],
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        const FilePickerWidget(),
                      ],
                    ),
                  ),

                // Public Result Edit Form
                if (examType == 'public')
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextTitleWidget(
                          title: "Edit Public Result",
                          color: color.primary,
                        ),
                        const TextBodyStyleWidget(title: "Public Level"),
                        Divider(
                          color: color.lightVersionOfPrimaryLightVersion,
                          height: 1,
                        ),
                        SizedBox(height: AppSizes.smallGap),

                        TextBodyStyleWidget(title: "Exam Name", color: color.primary, size: AppSizes.cardTitle),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "e.g. S.S.C / H.S.C", controller: examNameController),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Academic Year", color: color.primary, size: AppSizes.cardTitle),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "2026", controller: academicaYearController),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Total Examinees", color: color.primary, size: AppSizes.cardTitle),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(
                          hintText: "100",
                          controller: totalExaminessController,
                          isInputOnlyNumber: true,
                        ),
                        SizedBox(height: AppSizes.itemGap),

                        Row(
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextBodyStyleWidget(title: "Passed", color: color.primary, size: AppSizes.cardTitle),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextBodyStyleWidget(title: "Failed (Auto)", color: color.primary, size: AppSizes.cardTitle),
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

                        TextBodyStyleWidget(title: "GPA A+ Recipients", color: color.primary, size: AppSizes.cardTitle),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(
                          hintText: "0",
                          controller: aplusController,
                          isInputOnlyNumber: true,
                        ),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "GPA A Recipients", color: color.primary, size: AppSizes.cardTitle),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(
                          hintText: "0",
                          controller: agradeController,
                          isInputOnlyNumber: true,
                        ),
                        SizedBox(height: AppSizes.itemGap),

                        Row(
                          children: [
                            Icon(Icons.file_copy_outlined, size: AppSizes.icon, color: color.primary),
                            SizedBox(width: AppSizes.appbarGap),
                            TextBodyStyleWidget(title: "Result Sheet (PDF)", color: color.primary, size: AppSizes.cardTitle),
                          ],
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        const FilePickerWidget(),
                      ],
                    ),
                  ),

                // Admission Result Edit Form
                if (examType == 'admission')
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextTitleWidget(
                          title: "Edit Admission Result",
                          color: color.primary,
                        ),
                        const TextBodyStyleWidget(title: "Admission Level"),
                        Divider(
                          color: color.lightVersionOfPrimaryLightVersion,
                          height: 1,
                        ),
                        SizedBox(height: AppSizes.smallGap),

                        TextBodyStyleWidget(title: "Exam Name", color: color.primary, size: AppSizes.cardTitle),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "e.g. Admission Test 2026", controller: examNameController),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Program/Class", color: color.primary, size: AppSizes.cardTitle),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "e.g. Class Ten", controller: classNameController),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Academic Year", color: color.primary, size: AppSizes.cardTitle),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "2026", controller: academicaYearController),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(title: "Total Examinees", color: color.primary, size: AppSizes.cardTitle),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(
                          hintText: "100",
                          controller: totalExaminessController,
                          isInputOnlyNumber: true,
                        ),
                        SizedBox(height: AppSizes.itemGap),

                        Row(
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextBodyStyleWidget(title: "Passed", color: color.primary, size: AppSizes.cardTitle),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextBodyStyleWidget(title: "Failed (Auto)", color: color.primary, size: AppSizes.cardTitle),
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

                        Row(
                          children: [
                            Icon(Icons.file_copy_outlined, size: AppSizes.icon, color: color.primary),
                            SizedBox(width: AppSizes.appbarGap),
                            TextBodyStyleWidget(title: "Result Sheet (PDF)", color: color.primary, size: AppSizes.cardTitle),
                          ],
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        const FilePickerWidget(),
                      ],
                    ),
                  ),

                SizedBox(height: AppSizes.sectionGap),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      text: "Cancel",
                      onTap: () => Navigator.pop(context),
                      width: 30.w,
                      backgroundColor: color.cardBackground,
                      foregroundColor: color.primary,
                    ),
                    SizedBox(width: AppSizes.appbarGap),
                    Flexible(
                      child: CustomButton(
                        text: isSaving ? "Updating..." : "Update Result",
                        onTap: isSaving ? null : _handleUpdateResult,
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(bottom: AppSizes.sectionGap)),
        ],
      ),
    );
  }
}