import 'package:flutter/material.dart';
import '../../utils/theme/theme_ext.dart';

class ImageCircleWidget extends StatelessWidget {
  const ImageCircleWidget({
    super.key,
    required this.imgPath,
    this.isNetwork = false,
    this.size = 80,
  });

  final String imgPath;
  final bool isNetwork;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: color.primaryLightVersion,
          width: 1,
        ),
      ),
      child: ClipOval(
        child: isNetwork
            ? Image.network(
          imgPath,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            "assets/images/person.png",
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        )
            : Image.asset(
          imgPath,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}