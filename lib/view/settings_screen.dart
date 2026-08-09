import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/utils/sizes.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_app_bar.dart';
import 'package:storio_app/widget/universal/custom_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: "Settings"),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(4.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                CustomCard(
                    child: Column(
                      children: [
                        SettingListWidget(icon:Icons.settings,title: "General Settings",subtitle: "Manage Institute Information",onTap: (){},),
                        Divider(),
                        SettingListWidget(icon:Icons.lock,title: "Security",subtitle: "Manage passwords and acces",onTap: (){},),
                        Divider(),
                        SettingListWidget(icon:Icons.palette,title: "Themes",subtitle: "Custom appearance",onTap: (){},),

                      ],
                    ),),]),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingListWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const SettingListWidget({
    super.key, required this.title, required this.subtitle, required this.onTap, required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 2.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(icon,size: AppSizes.icon,color: AppColors.primary,),
          SizedBox(width: 3.w,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextTitleWidget(title: "${title}",size: AppSizes.cardTitle,color: AppColors.primary,),
                TextBodyStyleWidget(title: "${subtitle}",size: AppSizes.cardSubTitle,maxLines: 1,),
              ],
            ),
          ),
        IconButton(onPressed: onTap, icon: Icon(Icons.arrow_forward_ios,size: AppSizes.icon,))
        ],
      ),
    );
  }
}
