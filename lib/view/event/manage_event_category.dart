import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/viewModel/Content/event_view_model.dart';

import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/confirm_action.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/custom_text_field.dart';

class ManageEventCategory extends StatefulWidget {
  const ManageEventCategory({super.key});

  @override
  State<ManageEventCategory> createState() => _ManageEventCategoryState();
}

class _ManageEventCategoryState extends State<ManageEventCategory> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();


  int? categoryId;
  bool isSaving = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      if(!mounted) return ;

      context.read<EventViewModel>().getCategoryApi();
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }

  void _startEditing(int id, String? name, ) {
    setState(() {
      categoryId = id;
      nameController.text = name ?? '';
    });
  }

  void _resetForm() {
    setState(() {
      categoryId = null;
      nameController.clear();
      descriptionController.clear();
    });
  }

  Future<void> _handleSaveCategory() async {
    if (nameController.text.trim().isEmpty) {
      SnackBarMessage.showSnackBar(context, "Please enter a category name");
      return;
    }

    final provider = context.read<EventViewModel>();

    setState(() => isSaving = true);

    final data = <String, dynamic>{
      "name": nameController.text.trim(),
      "description": descriptionController.text.trim(),
    };

    final success = categoryId != null
        ? await provider.updateCategory(categoryId!, data)
        : await provider.createCategory(data);

    if (!mounted) return;

    setState(() => isSaving = false);

    if (success) {
      SnackBarMessage.showSnackBar(
        context,
        categoryId != null ? "Category updated" : "Category added",
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

    final provider = context.read<EventViewModel>();
    final success = await provider.deleteCategory(id);

    if (!mounted) return;

    if (success) {
      if (categoryId == id) _resetForm();
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
          CustomSliverAppBar(title: "Manage Event Categories", showBackButton: true),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          TextBodyStyleWidget(
                            title:categoryId != null ? "Edit Category" : "Create New Categories",
                            color: color.primary,
                            size: AppSizes.sectionTitle,
                          ),
                          SizedBox(height: AppSizes.sectionGap),

                          // Title
                          TextBodyStyleWidget(
                            title: "Name",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "New Categories",
                            controller: nameController,
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
                            hintText: "Write your content here",
                            controller: descriptionController,
                            minLines: 4,
                            maxLines: 6,
                          ),


                          SizedBox(height: AppSizes.sectionGap),

                          Row(mainAxisAlignment: .end,
                            children: [
                              if(categoryId !=null)...[
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
                                    : (categoryId != null ? "Update Category" : "Add Category"),
                                width: 30.w,
                                onTap: isSaving ? null : _handleSaveCategory,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    Consumer<EventViewModel>(builder: (context,provider,child){
                      return CustomCard(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            TextBodyStyleWidget(
                              title: "Existing Category ( ${provider.categoryList.length} )",
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
                                itemBuilder: (context,index){

                                  final category = provider.categoryList[index];

                                  return CustomCard2(
                                    child: Padding(
                                      padding: EdgeInsets.all(AppSizes.smallPadding),
                                      child: Row(
                                        mainAxisAlignment: .spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment: .start,
                                              children: [
                                                TextTitleWidget(
                                                  title: category.name ?? "",
                                                  color: color.primary,
                                                  maxLines: 1,
                                                ),

                                              ],
                                            ),
                                          ),
                                          SizedBox(width: AppSizes.smallGap),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              GestureDetector(
                                                onTap: category.id == null
                                                    ? null
                                                    : () => _startEditing(category.id!, category.name),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: color.primary,
                                                  size: AppSizes.iconLarge,
                                                ),
                                              ),

                                              SizedBox(width: AppSizes.itemGap),

                                              GestureDetector(
                                                onTap: category.id == null
                                                    ? null
                                                    : () => _handleDeleteCategory(
                                                  category.id!,
                                                  category.name ?? '',
                                                ),
                                                child: Icon(
                                                  Icons.delete_outline_outlined,
                                                  color: Colors.red,
                                                  size: AppSizes.iconLarge,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }, separatorBuilder:(context, index) {
                              return Divider();} )
                          ],
                        ),
                      );
                    }),

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
