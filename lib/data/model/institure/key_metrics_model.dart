import 'package:flutter/widgets.dart';

class KeyMetricsModel {
  final String label;
  final String value;
  final IconData? iconData;
  final bool isFixed;
  KeyMetricsModel({
    required this.label,
    required this.value,
    this.iconData,
    this.isFixed = false,
  });
}