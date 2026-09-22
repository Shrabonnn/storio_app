import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/bottom_height_widget.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../data/model/Content/calender/calender_model.dart';
import '../../routes/routes_name.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../viewModel/Content/calender_view_model.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/search_text_field.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<String> dropDownStatusList = [
    "All Levels",
    "School Wide",
    "Primary",
    "Secondary",
    "College",
  ];
  String selectedDropDownList = "All Levels";

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<CalendarViewModel>();
      viewModel.getSettings();
      viewModel.getEventApi();
    });
  }

  // ============================================================
  // FLEXIBLE CATEGORY BACKGROUND COLOR MATCHING
  // ============================================================
  Color _getCategoryBgColor(String? category) {
    final cat = category?.toLowerCase() ?? '';
    if (cat.contains('exam') || cat.contains('test')) {
      return const Color(0xFFFEF08A); // Light Yellow
    } else if (cat.contains('holiday') || cat.contains('vacation')) {
      return const Color(0xFFFFD1D1); // Light Pink/Red
    } else if (cat.contains('festival') || cat.contains('cultural') || cat.contains('eid') || cat.contains('pujo')) {
      return const Color(0xFFE9D5FF); // Light Purple
    } else if (cat.contains('academic') || cat.contains('class') || cat.contains('routine')) {
      return const Color(0xFFBFDBFE); // Light Blue
    } else if (cat.contains('admin') || cat.contains('office') || cat.contains('meeting')) {
      return const Color(0xFFA7F3D0); // Light Teal/Green
    }
    return const Color(0xFFE2E8F0); // Default Light Slate
  }

  // ============================================================
  // FLEXIBLE CATEGORY TEXT COLOR MATCHING
  // ============================================================
  Color _getCategoryTextColor(String? category) {
    final cat = category?.toLowerCase() ?? '';
    if (cat.contains('exam') || cat.contains('test')) {
      return const Color(0xFF854D0E); // Dark Yellow/Brown
    } else if (cat.contains('holiday') || cat.contains('vacation')) {
      return const Color(0xFF991B1B); // Dark Red
    } else if (cat.contains('festival') || cat.contains('cultural') || cat.contains('eid') || cat.contains('pujo')) {
      return const Color(0xFF6B21A8); // Dark Purple
    } else if (cat.contains('academic') || cat.contains('class') || cat.contains('routine')) {
      return const Color(0xFF1E40AF); // Dark Blue
    } else if (cat.contains('admin') || cat.contains('office') || cat.contains('meeting')) {
      return const Color(0xFF065F46); // Dark Green
    }
    return const Color(0xFF1E293B); // Dark Slate
  }

  String? _getLevelQueryParam() {
    if (selectedDropDownList == "All Levels") return null;
    return selectedDropDownList.toLowerCase().replaceAll(' ', '-');
  }

  // ============================================================
  // CATEGORY LEGEND / HINT WIDGET (Matching Web Dashboard)
  // ============================================================
  Widget _buildCategoryLegend() {
    final categories = [
      {'name': 'Examination', 'bg': const Color(0xFFFEF08A), 'text': const Color(0xFF854D0E)},
      {'name': 'Holiday', 'bg': const Color(0xFFFFD1D1), 'text': const Color(0xFF991B1B)},
      {'name': 'Festival', 'bg': const Color(0xFFE9D5FF), 'text': const Color(0xFF6B21A8)},
      {'name': 'Academic', 'bg': const Color(0xFFBFDBFE), 'text': const Color(0xFF1E40AF)},
      {'name': 'Admin', 'bg': const Color(0xFFA7F3D0), 'text': const Color(0xFF065F46)},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 6,
      alignment: WrapAlignment.start,
      children: categories.map((cat) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: cat['bg'] as Color,
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            border: Border.all(color: (cat['text'] as Color).withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: cat['text'] as Color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              TextBodyStyleWidget(title: cat['name'] as String, size: 13.8.sp, color: cat['text'] as Color,)
            ],
          ),
        );
      }).toList(),
    );
  }

  List<CalendarEventModel> _getEventsForDay(
      DateTime day, List<CalendarEventModel> allEvents) {
    final targetDate = DateTime(day.year, day.month, day.day);

    return allEvents.where((event) {
      if (event.startDate == null) return false;

      final start = DateTime(
        event.startDate!.year,
        event.startDate!.month,
        event.startDate!.day,
      );

      final end = event.endDate != null
          ? DateTime(
        event.endDate!.year,
        event.endDate!.month,
        event.endDate!.day,
      )
          : start;

      return (targetDate.isAtSameMomentAs(start) || targetDate.isAfter(start)) &&
          (targetDate.isAtSameMomentAs(end) || targetDate.isBefore(end));
    }).toList();
  }

  Widget _buildEventBox(CalendarEventModel event) {
    final bgColor = _getCategoryBgColor(event.category);
    final textColor = _getCategoryTextColor(event.category);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        event.title ?? "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: AppSizes.body,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  // ============================================================
  // CUSTOM CALENDAR CELL BUILDER (Fixed Flex Overflow Issue)
  // ============================================================
  Widget _buildCalendarCell({
    required DateTime day,
    required List<CalendarEventModel> events,
    bool isToday = false,
    bool isSelected = false,
    bool isOutside = false,
  }) {
    final dayEvents = _getEventsForDay(day, events);

    final color = context.Appcolor;

    return Container(
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? Colors.blue
              : (isToday ? Colors.blue.withOpacity(0.5) : Colors.grey.shade300),
          width: isSelected || isToday ? 1.5 : 0.5,
        ),
        borderRadius: BorderRadius.circular(4),
        color: isOutside ? Colors.grey.withOpacity(0.05) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: isToday
                  ? const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              )
                  : null,
              child: Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: AppSizes.body,
                  fontWeight: FontWeight.bold,
                  color: isToday
                      ? Colors.white
                      : (isOutside ? Colors.grey : null),
                ),
              ),
            ),
          ),
          const SizedBox(height: 1),
          // Directly Map Top 2 Events To Avoid Unbounded ListView Overflow
          ...dayEvents.take(2).map((event) => _buildEventBox(event)),
          if (dayEvents.length > 2)
            Padding(
              padding:  EdgeInsets.only(top: 3),
              child: Text(
                "+${dayEvents.length - 2} more",
                style: TextStyle(
                  fontSize: 10.sp,
                  color:color.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return Scaffold(
      body: Consumer<CalendarViewModel>(
        builder: (context, viewModel, child) {
          final weekendIndexes =
          viewModel.settings?.weekendDayIndexes.isNotEmpty == true
              ? viewModel.settings!.weekendDayIndexes
              : [5, 6];

          final displayedEvents = _selectedDay != null
              ? _getEventsForDay(_selectedDay!, viewModel.eventList)
              : viewModel.eventList;

          return CustomScrollView(
            slivers: [
              const CustomSliverAppBar(
                title: "Academic Calendar",
                showBackButton: true,
              ),

              SliverPadding(
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
                        // Search and Filter Dropdown
                        Row(
                          children: [
                            Flexible(
                              child: SearchTextField(
                                controller: searchController,
                                hinText: "Search...",
                                onChanged: (value) {
                                  viewModel.getEventApi(
                                    search: value,
                                    level: _getLevelQueryParam(),
                                    isFilterOrSearch: true,
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: AppSizes.appbarGap),
                            CustomDropdown(
                              items: dropDownStatusList,
                              initialValue: selectedDropDownList,
                              height: 4.5.h,
                              width: 32.w,
                              onChanged: (value) {
                                setState(() {
                                  selectedDropDownList = value.toString();
                                });
                                viewModel.getEventApi(
                                  search: searchController.text,
                                  level: _getLevelQueryParam(),
                                  isFilterOrSearch: true,
                                );
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: AppSizes.sectionGap),


                        // Table Calendar Component
                        CustomCard(
                          child: viewModel.loading
                              ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                              : TableCalendar<CalendarEventModel>(
                            firstDay: DateTime.utc(2010, 10, 16),
                            lastDay: DateTime.utc(2030, 3, 14),
                            focusedDay: _focusedDay,
                            rowHeight: 85.0,
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),
                            eventLoader: (day) =>
                                _getEventsForDay(day, viewModel.eventList),
                            weekendDays: weekendIndexes,
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                            headerStyle: HeaderStyle(
                              headerPadding: EdgeInsets.zero,
                              leftChevronIcon: Icon(
                                Icons.chevron_left,
                                color: color.primary,
                                size: AppSizes.iconLarge,
                              ),

                              rightChevronIcon: Icon(
                                Icons.chevron_right,
                                color: color.primary,
                                  size: AppSizes.iconLarge
                              ),
                              titleTextStyle: TextStyle(
                                color: color.primary,
                                fontSize: AppSizes.sectionTitle,
                                fontWeight: FontWeight.w600,
                              ),
                              formatButtonDecoration: BoxDecoration(
                                border: Border.all(color: color.primary),
                                borderRadius: BorderRadius.circular(
                                    AppSizes.buttonRadius),
                              ),
                            ),
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: TextStyle(
                                color: color.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            calendarBuilders: CalendarBuilders(

                              


                              markerBuilder: (context, day, events) => const SizedBox.shrink(),

                              defaultBuilder: (context, day, focusedDay) =>
                                  _buildCalendarCell(
                                    day: day,
                                    events: viewModel.eventList,
                                  ),
                              todayBuilder: (context, day, focusedDay) =>
                                  _buildCalendarCell(
                                    day: day,
                                    events: viewModel.eventList,
                                    isToday: true,
                                  ),
                              selectedBuilder: (context, day, focusedDay) =>
                                  _buildCalendarCell(
                                    day: day,
                                    events: viewModel.eventList,
                                    isSelected: true,
                                  ),
                              outsideBuilder: (context, day, focusedDay) =>
                                  _buildCalendarCell(
                                    day: day,
                                    events: viewModel.eventList,
                                    isOutside: true,
                                  ),
                            ),
                          ),
                        ),

                        SizedBox(height: AppSizes.sectionGap),
                        // Category Color Legend (Hint Chart Header)
                        _buildCategoryLegend(),

                        SizedBox(height: AppSizes.itemGap),


                        // Calendar Statistics
                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextTitleWidget(
                                title: "Calendar Statistics",
                                color: color.primary,
                              ),
                              SizedBox(height: AppSizes.smallGap),
                              Row(
                                children: [
                                  Flexible(
                                    child: _CalendarStatisticWidget(
                                      title: "Total Events",
                                      value: "${viewModel.eventList.length}",
                                    ),
                                  ),
                                  SizedBox(width: AppSizes.smallGap),
                                  Flexible(
                                    child: _CalendarStatisticWidget(
                                      title: "Holidays",
                                      value:
                                      "${viewModel.eventList.where((e) => (e.category ?? '').toLowerCase().contains('holiday')).length}",
                                    ),
                                  ),
                                  SizedBox(width: AppSizes.smallGap),
                                  Flexible(
                                    child: _CalendarStatisticWidget(
                                      title: "Major Exams",
                                      value:
                                      "${viewModel.eventList.where((e) => (e.category ?? '').toLowerCase().contains('exam')).length}",
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: AppSizes.sectionGap),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextTitleWidget(
                              title: _selectedDay == null
                                  ? "All Events"
                                  : "Events (${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year})",
                              color: color.primary,
                            ),
                            if (_selectedDay != null)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedDay = null;
                                  });
                                },
                                child: const Text("Show All"),
                              ),

                            SizedBox(height: AppSizes.smallGap),
                          ],
                        ),

                        SizedBox(height: AppSizes.smallGap),
                      ],
                    ),
                  ]),
                ),
              ),

              // Event Detailed List Below (With Delete Option)
              displayedEvents.isEmpty
                  ? SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: TextBodyStyleWidget(
                      title: "No events found",
                      color: color.textPrimary,
                    ),
                  ),
                ),
              )
                  : SliverPadding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding),
                sliver: SliverList.builder(
                  itemCount: displayedEvents.length,
                  itemBuilder: (context, index) {
                    final event = displayedEvents[index];
                    final catBgColor = _getCategoryBgColor(event.category);
                    final catTextColor = _getCategoryTextColor(event.category);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: CustomCard(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            width: 5,
                            height: 45,
                            decoration: BoxDecoration(
                              color: catTextColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          title: TextTitleWidget(
                            title: event.title ?? "Untitled Event",
                            color: color.primary,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (event.description != null &&
                                  event.description!.isNotEmpty)
                                Padding(
                                  padding:
                                  const EdgeInsets.only(top: 2.0),
                                  child: TextBodyStyleWidget(
                                    title: event.description!,
                                    color: color.textPrimary,
                                  ),
                                ),
                               SizedBox(height: AppSizes.appbarGap),
                              Row(
                                children: [
                                  Container(
                                    padding:  EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: catBgColor,
                                      borderRadius:
                                      BorderRadius.circular(4),
                                    ),
                                    child:  TextBodyStyleWidget(
                                      title: event.categoryDisplay ?? event.category ?? ""
                                      ,size: AppSizes.cardSubTitle,),
                                  ),
                                  const SizedBox(width: 8),
                                  TextBodyStyleWidget(title: "${_formatDate(event.startDate)} - ${_formatDate(event.endDate)}",size: AppSizes.cardSubTitle,),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            onPressed: () async {
                              if (event.id == null) return;

                              final success = await viewModel
                                  .deleteEvent(event.id!);

                              if (success) {
                                viewModel.getEventApi(
                                  search: searchController.text,
                                  level: _getLevelQueryParam(),
                                  isFilterOrSearch: true,
                                );

                                if (mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Event deleted successfully")),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              BottomHeightWidget()
            ],
          );
        },
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "setting",
            backgroundColor: color.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.calender_setting);
            },
            child: Icon(
              Icons.settings,
              color: color.cardBackground,
            ),
          ),
          SizedBox(height: AppSizes.itemGap),
          FloatingActionButton(
            heroTag: "add",
            backgroundColor: color.primary,
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                RoutesName.add_new_event_calender,
              );
              if (result == true && mounted) {
                context.read<CalendarViewModel>().getEventApi();
              }
            },
            child: Icon(
              Icons.add,
              color: color.cardBackground,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    return "${date.day}/${date.month}/${date.year}";
  }
}

class _CalendarStatisticWidget extends StatelessWidget {
  const _CalendarStatisticWidget({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return CustomCard2(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.smallPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextBodyStyleWidget(title: title, color: color.primary),
            SizedBox(height: AppSizes.appbarGap),
            TextBodyStyleWidget(title: value, color: color.primary),
          ],
        ),
      ),
    );
  }
}