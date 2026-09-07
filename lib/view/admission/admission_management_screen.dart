import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/custom_button/view_button.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/more_menu.dart';

import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/search_text_field.dart';
import '../../widget/universal/status_button_row.dart';

class AdmissionManagementScreen extends StatefulWidget {
  const AdmissionManagementScreen({super.key});

  @override
  State<AdmissionManagementScreen> createState() => _AdmissionManagementScreenState();
}

class _AdmissionManagementScreenState extends State<AdmissionManagementScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<String> statusList = [
    "All",
    "Pending",
    "Under Review",
    "Approved",
    "Rejected"
  ];

  int selectedStatus = 0;


  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Admission Management",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(top:AppSizes.screenPadding,left: AppSizes.screenPadding,right: AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Expanded(
                          child: SearchTextField(onChanged:(value){},hinText: "Search by student name, email, or application", controller: searchController),
                        ),

                      ],
                    ),
                    SizedBox(height: AppSizes.smallGap),
                    StatusButtonRow(
                      items: statusList,
                      selectedIndex: selectedStatus,
                      onSelected: (index) {
                        setState(() {
                          selectedStatus = index;
                        });
                      },
                      onTap: (status) {
                        // Set with API

                        print("Clicked: $status");
                      },
                    ),
                    SizedBox(height: AppSizes.sectionGap,),

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
                    return Container(
                      margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                      child: CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                TextTitleWidget(title: "Tony Stark",color: color.primary,),
                                MoreMenu(

                                  items: const [
                                    MoreMenuAction.view,
                                    MoreMenuAction.delete,
                                  ],
                                  onSelected: (action) {
                                    switch (action) {
                                      case MoreMenuAction.edit:
                                        break;

                                      case MoreMenuAction.view:
                                        Navigator.pushNamed(context, RoutesName.view_admission);
                                        break;

                                      case MoreMenuAction.delete:
                                      // delete
                                        break;
                                      case MoreMenuAction.archive:
                                       // archive
                                      break;
                                      case MoreMenuAction.changePassword:
                                      // TODO: Handle this case.
                                        throw UnimplementedError();
                                      case MoreMenuAction.suspend:
                                      // TODO: Handle this case.
                                        throw UnimplementedError();
                                    }
                                  },
                                ),
                              ],
                            ),

                             SizedBox(height: AppSizes.itemGap),

                            _infoRow(context,"Grade", "Grade 1"),
                            _infoRow(context,"Admission No", "ADM-2026-0001"),
                            _infoRow(context,"Email", "alfasunny95@gmail.com"),
                            _infoRow(context,"Phone", "01793960082"),
                            _infoRow(context,"Date", "Apr 9, 2026"),

                            SizedBox(height: AppSizes.itemGap),


                          ],
                        ),
                      ),
                    );
                  })
          )

        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(

            heroTag: "addCategory",
            backgroundColor: color.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.admission_general_setting);
            },
            child:  Icon(
              Icons.settings,
              color: color.cardBackground,
            ),
          ),

          SizedBox(height: AppSizes.itemGap),


          FloatingActionButton(


            heroTag: "add",
            backgroundColor: color.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.admission_form_builder);

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
Widget _infoRow(BuildContext context,String title, String value) {
  final color = context.Appcolor;
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 30.w,
          child: TextBodyStyleWidget(title: title)
        ),
        Expanded(
          child: TextBodyStyleWidget(title: value,color: color.primary,),
        ),
      ],
    ),
  );
}