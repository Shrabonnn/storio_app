import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
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
    final color = context.Appcolor;
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
                  color: color.primary,
                  width: 1,
                ),
                backgroundColor: selectedIndex == index
                    ? color.cardBackground
                    : color.primary,
                foregroundColor: selectedIndex == index
                    ? color.primary
                    : color.cardBackground,
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