import 'package:flutter/cupertino.dart';

class KeyMetricsModel {
  final String label;
  final String value;
  final IconData?iconData;

  KeyMetricsModel({
    required this.label,
    required this.value,  this.iconData,
  });
}