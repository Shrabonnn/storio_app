import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/universal/custom_card2.dart';
import 'package:storio_app/widget/universal/custom_status_badge.dart';

import '../../../utils/app_sizes.dart';
import '../../../utils/theme/theme_ext.dart';
import '../../../widget/universal/custom_app_bar.dart';

class EducationBoardNotices extends StatefulWidget {
  const EducationBoardNotices({super.key});

  @override
  State<EducationBoardNotices> createState() => _EducationBoardNoticesState();
}

class _EducationBoardNoticesState extends State<EducationBoardNotices> {

  List<String> educationBoards = [
    "Dhaka",
    "Rajshahi",
    "Comilla",
    "Jessore",
    "Chittagong",
    "Barisal",
    "Sylhet",
    "Dinajpur",
    "Mymensingh",
    "Madrasah",
    "Technical",
  ];
  String? selectedBoard;



  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Education Board Notices",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(top:AppSizes.screenPadding,left: AppSizes.screenPadding,right: AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: .start,
                  children: [
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextTitleWidget(
                            title: "Select Education Board (Single)",
                            color: color.primary,
                          ),

                          SizedBox(height: AppSizes.smallGap),

                          GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: educationBoards.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 6,
                              childAspectRatio: 4.5,
                            ),
                            itemBuilder: (context, index) {
                              final board = educationBoards[index];

                              //print("board: $board");
                              //print("selected: $selectedBoard");
                              return CustomCard2(
                                child: Row(
                                  children: [
                                    Radio<String>(
                                      value: board,
                                      groupValue: selectedBoard,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedBoard = value!;
                                          print("selected: $selectedBoard");
                                        });
                                      },
                                    ),

                                    TextBodyStyleWidget(
                                      title: board,

                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: AppSizes.itemGap),

                          CustomButton(text: "Fetch Latest Notices", onTap: (){

                          })

                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.sectionGap,),
                    // Fetch latest Notices
                    Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 5,itemBuilder: (context,index){
                          return Container(
                            margin: EdgeInsets.only(bottom: AppSizes.smallPadding),
                            child: CustomCard2(child: Padding(
                              padding:  EdgeInsets.all(AppSizes.smallPadding),
                              child: Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: .start,
                                      children: [
                                        TextBodyStyleWidget(title:"২০২৬-২০২৭ শিক্ষাবর্ষে ৯ম শ্রেণিতে অধ্যয়নরত শিক্ষার্থীদের রেজিস্ট্রেশনকরণ প্রসঙ্গে",maxLines: 1,),
                                        TextBodyStyleWidget(title: "১৯-০৮-২০২৬",maxLines: 1,),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: AppSizes.itemGap,),
                                  CustomStatusBadge(title: "View",backgroundColor: color.primary,foregroundColor: color.cardBackground,)
                                ],
                              ),
                            )),
                          );
                        })
                      ],
                    ),

                    SizedBox(height: AppSizes.sectionGap,),
                    // Important Links
                    CustomCard(
                      child:Column(
                        children: [
                          Row(
                            children: [
                              Column(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: color.lightVersionOfPrimaryLightVersion,
                                        borderRadius: BorderRadius.circular(AppSizes.buttonRadius)
                                      ),child: Padding(
                                        padding:  EdgeInsets.all(AppSizes.buttonRadius),
                                        child: Icon(Icons.link,size: AppSizes.appBarIcon,color: color.primary,),
                                      ))
                                ],
                              ),
                              SizedBox(width: AppSizes.itemGap,),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: .start,
                                  children: [
                                    TextTitleWidget(
                                      title: "Important Links",
                                      color: color.primary,
                                    ),
                                    SizedBox(height: AppSizes.appbarGap),
                                    TextBodyStyleWidget(
                                      title: "Manage quick access links for your institution ",fontbold: false),
                                  ],
                                ),
                              )

                            ],
                          ),

                          SizedBox(height: AppSizes.itemGap),
                          CustomButton(text: "Add New Link", onTap: (){
                            Navigator.pushNamed(context, RoutesName.add_new_links);
                          })

                        ],
                      ),



                    ),
                    SizedBox(height: AppSizes.sectionGap,),

                    // list of link
                    Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 2,itemBuilder: (context,index){
                          return Container(
                            margin: EdgeInsets.only(bottom: AppSizes.smallPadding),
                            child: CustomCard2(child: Padding(
                              padding:  EdgeInsets.all(AppSizes.smallPadding),
                              child: Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  Flexible(
                                    child: Row(
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                color: color.cardBackground.withValues(alpha: 0.7),
                                                borderRadius: BorderRadius.circular(AppSizes.buttonRadius)
                                            ),child: Padding(
                                          padding:  EdgeInsets.all(AppSizes.buttonRadius),
                                          child: Icon(Icons.language_outlined,size: AppSizes.appBarIcon,color: color.secondary,),
                                        )),
                                        SizedBox(width: AppSizes.smallGap,),

                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment: .start,
                                            children: [
                                              TextBodyStyleWidget(title:"Bangladesh Cricket Board",maxLines: 1,),
                                              TextBodyStyleWidget(title: "https://www.tigercricket.com.bd/",maxLines: 1,),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(width: AppSizes.itemGap,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.pushNamed(context, RoutesName.add_new_links,arguments: {
                                          'isEdit':true,
                                        });
                                      }
                                      ,child: Icon(Icons.edit,size: AppSizes.icon,color: color.primary,)),
                                  SizedBox(width: AppSizes.itemGap,),
                                  GestureDetector(
                                      onTap: (){}
                                      ,child: Icon(Icons.delete_outline_outlined,size: AppSizes.icon,color: Colors.red,)),
                                ],
                              ),
                            )),
                          );
                        })
                      ],
                    ),
                    // if no value then  api ashle connent
                    /*SizedBox(
                          height: 25.h,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 70,
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.link_rounded,
                                    size: 36,
                                    color: Colors.blueGrey,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                const Text(
                                  'No Important Links Found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  "Click 'Add New Link' to get started",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )*/

                    SizedBox(height: AppSizes.sectionGap,),
                    SizedBox(height: AppSizes.sectionGap,),

                  ],
                ),

              ]),
            ),
          ),


        ],
      ),
    );
  }
}
