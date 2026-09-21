import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_sizes.dart';

class BottomHeightWidget extends StatelessWidget {
  const BottomHeightWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(
        top: AppSizes.screenPadding,
        left: AppSizes.screenPadding,
        right: AppSizes.screenPadding,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h,)
            ],
          ),
        ]),
      ),
    );
  }
}