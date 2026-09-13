import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/custom_card.dart';

import '../../utils/app_sizes.dart';
import '../../utils/snackbar_message.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/faq_view_model.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_text_field.dart';

class CreateNewFaq extends StatefulWidget {
  const CreateNewFaq({super.key});

  @override
  State<CreateNewFaq> createState() => _CreateNewFaqState();
}

class _CreateNewFaqState extends State<CreateNewFaq> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  bool isVisible = true;
  bool isSaving = false;

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    SnackBarMessage.showSnackBar(context, message);
  }

  // ============================================================
  // Create FAQ
  // ============================================================

  Future<void> _handleCreateFaq() async {
    if (questionController.text.trim().isEmpty) {
      _showMessage("Please enter a question");
      return;
    }

    if (answerController.text.trim().isEmpty) {
      _showMessage("Please enter an answer");
      return;
    }

    final viewModel = context.read<FaqViewModel>();

    setState(() {
      isSaving = true;
    });

    final success = await viewModel.createFaq({
      "question": questionController.text.trim(),
      "answer": answerController.text.trim(),
      "is_visible": isVisible,
    });

    if (!mounted) return;

    setState(() {
      isSaving = false;
    });

    if (success) {
      _showMessage("FAQ created successfully");
      Navigator.pop(context, true);
    } else {
      _showMessage(viewModel.errorMessage ?? "Failed to create FAQ");
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Create FAQ",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    // ==================================================
                    // Question / Answer
                    // ==================================================

                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBodyStyleWidget(
                            title: "Question*",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "e.g. How do I reset my password?",
                            controller: questionController,
                            maxLines: 2,
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          TextBodyStyleWidget(
                            title: "Answer*",
                            color: color.primary,
                            size: AppSizes.cardTitle,
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          CustomTextFieldWidget(
                            hintText: "Write the answer here...",
                            controller: answerController,
                            minLines: 6,
                            maxLines: 6,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.sectionGap),

                    // ==================================================
                    // Visibility
                    // ==================================================

                    CustomCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextBodyStyleWidget(
                              title: "Visible to public",
                              color: color.primary,
                              size: AppSizes.cardTitle,
                            ),
                          ),
                          Switch(
                            value: isVisible,
                            activeColor: color.primary,
                            onChanged: (value) {
                              setState(() {
                                isVisible = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSizes.itemGap),

                    // ==================================================
                    // Buttons
                    // ==================================================

                    Row(
                      children: [
                        CustomButton(
                          text: "Cancel",
                          onTap: () {
                            Navigator.pop(context);
                          },
                          height: 4.5.h,
                          width: 30.w,
                          backgroundColor: color.cardBackground,
                          foregroundColor: color.primary,
                        ),
                        SizedBox(width: AppSizes.appbarGap),
                        Flexible(
                          child: CustomButton(
                            text: isSaving ? "Creating..." : "Create FAQ",
                            onTap: isSaving ? () {} : _handleCreateFaq,
                            height: 4.5.h,
                          ),
                        ),
                      ],
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