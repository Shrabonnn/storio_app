import 'package:flutter/material.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/utils/sizes.dart';
import 'package:storio_app/widget/universal/custom_app_bar.dart';
import 'package:storio_app/widget/universal/search_text_field.dart';

import '../../widget/hero/preview_mode_button_row.dart';
import '../../widget/textStyle/text_title_style.dart';

class HeroSectionManagerScreen extends StatefulWidget {
  const HeroSectionManagerScreen({super.key});

  @override
  State<HeroSectionManagerScreen> createState() =>
      _HeroSectionManagerScreenState();
}

class _HeroSectionManagerScreenState
    extends State<HeroSectionManagerScreen> {

  final TextEditingController searchController =
  TextEditingController();

  int selectedPreviewIndex = 0;

  final List<String> previewModes = [
    "Desktop",
    "Tablet",
    "Mobile",
  ];

  final List<IconData> previewIcons = [
    Icons.desktop_windows,
    Icons.tablet,
    Icons.phone_android,
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Hero Section Manager",
            showBackButton: true,
          ),

          SliverPadding(
            padding: EdgeInsets.only(
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
              top: AppSizes.screenPadding,
            ),

            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    crossAxisAlignment: .start,
                    children: [

                      // Search
                      Row(
                        children: [
                          Expanded(
                            child: SearchTextField(
                              hinText: "Search by heading",
                              controller: searchController,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: AppSizes.sectionGap,
                      ),
                      TextTitleWidget(title: "Frontend Preview",color: AppColors.primary,),
                      SizedBox(height: AppSizes.appbarGap,),


                      PreviewModeButtonRow(
                        items: previewModes,
                        icons: previewIcons,
                        selectedIndex: selectedPreviewIndex,
                        onSelected: (index) {
                          setState(() {
                            selectedPreviewIndex = index;
                          });
                        },
                      ),

                      SizedBox(
                        height: AppSizes.sectionGap,
                      ),

                      if (selectedPreviewIndex == 0) ...[
                        Center(
                          child: Container(
                            width: 800,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                            ),
                            child: AspectRatio(
                              aspectRatio: 16 / 7,
                              child: Image.asset(
                                'assets/images/institute.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ]

                      else if (selectedPreviewIndex == 1) ...[
                        Center(
                          child: Container(
                            width: 550,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                            ),
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: Image.asset(
                                'assets/images/institute.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ]

                      else if (selectedPreviewIndex == 2) ...[
                          Center(
                            child: Container(
                              width: 320,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                              ),
                              child: AspectRatio(
                                aspectRatio: 9 / 16,
                                child: Image.asset(
                                  'assets/images/institute.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ]
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