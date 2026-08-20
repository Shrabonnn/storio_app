import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../utils/sizes.dart';
import '../../widget/universal/custom_app_bar.dart';

class AddNewHeroSlide extends StatefulWidget {
  const AddNewHeroSlide({super.key});

  @override
  State<AddNewHeroSlide> createState() => _AddNewHeroSlideState();
}

class _AddNewHeroSlideState extends State<AddNewHeroSlide> {
  final TextEditingController _titleController =
  TextEditingController();

  final TextEditingController _subtitleController =
  TextEditingController();

  final TextEditingController _buttonTextController =
  TextEditingController();

  final TextEditingController _buttonLinkController =
  TextEditingController();

  File? selectedImage;
  Color selectedColor = Colors.blue;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  void selectColor(Color color) {
    setState(() {
      selectedColor = color;
      selectedImage = null;
    });
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

                      // ======================
                      // TITLE
                      // ======================

                      const Text(
                        "Title",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: _titleController,
                        onChanged: (_) {
                          setState(() {});
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter hero title",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ======================
                      // SUBTITLE
                      // ======================

                      const Text(
                        "Subtitle",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: _subtitleController,
                        onChanged: (_) {
                          setState(() {});
                        },
                        decoration: const InputDecoration(
                          hintText: "Enter hero subtitle",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ======================
                      // BUTTON TEXT
                      // ======================

                      const Text(
                        "Button Text",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: _buttonTextController,
                        onChanged: (_) {
                          setState(() {});
                        },
                        decoration: const InputDecoration(
                          hintText: "Example: Explore Now",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ======================
                      // BUTTON LINK
                      // ======================

                      const Text(
                        "Button Link",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: _buttonLinkController,
                        decoration: const InputDecoration(
                          hintText: "https://example.com",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ======================
                      // BACKGROUND
                      // ======================

                      const Text(
                        "Background",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: pickImage,
                              icon: const Icon(
                                Icons.image_outlined,
                              ),
                              label: const Text(
                                "Upload Image",
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: showColorPicker,
                              icon: const Icon(
                                Icons.palette_outlined,
                              ),
                              label: const Text(
                                "Select Color",
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (selectedImage != null) ...[
                        const SizedBox(height: 10),

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
                                setState(() {
                                  selectedImage = null;
                                });
                              },
                              child: const Text("Remove"),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 30),

                      // ======================
                      // PREVIEW
                      // ======================

                      const Text(
                        "Preview",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Container(
                        width: double.infinity,
                        height: 280,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(16),

                          color: selectedColor,

                          image: selectedImage != null
                              ? DecorationImage(
                            image: FileImage(
                              selectedImage!,
                            ),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),

                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(16),

                            gradient: selectedImage != null
                                ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(
                                  0.2,
                                ),
                                Colors.black.withOpacity(
                                  0.7,
                                ),
                              ],
                            )
                                : null,
                          ),

                          padding: const EdgeInsets.all(24),

                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [

                              // TITLE

                              Text(
                                _titleController.text.isEmpty
                                    ? "Your Title"
                                    : _titleController.text,

                                textAlign: TextAlign.center,

                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // SUBTITLE

                              Text(
                                _subtitleController.text.isEmpty
                                    ? "Your subtitle will appear here"
                                    : _subtitleController.text,

                                textAlign: TextAlign.center,

                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 24),

                              // BUTTON

                              ElevatedButton(
                                onPressed: () {},

                                child: Text(
                                  _buttonTextController
                                      .text
                                      .isEmpty
                                      ? "Button"
                                      : _buttonTextController
                                      .text,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ======================
                      // SAVE BUTTON
                      // ======================

                      SizedBox(
                        width: double.infinity,
                        height: 52,

                        child: ElevatedButton(
                          onPressed: () {
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
                          },

                          child: const Text(
                            "Save Slide",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
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
    final List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.black,
      Colors.grey,
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Select Background Color",
          ),

          content: Wrap(
            spacing: 12,
            runSpacing: 12,

            children: colors.map((color) {
              return InkWell(
                onTap: () {
                  selectColor(color);

                  Navigator.pop(context);
                },

                borderRadius:
                BorderRadius.circular(50),

                child: Container(
                  width: 45,
                  height: 45,

                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,

                    border: Border.all(
                      color: selectedColor == color
                          ? Colors.white
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}