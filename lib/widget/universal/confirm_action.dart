import 'package:flutter/material.dart';
import 'package:storio_app/utils/app_sizes.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';

import '../../utils/theme/theme_ext.dart';

Future<bool> confirmAction(
    BuildContext context, {required String title, required String message,}) async {
  final color = context.Appcolor;
  final result = await showDialog<bool>(
    context: context,

    builder: (context) => AlertDialog(
      backgroundColor:color.cardBackground,
      title: TextTitleWidget(title: title,size: AppSizes.cardTitle,),
      content: TextBodyStyleWidget(title: message,maxLines: 3,),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child:  TextTitleWidget(title: "No"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child:  TextTitleWidget(title:"Yes"),
        ),
      ],
    ),
  );

  return result ?? false;
}