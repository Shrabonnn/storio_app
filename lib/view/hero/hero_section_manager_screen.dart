import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/utils/app_sizes.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/universal/custom_app_bar.dart';
import 'package:storio_app/widget/universal/custom_status_badge.dart';
import 'package:storio_app/widget/universal/search_text_field.dart';

import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../widget/hero/preview_mode_button_row.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/custom_card.dart';

class HeroSectionManagerScreen extends StatefulWidget {
  const HeroSectionManagerScreen({super.key});

  @override
  State<HeroSectionManagerScreen> createState() =>
      _HeroSectionManagerScreenState();
}

class _HeroSectionManagerScreenState extends State<HeroSectionManagerScreen> {

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
    final color = context.Appcolor;
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
                              onChanged:(value){},
                              hinText: "Search by heading",
                              controller: searchController,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSizes.sectionGap,),

                      //
                      CustomCard(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: 222.w,
                            child: Column(
                              children: [

                                // ================= HEADER =================
                                Container(
                                  height: 4.5.h,
                                  decoration: BoxDecoration(
                                    color: color.primary.withOpacity(0.06),
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [

                                      SizedBox(
                                        width: 14.w,
                                        child: Center(
                                          child: Checkbox(
                                            value: false,
                                            onChanged: (value) {},
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        width: 110.w,
                                        child: Text(
                                          "SUPER CONTENT",
                                          style: TextStyle(
                                            color: color.primary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        width: 38.w,
                                        child: Text(
                                          "BUTTON & LINK",
                                          style: TextStyle(
                                            color: color.primary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        width: 25.w,
                                        child: Text(
                                          "STATUS",
                                          style: TextStyle(
                                            color: color.primary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),

                                      SizedBox(
                                        width: 31.w,
                                        child: Text(
                                          "ACTIONS",
                                          style: TextStyle(
                                            color: color.primary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: 2,
                                    itemBuilder: (context,index){
                                  return _superContentRow(
                                    context: context,
                                    image: 'assets/images/institute.png',
                                    title: 'Hill View',
                                    subtitle: 'A catchy subheading goes here.Testing',
                                    buttonText: 'View More',
                                  );
                                })


                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSizes.sectionGap,),


                      // Frontend Preview
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          TextTitleWidget(title: "Frontend Preview",color: color.primary,),
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
                      SizedBox(height: AppSizes.sectionGap,),
                      SizedBox(height: AppSizes.sectionGap,),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(


            heroTag: "add",
            backgroundColor: color.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.add_new_hero_slide);

            },
            child:  Icon(
              Icons.add,
              color: color.cardBackground,
            ),
          ),
        ],
      ),
    );
  }
}
Widget _superContentRow({
  required BuildContext context,
  required String image,
  required String title,
  required String subtitle,
  required String buttonText,
}) {
  final color = context.Appcolor;
  return Container(
    height: 8.5.h,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.shade200,
        ),
      ),
    ),
    child: Row(
      children: [

        // Checkbox
        SizedBox(
          width: 14.w,
          child: Center(
            child: Checkbox(
              value: false,
              onChanged: (value) {

              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),

        //Super content
        SizedBox(
          width: 110.w,
          child: Row(
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  image,
                  width: 10.w,
                  height: 5.h,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: 2.w),

              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    TextTitleWidget(title: title,color: color.primary,maxLines: 1,),

                    SizedBox(height: AppSizes.appbarGap),

                    TextBodyStyleWidget(title: subtitle,maxLines: 1,)
                  ],
                ),
              ),
            ],
          ),
        ),

        //Button link
        SizedBox(
          width: 36.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              TextTitleWidget(title: buttonText,color: color.primary,maxLines: 1,),

              SizedBox(height: AppSizes.appbarGap),

              TextBodyStyleWidget(title: "https://diu.storio.cloud/info",maxLines: 1,)
            ],
          ),
        ),
        SizedBox(width: 2.w,),

        // status
        SizedBox(
          width: 25.w,
          child: Align(
            alignment: Alignment.centerLeft,
            child: CustomStatusBadge(title: "ACTIVE"),
          ),
        ),

        // Action button
        SizedBox(
          width: 31.w,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [

              // Edit
              GestureDetector(
              onTap: () {},
              child: Icon(
              Icons.edit, size: AppSizes.iconLarge,
              color: color.primary,)),

              SizedBox(width: 2.w),

              // Copy
              GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.copy, size: AppSizes.iconLarge,
                    color: Colors.grey,)),

              SizedBox(width: 2.w),

              // Delete
              GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.delete_outline_outlined, size: AppSizes.iconLarge,
                    color: Colors.red,)),
            ],
          ),
        ),
      ],
    ),
  );
}