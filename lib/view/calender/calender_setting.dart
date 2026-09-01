import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_card2.dart';

import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';

class CalenderSetting extends StatefulWidget {
  const CalenderSetting({super.key});

  @override
  State<CalenderSetting> createState() => _CalenderSettingState();
}

class _CalenderSettingState extends State<CalenderSetting> {


  final List<String> weekendDays = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  List<String> selectedDays = ["Friday", "Saturday"];


  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title:"Calendar Settings",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextTitleWidget(
                            title: "Select Weekend Days",
                            color: color.primary,
                          ),

                          SizedBox(height: AppSizes.itemGap),

                          GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: weekendDays.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 4.8,
                            ),
                            itemBuilder: (context, index) {
                              final day = weekendDays[index];
                              final isSelected = selectedDays.contains(day);

                              return CustomCard2(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedDays.remove(day);
                                      } else {
                                        selectedDays.add(day);
                                      }
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: isSelected,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == true) {
                                              selectedDays.add(day);
                                            } else {
                                              selectedDays.remove(day);
                                            }
                                          });
                                        },
                                        activeColor: color.primary,
                                        materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                      ),

                                      TextTitleWidget(title: day,color: color.primary,)
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),


                    SizedBox(height: AppSizes.sectionGap,),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text: "Cancel", onTap: (){},width: 30.w,backgroundColor: color.cardBackground,foregroundColor: color.primary,),
                        SizedBox(width: AppSizes.appbarGap,),
                        Flexible(child: CustomButton(text:"Save Settings", onTap: (){},)),
                      ],
                    ),
                    SizedBox(height: AppSizes.sectionGap),
                  ],
                )

              ]),
            ),
          ),

        ],
      ),
    );
  }
}
