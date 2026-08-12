import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../custom_button/custom_buttom.dart';

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
    return Row(
      children: List.generate(
        items.length,
            (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == items.length - 1
                    ? 0
                    : AppSizes.appbarGap,
              ),
              child: CustomButton(
                text: items[index],
                height: 4.5.h,
                size: AppSizes.cardSubTitle,
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 1,
                ),
                backgroundColor: selectedIndex == index
                    ? Colors.white
                    : AppColors.primary,
                foregroundColor: selectedIndex == index
                    ? AppColors.primary
                    : Colors.white,
                onTap: () {
                  // Selected button change
                  onSelected(index);

                  // Future custom action
                  onTap?.call(items[index]);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}