import 'package:flutter/material.dart';
import '../../utils/theme/theme_ext.dart';

class ImageRectangleWidget extends StatelessWidget {
  const ImageRectangleWidget({
    super.key,
    required this.imgPath,
    this.isNetwork = false,
    this.width = 80,
    this.height = 80,
    this.borderRadius = 12,
  });

  final String imgPath;
  final bool isNetwork;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: color.primaryLightVersion,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: isNetwork
            ? Image.network(
          imgPath,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            "assets/images/person.png",
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        )
            : Image.asset(
          imgPath,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}