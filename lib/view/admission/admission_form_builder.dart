import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/snackbar_message.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/universal/custom_drop_down.dart';

import '../../data/model/Content/admission/admission_model.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/admission_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/custom_text_field.dart';

// ============================================================
// Display label <-> API value maps
// ============================================================

const Map<String, String> _typeDisplayToApi = {
  "Single Line Text": "text",
  "Email Address": "email",
  "Phone Number": "tel",
  "Number": "number",
  "Date": "date",
  "Dropdown Select": "select",
  "Radio Selection": "radio",
  "Checkbox": "checkbox",
  "Multi-line Text": "textarea",
  "File Upload": "file",
  "Image Upload": "image",
};

final Map<String, String> _typeApiToDisplay = {
  for (final entry in _typeDisplayToApi.entries) entry.value: entry.key,
};

const Map<String, String> _operatorDisplayToApi = {
  "Equals": "equals",
  "Doesnot Equal": "not_equals",
};

final Map<String, String> _operatorApiToDisplay = {
  for (final entry in _operatorDisplayToApi.entries) entry.value: entry.key,
};

// Field types that need an "Options" input (comma separated).
const List<String> _optionTypes = [
  "Dropdown Select",
  "Radio Selection",
  "Checkbox",
];

// ============================================================
// Dynamic Form Field (local editing state, mirrors
// AdmissionFormFieldModel but keeps display-friendly values)
// ============================================================

class FormFieldItem {
  final TextEditingController labelController;
  final TextEditingController idController;
  final TextEditingController optionsController;
  final TextEditingController logicIdController;
  final TextEditingController logicTargetController;

  String selectedType;
  bool isRequired;
  bool isLogicEnabled;
  String selectedLogicType;

  FormFieldItem({
    String label = '',
    String id = '',
    String selectedType = "Single Line Text",
    this.isRequired = false,
    String options = '',
    this.isLogicEnabled = false,
    String logicId = '',
    this.selectedLogicType = "Equals",
    String logicTarget = '',
  })  : labelController = TextEditingController(text: label),
        idController = TextEditingController(text: id),
        optionsController = TextEditingController(text: options),
        logicIdController = TextEditingController(text: logicId),
        logicTargetController = TextEditingController(text: logicTarget),
        selectedType = selectedType;

  // Build from an existing API field (edit mode hydration).
  factory FormFieldItem.fromApiModel(AdmissionFormFieldModel field) {
    final hasLogic = field.logic != null &&
        (field.logic!.sourceField?.isNotEmpty ?? false);

    return FormFieldItem(
      label: field.label ?? '',
      id: field.id ?? '',
      selectedType: _typeApiToDisplay[field.type] ?? "Single Line Text",
      isRequired: field.required ?? false,
      options: field.options?.join(', ') ?? '',
      isLogicEnabled: hasLogic,
      logicId: field.logic?.sourceField ?? '',
      selectedLogicType:
      _operatorApiToDisplay[field.logic?.operator] ?? "Equals",
      logicTarget: field.logic?.value ?? '',
    );
  }

  // Convert back to the API shape for saving.
  AdmissionFormFieldModel toApiModel(int order) {
    final apiType = _typeDisplayToApi[selectedType] ?? "text";

    List<String>? options;
    if (_optionTypes.contains(selectedType)) {
      options = optionsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    AdmissionFieldLogicModel? logic;
    if (isLogicEnabled && logicIdController.text.trim().isNotEmpty) {
      logic = AdmissionFieldLogicModel(
        sourceField: logicIdController.text.trim(),
        operator: _operatorDisplayToApi[selectedLogicType] ?? "equals",
        value: logicTargetController.text.trim(),
      );
    }

    return AdmissionFormFieldModel(
      id: idController.text.trim(),
      label: labelController.text.trim(),
      type: apiType,
      required: isRequired,
      order: order,
      options: options,
      logic: logic,
    );
  }

  void dispose() {
    labelController.dispose();
    idController.dispose();
    optionsController.dispose();
    logicIdController.dispose();
    logicTargetController.dispose();
  }
}

class AdmissionFormBuilder extends StatefulWidget {
  const AdmissionFormBuilder({super.key});

  @override
  State<AdmissionFormBuilder> createState() => _AdmissionFormBuilderState();
}

class _AdmissionFormBuilderState extends State<AdmissionFormBuilder> {
  final TextEditingController fromTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();

  bool isFormStatus = true;
  bool isLoading = true;

  // Set once the initial GET completes — null means "no existing form
  // yet" (create mode), non-null means we're editing that config's id.
  int? _existingConfigId;

  final List<FormFieldItem> _formFields = [];

  final List<String> formType = [
    "Single Line Text",
    "Email Address",
    "Phone Number",
    "Number",
    "Date",
    "Dropdown Select",
    "Radio Selection",
    "Checkbox",
    "Multi-line Text",
    "File Upload",
    "Image Upload",
  ];

  final List<String> logicType = [
    "Equals",
    "Doesnot Equal",
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel = context.read<AdmissionViewModel>();
      await viewModel.getFormConfig();

      if (!mounted) return;

      final config = viewModel.formConfig;

      if (config != null) {
        _hydrateFromConfig(config);
      } else {
        _setInitialDefaultFields();
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  // ============================================================
  // Hydrate from an existing config (edit mode)
  // ============================================================
  void _hydrateFromConfig(AdmissionFormConfigModel config) {
    _existingConfigId = config.id;

    fromTitleController.text = config.title ?? '';
    descriptionController.text = config.description ?? '';
    deadlineController.text = _isoToDisplayDate(config.deadline);
    isFormStatus = config.isActive ?? true;

    _formFields.clear();
    for (final field in (config.fields ?? [])) {
      _formFields.add(FormFieldItem.fromApiModel(field));
    }
  }

  // Default starting fields when there's no config yet (create mode).
  void _setInitialDefaultFields() {
    _existingConfigId = null;

    fromTitleController.text = "School Admission Form";
    descriptionController.text = "Please fill in the required details.";
    deadlineController.text = "";
    isFormStatus = true;

    _formFields.addAll([
      FormFieldItem(
        label: "Student Name",
        id: "student_name",
        selectedType: "Single Line Text",
        isRequired: true,
      ),
      FormFieldItem(
        label: "Phone Number",
        id: "phone_number",
        selectedType: "Phone Number",
        isRequired: true,
      ),
    ]);
  }

  // ============================================================
  // Date helpers — the picker shows "dd/MM/yyyy", the API expects
  // a plain ISO date string ("yyyy-MM-dd").
  // ============================================================

  String? _displayDateToIso(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    final parts = trimmed.split('/');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;

    final mm = month.toString().padLeft(2, '0');
    final dd = day.toString().padLeft(2, '0');
    return "$year-$mm-$dd";
  }

  String _isoToDisplayDate(String? iso) {
    if (iso == null || iso.trim().isEmpty) return '';
    final parts = iso.split('-');
    if (parts.length != 3) return iso;
    final year = parts[0];
    final month = parts[1];
    final day = parts[2];
    return "$day/$month/$year";
  }

  // ============================================================
  // Save (create or update, decided by _existingConfigId)
  // ============================================================
  Future<void> _saveForm() async {
    if (fromTitleController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter a form title");
      return;
    }

    if (_formFields.isEmpty) {
      SnackBarMessage.showSnackBar(context, "Add at least one field");
      return;
    }

    for (final field in _formFields) {
      if (field.labelController.text.trim().isEmpty ||
          field.idController.text.trim().isEmpty) {
        SnackBarMessage.showSnackBar(
          context,
          "Every field needs a label and a field ID",
        );
        return;
      }
    }

    final fields = <AdmissionFormFieldModel>[
      for (var i = 0; i < _formFields.length; i++)
        _formFields[i].toApiModel(i + 1),
    ];

    final configToSave = AdmissionFormConfigModel(
      id: _existingConfigId,
      title: fromTitleController.text.trim(),
      description: descriptionController.text.trim(),
      isActive: isFormStatus,
      deadline: _displayDateToIso(deadlineController.text),
      fields: fields,
    );

    final viewModel = context.read<AdmissionViewModel>();
    final success = await viewModel.saveFormConfig(configToSave);

    if (!mounted) return;

    if (success) {
      // Keep the id so a second save in the same session updates
      // instead of creating a duplicate.
      _existingConfigId = viewModel.formConfig?.id ?? _existingConfigId;

      SnackBarMessage.showSnackBar(
        context,
        "Admission form saved successfully!",
      );
      Navigator.pop(context, true);
    } else {
      SnackBarMessage.showSnackBar(
        context,
        viewModel.errorMessage ?? "Failed to save admission form",
      );
    }
  }

  void _addNewField() {
    setState(() {
      _formFields.add(FormFieldItem());
    });
  }

  void _removeField(int index) {
    setState(() {
      _formFields[index].dispose();
      _formFields.removeAt(index);
    });
  }

  @override
  void dispose() {
    fromTitleController.dispose();
    descriptionController.dispose();
    deadlineController.dispose();
    for (var field in _formFields) {
      field.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    final isSaving = context.watch<AdmissionViewModel>().isSavingFormConfig;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: _existingConfigId != null
                ? "Edit Admission Form"
                : "Admission Form Builder",
            showBackButton: true,
          ),

          // Header Info
          SliverPadding(
            padding: EdgeInsets.only(
              top: AppSizes.sectionTitle,
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextBodyStyleWidget(
                        title: "Form Title",
                        color: color.primary,
                        size: AppSizes.sectionTitle,
                      ),
                      SizedBox(height: AppSizes.appbarGap),
                      CustomTextFieldWidget(
                        hintText: "Online Admission Form",
                        controller: fromTitleController,
                      ),
                      SizedBox(height: AppSizes.itemGap),

                      TextBodyStyleWidget(
                        title: "Description",
                        color: color.primary,
                        size: AppSizes.sectionTitle,
                      ),
                      SizedBox(height: AppSizes.appbarGap),
                      CustomTextFieldWidget(
                        hintText: "Enter form description...",
                        controller: descriptionController,
                        maxLines: 6,
                        minLines: 4,
                      ),
                      SizedBox(height: AppSizes.itemGap),

                      TextBodyStyleWidget(
                        title: "Application Deadline",
                        color: color.primary,
                        size: AppSizes.sectionTitle,
                      ),
                      SizedBox(height: AppSizes.appbarGap),
                      CustomTextFieldWidget(
                        hintText: "07/09/2026",
                        controller: deadlineController,
                        isDatePicker: true,
                      ),
                      SizedBox(height: AppSizes.itemGap),

                      CustomCard2(
                        child: Padding(
                          padding: EdgeInsets.all(AppSizes.contentPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.format_align_center_outlined,
                                    color: isFormStatus
                                        ? Colors.green
                                        : Colors.redAccent,
                                    size: AppSizes.iconLarge,
                                  ),
                                  SizedBox(width: AppSizes.smallGap),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      TextTitleWidget(
                                        title: "Form Status",
                                        color: color.primary,
                                      ),
                                      SizedBox(height: AppSizes.appbarGap),
                                      TextBodyStyleWidget(
                                        title: isFormStatus
                                            ? "Currently accepting applications"
                                            : "Applications are closed",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(width: AppSizes.sectionGap),
                              Checkbox(
                                value: isFormStatus,
                                activeColor: color.primary,
                                onChanged: (value) {
                                  setState(() {
                                    isFormStatus = value ?? false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),

          // Add Field Header
          SliverPadding(
            padding: EdgeInsets.only(
              top: AppSizes.screenPadding,
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                CustomCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextBodyStyleWidget(
                        title: "Form Fields (${_formFields.length})",
                        color: color.primary,
                        size: AppSizes.sectionTitle,
                      ),
                      CustomButton(
                        width: 32.w,
                        text: "Add New Field",
                        onTap: _addNewField,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSizes.itemGap),
              ]),
            ),
          ),

          // Dynamic Fields List
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.screenPadding,
            ),
            sliver: SliverList.builder(
              itemCount: _formFields.length,
              itemBuilder: (context, index) {
                final field = _formFields[index];
                final showOptions = _optionTypes.contains(field.selectedType);

                return Container(
                  margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                  child: CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextTitleWidget(
                              title: "Field #${index + 1}",
                              color: color.primary,
                            ),
                            IconButton(
                              onPressed: () => _removeField(index),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: color.lightVersionOfPrimaryLightVersion,
                          height: 1,
                        ),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(
                          title: "Field Label",
                          color: color.primary,
                          size: AppSizes.sectionTitle,
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(
                          hintText: "e.g. Student Name",
                          controller: field.labelController,
                        ),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(
                          title: "Field ID (Internal Name)",
                          color: color.primary,
                          size: AppSizes.sectionTitle,
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(
                          hintText: "e.g. student_name",
                          controller: field.idController,
                        ),
                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(
                          title: "Type",
                          color: color.primary,
                          size: AppSizes.sectionTitle,
                        ),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomDropdown(
                          height: 5.h,
                          width: 100.w,
                          items: formType,
                          initialValue: field.selectedType,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                field.selectedType = value;
                              });
                            }
                          },
                        ),

                        // Options input — only for select/radio/checkbox
                        if (showOptions) ...[
                          SizedBox(height: AppSizes.itemGap),
                          TextBodyStyleWidget(
                            title: "Options (comma separated)",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "Grade 1, Grade 2, Grade 3...",
                            controller: field.optionsController,
                            minLines: 2,
                            maxLines: 3,
                          ),
                        ],

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextBodyStyleWidget(
                              title: "Required",
                              color: color.primary,
                            ),
                            Checkbox(
                              value: field.isRequired,
                              activeColor: color.primary,
                              onChanged: (value) {
                                setState(() {
                                  field.isRequired = value ?? false;
                                });
                              },
                            ),
                          ],
                        ),
                        Divider(
                          color: color.lightVersionOfPrimaryLightVersion,
                          height: 1,
                        ),
                        SizedBox(height: AppSizes.smallGap),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextBodyStyleWidget(
                              title: "Conditional Logic",
                              color: color.primary,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  field.isLogicEnabled = !field.isLogicEnabled;
                                });
                              },
                              child: TextBodyStyleWidget(
                                title: field.isLogicEnabled
                                    ? "Enable"
                                    : "Disable",
                                color: color.primary,
                              ),
                            ),
                          ],
                        ),

                        if (field.isLogicEnabled) ...[
                          SizedBox(height: AppSizes.smallGap),
                          CustomCard2(
                            child: Padding(
                              padding: EdgeInsets.all(AppSizes.contentPadding),
                              child: Column(
                                children: [
                                  CustomTextFieldWidget(
                                    hintText: "Select or type field ID...",
                                    controller: field.logicIdController,
                                  ),
                                  SizedBox(height: AppSizes.itemGap),
                                  CustomDropdown(
                                    height: 5.h,
                                    width: 100.w,
                                    items: logicType,
                                    initialValue: field.selectedLogicType,
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          field.selectedLogicType = value;
                                        });
                                      }
                                    },
                                  ),
                                  SizedBox(height: AppSizes.itemGap),
                                  CustomTextFieldWidget(
                                    hintText: "Target Value",
                                    controller: field.logicTargetController,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: AppSizes.smallGap),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Actions
          SliverPadding(
            padding: EdgeInsets.only(
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
              bottom: AppSizes.sectionGap,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
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
                    SizedBox(width: AppSizes.appbarGap),
                    Flexible(
                      child: CustomButton(
                        text: isSaving ? "Saving..." : "Save Form",
                        onTap: isSaving ? () {} : _saveForm,
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