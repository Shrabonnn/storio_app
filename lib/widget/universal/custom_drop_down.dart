
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../textStyle/text_body_style.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final double? width;
  final double? height;
  final bool enabled;

  const CustomDropdown({
    super.key,
    required this.items,
    this.initialValue,
    this.onChanged,
    this.width,
    this.height,
    this.enabled = true,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String? selectiveType;
  late final ValueNotifier<String?> valueListenable;

  @override
  void initState() {
    super.initState();
    selectiveType = widget.initialValue ?? (widget.items.isNotEmpty ? widget.items.first : null);
    valueListenable = ValueNotifier<String?>(selectiveType);
  }

  @override
  void dispose() {
    valueListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 4.5.h,
      width: widget.width ?? 25.w,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          valueListenable: valueListenable,

          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ),

          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
          ),

          dropdownStyleData: DropdownStyleData(
            maxHeight: 250,
            offset: const Offset(0, 4),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollPadding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppSizes.buttonRadius),
                bottomRight: Radius.circular(AppSizes.buttonRadius),
              ),
            ),
          ),

          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.zero,
          ),

          selectedItemBuilder: (context) {
            return widget.items.map((item) {
              return Align(
                alignment: Alignment.centerLeft,
                child: TextBodyStyleWidget(
                  title: item,
                  color: Colors.white,
                  size: AppSizes.cardTitle,
                ),
              );
            }).toList();
          },

          items: widget.items.map((item) {
            final bool isSelected = item == selectiveType;

            return DropdownItem<String>(
              value: item,
              height: 42,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.centerLeft,
                child: TextBodyStyleWidget(
                  title: item,
                  color: isSelected ? Colors.orange : Colors.white,
                  size: AppSizes.cardSubTitle,
                ),
              ),
            );
          }).toList(),

          onChanged: widget.enabled
              ? (value) {
            valueListenable.value = value;

            setState(() {
              selectiveType = value;
            });

            widget.onChanged?.call(value);
          }
              : null,
        ),
      ),
    );
  }
}