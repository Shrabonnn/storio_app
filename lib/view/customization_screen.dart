import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/utils/sizes.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';

import '../routes/routes_name.dart';
import '../widget/dashboard/action_grid.dart';
import '../widget/dashboard/action_tile.dart';
import '../widget/universal/custom_app_bar.dart';
import '../widget/universal/custom_card.dart';

class CustomizationScreen extends StatefulWidget {
  const CustomizationScreen({super.key});

  @override
  State<CustomizationScreen> createState() => _CustomizationScreenState();
}

class _CustomizationScreenState extends State<CustomizationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: "Customization"),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [

                    // Overlapping Card
                    CustomCard(child: Column(
                      children: [
                        TextTitleWidget(title: 'Customize Your Pages',color: AppColors.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.itemGap,),
                        // 8 Actions
                        _buildActionGrid(context),

                      ],
                    ),),

                    SizedBox(height: AppSizes.itemGap),

                    // Other widgets
                    Container(
                      height: 8.h,
                      padding: EdgeInsets.all(AppSizes.cardPadding),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppSizes.cardRadius)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 3.h,
                            backgroundColor: AppColors.primary,
                            child: Icon(
                              Icons.computer,
                              color: Colors.white,
                              size: 3.5.h,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Flexible(
                            child: TextBodyStyleWidget(
                              title: 'For better view use Desktop',
                              size: AppSizes.sectionTitle,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                ]),
            ),
          ),
        ],
      ),);
  }
  ActionGrid _buildActionGrid(BuildContext context) {
    return ActionGrid(
      items: [
        ActionTile(
          icon: Icons.foggy,
          label: "Form",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.dasboard);
          },
        ),
        ActionTile(
          icon: Icons.school_outlined,
          label: "Menu",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.dasboard);
          },
        ),
        ActionTile(
          icon: Icons.menu_book_outlined,
          label: "Templates",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.dasboard);
          },
        ),
        ActionTile(
          icon: Icons.calendar_month_outlined,
          label: "Page Custom ",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.dasboard);
          },
        ),

      ],
    );
  }
}
