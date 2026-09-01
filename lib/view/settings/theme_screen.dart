import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../viewModel/setting/theme_view_model.dart';

import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Appearance & Theme",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _themeOptionCard(
                  context: context,
                  themeType: AppThemeType.defaultTheme,
                  title: "Default",
                  subtitle: "(Blue & Gold)",
                  description:
                  "Vibrant and professional. Ideal for educational and corporate dashboards.",
                  primaryColor: const Color(0xFF1A437A),
                  isSelected: themeProvider.selectedTheme == AppThemeType.defaultTheme,
                  screenBackgroundColor: Color(0xFFEDEDF7),
                ),
                SizedBox(height: 2.h),
                _themeOptionCard(
                  context: context,
                  themeType: AppThemeType.emerald,
                  title: "Emerald",
                  subtitle: "(Green & Red)",
                  description:
                  "A bold, high-contrast look featuring forest green and deep red accents.",
                  primaryColor: const Color(0xFF0E6B4F),
                  isSelected:
                  themeProvider.selectedTheme == AppThemeType.emerald,
                  screenBackgroundColor:  Color(0xFFE7F5EE),
                ),
                SizedBox(height: 2.h),
                _themeOptionCard(
                  context: context,
                  themeType: AppThemeType.cosmic,
                  title: "Cosmic",
                  subtitle: "(Dark Mode)",
                  description:
                  "Modern dark mode, designed for long hours of use with reduced eye strain.",
                  primaryColor: const Color(0xFF1C1F2E),
                  isSelected:
                  themeProvider.selectedTheme == AppThemeType.cosmic,
                  screenBackgroundColor:  Color(0xFF12141F),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _themeOptionCard({
    required BuildContext context,
    required AppThemeType themeType,
    required String title,
    required String subtitle,
    required String description,
    required Color primaryColor,
    required Color screenBackgroundColor,
    required bool isSelected,
  }) {
    final color = context.Appcolor;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBodyStyleWidget(
                    title: title,
                    size: AppSizes.sectionTitle,

                  ),
                  TextBodyStyleWidget(
                    title: subtitle,
                    color: color.textSecondary,
                  ),
                ],
              ),
              Radio<AppThemeType>(
                value: themeType,
                groupValue:
                context.read<ThemeProvider>().selectedTheme,
                activeColor: color.primary,
                onChanged: (value) {
                  if (value != null) {
                    context.read<ThemeProvider>().setTheme(value);
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 1.h),

          // color preview bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            child: SizedBox(
              height: 10.h,
              child: Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(color: primaryColor),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(color: screenBackgroundColor),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child:  TextBodyStyleWidget(
                        title: "Primary",
                        color: Colors.white,
                        fontbold: false,
                        size: AppSizes.cardSubTitle,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),

          SizedBox(height: 1.h),
          TextBodyStyleWidget(title: description, color: color.textSecondary),
          SizedBox(height: 1.h),

          isSelected
              ? Row(
            children: [
              Icon(Icons.check_circle, color: color.primary, size: 18),
              const SizedBox(width: 6),
              TextBodyStyleWidget(
                title: "Active Theme",
                color: color.primary,

              ),
            ],
          )
              : CustomButton(
            text: "Apply Theme",
            onTap: () {
              context.read<ThemeProvider>().setTheme(themeType);
            },
          ),
        ],
      ),
    );
  }
}