import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/universal/custom_card2.dart';
import 'package:storio_app/widget/universal/info_item_card.dart';

import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/search_text_field.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends StatefulWidget {
  const CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {

  final TextEditingController searchController = TextEditingController();

  // drop down
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
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Academic Calendar",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(top:AppSizes.screenPadding,left: AppSizes.screenPadding,right: AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Row(
                      children: [
                        Flexible(child: SearchTextField(onChanged:(value){},hinText: "Search...", controller: searchController)),
                        SizedBox(width: AppSizes.appbarGap),
                        CustomDropdown(
                          items:dropDownStatusList ,
                          initialValue: selectedDropDownList,
                          height: 4.5.h,
                          width: 32.w,
                          onChanged: (value) {
                            setState(() {
                              selectedDropDownList = value.toString();
                              print(selectedDropDownList);
                            });
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: AppSizes.sectionGap,),


                    CustomCard(child: TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: DateTime.now(),
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      weekendDays: const [
                        DateTime.friday,
                        DateTime.saturday,
                      ],
                      headerStyle: HeaderStyle(
                        titleTextStyle: TextStyle(
                          color: color.primary,
                          fontSize: AppSizes.sectionTitle,
                          fontWeight: FontWeight.w600,
                        ),
                        formatButtonDecoration: BoxDecoration(
                          border: Border.all(
                            color: color.primary,
                          ),
                          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                        ),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          color: color.primary,
                          fontWeight: FontWeight.w500,
                        ),

                      ),
                      calendarStyle: CalendarStyle(
                        defaultTextStyle: TextStyle(
                          color: Colors.black,
                        ),
                        weekendTextStyle: TextStyle(
                          color: Colors.red,
                        ),
                        outsideTextStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        selectedTextStyle: TextStyle(
                          color: color.cardBackground,
                        ),
                        todayTextStyle: TextStyle(
                          color: color.cardBackground,
                        ),

                      ),

                    )),

                    SizedBox(height: AppSizes.sectionGap,),


                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        TextTitleWidget( title: "Calendar Statistics",color: color.primary,),
                        SizedBox(height: AppSizes.smallGap,),
                        Row(
                          children: [
                            Flexible(child:
                            calenderStatisticWidget(context:context,title: "Working Days",value: "21",)),
                            SizedBox(width: AppSizes.appbarGap,),
                            Flexible(child:
                            calenderStatisticWidget(context:context,title: "Holidays",value: "2",)),
                            SizedBox(width: AppSizes.appbarGap,),
                            Flexible(child:
                            calenderStatisticWidget(context:context,title: "Major Exams",value: "0",)),
                          ],
                        )
                      ],

                    )),

                  ],
                ),



              ]),
            ),
          ),
          SliverPadding(
              padding: EdgeInsetsGeometry.only(left: AppSizes.screenPadding,right: AppSizes.screenPadding),
              sliver: SliverList.builder(
                  itemCount:2,
                  itemBuilder: (context,index){
                    return Column(
                      children: [],
                    );
                  })
          )

        ],
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
            child:  Icon(
              Icons.settings,
              color: color.cardBackground,
            ),
          ),
          SizedBox(height: AppSizes.itemGap,),
          FloatingActionButton(


            heroTag: "add",
            backgroundColor: color.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.add_new_event_calender);

            },
            child:  Icon(
              Icons.add,
              color: color.cardBackground,
            ),
          ),
        ],
      ),
    );
  }
}

class calenderStatisticWidget extends StatelessWidget {
  const calenderStatisticWidget({

    super.key, required this.title, required this.value,required BuildContext context,
  });
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return CustomCard2(child: Padding(
      padding:  EdgeInsets.all(AppSizes.smallPadding),
      child: Column(
        crossAxisAlignment: .center,
        children: [
          TextBodyStyleWidget(title: title,color: color.primary,),
          SizedBox(height: AppSizes.appbarGap,),
          TextBodyStyleWidget(title: value,color: color.primary,),
        ],
      ),
    ));
  }
}
