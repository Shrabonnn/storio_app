import 'package:flutter/material.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';

import '../../utils/theme/theme_ext.dart';

enum MoreMenuAction {
  edit,
  view,
  delete,
  changePassword,
  suspend
}
class MoreMenu extends StatelessWidget {
  final List<MoreMenuAction> items;
  final Function(MoreMenuAction) onSelected;


  const MoreMenu({
    super.key,
    required this.items,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return PopupMenuButton<MoreMenuAction>(
      color: color.primary,
      icon: const Icon(Icons.more_vert),
      onSelected: onSelected,
      itemBuilder: (context) {
        return items.map((item) {
          return PopupMenuItem<MoreMenuAction>(
            value: item,
            child: TextBodyStyleWidget(title: item.name,color: color.cardBackground,),
          );
        }).toList();
      },
    );
  }
}