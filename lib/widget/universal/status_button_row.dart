import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../custom_button/status_row_button.dart';

class StatusButtonRow extends StatelessWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final ValueChanged<String>? onTap;

  const StatusButtonRow({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          items.length,
              (index) {
            return Padding(
              padding: EdgeInsets.only(
                right: index == items.length - 1 ? 0 : AppSizes.appbarGap,
              ),
              child: StatusButton(
                text: items[index],
                height: 4.5.h,
                size: AppSizes.cardSubTitle,
                borderSide: BorderSide(
                  color: color.primary,
                  width: 1,
                ),
                backgroundColor: selectedIndex == index
                    ? color.cardBackground
                    : color.primary,
                foregroundColor: selectedIndex == index
                    ? color.primary
                    : color.cardBackground,
                onTap: () {
                  onSelected(index);
                  onTap?.call(items[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}