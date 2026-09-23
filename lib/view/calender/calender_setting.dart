import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_card2.dart';

import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/calender_view_model.dart';
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
    "Sunday", // Index 0
    "Monday", // Index 1
    "Tuesday", // Index 2
    "Wednesday", // Index 3
    "Thursday", // Index 4
    "Friday", // Index 5
    "Saturday", // Index 6
  ];

  List<String> selectedDays = ["Friday", "Saturday"];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingSettings();
    });
  }


  void _loadExistingSettings() async {
    final viewModel = context.read<CalendarViewModel>();

    if (viewModel.settings == null) {
      await viewModel.getSettings();
    }

    if (viewModel.settings != null && viewModel.settings!.weekendDays!.isNotEmpty) {
      final rawDays = viewModel.settings!.weekendDays; // Example: "5,6"
      final indexes = rawDays!.split(',').map((e) => e.trim()).toList();

      setState(() {
        selectedDays.clear();
        for (var idxStr in indexes) {
          final idx = int.tryParse(idxStr);
          if (idx != null && idx >= 0 && idx < weekendDays.length) {
            selectedDays.add(weekendDays[idx]);
          }
        }
      });
    }
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isSaving = true;
    });

    final viewModel = context.read<CalendarViewModel>();

    final List<int> indexList = selectedDays
        .map((day) => weekendDays.indexOf(day))
        .where((idx) => idx != -1)
        .toList()..sort();

    final String weekendDaysString = indexList.join(','); // "5,6" format

    final success = await viewModel.updateSettings(weekendDaysString);

    if (mounted) {
      setState(() {
        _isSaving = false;
      });

      if (success) {
        viewModel.getSettings();
        viewModel.getEventApi();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Settings saved successfully!")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.errorMessage ?? "Failed to save settings"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBar(
            title: "Calendar Settings",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
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
                          ),
                          SizedBox(height: AppSizes.itemGap),
                          GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: weekendDays.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  borderRadius: BorderRadius.circular(8),
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
                                      SizedBox(width: AppSizes.itemGap,),
                                      TextTitleWidget(
                                        title: day,
                                        color: color.primary,
                                        size: AppSizes.sectionTitle,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap),

                    // Action Buttons (Cancel & Save)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          text: "Cancel",
                          onTap: () => Navigator.pop(context),
                          width: 30.w,
                          backgroundColor: color.cardBackground,
                          foregroundColor: color.primary,
                        ),
                        SizedBox(width: AppSizes.appbarGap),
                        Flexible(
                          child: CustomButton(
                            text: _isSaving ? "Saving..." : "Save Settings",
                            onTap: _isSaving ? null : _saveSettings,
                          ),
                        ),
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