import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../data/model/Content/blog/blog_model.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../viewModel/Content/blog_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/custom_text_field.dart';

class ManageBlogCategory extends StatefulWidget {
  const ManageBlogCategory({super.key});

  @override
  State<ManageBlogCategory> createState() => _ManageBlogCategoryState();
}

class _ManageBlogCategoryState extends State<ManageBlogCategory> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController urlSlugController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  CategoriesData? editingCategory;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BlogViewModel>().getCategoryApi();
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    urlSlugController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void clearForm() {
    nameController.clear();
    urlSlugController.clear();
    descriptionController.clear();

    setState(() {
      editingCategory = null;
    });
  }

  void editCategory(CategoriesData category) {
    nameController.text = category.name ?? '';
    urlSlugController.text = category.slug ?? '';
    descriptionController.text = category.description ?? '';

    setState(() {
      editingCategory = category;
    });
  }

  Future<void> submitCategory() async {
    if (nameController.text.trim().isEmpty) {
      return;
    }

    final provider = context.read<BlogViewModel>();

    final data = {
      "name": nameController.text.trim(),
      "slug": urlSlugController.text.trim(),
      "description": descriptionController.text.trim(),
    };

    bool success;

    if (editingCategory == null) {
      success = await provider.createCategory(data);
    } else {
      success = await provider.updateCategory(
        editingCategory!.id!,
        data,
      );
    }

    if (!mounted) return;

    if (success) {
      clearForm();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            editingCategory == null
                ? "Category created successfully."
                : "Category updated successfully.",
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.categoryErrorMessage ??
                "Something went wrong.",
          ),
        ),
      );
    }
  }

  Future<void> deleteCategory(int id) async {
    final provider = context.read<BlogViewModel>();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Category"),
          content: const Text(
            "Are you sure you want to delete this category?",
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

    final success = await provider.deleteCategory(id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Category deleted successfully."
              : provider.categoryErrorMessage ??
              "Failed to delete category.",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBar(
            title: "Manage Categories",
            showBackButton: true,
          ),

          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // =====================================================
                  // CREATE / EDIT CATEGORY
                  // =====================================================

                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBodyStyleWidget(
                          title: editingCategory == null
                              ? "Create New Category"
                              : "Edit Category",
                          color: color.primary,
                          size: AppSizes.sectionTitle,
                        ),

                        SizedBox(height: AppSizes.sectionGap),

                        // NAME
                        TextBodyStyleWidget(
                          title: "Name",
                          color: color.primary,
                          size: AppSizes.cardTitle,
                        ),

                        SizedBox(height: AppSizes.appbarGap),

                        CustomTextFieldWidget(
                          hintText: "New Category",
                          controller: nameController,
                        ),

                        SizedBox(height: AppSizes.itemGap),

                        // SLUG
                        TextBodyStyleWidget(
                          title: "URL Slug",
                          color: color.primary,
                          size: AppSizes.cardTitle,
                        ),

                        SizedBox(height: AppSizes.appbarGap),

                        CustomTextFieldWidget(
                          hintText: "category-slug",
                          controller: urlSlugController,
                        ),

                        SizedBox(height: AppSizes.itemGap),

                        // DESCRIPTION
                        TextBodyStyleWidget(
                          title: "Description",
                          color: color.primary,
                          size: AppSizes.cardTitle,
                        ),

                        SizedBox(height: AppSizes.appbarGap),

                        CustomTextFieldWidget(
                          hintText: "Write your content here",
                          controller: descriptionController,
                          minLines: 4,
                          maxLines: 6,
                        ),

                        SizedBox(height: AppSizes.sectionGap),

                        Consumer<BlogViewModel>(
                          builder: (context, provider, child) {
                            return Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    text: editingCategory == null
                                        ? "Add Category"
                                        : "Update Category",
                                    onTap: provider.categoryLoading
                                        ? null
                                        : submitCategory,
                                  ),
                                ),

                                if (editingCategory != null) ...[
                                  SizedBox(
                                    width: AppSizes.smallGap,
                                  ),

                                  Expanded(
                                    child: CustomButton(
                                      text: "Cancel",
                                      onTap: clearForm,
                                    ),
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSizes.sectionGap),

                  // =====================================================
                  // EXISTING CATEGORIES
                  // =====================================================

                  Consumer<BlogViewModel>(
                    builder: (context, provider, child) {
                      if (provider.categoryLoading &&
                          provider.categoryList.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (provider.categoryList.isEmpty) {
                        return CustomCard(
                          child: Center(
                            child: TextBodyStyleWidget(
                              title: "No categories found.",
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
                              "Existing Categories (${provider.categoryList.length})",
                              color: color.primary,
                              size: AppSizes.sectionTitle,
                            ),

                            SizedBox(height: AppSizes.itemGap),

                            ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              itemCount:
                              provider.categoryList.length,
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemBuilder: (context, index) {
                                final category =
                                provider.categoryList[index];

                                return CustomCard2(
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                      AppSizes.smallPadding,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              TextTitleWidget(
                                                title:
                                                category.name ?? '',
                                                color: color.primary,
                                                maxLines: 1,
                                              ),

                                              SizedBox(
                                                height:
                                                AppSizes.appbarGap,
                                              ),

                                              TextBodyStyleWidget(
                                                title:
                                                category.description ??
                                                    '',
                                                maxLines: 2,
                                                size:
                                                AppSizes.cardTitle,
                                              ),
                                            ],
                                          ),
                                        ),

                                        SizedBox(
                                          width: AppSizes.smallGap,
                                        ),

                                        IconButton(
                                          onPressed: () {
                                            editCategory(category);
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: color.primary,
                                            size:
                                            AppSizes.iconLarge,
                                          ),
                                        ),

                                        IconButton(
                                          onPressed: () {
                                            deleteCategory(
                                              category.id!,
                                            );
                                          },
                                          icon: Icon(
                                            Icons
                                                .delete_outline_outlined,
                                            color: Colors.red,
                                            size:
                                            AppSizes.iconLarge,
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

                  SizedBox(height: AppSizes.appbarGap),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}