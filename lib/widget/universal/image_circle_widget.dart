

import 'package:flutter/material.dart';
import 'package:storio_app/utils/theme/app_color.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/theme/theme_ext.dart';

class ImageCircleWidget extends StatelessWidget {
  const ImageCircleWidget({super.key, required this.imgPath});
  final String imgPath;

  @override
  Widget build(BuildContext context) {

    final color = context.Appcolor;
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color.primaryLightVersion,
          width: 1,
        ),
      ),
      child:  CircleAvatar(
        backgroundColor: color.primaryLightVersion,
        backgroundImage: AssetImage(imgPath)
      ),
    );
  }
}
