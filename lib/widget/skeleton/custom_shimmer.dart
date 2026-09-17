import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/theme/theme_ext.dart';

class CustomShimmer extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape shape;

  const CustomShimmer.rectangular({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 8,
  }) : shape = BoxShape.rectangle;

  const CustomShimmer.circular({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = 0,
        shape = BoxShape.circle;

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    final isDark = Theme.of(context).brightness == Brightness.dark;


    final baseColor = color.lightVersionOfPrimaryLightVersion;
    final highlightColor = isDark
        ? color.primaryLightVersion
        : color.cardBackground;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color.cardBackground,
          shape: shape,
          borderRadius: shape == BoxShape.rectangle
              ? BorderRadius.circular(borderRadius)
              : null,
        ),
      ),
    );
  }
}

class ShimmerWrapper extends StatelessWidget {
  final Widget child;

  const ShimmerWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    final isDark = Theme.of(context).brightness == Brightness.dark;


    final baseColor = color.lightVersionOfPrimaryLightVersion;
    final highlightColor = isDark
        ? color.primaryLightVersion
        : color.cardBackground;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: child,
    );
  }
}