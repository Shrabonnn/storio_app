import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/widget/universal/search_text_field.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_status_badge.dart';

class FaqManagementScreen extends StatefulWidget {
  const FaqManagementScreen({super.key});




  @override
  State<FaqManagementScreen> createState() => _FaqManagementScreenState();
}

class _FaqManagementScreenState extends State<FaqManagementScreen> {

  final TextEditingController searchController = TextEditingController();


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
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "FAQ",showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [

                    Row(
                      children: [
                        Expanded(child: SearchTextField(onChanged:(value){},hinText: "Search FAQ...",controller: searchController,)),
                      ],
                    ),

                  ],
                )
              ]),
            ),
          ),
          SliverPadding(padding: EdgeInsets.symmetric(horizontal:AppSizes.screenPadding),
            sliver: SliverList.builder(
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: AppSizes.sectionGap),
                  child: CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Question
                        TextBodyStyleWidget(
                          title: "Question: Admission process starts ?",
                          maxLines: 2,
                          color: color.primary,
                          size: AppSizes.sectionTitle,
                        ),

                        SizedBox(height: AppSizes.smallGap),

                        // Answer
                        TextBodyStyleWidget(
                          title: "Answer: Checking the FAQ API",
                          maxLines: 3,
                          color: color.primary,
                          size: AppSizes.cardTitle,
                        ),

                        SizedBox(height: AppSizes.itemGap),

                        // Status + Created date
                        Row(
                          children: [


                            // Created date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: .spaceBetween,
                                    children: [
                                      TextBodyStyleWidget(
                                        title: "Created On",
                                        color: color.primary,
                                        size: AppSizes.cardTitle,
                                      ),

                                      CustomStatusBadge(
                                        title: "Visible",
                                        backgroundColor: Colors.green.shade100,
                                        size: AppSizes.cardTitle,

                                      ),
                                    ],
                                  ),


                                  TextBodyStyleWidget(
                                    title: "May 2, 2026",
                                    color: color.primary,
                                    size: AppSizes.cardTitle,
                                  ),
                                ],
                              ),
                            ),



                          ],
                        ),



                        Divider(),


                        // Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            Flexible(
                              child: CustomButton(
                                text: "Edit",
                                onTap: () {
                                  Navigator.pushNamed(context, RoutesName.edit_faq);
                                },

                              ),
                            ),

                            SizedBox(width: AppSizes.smallGap),

                            Flexible(
                              child: CustomButton(
                                text: "Delete",
                                onTap: () {},

                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },

              itemCount: 2,
            ),),



          SliverPadding(padding: EdgeInsets.only(bottom:AppSizes.sectionGap))
        ],
      ),
    );
  }
}
