import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_colors.dart';

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
          style: TextStyle(fontSize: AppSizes.cardTitle),
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
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
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
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: AppSizes.cardSubTitle),
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
                            showDividers: false,

                            toolbarRunSpacing: AppSizes.smallPadding / 2,
                            toolbarIconAlignment: WrapAlignment.spaceBetween,
                            toolbarIconCrossAlignment: WrapCrossAlignment.center,

                            // TEXT

                            showFontFamily: true,
                            showFontSize: true,

                            // Font sizes
                            buttonOptions: QuillSimpleToolbarButtonOptions(
                              fontSize: QuillToolbarFontSizeButtonOptions(
                                items: const {
                                  '12': '12',
                                  '13': '13',
                                  '14': '14',
                                  '15': '15',
                                  '16': '16',
                                  '18': '18',
                                  '20': '20',
                                  '24': '24',
                                  '28': '28',
                                  '32': '32',
                                },
                              ),
                            ),


                            // BASIC FORMATTING

                            showBoldButton: true,
                            showItalicButton: true,
                            showUnderLineButton: true,
                            showStrikeThrough: true,




                            // COLOR

                            showColorButton: false,
                            showBackgroundColorButton: false,


                            // HEADING

                            showHeaderStyle: true,


                            // ALIGNMENT

                            showAlignmentButtons: true,
                            showLeftAlignment: true,
                            showCenterAlignment: true,
                            showRightAlignment: true,
                            showJustifyAlignment: true,


                            // LIST

                            showListNumbers: true,
                            showListBullets: true,
                            showListCheck: true,


                            // INDENT

                            showIndent: true,


                            // LINK

                            showLink: true,


                            // HISTORY

                            showUndo: true,
                            showRedo: true,


                            // SEARCH

                            showSearchButton: true,


                            // REMOVE THESE

                            showSubscript: true,
                            showSuperscript: true,
                            showInlineCode: true,
                            showCodeBlock: true,
                            showQuote: true,
                            showDirection: false,

                            // Clipboard buttons
                            showClipboardCut: true,
                            showClipboardCopy: true,
                            showClipboardPaste: true,


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
                                    fontSize: AppSizes.cardSubTitle,
                                    height: 1.5,
                                    color: Colors.black87,
                                  ),
                                  const HorizontalSpacing(0, 0),
                                  const VerticalSpacing(3, 0),
                                  const VerticalSpacing(0, 0),
                                  null,
                                ),
                                placeHolder: DefaultTextBlockStyle(
                                  TextStyle(
                                    fontSize: AppSizes.sectionTitle,
                                    color: Colors.grey.shade500,
                                  ),
                                  const HorizontalSpacing(0, 0),
                                  const VerticalSpacing(3, 0),
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