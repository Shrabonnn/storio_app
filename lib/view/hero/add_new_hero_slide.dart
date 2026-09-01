import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/viewModel/hero_view_model.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';

import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../widget/hero/color_picket_dialog_widget.dart';
import '../../widget/universal/custom_app_bar.dart';

class AddNewHeroSlide extends StatefulWidget {
  const AddNewHeroSlide({super.key});

  @override
  State<AddNewHeroSlide> createState() => _AddNewHeroSlideState();
}

class _AddNewHeroSlideState extends State<AddNewHeroSlide> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _subtitleController = TextEditingController();

  final TextEditingController _buttonTextController = TextEditingController();

  final TextEditingController _buttonLinkController = TextEditingController();

  File? selectedImage;
  Color selectedColor = Colors.blue;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {

      context.read<HeroProvider>().setImage(
        File(image.path)
      );

    }
  }

  void selectColor(Color color) {
    context.read<HeroProvider>().setColor(color);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _buttonTextController.dispose();
    _buttonLinkController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final color = context.Appcolor;
    final heroProvider = context.watch<HeroProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Add New Slide",
            showBackButton: true,
          ),

          SliverPadding(
            padding: EdgeInsets.only(
              left: AppSizes.screenPadding,
              right: AppSizes.screenPadding,
              top: AppSizes.screenPadding,
              bottom: 30,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Column(
                        crossAxisAlignment: .start,
                        children: [

                          // TITLE
                          Row(
                            //mainAxisAlignment: .spaceBetween,
                            children: [
                              TextTitleWidget(title: "Title",color: color.primary,),
                              SizedBox(width: AppSizes.sectionGap,),
                              GestureDetector(
                                onTap: showTitleColorPicker,
                                  child: Icon(Icons.color_lens_outlined,size: AppSizes.icon,color: color.primary,))
                            ],
                          ),

                          SizedBox(height: AppSizes.appbarGap),

                          TextField(
                            controller: _titleController,
                            onChanged: (value) {
                              heroProvider.setTitle(value);
                            },
                            decoration: const InputDecoration(
                              hintText: "Enter hero title",

                            ),
                          ),

                          SizedBox(height: AppSizes.itemGap),

                          // SUBTITLE


                          Row(
                            //mainAxisAlignment: .spaceBetween,
                            children: [
                              TextTitleWidget(title: "SubTitle",color: color.primary,),
                              SizedBox(width: AppSizes.sectionGap,),
                              GestureDetector(
                                  onTap: showSubTitleColorPicker,
                                  child: Icon(Icons.color_lens_outlined,size: AppSizes.icon,color: color.primary,))
                            ],
                          ),
                          SizedBox(height: AppSizes.appbarGap),

                          TextField(
                            controller: _subtitleController,
                            onChanged: (value) {
                              heroProvider.setSubtitle(value);
                            },
                            decoration: const InputDecoration(
                              hintText: "Enter hero subtitle",

                            ),
                          ),

                          SizedBox(height: AppSizes.itemGap),


                          // BUTTON TEXT

                          Row(
                            //mainAxisAlignment: .spaceBetween,
                            children: [
                              TextTitleWidget(title: "Button Text",color: color.primary,),
                              SizedBox(width: AppSizes.sectionGap,),
                              GestureDetector(
                                  onTap: showButtonTextColorPicker,
                                  child: Icon(Icons.color_lens_outlined,size: AppSizes.icon,color: color.primary,)),
                              Spacer(),
                              GestureDetector(
                                  onTap: showButtonBackgroundColorPicker,
                                  child:TextBodyStyleWidget(title: "Background Color"))
                            ],
                          ),
                          SizedBox(height: AppSizes.appbarGap),

                          TextField(
                            controller: _buttonTextController,
                            onChanged: (value) {
                              heroProvider.setButtonText(value);
                            },
                            decoration: const InputDecoration(
                              hintText: "Example: Explore Now",

                            ),
                          ),

                          SizedBox(height: AppSizes.itemGap),


                          // BUTTON LINK


                          TextTitleWidget(title: "Button Link",color: color.primary,),

                          SizedBox(height: AppSizes.appbarGap),

                          TextField(
                            controller: _buttonLinkController,
                            decoration: const InputDecoration(
                              hintText: "https://example.com",

                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSizes.sectionGap),


                      // BACKGROUND
                      TextTitleWidget(title: "Background",color: color.primary,),

                      SizedBox(height: AppSizes.appbarGap),

                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                                text: "Upload Image",
                                icon: Icons.image_outlined,
                                onTap: pickImage),
                          ),

                           SizedBox(width: AppSizes.smallGap),

                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: showColorPicker,
                              icon:  Icon(
                                Icons.palette_outlined,
                                color: color.primary,
                                size: AppSizes.icon,
                              ),
                              label: TextBodyStyleWidget(title: "Select Color",color: color.primary,size: AppSizes.cardTitle,),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (heroProvider.selectedImage != null) ...[
                         SizedBox(height: AppSizes.smallGap),

                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),

                            const SizedBox(width: 8),

                            const Expanded(
                              child: Text(
                                "Image selected",
                              ),
                            ),

                            TextButton(
                              onPressed: () {
                                heroProvider.removeImage();
                              },
                              child: const Text("Remove"),
                            ),
                          ],
                        ),
                      ],

                       SizedBox(height: AppSizes.sectionGap),


                      // PREVIEW


                      const Text(
                        "Preview",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                       SizedBox(height: AppSizes.appbarGap),

                      Consumer<HeroProvider>(
                        builder: (context, heroProvider, child) {
                          return Container(
                            width: double.infinity,
                            height: 280,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),

                              color: heroProvider.selectedColor,

                              image: heroProvider.selectedImage != null
                                  ? DecorationImage(
                                image: FileImage(heroProvider.selectedImage!),
                                fit: BoxFit.cover,
                              )
                                  : null,
                            ),

                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),

                                gradient: heroProvider.selectedImage != null
                                    ? LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.2),
                                    Colors.black.withOpacity(0.7),
                                  ],
                                )
                                    : null,
                              ),

                              padding: const EdgeInsets.all(24),

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    heroProvider.title.isEmpty
                                        ? "Your Title"
                                        : heroProvider.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: heroProvider.titleColor,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  Text(
                                    heroProvider.subtitle.isEmpty
                                        ? "Your subtitle will appear here"
                                        : heroProvider.subtitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: heroProvider.subtitleColor,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  CustomButton(
                                    width:40.w,
                                    text: heroProvider.buttonText.isEmpty ? "Button" : heroProvider.buttonText,
                                    onTap: (){},
                                    foregroundColor: heroProvider.buttonTextColor,
                                    backgroundColor: heroProvider.buttonBackgroundColor,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                       SizedBox(height: AppSizes.sectionGap),


                      // SAVE BUTTON


                      CustomButton(text: "Save"
                        ,onTap: () {
                          debugPrint(
                            "Title: ${_titleController.text}",
                          );

                          debugPrint(
                            "Subtitle: ${_subtitleController.text}",
                          );

                          debugPrint(
                            "Button Text: "
                                "${_buttonTextController.text}",
                          );

                          debugPrint(
                            "Button Link: "
                                "${_buttonLinkController.text}",
                          );

                          debugPrint(
                            "Selected Image: $selectedImage",
                          );

                          debugPrint(
                            "Selected Color: $selectedColor",
                          );

                      }),
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

  void showColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<HeroProvider>(builder: (context,heroProvider ,child){
          return ColorPicketDialog(title: "Select Background Color",
              selectedColor: heroProvider.selectedColor,
              onColorSelected: (color){
                heroProvider.setColor(color);
              });
        });
      },
    );
  }
  void showTitleColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<HeroProvider>(builder: (context,heroProvider ,child){
          return ColorPicketDialog(title: "Select Title Color",
              selectedColor: heroProvider.titleColor,
              onColorSelected: (color){
                heroProvider.setTitleColor(color);
              });
        });
      },
    );
  }
  void showSubTitleColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<HeroProvider>(builder: (context,heroProvider ,child){
          return ColorPicketDialog(title: "Select SubTitle Color",
              selectedColor: heroProvider.subtitleColor,
              onColorSelected: (color){
                heroProvider.setSubtitleColor(color);
              });
        });
      },
    );
  }
  void showButtonTextColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<HeroProvider>(builder: (context,heroProvider ,child){
          return ColorPicketDialog(title: "Select Button Text Color",
              selectedColor: heroProvider.buttonTextColor,
              onColorSelected: (color){
                heroProvider.setButtonTextColor(color);
              });
        });
      },
    );
  }
  void showButtonBackgroundColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<HeroProvider>(builder: (context,heroProvider ,child){
          return ColorPicketDialog(title: "Select Button Text Color",
              selectedColor: heroProvider.buttonBackgroundColor,
              onColorSelected: (color){
                heroProvider.setButtonBackgroundColor(color);
              });
        });
      },
    );
  }
}
