import 'package:flutter/cupertino.dart';

class InfrastructureItemModel {
  final String label;
  final String value;
  final IconData?iconData;

  InfrastructureItemModel({
    required this.label,
    required this.value,  this.iconData,
  });
}