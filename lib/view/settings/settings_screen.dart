import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/utils/app_sizes.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_app_bar.dart';
import 'package:storio_app/widget/universal/custom_card.dart';

import '../../utils/theme/theme_ext.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: "Settings"),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                CustomCard(
                    child: Column(
                      children: [
                        SettingListWidget(icon:Icons.settings,title: "General Settings",subtitle: "Manage Institute Information",onTap: (){
                          Navigator.pushNamed(context, RoutesName.general_settings);
                        },),
                        Divider(),
                        SettingListWidget(icon:Icons.lock,title: "Security",subtitle: "Manage passwords and acces",onTap: (){
                          Navigator.pushNamed(context, RoutesName.security);
                        },),
                        Divider(),
                        SettingListWidget(icon:Icons.palette,title: "Themes",subtitle: "Custom appearance",onTap: (){
                          Navigator.pushNamed(context, RoutesName.theme);
                        },),

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
    final color = context.Appcolor;
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: AppSizes.smallPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon,size: AppSizes.iconLarge,color: color.primary,),
          SizedBox(width: AppSizes.smallGap,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextTitleWidget(title: "${title}",size: AppSizes.sectionTitle,color: color.primary,),
                TextBodyStyleWidget(title: "${subtitle}",size: AppSizes.cardTitle,maxLines: 1,),
              ],
            ),
          ),
        IconButton(onPressed: onTap, icon: Icon(Icons.arrow_forward_ios,size: AppSizes.icon,))
        ],
      ),
    );
  }
}
