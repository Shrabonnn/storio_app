import 'package:flutter/material.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/theme/theme_ext.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String heroTag;
  final Color? backgroundColor;
  final Color? iconColor;

  const CustomFloatingActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.heroTag,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return FloatingActionButton(
      heroTag: heroTag,
      backgroundColor: backgroundColor ?? color.primary,
      onPressed: onTap,
      child: Icon(
        icon,
        color: iconColor ?? color.cardBackground,
      ),
    );
  }
}