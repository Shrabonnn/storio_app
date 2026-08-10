
import 'package:flutter/material.dart';

import '../../utils/sizes.dart';

class CustomCard2 extends StatelessWidget {
  const CustomCard2({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSizes.smallPadding),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFD),
        borderRadius: BorderRadius.circular(
          AppSizes.cardRadius,
        ),
        border: Border.all(
          color: Colors.grey.shade300,
        ),

      ),child: child,
    );
  }
}
