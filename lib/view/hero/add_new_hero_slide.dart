import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/viewModel/hero_view_model.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';

import '../../data/model/hero/hero_slide_model.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/hero_slide_view_model.dart';
import '../../widget/hero/color_picket_dialog_widget.dart';
import '../../widget/universal/custom_app_bar.dart';

class AddNewHeroSlide extends StatefulWidget {
  final HeroSlideModel? heroSlide;

  const AddNewHeroSlide({super.key, this.heroSlide});

  @override
  State<AddNewHeroSlide> createState() => _AddNewHeroSlideState();
}

class _AddNewHeroSlideState extends State<AddNewHeroSlide> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _buttonTextController = TextEditingController();
  final TextEditingController _buttonLinkController = TextEditingController();

  // ---- Background image (picked from Media Library) ----
  int? _selectedImageId;
  String? _selectedImageUrl;

  // ---- Edit-mode state ----
  HeroSlideModel? _editingSlide;
  bool _saving = false;

  bool get isEditMode => _editingSlide != null;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hydrateFromExistingSlide();
    });
  }

  void _hydrateFromExistingSlide() {
    HeroSlideModel? slide = widget.heroSlide;

    if (slide == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args['heroSlide'] is HeroSlideModel) {
        slide = args['heroSlide'] as HeroSlideModel;
      }
    }

    if (slide == null) return; // Add mode — nothing to prefill

    setState(() {
      _editingSlide = slide;
      _selectedImageUrl = slide!.bgImageData?.file ?? slide.bgImageUrl;
    });

    _titleController.text = slide.heading ?? '';
    _subtitleController.text = slide.subheading ?? '';
    _buttonTextController.text = slide.buttonText ?? '';
    _buttonLinkController.text = slide.buttonLink ?? '';

    final heroProvider = context.read<HeroProvider>();
    heroProvider.setTitle(slide.heading ?? '');
    heroProvider.setSubtitle(slide.subheading ?? '');
    heroProvider.setButtonText(slide.buttonText ?? '');
    heroProvider.setColor(_hexToColor(slide.bgColor, fallback: Colors.blue));
    heroProvider.setTitleColor(
      _hexToColor(slide.headingColor, fallback: Colors.white),
    );
    heroProvider.setSubtitleColor(
      _hexToColor(slide.subheadingColor, fallback: const Color(0xFFE0E0E0)),
    );
    heroProvider.setButtonTextColor(
      _hexToColor(slide.buttonTextColor, fallback: Colors.white),
    );
    heroProvider.setButtonBackgroundColor(
      _hexToColor(slide.buttonColor, fallback: const Color(0xFF4F46E5)),
    );
  }

  Color _hexToColor(String? hex, {required Color fallback}) {
    if (hex == null || hex.isEmpty) return fallback;
    var cleaned = hex.replaceAll('#', '').trim();
    if (cleaned.length == 6) cleaned = 'FF$cleaned';
    try {
      return Color(int.parse(cleaned, radix: 16));
    } catch (_) {
      return fallback;
    }
  }

  String _colorToHex(Color c) {
    return '#${c.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  // ============================================================
  // Pick Background Image From Media Library
  // ============================================================

  Future<void> _pickBackgroundImage() async {
    final result = await Navigator.pushNamed(
      context,
      RoutesName.media_manage_details,
      arguments: {
        "currentId": _selectedImageId,
        "currentFileUrl": _selectedImageUrl,
      },
    );

    if (!mounted) return;

    if (result is Map<String, dynamic>) {
      setState(() {
        _selectedImageId = result['id'] as int?;
        _selectedImageUrl = result['file'] as String?;
      });
    }
  }

  void _removeBackgroundImage() {
    setState(() {
      _selectedImageId = null;
      _selectedImageUrl = null;
    });
  }

  Future<void> _handleSave() async {
    if (_saving) return;

    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Heading is required")),
      );
      return;
    }

    final heroProvider = context.read<HeroProvider>();

    setState(() => _saving = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final hasImage = _selectedImageUrl != null;
      final bgType = hasImage ? "image" : "color";

      final data = <String, dynamic>{
        "heading": _titleController.text.trim(),
        "subheading": _subtitleController.text.trim(),
        "buttonText": _buttonTextController.text.trim(),
        "buttonLink": _buttonLinkController.text.trim(),
        "bgType": bgType,
        "headingColor": _colorToHex(heroProvider.titleColor),
        "subheadingColor": _colorToHex(heroProvider.subtitleColor),
        "buttonColor": _colorToHex(heroProvider.buttonBackgroundColor),
        "buttonTextColor": _colorToHex(heroProvider.buttonTextColor),
      };

      if (bgType == "color") {
        data["bgColor"] = _colorToHex(heroProvider.selectedColor);
      } else if (_selectedImageId != null) {
        data["bgImage"] = _selectedImageId;
      }

      final heroSlideProvider = context.read<HeroSlideViewModel>();

      final success = isEditMode
          ? await heroSlideProvider.updateHeroSlide(_editingSlide!.id!, data)
          : await heroSlideProvider.createHeroSlide(data);

      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog

      if (success) {
        Navigator.pop(context, true); // Return success to refresh list screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              heroSlideProvider.managementErrorMessage ??
                  "Failed to save hero slide",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: $e")),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
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
            title: isEditMode ? "Edit Slide" : "Add New Slide",
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE
                      Row(
                        children: [
                          TextTitleWidget(
                            title: "Title",
                            color: color.primary,
                          ),
                          SizedBox(width: AppSizes.sectionGap),
                          GestureDetector(
                            onTap: showTitleColorPicker,
                            child: Icon(
                              Icons.color_lens_outlined,
                              size: AppSizes.icon,
                              color: color.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.appbarGap),
                      TextField(
                        controller: _titleController,
                        onChanged: (value) => heroProvider.setTitle(value),
                        decoration: InputDecoration(
                          hintText: "Enter hero title",
                          hintStyle: TextStyle(color: color.primary),
                        ),
                      ),
                      SizedBox(height: AppSizes.itemGap),

                      // SUBTITLE
                      Row(
                        children: [
                          TextTitleWidget(
                            title: "SubTitle",
                            color: color.primary,
                          ),
                          SizedBox(width: AppSizes.sectionGap),
                          GestureDetector(
                            onTap: showSubTitleColorPicker,
                            child: Icon(
                              Icons.color_lens_outlined,
                              size: AppSizes.icon,
                              color: color.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.appbarGap),
                      TextField(
                        controller: _subtitleController,
                        onChanged: (value) => heroProvider.setSubtitle(value),
                        decoration: InputDecoration(
                          hintText: "Enter hero subtitle",
                          hintStyle: TextStyle(color: color.primary),
                        ),
                      ),
                      SizedBox(height: AppSizes.itemGap),

                      // BUTTON TEXT
                      Row(
                        children: [
                          TextTitleWidget(
                            title: "Button Text",
                            color: color.primary,
                          ),
                          SizedBox(width: AppSizes.sectionGap),
                          GestureDetector(
                            onTap: showButtonTextColorPicker,
                            child: Icon(
                              Icons.color_lens_outlined,
                              size: AppSizes.icon,
                              color: color.primary,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: showButtonBackgroundColorPicker,
                            child: TextBodyStyleWidget(
                              title: "Background Color",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.appbarGap),
                      TextField(
                        controller: _buttonTextController,
                        onChanged: (value) => heroProvider.setButtonText(value),
                        decoration: InputDecoration(
                          hintText: "Example: Explore Now",
                          hintStyle: TextStyle(color: color.primary),
                        ),
                      ),
                      SizedBox(height: AppSizes.itemGap),

                      // BUTTON LINK
                      TextTitleWidget(
                        title: "Button Link",
                        color: color.primary,
                      ),
                      SizedBox(height: AppSizes.appbarGap),
                      TextField(
                        controller: _buttonLinkController,
                        decoration: InputDecoration(
                          hintText: "https://example.com",
                          hintStyle: TextStyle(color: color.primary),
                        ),
                      ),

                      SizedBox(height: AppSizes.sectionGap),

                      // BACKGROUND
                      TextTitleWidget(
                        title: "Background",
                        color: color.primary,
                      ),
                      SizedBox(height: AppSizes.appbarGap),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: "Choose From Media Library",
                              icon: Icons.image_outlined,
                              onTap: _pickBackgroundImage,
                            ),
                          ),
                          SizedBox(width: AppSizes.smallGap),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: showColorPicker,
                              icon: Icon(
                                Icons.palette_outlined,
                                color: color.primary,
                                size: AppSizes.icon,
                              ),
                              label: TextBodyStyleWidget(
                                title: "Select Color",
                                color: color.primary,
                                size: AppSizes.cardTitle,
                              ),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSizes.buttonRadius,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (_selectedImageUrl != null) ...[
                        SizedBox(height: AppSizes.smallGap),
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text("Image selected"),
                            ),
                            TextButton(
                              onPressed: _removeBackgroundImage,
                              child: const Text("Remove"),
                            ),
                          ],
                        ),
                      ],

                      SizedBox(height: AppSizes.sectionGap),

                      // PREVIEW (Matches Frontend Carousel Slide Design)
                      const Text(
                        "Preview",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSizes.appbarGap),

                      Consumer<HeroProvider>(
                        builder: (context, provider, child) {
                          final hasImage = _selectedImageUrl != null;

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: double.infinity,
                              height: 260,
                              decoration: BoxDecoration(
                                color: provider.selectedColor,
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Background Image Layer
                                  if (hasImage)
                                    Image.network(
                                      _selectedImageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Image.asset(
                                            'assets/images/institute.png',
                                            fit: BoxFit.cover,
                                          ),
                                    )
                                  else if (_selectedImageUrl == null &&
                                      provider.selectedColor == Colors.transparent)
                                    Image.asset(
                                      'assets/images/institute.png',
                                      fit: BoxFit.cover,
                                    ),

                                  // Dark Scrim Overlay for Legibility (Exact match with Manager screen)
                                  Container(
                                    color: Colors.black.withOpacity(0.22),
                                  ),

                                  // Card Content Layer
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            provider.title.isEmpty
                                                ? "Your Title Here"
                                                : provider.title,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: provider.titleColor,
                                              fontSize: 24,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          if (provider.subtitle.isNotEmpty ||
                                              provider.title.isEmpty) ...[
                                            const SizedBox(height: 8),
                                            Text(
                                              provider.subtitle.isEmpty
                                                  ? "Your subtitle will appear here"
                                                  : provider.subtitle,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: provider.subtitleColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                          if (provider.buttonText.isNotEmpty ||
                                              provider.title.isEmpty) ...[
                                            const SizedBox(height: 16),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 24,
                                                vertical: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: provider.buttonBackgroundColor,
                                                borderRadius:
                                                BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                provider.buttonText.isEmpty
                                                    ? "Button"
                                                    : provider.buttonText,
                                                style: TextStyle(
                                                  color: provider.buttonTextColor,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: AppSizes.sectionGap),

                      // SAVE / UPDATE BUTTON
                      CustomButton(
                        text: _saving
                            ? "Saving..."
                            : (isEditMode ? "Update Slide" : "Save Slide"),
                        onTap: _handleSave,
                      ),
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
        return Consumer<HeroProvider>(builder: (context, heroProvider, child) {
          return ColorPicketDialog(
            title: "Select Background Color",
            selectedColor: heroProvider.selectedColor,
            onColorSelected: (color) {
              heroProvider.setColor(color);
            },
          );
        });
      },
    );
  }

  void showTitleColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<HeroProvider>(builder: (context, heroProvider, child) {
          return ColorPicketDialog(
            title: "Select Title Color",
            selectedColor: heroProvider.titleColor,
            onColorSelected: (color) {
              heroProvider.setTitleColor(color);
            },
          );
        });
      },
    );
  }

  void showSubTitleColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<HeroProvider>(builder: (context, heroProvider, child) {
          return ColorPicketDialog(
            title: "Select SubTitle Color",
            selectedColor: heroProvider.subtitleColor,
            onColorSelected: (color) {
              heroProvider.setSubtitleColor(color);
            },
          );
        });
      },
    );
  }

  void showButtonTextColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<HeroProvider>(builder: (context, heroProvider, child) {
          return ColorPicketDialog(
            title: "Select Button Text Color",
            selectedColor: heroProvider.buttonTextColor,
            onColorSelected: (color) {
              heroProvider.setButtonTextColor(color);
            },
          );
        });
      },
    );
  }

  void showButtonBackgroundColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<HeroProvider>(builder: (context, heroProvider, child) {
          return ColorPicketDialog(
            title: "Select Button Background Color",
            selectedColor: heroProvider.buttonBackgroundColor,
            onColorSelected: (color) {
              heroProvider.setButtonBackgroundColor(color);
            },
          );
        });
      },
    );
  }
}