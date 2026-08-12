import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';

import '../routes/routes_name.dart';
import '../utils/app_colors.dart';
import '../widget/dashboard/action_grid.dart';
import '../widget/dashboard/action_tile.dart';
import '../widget/universal/custom_app_bar.dart';
import '../widget/universal/custom_card.dart';

class ActionDetails extends StatefulWidget {
  const ActionDetails({super.key});

  @override
  State<ActionDetails> createState() => _ActionDetailsState();
}

class _ActionDetailsState extends State<ActionDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: "Action Details View",showBackButton: true,),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(4.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [

                    // Overlapping Card
                    CustomCard(child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextTitleWidget(title: "Content",color: AppColors.primary,size: 17,),
                        SizedBox(height: 1.h,),
                        // 8 Actions
                        _buildContentActionGrid(context),


                        SizedBox(height: 1.h,),
                        Divider(),
                        SizedBox(height: 1.h,),


                        //Oraganization
                        TextTitleWidget(title: "Organization",color: AppColors.primary,size: 17,),

                        SizedBox(height: 1.h,),

                        // 8 Actions
                        _buildOrganizationActionGrid(context),


                        SizedBox(height: 1.h,),
                        Divider(),
                        SizedBox(height: 1.h,),


                        //User Manage
                        TextTitleWidget(title: "User Manage",color: AppColors.primary,size: 17,),

                        SizedBox(height: 1.h,),
                        // 8 Actions
                        _buildUserManagerActionGrid(context),


                      ],
                    ),),
                    SizedBox(height: 2.5.h,)


                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  ActionGrid _buildContentActionGrid(BuildContext context) {
    return ActionGrid(
      items: [
        ActionTile(
          icon: Icons.notifications_none,
          label: "Notice",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.dasboard);
          },
        ),
        ActionTile(
          icon: Icons.school_outlined,
          label: "Admission",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.dasboard);
          },
        ),
        ActionTile(
          icon: Icons.menu_book_outlined,
          label: "Blog",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.dasboard);
          },
        ),
        ActionTile(
          icon: Icons.calendar_month_outlined,
          label: "Calendar",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.dasboard);
          },
        ),
        ActionTile(
          icon: Icons.event_outlined,
          label: "Event",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.dasboard);
          },
        ),
        ActionTile(
          icon: Icons.camera_outlined,
          label: "Activity",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.dasboard);
          },
        ),
        ActionTile(
          icon: Icons.image_outlined,
          label: "Gallery",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.dasboard);
          },
        ),
        ActionTile(
          icon: Icons.emoji_events_outlined,
          label: "Result",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.exam_result);
          },
        ),
        ActionTile(
          icon: Icons.work_outline,
          label: "Career",
          onTap: () {},
        ),
        ActionTile(
          icon: Icons.phone_in_talk_outlined,
          label: "Contact",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.contact);
          },
        ),
        ActionTile(
          icon: Icons.help_outline,
          label: "FAQ",
          onTap: () {},
        ),
        ActionTile(
          icon: Icons.hexagon_outlined,
          label: "Hero-Slide",
          onTap: () {},
        ),
        ActionTile(
          icon: Icons.image_outlined,
          label: "Media",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.media_manage);
          },
        ),
        ActionTile(
          icon: Icons.campaign_outlined,
          label: "Promotion",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.promotion);
          },
        ),
        ActionTile(
          icon: Icons.record_voice_over_outlined,
          label: "Testimonial",
          onTap: () {},
        ),
        ActionTile(
          icon: Icons.videocam_outlined,
          label: "Video",
          onTap: () {},
        ),
      ],
    );
  }
  ActionGrid _buildOrganizationActionGrid(BuildContext context) {
    return ActionGrid(
      items: [
        ActionTile(
          icon: Icons.badge_outlined,
          label: "Card Manage",
          onTap: () {},
        ),
        ActionTile(
          icon: Icons.link,
          label: "Links",
          onTap: () {},
        ),
        ActionTile(
          icon: Icons.chat_bubble_outline,
          label: "Leadership\nMessage",
          onTap: () {},
        ),
        ActionTile(
          icon: Icons.person_outline,
          label: "Staff",
          onTap: () {},
        ),
        ActionTile(
          icon: Icons.groups_outlined,
          label: "Team",
          onTap: () {},
        ),
      ],
    );
  }
  ActionGrid _buildUserManagerActionGrid(BuildContext context) {
    return ActionGrid(
      items: [
        ActionTile(
          icon: Icons.hub_outlined,
          label: "Role",
          onTap: () {},
        ),
        ActionTile(
          icon: Icons.supervisor_account_outlined,
          label: "Users",
          onTap: () {},
        ),
      ],
    );
  }
}
