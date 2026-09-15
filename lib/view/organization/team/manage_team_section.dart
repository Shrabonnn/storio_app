import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../data/model/organization/team/team_member_model.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/snackbar_message.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../viewModel/organization/team_member_view_model.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/textStyle/text_title_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_card.dart';
import '../../../widget/universal/custom_card2.dart';
import '../../../widget/universal/custom_text_field.dart';

class ManageTeamSection extends StatefulWidget {
  const ManageTeamSection({super.key});

  @override
  State<ManageTeamSection> createState() => _ManageTeamSectionState();
}

class _ManageTeamSectionState extends State<ManageTeamSection> {
  // Controller definitions
  final TextEditingController sectionNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // State variable for tracking active edit item
  TeamSectionModel? editingSection;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TeamViewModel>().fetchManagementSections();
    });
  }

  @override
  void dispose() {
    sectionNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // Clear form fields and reset edit state
  void clearForm() {
    sectionNameController.clear();
    descriptionController.clear();
    setState(() {
      editingSection = null;
      isVisible = true;
    });
  }

  // Populate fields for editing using final TeamSectionModel parameter
  void editSection(final TeamSectionModel section) {
    sectionNameController.text = section.name ?? '';
    descriptionController.text = section.description ?? '';
    setState(() {
      editingSection = section;
      isVisible = section.isVisible ?? true;
    });
  }

  // Submit Action (Create / Update Section)
  Future<void> submitSection() async {
    if (sectionNameController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter section name");
      return;
    }

    final provider = context.read<TeamViewModel>();
    final isCreating = editingSection == null;

    bool success;

    if (isCreating) {
      // Explicitly call final TeamSectionModel
      final TeamSectionModel newSection = TeamSectionModel(
        name: sectionNameController.text.trim(),
        description: descriptionController.text.trim(),
        isVisible: isVisible,
      );
      success = await provider.createTeamSection(newSection);
    } else {
      if (editingSection!.id == null) return;

      final Map<String, dynamic> data = {
        "name": sectionNameController.text.trim(),
        "description": descriptionController.text.trim(),
        "is_visible": isVisible,
      };

      success = await provider.updateTeamSection(
        editingSection!.id!,
        data,
      );
    }

    if (!mounted) return;

    if (success) {
      clearForm();
      provider.fetchManagementSections();

      SnackBarMessage.showSnackBar(
        context,
        isCreating
            ? "Section created successfully."
            : "Section updated successfully.",
      );
    } else {
      SnackBarMessage.showSnackBar(
        context,
        provider.errorMessage ?? "Something went wrong.",
      );
    }
  }

  // Delete Section Action
  Future<void> deleteSection(int id) async {
    final provider = context.read<TeamViewModel>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Section"),
          content: const Text(
            "Are you sure you want to delete this section?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final success = await provider.deleteTeamSection(id);

    if (!mounted) return;

    SnackBarMessage.showSnackBar(
      context,
      success
          ? "Section deleted successfully."
          : provider.errorMessage ?? "Failed to delete section.",
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBar(
            title: "Manage Team Sections",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    // =====================================================
                    // CREATE / EDIT SECTION FORM
                    // =====================================================
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextBodyStyleWidget(
                                  title: editingSection == null
                                      ? "Create New Section"
                                      : "Edit Section: ${editingSection?.name ?? ''}",
                                  color: color.primary,
                                  size: AppSizes.sectionTitle,
                                ),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: isVisible,
                                    activeColor: color.primary,
                                    onChanged: (value) {
                                      setState(() {
                                        isVisible = value ?? false;
                                      });
                                    },
                                  ),
                                  TextBodyStyleWidget(
                                    title: "Is Visible",
                                    color: color.primary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: AppSizes.sectionGap),

                          // Section Name
                          TextBodyStyleWidget(
                            title: "Section Name",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "e.g. Executive Board, Advisory",
                            controller: sectionNameController,
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          // Description
                          TextBodyStyleWidget(
                            title: "Description",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "Brief description of the section",
                            controller: descriptionController,
                            minLines: 4,
                            maxLines: 6,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // Submit & Cancel Buttons
                    Consumer<TeamViewModel>(
                      builder: (context, provider, child) {
                        return Row(
                          children: [
                            if (editingSection != null) ...[
                              CustomButton(
                                text: "Cancel",
                                width: 30.w,
                                onTap: clearForm,
                                backgroundColor: color.cardBackground,
                                foregroundColor: color.primary,
                              ),
                              SizedBox(width: AppSizes.appbarGap),
                            ],
                            Flexible(
                              child: CustomButton(
                                text: editingSection == null
                                    ? "Create Section"
                                    : provider.isSaving? "Updating...":"Update Section",
                                onTap: provider.isSaving
                                    ? null
                                    : submitSection,
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // =====================================================
                    // EXISTING SECTIONS LIST
                    // =====================================================
                    Consumer<TeamViewModel>(
                      builder: (context, provider, child) {
                        if (provider.isLoading &&
                            provider.managementSections.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (provider.managementSections.isEmpty) {
                          return CustomCard(
                            child: Center(
                              child: TextBodyStyleWidget(
                                title: "No sections found.",
                                color: color.primary,
                              ),
                            ),
                          );
                        }

                        return CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextBodyStyleWidget(
                                title:
                                "Existing Sections (${provider.managementSections.length})",
                                color: color.primary,
                                size: AppSizes.sectionTitle,
                              ),
                              SizedBox(height: AppSizes.itemGap),
                              ListView.separated(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: provider.managementSections.length,
                                separatorBuilder: (context, index) {
                                  return const Divider();
                                },
                                itemBuilder: (context, index) {
                                  // Explicitly call final TeamSectionModel
                                  final TeamSectionModel section =
                                  provider.managementSections[index];

                                  return CustomCard2(
                                    child: Padding(
                                      padding:
                                      EdgeInsets.all(AppSizes.smallPadding),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                TextTitleWidget(
                                                  title: section.name ?? '',
                                                  color: color.primary,
                                                  maxLines: 1,
                                                ),
                                                SizedBox(
                                                    height: AppSizes.appbarGap),
                                                TextBodyStyleWidget(
                                                  title: section.description ??
                                                      'No description provided.',
                                                  maxLines: 2,
                                                  size: AppSizes.cardTitle,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  editSection(section);
                                                },
                                                icon: Icon(
                                                  Icons.edit,
                                                  size: AppSizes.iconLarge,
                                                  color: color.primary,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  if (section.id != null) {
                                                    deleteSection(section.id!);
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.delete_outline_outlined,
                                                  size: AppSizes.iconLarge,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    SizedBox(height: AppSizes.appbarGap),
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