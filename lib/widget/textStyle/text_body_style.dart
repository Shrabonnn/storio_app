import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_sizes.dart';

import '../../utils/theme/theme_ext.dart';

class TextBodyStyleWidget extends StatelessWidget {
  final String title;
  final double? size;
  final Color? color;
  final int? maxLines;
  final bool fontbold;

  const TextBodyStyleWidget({
    super.key,
    required this.title,
    this.size,
    this.color,
    this.maxLines, this.fontbold = true,
  });

  @override
  Widget build(BuildContext context) {
    final Appcolor = context.Appcolor;
    return Text(
      title,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color ?? Appcolor.textSecondary,
        fontSize: size?.sp ?? AppSizes.cardSubTitle,
        fontWeight: fontbold ? FontWeight.w600 :FontWeight.normal  ,
      ),
    );
  }
}