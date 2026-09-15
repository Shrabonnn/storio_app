import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/widget/institute_profile/Institute_overview_screen.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';

import '../../utils/app_sizes.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/activity_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/universal/confirm_action.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/custom_text_field.dart';

class ActivityCategoryScreen extends StatefulWidget {
  const ActivityCategoryScreen({super.key});

  @override
  State<ActivityCategoryScreen> createState() => _ActivityCategoryScreenState();
}

class _ActivityCategoryScreenState extends State<ActivityCategoryScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  int? editingCategoryId;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ActivityViewModel>().getCategoryApi();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _startEditing(int id, String? name, String? description) {
    setState(() {
      editingCategoryId = id;
      nameController.text = name ?? '';
      descriptionController.text = description ?? '';
    });
  }

  void _resetForm() {
    setState(() {
      editingCategoryId = null;
      nameController.clear();
      descriptionController.clear();
    });
  }

  Future<void> _handleSaveCategory() async {
    if (nameController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter a category name");
      return;
    }

    final provider = context.read<ActivityViewModel>();

    setState(() => isSaving = true);

    final data = <String, dynamic>{
      "name": nameController.text.trim(),
      "description": descriptionController.text.trim(),
    };

    final success = editingCategoryId != null
        ? await provider.updateCategory(editingCategoryId!, data)
        : await provider.createCategory(data);

    if (!mounted) return;

    setState(() => isSaving = false);

    if (success) {
      SnackBarMessage.showSnackBar(
        context,
        editingCategoryId != null ? "Category updated" : "Category added",
      );
      _resetForm();
      provider.getCategoryApi();
    } else {
      SnackBarMessage.showSnackBar(context, provider.categoryErrorMessage ?? "Failed to save category");
    }
  }

  Future<void> _handleDeleteCategory(int id, String name) async {
    final confirmed = await confirmAction(
      context,
      title: "Delete Category",
      message: "Are you sure you want to delete '$name'?",
    );

    if (!mounted || !confirmed) return;

    final provider = context.read<ActivityViewModel>();
    final success = await provider.deleteCategory(id);

    if (!mounted) return;

    if (success) {
      if (editingCategoryId == id) _resetForm();
      provider.getCategoryApi();
    } else {
      SnackBarMessage.showSnackBar(context, provider.categoryErrorMessage ?? "Failed to delete category");
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Activity Manage Category",
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
                          TextTitleWidget(
                            title: editingCategoryId != null ? "Edit Category" : "Manage Category",
                            size: AppSizes.sectionTitle,
                            color: color.primary,
                          ),
                          SizedBox(height: AppSizes.sectionGap),

                          TextBodyStyleWidget(title: "Name", color: color.primary, size: AppSizes.cardTitle),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(hintText: "Annual Sports Day", controller: nameController),
                          SizedBox(height: AppSizes.itemGap),

                          TextBodyStyleWidget(title: "Description", color: color.primary, size: AppSizes.cardTitle),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "Brief description category",
                            minLines: 3,
                            maxLines: 5,
                            controller: descriptionController,
                          ),

                          SizedBox(height: AppSizes.sectionGap),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (editingCategoryId != null) ...[
                                CustomButton(
                                  text: "Cancel",
                                  width: 25.w,
                                  backgroundColor: color.cardBackground,
                                  foregroundColor: color.primary,
                                  onTap: isSaving ? null : _resetForm,
                                ),
                                SizedBox(width: AppSizes.smallGap),
                              ],
                              CustomButton(
                                text: isSaving
                                    ? "Saving..."
                                    : (editingCategoryId != null ? "Update Category" : "Add Category"),
                                width: 30.w,
                                onTap: isSaving ? null : _handleSaveCategory,
                              ),
                            ],
                          ),

                          SizedBox(height: AppSizes.appbarGap),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap),
                    Consumer<ActivityViewModel>(
                      builder: (context, provider, child) {

                        return CustomCard(

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextBodyStyleWidget(
                                title: "Existing Categories (${provider.categoryList.length})",
                                color: color.primary,
                                size: AppSizes.sectionTitle,
                              ),
                              SizedBox(height: AppSizes.itemGap),

                              if (provider.categoryLoading)
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(child: CircularProgressIndicator()),
                                )
                              else if (provider.categoryErrorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: TextBodyStyleWidget(
                                    title: provider.categoryErrorMessage!,
                                    color: Colors.red,
                                  ),
                                )
                              else if (provider.categoryList.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: TextBodyStyleWidget(title: "No categories yet", color: color.primary),
                                  )
                                else
                                  ListView.separated(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: provider.categoryList.length,
                                    separatorBuilder: (context, index) =>  Divider(
       color: color.lightVersionOfPrimaryLightVersion,
       height: 1, ),
                                    itemBuilder: (context, index) {
                                      final category = provider.categoryList[index];

                                      return CustomCard2(
                                        child: Padding(
                                          padding: EdgeInsets.all(AppSizes.smallPadding),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    TextTitleWidget(
                                                      title: category.name ?? '',
                                                      color: color.primary,
                                                      maxLines: 1,
                                                    ),
                                                    SizedBox(height: AppSizes.appbarGap),
                                                    TextBodyStyleWidget(
                                                      title: (category.description?.isNotEmpty == true)
                                                          ? category.description!
                                                          : "${category.activitiesCount ?? 0} activities",
                                                      maxLines: 2,
                                                      size: AppSizes.cardTitle,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: AppSizes.smallGap),
                                              IconButton(
                                                onPressed: category.id == null
                                                    ? null
                                                    : () => _startEditing(category.id!, category.name, category.description),
                                                icon: Icon(Icons.edit, color: color.primary, size: AppSizes.iconLarge),
                                              ),
                                              IconButton(
                                                onPressed: category.id == null
                                                    ? null
                                                    : () => _handleDeleteCategory(category.id!, category.name ?? ''),
                                                icon:  Icon(
                                                  Icons.delete_outline_outlined,
                                                  color: Colors.red,
                                                  size: AppSizes.iconLarge,
                                                ),
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