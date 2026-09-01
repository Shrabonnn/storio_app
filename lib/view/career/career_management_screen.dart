import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/search_text_field.dart';
import '../../widget/universal/status_button_row.dart';

class CareerManagementScreen extends StatefulWidget {
  const CareerManagementScreen({super.key});

  @override
  State<CareerManagementScreen> createState() => _CareerManagementScreenState();
}

class _CareerManagementScreenState extends State<CareerManagementScreen> {


  final TextEditingController searchController = TextEditingController();

  List <String> statusList = ["All","Active", "Draft" ,"Expired"];
  int selectedStatus = 0;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body:  CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Exam Results",
            subtitle: "Academic Records",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(top: AppSizes.screenPadding,left: AppSizes.screenPadding,right: AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [


                    Row(
                      children: [
                        Expanded(
                          child: SearchTextField(onChanged:(value){},
                            hinText: 'Search by title or company...',
                            controller: searchController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.sectionGap),
                    StatusButtonRow(
                      items: statusList,
                      selectedIndex: selectedStatus,
                      onSelected: (index) {
                        setState(() {
                          selectedStatus = index;
                        });
                      },
                      onTap: (status) {


                        print("Clicked: $status");
                      },
                    ),
                    SizedBox(height: AppSizes.sectionGap),


                  ],
                ),
              ]),
            ),
          ),
          if(selectedStatus == 0)
            SliverPadding(padding: EdgeInsets.symmetric(horizontal:AppSizes.screenPadding),
              sliver: SliverList.builder(
                itemBuilder: (context, index) {
                 return Container(
                   margin: EdgeInsets.only(
                     bottom: AppSizes.sectionGap,
                   ),
                   child: CustomCard(
                     child: SingleChildScrollView(
                       scrollDirection: Axis.horizontal,
                       child: ConstrainedBox(
                         constraints: const BoxConstraints(
                           minWidth: 900,
                         ),
                         child: Table(
                           defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                           columnWidths: const {
                             0: FlexColumnWidth(2.3),
                             1: FlexColumnWidth(1.8),
                             2: FlexColumnWidth(1.2),
                             3: FlexColumnWidth(1.3),
                             4: FlexColumnWidth(1.2),
                             5: FlexColumnWidth(1),
                           },
                           children: [
                             // ================= HEADER =================
                             TableRow(
                               children: [
                                 _tableCell(
                                   context:context,
                                   "JOB TITLE & COMPANY",
                                   isHeader: true,
                                 ),
                                 _tableCell(
                                   context:context,
                                   "TYPE & LOCATION",
                                   isHeader: true,
                                 ),
                                 _tableCell(
                                   context:context,
                                   "CANDIDATES",
                                   isHeader: true,
                                 ),
                                 _tableCell(
                                   context:context,
                                   "DEADLINE",
                                   isHeader: true,
                                 ),
                                 _tableCell(
                                   context:context,
                                   "STATUS",
                                   isHeader: true,
                                 ),
                                 _tableCell(
                                   context:context,
                                   "ACTIONS",
                                   isHeader: true,
                                 ),
                               ],
                             ),

                             // ================= BODY =================
                             TableRow(
                               children: [
                                 _tableCell(
                                   context:context,
                                   "Sr. Software Engineer\nBrainicon Technology",
                                 ),
                                 _tableCell(
                                   context:context,
                                   "Full-Time\nDhaka",
                                 ),
                                 _tableCell(
                                   context:context,
                                   "1 Openings",
                                 ),
                                 _tableCell(
                                   context:context,
                                   "4/30/2026",
                                 ),
                                 _tableCell(
                                   context:context,
                                   "Active",
                                 ),
                                 _tableCell(
                                   context:context,
                                   "",
                                   icons: [
                                     Icons.edit_outlined,
                                     Icons.delete_outline,
                                   ],
                                   onTaps: [
                                         () {
                                       Navigator.pushNamed(context, RoutesName.add_new_job_circular,arguments: {
                                         'isEdit':true
                                       });
                                     },
                                         () {
                                       print("Delete");
                                     },
                                   ],
                                 ),
                               ],
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                 );
                },

                itemCount: 2,
              ),),



          SliverPadding(padding: EdgeInsets.only(bottom:AppSizes.sectionGap))
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [


          FloatingActionButton(
            heroTag: "add",
            backgroundColor: color.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.add_new_job_circular,arguments: {
                'isEdit': false,
              },);
            },
            child:  Icon(Icons.add, color: color.cardBackground),
          ),
        ],
      ),
    );
  }
}



Widget _tableCell(
    String text, {
      required BuildContext context,
      bool isHeader = false,
      List<IconData>? icons,
      List<VoidCallback>? onTaps,


    }) {
  final color = context.Appcolor;
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: AppSizes.cardPadding,
      vertical: AppSizes.itemGap,
    ),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
    ),
    child: icons != null
        ? Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
            icons.length,
                (index) {
              return InkWell(
                onTap: onTaps?[index],
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    icons[index],
                    size: 20,
                  ),
                ),
              );
            },
          ),
        )
        : Text(
      text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: isHeader
            ? AppSizes.cardSubTitle
            : AppSizes.cardTitle,
        fontWeight: isHeader
            ? FontWeight.w600
            : FontWeight.w500,
        color: isHeader
            ? color.primary
            : Colors.grey.shade700,
      ),
    ),
  );
}