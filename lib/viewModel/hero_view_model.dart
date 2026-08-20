import 'dart:io';
import 'package:flutter/material.dart';
import 'package:storio_app/utils/app_colors.dart';

class HeroProvider extends ChangeNotifier {
  String title = '';
  String subtitle = '';
  String buttonText = '';
  String buttonLink = '';

  File? selectedImage;
  Color selectedColor = Colors.blue;
  Color titleColor = Colors.white;
  Color subtitleColor = Colors.white;
  Color buttonBackgroundColor = AppColors.primary;
  Color buttonTextColor = Colors.white;

  bool get hasImage => selectedImage != null;

  void setTitle(String value) {
    title = value;
    notifyListeners();
  }

  void setSubtitle(String value) {
    subtitle = value;
    notifyListeners();
  }

  void setButtonText(String value) {
    buttonText = value;
    notifyListeners();
  }

  void setButtonLink(String value) {
    buttonLink = value;
    notifyListeners();
  }

  void setImage(File image) {
    selectedImage = image;
    notifyListeners();
  }

  void removeImage() {
    selectedImage = null;
    notifyListeners();
  }

  void setColor(Color color) {
    selectedColor = color;

    // Color select করলে image remove
    selectedImage = null;

    notifyListeners();
  }
}