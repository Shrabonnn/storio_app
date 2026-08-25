import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
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
                            TextTitleWidget(title: "Tony Stark",color: AppColors.primary,),

                             SizedBox(height: AppSizes.itemGap),

                            _infoRow("Grade", "Grade 1"),
                            _infoRow("Admission No", "ADM-2026-0001"),
                            _infoRow("Email", "alfasunny95@gmail.com"),
                            _infoRow("Phone", "01793960082"),
                            _infoRow("Date", "Apr 9, 2026"),

                            SizedBox(height: AppSizes.itemGap),

                            Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    text: "View",
                                    onTap: () {
                                      Navigator.pushNamed(context, RoutesName.view_admission);
                                    },
                                  ),
                                ),
                                SizedBox(width: AppSizes.appbarGap),
                                Expanded(
                                  child: CustomButton(
                                    text: "Delete",
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
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
            backgroundColor: AppColors.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.admission_general_setting);
            },
            child: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),

          SizedBox(height: AppSizes.itemGap),


          FloatingActionButton(


            heroTag: "add",
            backgroundColor: AppColors.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.admission_form_builder);

            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
Widget _infoRow(String title, String value) {
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
          child: TextBodyStyleWidget(title: value,color: AppColors.primary,),
        ),
      ],
    ),
  );
}