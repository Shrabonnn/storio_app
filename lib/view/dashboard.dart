import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';

import '../data/model/Content/event/event_model.dart';
import '../data/model/Content/notice/notice_model.dart';
import '../routes/routes_name.dart';
import '../utils/app_colors.dart';
import '../utils/app_sizes.dart';
import '../utils/theme/theme_ext.dart';
import '../viewModel/Content/blog_view_model.dart';
import '../viewModel/Content/event_view_model.dart';
import '../viewModel/Content/notice_view_model.dart';
import '../viewModel/user_manage/user_view_model.dart';
import '../widget/dashboard/action_grid.dart';
import '../widget/dashboard/action_tile.dart';
import '../widget/dashboard/stat_card.dart';
import '../widget/textStyle/appbar_text_style.dart';
import '../widget/universal/epmty_state_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Only fetch if not already loaded elsewhere in the app — avoids
      // refetching every time the dashboard re-mounts.
      final userVM = context.read<UserViewModel>();
      if (userVM.userList.isEmpty) userVM.fetchUsers();

      final blogVM = context.read<BlogViewModel>();
      if (blogVM.blogList.isEmpty) blogVM.getBlogApi();

      final eventVM = context.read<EventViewModel>();
      if (eventVM.eventList.isEmpty) eventVM.getEventApi();

      final noticeVM = context.read<NoticeViewModel>();
      if (noticeVM.noticeList.isEmpty) noticeVM.getNoticeApi();
    });
  }

  // ============================================================
  // Date helpers
  // ============================================================

  String _ordinalSuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String _formatNoticeDate(DateTime date) {
    final day = date.day;
    final suffix = _ordinalSuffix(day);
    final month = DateFormat('MMMM').format(date);
    return '$day$suffix $month, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    // Reactive stat counts.
    final userVM = context.watch<UserViewModel>();
    final blogVM = context.watch<BlogViewModel>();
    final eventVM = context.watch<EventViewModel>();
    final noticeVM = context.watch<NoticeViewModel>();

    String statValue({
      required bool loading,
      required int count,
    }) {
      if (loading && count == 0) return "-";
      return count.toString();
    }

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Top Bar
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 21.h,
                  width: double.infinity,
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(AppSizes.containerRadius),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [color.primaryLightVersion, color.primary],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: AppSizes.cardPadding,
                            right: AppSizes.cardPadding,
                            top: AppSizes.cardPadding*4
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 12.w,
                                      height: 12.w,
                                      child: Image.asset(
                                        "assets/images/Storio_main_logo.png",
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(width: AppSizes.smallGap,),
                                    AppbarTextStyle(title: 'Storio',size: AppSizes.appBarTitle,)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.search_sharp,
                                        color: color.cardBackground,
                                        size: AppSizes.iconLarge,
                                      ),
                                    ),
                                    Icon(
                                      Icons.circle_rounded,
                                      size: AppSizes.iconLarge,
                                      color: Colors.redAccent,
                                    ),
                                    SizedBox(width: AppSizes.itemGap,),
                                    CustomButton(width: 20.w,height: 3.5.h,text: "Visit Site", onTap: (){}),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 1.5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppbarTextStyle(title: 'Hello, MAIYASHA👋',),
                                    SizedBox(height: AppSizes.appbarGap,),
                                    TextBodyStyleWidget(title: "Welcome back to Storio",color: color.textAppbar,),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: color.secondary,
                                          width: 1,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 23,
                                        backgroundColor: color.primaryLightVersion,
                                        backgroundImage: AssetImage(
                                          "assets/images/person.png",
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, RoutesName.profile);
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: color.cardBackground,
                                        size: AppSizes.icon,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //Information
            Padding(
              padding: EdgeInsets.all(AppSizes.screenPadding),
              child: Row(
                children: [
                  Expanded(
                    child: StatCard(
                      label: "Total Users",
                      value: statValue(
                        loading: userVM.loading,
                        count: userVM.userList.length,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: StatCard(
                      label: "Blog Posts",
                      value: statValue(
                        loading: blogVM.loading,
                        count: blogVM.blogList.length,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: StatCard(
                      label: "Total Events",
                      value: statValue(
                        loading: eventVM.loading,
                        count: eventVM.eventList.length,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: StatCard(
                      label: "Total Notices",
                      value: statValue(
                        loading: noticeVM.loading,
                        count: noticeVM.noticeList.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // graph
            Padding(
              padding: EdgeInsets.symmetric(horizontal:AppSizes.screenPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextTitleWidget(title: "Overview",color: color.primary,),

                ],
              ),
            ),
            SizedBox(height: AppSizes.sectionGap,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:AppSizes.screenPadding),
              child: AspectRatio(
                aspectRatio: 2.0,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 5,
                    minY: 0,
                    maxY: 100,

                    gridData: FlGridData(
                      show: false,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.shade300,
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),

                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 20,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: color.textSecondary,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            const months = [
                              'Feb',
                              'Mar',
                              'Apr',
                              'May',
                              'Jun',
                              'Jul',
                            ];

                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                months[value.toInt()],
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: color.textSecondary,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        color: color.primary,
                        barWidth: 2.5,

                        spots: const [
                          FlSpot(0, 40),
                          FlSpot(1, 60),
                          FlSpot(2, 80),
                          FlSpot(3, 50),
                          FlSpot(4, 70),
                          FlSpot(5, 90),
                        ],
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              color.secondary,
                              color.lightVersionOfPrimaryLightVersion,
                            ],
                          ),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, bar, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: color.primary,
                              strokeWidth: 2,
                              strokeColor: color.cardBackground,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSizes.sectionGap),
            //  Action to Rest
            Padding(
              padding: EdgeInsets.symmetric(horizontal:AppSizes.screenPadding),
              child: Column(
                children: [
                  // All Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextTitleWidget(title: "Actions",color: color.primary,),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RoutesName.action_details);
                        },
                        child: Row(
                          children: [
                            TextBodyStyleWidget(title: "View More",color: color.primary,),
                            Icon(
                              Icons.chevron_right,
                              size: AppSizes.icon,
                              color: color.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.smallGap),
                  // 8 Actions
                  _buildActionGrid(context),



                  SizedBox(height: AppSizes.sectionGap),



                  // Notices
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextTitleWidget(title: "Notices",color: color.primary,),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RoutesName.notice);
                        },
                        child: Row(
                          children: [
                            TextBodyStyleWidget(title: "View All",color: color.primary,),

                            Icon(
                              Icons.chevron_right,
                              size: AppSizes.icon,
                              color: color.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.smallGap),
                  // Notice card — top 2, real data
                  Consumer<NoticeViewModel>(
                    builder: (context, provider, child) {
                      if (provider.loading && provider.noticeList.isEmpty) {
                        return CustomCard(
                          child: SizedBox(
                            height: 12.h,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }

                      final topNotices = provider.noticeList.take(2).toList();

                      if (topNotices.isEmpty) {
                        return CustomCard(
                          child: EmptyStateWidget(
                            title: "No notices yet",
                            subtitle:
                            "New notices will appear here once published.",
                            icon: Icons.campaign_outlined,
                            compact: true,
                          ),
                        );
                      }

                      return CustomCard(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: topNotices.length,
                          separatorBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal:AppSizes.smallPadding),
                              child: Divider(
                                color: color.lightVersionOfPrimaryLightVersion,
                                height: 1, ),
                            );
                          },
                          itemBuilder: (context, index) {
                            final NoticeModel notice = topNotices[index];
                            final displayDate = notice.publishDate ??
                                notice.createDate;

                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RoutesName.notice,
                                  arguments: {
                                    'notice': notice,
                                    'showBackButton':true
                                  },
                                );
                              },
                              child: Flexible(
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.w),
                                  ),
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding:  EdgeInsets.only(right: 2.w),
                                            child: Icon(
                                              color: AppColors.primary,
                                              Icons.south_east,
                                              size: AppSizes.icon,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: AppSizes.smallGap,),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  TextTitleWidget(
                                                    title: notice.title ?? "Untitled Notice",
                                                    maxLines: 1,
                                                  ),
                                                  TextBodyStyleWidget(
                                                    title: displayDate != null
                                                        ? _formatNoticeDate(displayDate)
                                                        : "",
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),



                  SizedBox(height: AppSizes.sectionGap),



                  // Upcoming Events
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextTitleWidget(title: "Upcoming Events",color: color.primary,),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RoutesName.event);
                        },
                        child: Row(
                          children: [
                            TextBodyStyleWidget(title: "View All",color: color.primary,),

                            Icon(
                              Icons.chevron_right,
                              size: AppSizes.icon,
                              color: color.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.smallGap),
                  // Upcoming event card — top 2 upcoming, real data
                  Consumer<EventViewModel>(
                    builder: (context, provider, child) {
                      if (provider.loading && provider.eventList.isEmpty) {
                        return CustomCard(
                          child: SizedBox(
                            height: 12.h,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }

                      final now = DateTime.now();
                      final upcoming = provider.eventList
                          .where((e) =>
                      e.startDate != null && e.startDate!.isAfter(now))
                          .toList()
                        ..sort((a, b) => a.startDate!.compareTo(b.startDate!));

                      final topEvents = upcoming.take(2).toList();

                      if (topEvents.isEmpty) {
                        return CustomCard(
                          child: EmptyStateWidget(
                            title: "No upcoming events",
                            subtitle:
                            "Check back soon for newly scheduled events.",
                            icon: Icons.event_available_outlined,
                            compact: true,
                          ),
                        );
                      }

                      return CustomCard(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: topEvents.length,
                          separatorBuilder: (context, index) {
                            return Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 2.w),
                              child: Divider(
                                color: color.lightVersionOfPrimaryLightVersion,
                                height: 1, ),
                            );
                          },
                          itemBuilder: (context, index) {
                            final EventModel event = topEvents[index];
                            final start = event.startDate!;
                            final month = DateFormat('MMM').format(start).toUpperCase();
                            final day = start.day.toString();
                            final time = DateFormat('h:mm a').format(start);

                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  RoutesName.event,
                                  arguments: {'event': event},
                                );
                              },
                              child: Container(
                                height: 6.h,
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.w),
                                ),
                                child: Row(
                                  children: [
                                    // Date Card
                                    Container(
                                      width: 16.w,
                                      margin: EdgeInsets.symmetric(vertical: AppSizes.smallPadding),
                                      padding: EdgeInsets.symmetric(vertical: AppSizes.smallPadding),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                                        color: color.lightVersionOfPrimaryLightVersion,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.08),
                                            blurRadius: 5,
                                            spreadRadius: 2,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),

                                      child: Column(
                                        children: [
                                          Flexible(
                                            child: TextBodyStyleWidget(title: month,color: color.primary,),
                                          ),
                                          Flexible(
                                            child: TextTitleWidget(title: day,color: color.primary,),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 2.5.w),
                                    // Event info
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          TextTitleWidget(
                                            title: event.title ?? "Untitled Event",
                                            color: color.textPrimary,
                                            maxLines: 1,
                                          ),
                                          SizedBox(height: AppSizes.appbarGap,),
                                          TextBodyStyleWidget(
                                            title: _formatNoticeDate(start),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Time
                                    Container(
                                      padding: EdgeInsets.all(AppSizes.contentPadding),
                                      decoration: BoxDecoration(
                                        color: color.lightVersionOfPrimaryLightVersion,
                                        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                                      ),
                                      child: TextBodyStyleWidget(title: time,color: color.primary,),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),


                  SizedBox(height: 2.5.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ActionGrid _buildActionGrid(BuildContext context) {

    return ActionGrid(
      items: [
        ActionTile(
          icon: Icons.notifications_none,
          label: "Notice",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.notice,arguments: {
              'showBackButton' :true,
            });
          },
        ),
        ActionTile(
          icon: Icons.school_outlined,
          label: "Admission",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.admission);
          },
        ),
        ActionTile(
          icon: Icons.menu_book_outlined,
          label: "Blog",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.blog);
          },
        ),
        ActionTile(
          icon: Icons.calendar_month_outlined,
          label: "Calendar",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.calender);
          },
        ),
        ActionTile(
          icon: Icons.event_outlined,
          label: "Event",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.event);
          },
        ),
        ActionTile(
          icon: Icons.camera_outlined,
          label: "Activity",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.activity_manage);
          },
        ),
        ActionTile(
          icon: Icons.image_outlined,
          label: "Gallery",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.gallery_manage);
          },
        ),
        ActionTile(
          icon: Icons.emoji_events_outlined,
          label: "Result",
          onTap: () {
            Navigator.pushNamed(context, RoutesName.exam_result);
          },
        ),
      ],
    );
  }


}




