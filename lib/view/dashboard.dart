import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';

import '../routes/routes_name.dart';
import '../utils/app_colors.dart';
import '../utils/sizes.dart';
import '../widget/dashboard/action_grid.dart';
import '../widget/dashboard/action_tile.dart';
import '../widget/dashboard/stat_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
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
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.cartbackground, AppColors.primary],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 4.5.h,
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
                                      width: 10.w,
                                      height: 10.w,
                                      child: Image.asset(
                                        "assets/images/Storio_main_logo.png",
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    TextTitleWidget(title: 'Storio',size: AppSizes.appBarTitle,)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.search_sharp,
                                        color: Colors.white,
                                        size: AppSizes.icon,
                                      ),
                                    ),
                                    Icon(
                                      Icons.circle_rounded,
                                      size: AppSizes.iconSmall,
                                      color: Colors.red,
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 1.5.w,
                                          vertical: .5.h,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Text(
                                          "Visit Site",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
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
                                    TextTitleWidget(title: 'Hello, MAIYASHA👋',),
                                    TextBodyStyleWidget(title: "Welcome back to Storio",color: Colors.white,),
                                  ],
                                ),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: AssetImage(
                                        "assets/images/person.png",
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, RoutesName.profile);
                                      },
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
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
                    child: StatCard(label: "Total Users", value: "5"),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: StatCard(label: "Blog Posts", value: "8"),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: StatCard(label: "Total Events", value: "10"),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: StatCard(label: "Total Notices", value: "3"),
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
                  TextTitleWidget(title: "Overview",color: AppColors.primary,),

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
                                color: Colors.black54,
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
                                  color: Colors.black54,
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
                        color: AppColors.primary,
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
                              AppColors.secondary,
                              AppColors.cartBackgroundLight,
                            ],
                          ),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, bar, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: AppColors.primary,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
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
                      TextTitleWidget(title: "Actions",color: AppColors.primary,),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RoutesName.action_details);
                        },
                        child: Row(
                          children: [
                            TextBodyStyleWidget(title: "View More",color: AppColors.primary,),
                            Icon(
                              Icons.chevron_right,
                              size: AppSizes.icon,
                              color: AppColors.primary,
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
                      TextTitleWidget(title: "Notices",color: AppColors.primary,),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            TextBodyStyleWidget(title: "View All",color: AppColors.primary,),

                            Icon(
                              Icons.chevron_right,
                              size: AppSizes.icon,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.smallGap),
                  // Notice card
                  CustomCard(child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 2,
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Divider(),
                      );
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        height: 7.h,
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          //color: AppColors.cartBackgroundLight,
                          borderRadius: BorderRadius.circular(3.w),
                        ),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding:  EdgeInsets.only(right: 2.w),
                                  child: Icon(
                                    Icons.south_east,
                                    size: 2.5.h,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Admission will be open ",
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,

                                          ),
                                        ),
                                      ),
                                      Text(
                                        "26th July, 2026",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),),



                  SizedBox(height: AppSizes.sectionGap),



                  // Upcoming Events
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextTitleWidget(title: "Upcoming Events",color: AppColors.primary,),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            TextBodyStyleWidget(title: "View All",color: AppColors.primary,),

                            Icon(
                              Icons.chevron_right,
                              size: AppSizes.icon,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.smallGap),
                  // Upcoming event card
                  CustomCard(child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 2,
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 2.w),
                        child: Divider(),
                      );
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        height: 8.h,
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(3.w),
                        ),
                        child: Row(
                          children: [
                            // Date Card
                            Container(
                              width: 16.w,
                              margin: EdgeInsets.symmetric(vertical: 4),
                              padding: EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.w),
                                color: AppColors.cartBackgroundLight,
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
                                    child: TextBodyStyleWidget(title: "AUG",color: AppColors.primary,),
                                  ),
                                  Flexible(
                                    child: TextTitleWidget(title: "10",color: AppColors.primary,),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 2.5.w),
                            // Exam info
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  TextTitleWidget(title: "Exam Starts",color: AppColors.primary,),
                                  SizedBox(height: AppSizes.appbarGap,),
                                  TextBodyStyleWidget(title: "10 August, 2026",),
                                ],
                              ),
                            ),
                            // Time
                            Container(
                              padding: EdgeInsets.all(AppSizes.contentPadding),
                              decoration: BoxDecoration(
                                color: AppColors.cartBackgroundLight,
                                borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                              ),
                              child: TextBodyStyleWidget(title: "10: 00 AM",color: AppColors.primary,),
                            ),
                          ],
                        ),
                      );
                    },
                  ),),


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
            Navigator.pushNamed(context, RoutesName.activity_manage);
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
            Navigator.pushNamed(context, RoutesName.dasboard);
          },
        ),
      ],
    );
  }
}
