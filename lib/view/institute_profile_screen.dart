import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/utils/app_sizes.dart';
import 'package:storio_app/utils/snackbar_message.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';
import 'package:storio_app/widget/institute_profile/Institute_overview_screen.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/universal/custom_app_bar.dart';
import 'package:storio_app/widget/universal/custom_text_field.dart';

import '../data/model/form_field/form_feild_data.dart';
import '../data/model/institure/infrastructure_Item_model.dart';
import '../data/model/institure/key_metrics_model.dart';
import '../data/model/institute_profile/institute_profile_model.dart';
import '../utils/theme/theme_ext.dart';
import '../viewModel/Institute_Profile/institute_profile_view_model.dart';
import '../widget/institute_profile/information_row.dart';
import '../widget/institute_profile/infrastructure_drop_down.dart';
import '../widget/textStyle/text_title_style.dart';
import '../widget/universal/custom_card.dart';

class InstituteProfileScreen extends StatefulWidget {
  const InstituteProfileScreen({super.key});

  @override
  State<InstituteProfileScreen> createState() => _InstituteProfileScreenState();
}

class _InstituteProfileScreenState extends State<InstituteProfileScreen> {
  final TextEditingController aboutInstitutionController = TextEditingController();
  final TextEditingController missionController = TextEditingController();
  final TextEditingController visionController = TextEditingController();

  // Media & Image Selection States
  File? selectedImage;
  String? selectedImageUrl;
  int? selectedAttachmentId;

  // Infrastructure controller
  final infrastructuresLabelController = TextEditingController();
  final infrastructuresValueController = TextEditingController();
  List<InfrastructureItemModel> infrastructures = [];

  // Metrics controller
  final metricsLabelController = TextEditingController();
  final metricsValueController = TextEditingController();
  IconData selectedMetricIcon = Icons.people_alt_outlined;
  List<KeyMetricsModel> keyMertics = [];

  // Edit Index Track রাখার জন্য Variable
  int? editingMetricIndex;
  int? editingInfrastructureIndex;

  bool isKeyMetricsExpanded = false;
  bool isinfrastructuresExpanded = false;

  bool isEditing = false;
  bool _isDataPopulated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InstitutionProfileViewModel>().getInstitutionProfile();
    });
  }

  // Media Manage details open call and response handle
  Future<void> _openMediaManage() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
      arguments: {
        "currentId": selectedAttachmentId,
        "currentFileUrl": selectedImageUrl,
      },
    );

    if (!mounted || result == null) return;

    if (result is Map) {
      setState(() {
        // Safe ID parsing
        final rawId = result['id'] ?? result['attachment_id'] ?? result['media_id'];
        if (rawId != null) {
          selectedAttachmentId = int.tryParse(rawId.toString());
        }

        // Safe URL parsing
        final rawUrl = result['file'] ??
            result['url'] ??
            result['image'] ??
            result['image_url'] ??
            result['path'];

        if (rawUrl != null && rawUrl.toString().isNotEmpty) {
          selectedImageUrl = rawUrl.toString();
        }

        // Local File Path check
        if (result['localPath'] != null) {
          selectedImage = File(result['localPath'].toString());
        } else {
          selectedImage = null;
        }
      });
    } else if (result is String) {
      setState(() {
        if (result.startsWith('http://') || result.startsWith('https://')) {
          selectedImageUrl = result;
          selectedImage = null;
        } else {
          selectedImage = File(result);
          selectedImageUrl = null;
        }
      });
    }
  }

  // Populate controllers with fetched API data
  void _populateData(InstitutionProfileModel profile) {
    if (_isDataPopulated) return;

    aboutInstitutionController.text = profile.schoolDetails ?? "";
    missionController.text = profile.mission ?? "";
    visionController.text = profile.vision ?? "";
    selectedImageUrl = profile.institutionImageUrl;

    keyMertics.clear();

    // 1. Fixed Metric: Total Students
    keyMertics.add(
      KeyMetricsModel(
        label: profile.totalStudentsLabel ?? "Total Students",
        value: "${profile.totalStudents ?? 0}",
        iconData: Icons.people_alt_outlined,
        isFixed: true,
      ),
    );

    // 2. Fixed Metric: Total Teachers
    keyMertics.add(
      KeyMetricsModel(
        label: profile.totalTeachersLabel ?? "Total Teachers",
        value: "${profile.totalTeachers ?? 0}",
        iconData: Icons.school_outlined,
        isFixed: true,
      ),
    );

    // 3. Dynamic Key Metrics Array
    if (profile.keyMetrics != null) {
      for (var metric in profile.keyMetrics!) {
        String label = "";
        String value = "";

        if (metric is Map) {
          label = metric['label']?.toString() ?? "";
          value = metric['value']?.toString() ?? "";
        } else {
          label = metric.label ?? "";
          value = metric.value ?? "";
        }

        keyMertics.add(
          KeyMetricsModel(
            label: label,
            value: value,
            iconData: Icons.star_outline,
            isFixed: false,
          ),
        );
      }
    }

    // Populate Infrastructure Data
    if (profile.additionalInfo != null) {
      infrastructures = profile.additionalInfo!
          .map((e) => InfrastructureItemModel(
        label: e.label ?? "",
        value: e.value ?? "",
      ))
          .toList();
    }

    _isDataPopulated = true;
  }

  // Handle Save / Update Action
  Future<void> _handleUpdate(InstitutionProfileViewModel viewModel) async {
    int? totalStudents;
    String? totalStudentsLabel;
    int? totalTeachers;
    String? totalTeachersLabel;

    List<Map<String, dynamic>> dynamicKeyMetricsList = [];

    for (int i = 0; i < keyMertics.length; i++) {
      var metric = keyMertics[i];

      if (metric.isFixed) {
        if (i == 0) {
          totalStudents = int.tryParse(metric.value);
          totalStudentsLabel = metric.label;
        } else if (i == 1) {
          totalTeachers = int.tryParse(metric.value);
          totalTeachersLabel = metric.label;
        }
      } else {
        dynamicKeyMetricsList.add({
          "label": metric.label,
          "value": metric.value,
          "icon": "BookOpen",
        });
      }
    }

    final updateData = {
      "school_details": aboutInstitutionController.text.trim(),
      "mission": missionController.text.trim(),
      "vision": visionController.text.trim(),
      if (selectedAttachmentId != null) "institution_image": selectedAttachmentId,
      if (totalStudents != null) "total_students": totalStudents,
      if (totalStudentsLabel != null) "total_students_label": totalStudentsLabel,
      if (totalTeachers != null) "total_teachers": totalTeachers,
      if (totalTeachersLabel != null) "total_teachers_label": totalTeachersLabel,
      "key_metrics": dynamicKeyMetricsList,
      "additional_info": infrastructures
          .map((item) => {
        "label": item.label,
        "value": item.value,
      })
          .toList(),
    };

    final success = await viewModel.updateInstitutionProfile(updateData, isPatch: true);

    if (mounted) {
      if (success) {
        _isDataPopulated = false;

        SnackBarMessage.showSnackBar(context, "Profile Updated Successfully!");
        setState(() {
          isEditing = false;
        });
      } else {
        SnackBarMessage.showSnackBar(context, "Failed to update profile.");
      }
    }
  }

  @override
  void dispose() {
    aboutInstitutionController.dispose();
    missionController.dispose();
    visionController.dispose();
    infrastructuresLabelController.dispose();
    infrastructuresValueController.dispose();
    metricsLabelController.dispose();
    metricsValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: Consumer<InstitutionProfileViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.loading && viewModel.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = viewModel.profile;

          if (profile != null) {
            _populateData(profile);
          }

          return CustomScrollView(
            slivers: [
              const CustomSliverAppBar(
                title: "Institute Profile",
                subtitle: "Manage your institute information",
              ),
              SliverPadding(
                padding: EdgeInsets.all(AppSizes.screenPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Visual Identity Card
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TextTitleWidget(
                                title: "Visual Identity",
                              ),
                              CustomButton(
                                height: 4.h,
                                width: 28.w,
                                size: AppSizes.cardSubTitle,
                                text: viewModel.isUpdating
                                    ? "Updating..."
                                    : (isEditing ? "Update" : "Edit Profile"),
                                onTap: viewModel.isUpdating
                                    ? null
                                    : () {
                                  if (!isEditing) {
                                    setState(() {
                                      isEditing = true;
                                    });
                                  } else {
                                    _handleUpdate(viewModel);
                                  }
                                },
                                backgroundColor: isEditing
                                    ? color.active
                                    : color.primary,
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.smallGap),

                          // Visual Identity Image Container
                          GestureDetector(
                            onTap: isEditing ? _openMediaManage : null,
                            child: Stack(
                              children: [
                                Container(
                                  width: 100.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                                    color: Colors.grey.shade200,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: selectedImage != null
                                      ? Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  )
                                      : (selectedImageUrl != null && selectedImageUrl!.isNotEmpty)
                                      ? Image.network(
                                    selectedImageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Image.asset(
                                      'assets/images/institute.png',
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : Image.asset(
                                    'assets/images/institute.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                // Edit Overlay on Image
                                if (isEditing)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                                        color: Colors.black.withOpacity(0.35),
                                      ),
                                      child: const Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.camera_alt_outlined,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              "Tap to change image",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.itemGap),

                    // General Information
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextTitleWidget(
                            title: "General Information",
                          ),
                          const Divider(thickness: .6),

                          InfoRow(
                            icon: Icons.badge_outlined,
                            label: "EIIN",
                            value: "${profile?.eiin ?? 'N/A'}",
                          ),
                          const Divider(thickness: .5, height: 1),

                          InfoRow(
                            icon: Icons.miscellaneous_services_outlined,
                            label: "School Code",
                            value: profile?.schoolCode ?? "N/A",
                          ),
                          const Divider(thickness: .5, height: 1),

                          InfoRow(
                            icon: Icons.access_time,
                            label: "Shift",
                            value: profile?.schoolShift ?? "N/A",
                          ),
                          const Divider(thickness: .5, height: 1),

                          InfoRow(
                            icon: Icons.school_outlined,
                            label: "Type",
                            value: profile?.schoolType ?? "N/A",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.itemGap),

                    // Key Metrics Section
                    CustomCard(
                      child: InstituteOverviewScreen(
                        title: "Key Metrics",
                        showIcon: isEditing,
                        userIcon: isKeyMetricsExpanded ? Icons.remove : Icons.add,
                        onTap: isEditing
                            ? () {
                          setState(() {
                            if (!isKeyMetricsExpanded) {
                              editingMetricIndex = null;
                              metricsLabelController.clear();
                              metricsValueController.clear();
                            }
                            isKeyMetricsExpanded = !isKeyMetricsExpanded;
                          });
                        }
                            : null,
                        isExpanded: isKeyMetricsExpanded,
                        expandableChild: InfrastructureDropDown(
                          showIconPicker: true,
                          selectedIcon: selectedMetricIcon,
                          onIconSelected: (icon) {
                            setState(() {
                              selectedMetricIcon = icon;
                            });
                          },
                          fields: [
                            FormFieldData(
                              title: "Metric Label",
                              hint: "e.g. Total Alumni",
                              controller: metricsLabelController,
                            ),
                            FormFieldData(
                              title: "Metric Value",
                              hint: "e.g. 1550",
                              controller: metricsValueController,
                            ),
                          ],
                          onSave: () {
                            if (metricsLabelController.text.trim().isEmpty ||
                                metricsValueController.text.trim().isEmpty) return;

                            setState(() {
                              if (editingMetricIndex != null) {
                                final oldMetric = keyMertics[editingMetricIndex!];
                                keyMertics[editingMetricIndex!] = KeyMetricsModel(
                                  label: metricsLabelController.text.trim(),
                                  value: metricsValueController.text.trim(),
                                  iconData: selectedMetricIcon,
                                  isFixed: oldMetric.isFixed,
                                );
                                editingMetricIndex = null;
                              } else {
                                keyMertics.add(
                                  KeyMetricsModel(
                                    label: metricsLabelController.text.trim(),
                                    value: metricsValueController.text.trim(),
                                    iconData: selectedMetricIcon,
                                    isFixed: false,
                                  ),
                                );
                              }

                              metricsLabelController.clear();
                              metricsValueController.clear();
                              isKeyMetricsExpanded = false;
                            });
                          },
                        ),
                        child: Column(
                          children: keyMertics.asMap().entries.map((entry) {
                            int index = entry.key;
                            var metric = entry.value;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: color.cardBackground,
                                      borderRadius: BorderRadius.circular(
                                          AppSizes.cardRadius),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 4),
                                        )
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(AppSizes.smallPadding),
                                      child: Icon(metric.iconData ?? Icons.star_outline,
                                          size: AppSizes.iconLarge),
                                    ),
                                  ),
                                  SizedBox(width: AppSizes.smallGap),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: TextBodyStyleWidget(
                                            title: metric.label,
                                            size: AppSizes.cardTitle,
                                            maxLines: 1,
                                          ),
                                        ),
                                        SizedBox(width: 1.w),
                                        TextBodyStyleWidget(
                                          title: metric.value,
                                          color: color.primary,
                                          size: AppSizes.cardTitle,
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (isEditing) ...[
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined,
                                          color: Colors.blue, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          editingMetricIndex = index;
                                          metricsLabelController.text = metric.label;
                                          metricsValueController.text = metric.value;
                                          if (metric.iconData != null) {
                                            selectedMetricIcon = metric.iconData!;
                                          }
                                          isKeyMetricsExpanded = true;
                                        });
                                      },
                                    ),

                                    if (!metric.isFixed)
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline,
                                            color: Colors.red, size: 20),
                                        onPressed: () {
                                          setState(() {
                                            if (editingMetricIndex == index) {
                                              editingMetricIndex = null;
                                              metricsLabelController.clear();
                                              metricsValueController.clear();
                                              isKeyMetricsExpanded = false;
                                            }
                                            keyMertics.removeAt(index);
                                          });
                                        },
                                      ),
                                  ]
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.itemGap),

                    // Infrastructure Data (Additional Info)
                    CustomCard(
                      child: InstituteOverviewScreen(
                        title: "Infrastructure Data",
                        showIcon: isEditing,
                        userIcon:
                        isinfrastructuresExpanded ? Icons.remove : Icons.add,
                        onTap: isEditing
                            ? () {
                          setState(() {
                            if (!isinfrastructuresExpanded) {
                              editingInfrastructureIndex = null;
                              infrastructuresLabelController.clear();
                              infrastructuresValueController.clear();
                            }
                            isinfrastructuresExpanded =
                            !isinfrastructuresExpanded;
                          });
                        }
                            : null,
                        isExpanded: isinfrastructuresExpanded,
                        expandableChild: InfrastructureDropDown(
                          fields: [
                            FormFieldData(
                              title: "Infrastructures Label",
                              hint: "e.g. Classrooms",
                              controller: infrastructuresLabelController,
                            ),
                            FormFieldData(
                              title: "Value",
                              hint: "e.g. 20",
                              controller: infrastructuresValueController,
                            ),
                          ],
                          onSave: () {
                            if (infrastructuresLabelController.text.trim().isEmpty ||
                                infrastructuresValueController.text.trim().isEmpty) return;

                            setState(() {
                              if (editingInfrastructureIndex != null) {
                                infrastructures[editingInfrastructureIndex!] =
                                    InfrastructureItemModel(
                                      label:
                                      infrastructuresLabelController.text.trim(),
                                      value:
                                      infrastructuresValueController.text.trim(),
                                    );
                                editingInfrastructureIndex = null;
                              } else {
                                infrastructures.add(
                                  InfrastructureItemModel(
                                    label:
                                    infrastructuresLabelController.text.trim(),
                                    value:
                                    infrastructuresValueController.text.trim(),
                                  ),
                                );
                              }

                              infrastructuresLabelController.clear();
                              infrastructuresValueController.clear();
                              isinfrastructuresExpanded = false;
                            });
                          },
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: infrastructures.isEmpty
                              ? [
                            TextBodyStyleWidget(
                              title: "No Data Added",
                              size: AppSizes.cardTitle,
                            )
                          ]
                              : infrastructures.asMap().entries.map((entry) {
                            int index = entry.key;
                            var item = entry.value;

                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  TextBodyStyleWidget(
                                    title: item.label,
                                    size: AppSizes.cardTitle,
                                  ),
                                  Row(
                                    children: [
                                      TextBodyStyleWidget(
                                        title: item.value,
                                        size: AppSizes.cardTitle,
                                      ),
                                      if (isEditing) ...[
                                        IconButton(
                                          icon: const Icon(
                                              Icons.edit_outlined,
                                              color: Colors.blue,
                                              size: 20),
                                          onPressed: () {
                                            setState(() {
                                              editingInfrastructureIndex =
                                                  index;
                                              infrastructuresLabelController
                                                  .text = item.label;
                                              infrastructuresValueController
                                                  .text = item.value;
                                              isinfrastructuresExpanded =
                                              true;
                                            });
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.red,
                                              size: 20),
                                          onPressed: () {
                                            setState(() {
                                              if (editingInfrastructureIndex ==
                                                  index) {
                                                editingInfrastructureIndex =
                                                null;
                                                infrastructuresLabelController
                                                    .clear();
                                                infrastructuresValueController
                                                    .clear();
                                                isinfrastructuresExpanded =
                                                false;
                                              }
                                              infrastructures
                                                  .removeAt(index);
                                            });
                                          },
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.itemGap),

                    // About Institute
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextTitleWidget(title: "About Institution"),
                          SizedBox(height: AppSizes.smallGap),
                          CustomTextFieldWidget(
                            controller: aboutInstitutionController,
                            hintText: "Write something...",
                            readOnly: !isEditing,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.itemGap),

                    // Mission
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextTitleWidget(title: "Mission"),
                          SizedBox(height: AppSizes.smallGap),
                          CustomTextFieldWidget(
                            controller: missionController,
                            hintText: "Our Mission Statement...",
                            readOnly: !isEditing,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.itemGap),

                    // Vision
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextTitleWidget(title: "Vision"),
                          SizedBox(height: AppSizes.smallGap),
                          CustomTextFieldWidget(
                            controller: visionController,
                            hintText: "Our Vision Statement...",
                            readOnly: !isEditing,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 9.h),
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