import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../custom_button/custom_buttom.dart';

class PreviewModeButtonRow extends StatelessWidget {
  final List<String> items;
  final List<IconData> icons;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const PreviewModeButtonRow({
    super.key,
    required this.items,
    required this.icons,
    required this.selectedIndex,
    required this.onSelected,
  }) : assert(items.length == icons.length);

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
                icon: icons[index],
                onTap: () {
                  onSelected(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}