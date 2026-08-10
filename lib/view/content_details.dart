import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:sizer/sizer.dart';

import '../utils/sizes.dart';
import '../widget/universal/custom_app_bar.dart';
import '../widget/universal/custom_card.dart';

class ContentDetails extends StatefulWidget {
  const ContentDetails({super.key});

  @override
  State<ContentDetails> createState() => _ContentDetailsState();
}

class _ContentDetailsState extends State<ContentDetails> {
  late QuillController _contentController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _contentController = QuillController.basic();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);


    final content = _contentController.document.toPlainText();
    debugPrint("Saving content: $content");

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Content saved successfully",
          style: TextStyle(fontSize: AppSizes.body),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSaving ? null : _handleSave,
        icon: _isSaving
            ? SizedBox(
          width: AppSizes.iconSmall,
          height: AppSizes.iconSmall,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Icon(Icons.save_outlined, size: AppSizes.icon),
        label: Text(
          _isSaving ? "Saving..." : "Save",
          style: TextStyle(fontSize: AppSizes.buttonText),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Content Manage",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverFillRemaining(
              hasScrollBody: false,
              child: CustomCard(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenHeight * 0.55,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Toolbar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppSizes.cardRadius),
                            topRight: Radius.circular(AppSizes.cardRadius),
                          ),
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.smallPadding,
                          vertical: AppSizes.smallPadding / 2,
                        ),
                        child: QuillSimpleToolbar(
                          controller: _contentController,
                          config: QuillSimpleToolbarConfig(
                            multiRowsDisplay: true,
                            showDividers: true,
                            toolbarRunSpacing: AppSizes.smallPadding / 2,
                            toolbarIconAlignment: WrapAlignment.start,

                            // Text
                            showFontFamily: true,
                            showFontSize: true,

                            // Basic formatting
                            showBoldButton: true,
                            showItalicButton: true,
                            showUnderLineButton: true,
                            showStrikeThrough: true,

                            // Script
                            showSubscript: true,
                            showSuperscript: true,

                            // Color
                            showColorButton: true,
                            showBackgroundColorButton: true,

                            // Clear formatting
                            showClearFormat: true,

                            // Heading
                            showHeaderStyle: true,

                            // Alignment
                            showAlignmentButtons: true,
                            showLeftAlignment: true,
                            showCenterAlignment: true,
                            showRightAlignment: true,
                            showJustifyAlignment: true,

                            // Lists
                            showListNumbers: true,
                            showListBullets: true,
                            showListCheck: true,

                            // Code / Quote
                            showInlineCode: true,
                            showCodeBlock: true,
                            showQuote: true,

                            // Indent
                            showIndent: true,

                            // Link
                            showLink: true,

                            // History
                            showUndo: true,
                            showRedo: true,

                            // Search
                            showSearchButton: true,

                            // Direction
                            showDirection: true,
                          ),
                        ),
                      ),

                      // Editor
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.contentPadding,
                          ),
                          child: QuillEditor.basic(
                            controller: _contentController,
                            config: QuillEditorConfig(
                              placeholder:
                              "Write the full activity content here...",
                              padding: EdgeInsets.all(AppSizes.contentPadding),
                              scrollable: true,
                              expands: true,
                              autoFocus: false,
                              customStyles: DefaultStyles(
                                paragraph: DefaultTextBlockStyle(
                                  TextStyle(
                                    fontSize: AppSizes.body,
                                    height: 1.5,
                                    color: Colors.black87,
                                  ),
                                  const HorizontalSpacing(0, 0),
                                  const VerticalSpacing(6, 0),
                                  const VerticalSpacing(0, 0),
                                  null,
                                ),
                                placeHolder: DefaultTextBlockStyle(
                                  TextStyle(
                                    fontSize: AppSizes.body,
                                    color: Colors.grey.shade500,
                                  ),
                                  const HorizontalSpacing(0, 0),
                                  const VerticalSpacing(6, 0),
                                  const VerticalSpacing(0, 0),
                                  null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}