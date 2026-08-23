import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/sizes.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';

class InfoRow extends StatelessWidget {
  final IconData?icon;
  final String label;
  final String value;

  const InfoRow({
    super.key,
    this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: AppSizes.contentPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 30.w,
            child: Row(
              children: [
                Icon(icon, size: AppSizes.iconSmall, color: Colors.grey),
                 SizedBox(width: AppSizes.smallGap),
                TextBodyStyleWidget(title: label)
              ],
            ),
          ),
          SizedBox(width: 17.w,),


          // Value column (left-aligned, starts right after label column)
          Expanded(
            child: TextBodyStyleWidget(title: value,color: Colors.black,)
          ),
        ],
      ),
    );
  }
}