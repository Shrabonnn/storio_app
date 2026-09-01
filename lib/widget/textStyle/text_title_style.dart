import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_sizes.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/theme/theme_ext.dart';

class TextTitleWidget extends StatelessWidget {
  final String title;
  final double? size;
  final int ? maxLines;
  final Color? color;
  const TextTitleWidget({
    super.key, required this.title, this.size, this.color, this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final Appcolor = context.Appcolor;
    return Text(
      title,
      maxLines: maxLines,
      style: TextStyle(
        color: color ?? Appcolor.textPrimary,
        fontSize: size?.sp ?? AppSizes.sectionTitle ,
        fontWeight: FontWeight.w600,

      ),
    );
  }
}