import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/sizes.dart';

class TextBodyStyleWidget extends StatelessWidget {
  final String title;
  final double? size;
  final Color? color;
  final int? maxLines;

  const TextBodyStyleWidget({
    super.key,
    required this.title,
    this.size,
    this.color,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color ?? Colors.black54,
        fontSize: size?.sp ?? AppSizes.cardSubTitle,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}