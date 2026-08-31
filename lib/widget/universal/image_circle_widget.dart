

import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class ImageCircleWidget extends StatelessWidget {
  const ImageCircleWidget({super.key, required this.imgPath});
  final String imgPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary,
          width: 1,
        ),
      ),
      child:  CircleAvatar(
        backgroundImage: AssetImage(imgPath)
      ),
    );
  }
}
