import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../custom_button/custom_buttom.dart';
import '../textStyle/text_title_style.dart';
class InstituteOverviewScreen extends StatefulWidget {
  final String title;
  final Widget ?child;

  final Widget? expandableChild;
  final bool isExpanded;


  final bool showIcon;
  final IconData ? userIcon;
  final VoidCallback?onTap;

  const InstituteOverviewScreen({
    super.key,
    required this.title,
     this.child,
    this.onTap,
    this.userIcon,
    this.showIcon= false, this.expandableChild, required this.isExpanded,
  });

  @override
  State<InstituteOverviewScreen> createState() => _InstituteOverviewScreenState();
}

class _InstituteOverviewScreenState extends State<InstituteOverviewScreen> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextTitleWidget(
              title: widget.title,
              size: AppSizes.sectionTitle,

              color: AppColors.primary,
            ),
            if (widget.showIcon)
             IconButton(
                 onPressed: widget.onTap,
                 icon: AnimatedRotation(
                   turns: widget.isExpanded ? 0.50 : 0,
                   duration: const Duration(milliseconds: 300),
                   child: Icon(
                     widget.userIcon,
                     size: AppSizes.icon,

                   ),
                 ),)
          ],
        ),

        SizedBox(height: AppSizes.smallGap),


        Container(
          width: 100.w,
         // padding: EdgeInsets.symmetric(horizontal: AppSizes.smallPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 2,
                spreadRadius: 2,
                offset: Offset(0,0),
              )
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all( AppSizes.cardPadding),
            child: AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.isExpanded && widget.expandableChild != null) ...[
                    widget.expandableChild!,
                    SizedBox(height: AppSizes.sectionGap),
                  ],
                  if (widget.child != null) widget.child!,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}