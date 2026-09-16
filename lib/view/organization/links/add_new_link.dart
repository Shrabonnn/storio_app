import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/custom_card.dart';

import '../../../data/model/organization/links/important_link_model.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/snackbar_message.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../viewModel/organization/important_view_model.dart';
import '../../../widget/custom_button/custom_buttom.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/custom_text_field.dart';

class AddNewLink extends StatefulWidget {
  const AddNewLink({super.key, this.isEdit = false, this.link});

  final bool isEdit;


  final ImportantLinkModel? link;

  @override
  State<AddNewLink> createState() => _AddNewLinkState();
}

class _AddNewLinkState extends State<AddNewLink> {
  final TextEditingController linkTitleController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController displayOrderController = TextEditingController();

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    if (widget.isEdit && widget.link != null) {
      linkTitleController.text = widget.link!.title ?? '';
      urlController.text = widget.link!.url ?? '';
      displayOrderController.text = (widget.link!.order ?? 0).toString();
    }
  }

  @override
  void dispose() {
    linkTitleController.dispose();
    urlController.dispose();
    displayOrderController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    SnackBarMessage.showSnackBar(context, message);
  }


  // Save / Update Link


  Future<void> _handleSave() async {
    if (linkTitleController.text.trim().isEmpty) {
      _showMessage("Please enter link title");
      return;
    }

    if (urlController.text.trim().isEmpty) {
      _showMessage("Please enter a URL");
      return;
    }

    final url = urlController.text.trim();
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      _showMessage("URL must start with http:// or https://");
      return;
    }

    final viewModel = context.read<ImportantLinkViewModel>();

    setState(() {
      isSaving = true;
    });

    final Map<String, dynamic> data = {
      "title": linkTitleController.text.trim(),
      "url": url,
    };

    final order = int.tryParse(displayOrderController.text.trim());
    if (order != null) {
      data["order"] = order;
    }

    bool success;

    if (widget.isEdit && widget.link?.id != null) {
      success = await viewModel.updateImportantLink(widget.link!.id!, data);
    } else {
      success = await viewModel.createImportantLink(data);
    }

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      _showMessage(
        widget.isEdit ? "Link updated successfully" : "Link added successfully",
      );
      Navigator.pop(context, true);
    } else {
      _showMessage(
        viewModel.errorMessage ??
            (widget.isEdit ? "Failed to update link" : "Failed to add link"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: widget.isEdit ? "Edit Link" : "Add New Link",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              top: AppSizes.screenPadding,
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextBodyStyleWidget(
                              title: "Link Title*",
                              color: color.primary,
                              size: AppSizes.sectionTitle,
                            ),
                            SizedBox(height: AppSizes.appbarGap),
                            CustomTextFieldWidget(
                              hintText: "e.g. Original Website",
                              controller: linkTitleController,
                            ),
                            SizedBox(height: AppSizes.itemGap),
                            TextBodyStyleWidget(
                              title: "URL*",
                              color: color.primary,
                              size: AppSizes.sectionTitle,
                            ),
                            SizedBox(height: AppSizes.appbarGap),
                            CustomTextFieldWidget(
                              hintText: "https://example.com",
                              controller: urlController,
                            ),
                            SizedBox(height: AppSizes.itemGap),
                            TextBodyStyleWidget(
                              title: "Display Order",
                              color: color.primary,
                              size: AppSizes.sectionTitle,
                            ),
                            SizedBox(height: AppSizes.appbarGap),
                            CustomTextFieldWidget(
                              hintText: "1",
                              controller: displayOrderController,
                              isInputOnlyNumber: true,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSizes.sectionGap),

                      // Save Button
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
                              text: isSaving
                                  ? (widget.isEdit
                                  ? "Updating..."
                                  : "Saving...")
                                  : (widget.isEdit ? "Update" : "Save"),
                              onTap: isSaving ? () {} : _handleSave,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.sectionGap),
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