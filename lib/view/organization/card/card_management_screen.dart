import 'package:flutter/material.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/universal/custom_status_badge.dart';

import '../../../routes/routes_name.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/sizes.dart';
import '../../../widget/textStyle/text_body_style.dart';
import '../../../widget/universal/custom_app_bar.dart';
import '../../../widget/universal/search_text_field.dart';

class CardManagementScreen extends StatefulWidget {
  const CardManagementScreen({super.key});

  @override
  State<CardManagementScreen> createState() => _CardManagementScreenState();
}

class _CardManagementScreenState extends State<CardManagementScreen> {

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Card Management",
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
                          child: SearchTextField(hinText: "Search cards...", controller: searchController),
                        ),


                      ],
                    ),
                    SizedBox(height: AppSizes.sectionGap,)

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
                      child: CustomCard(child: Column(
                        crossAxisAlignment: .start,
                        children: [

                          Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.cartBackgroundLight,
                                      borderRadius: BorderRadius.circular(AppSizes.cardRadius)
                                  ),child: Padding(
                                padding:  EdgeInsets.all(AppSizes.cardRadius),
                                child: Icon(Icons.person,color: AppColors.primary,size: AppSizes.appBarIcon,),

                                // image or icon
                                /*Image.asset(
                                    'assets/images/person.png',
                                    width: AppSizes.appBarIcon,
                                    height: AppSizes.appBarIcon,
                                    fit: BoxFit.cover,
                                  )*/

                              )),
                              Spacer(),
                              GestureDetector(onTap: (){
                                Navigator.pushNamed(context, RoutesName.add_new_card_manage,arguments: {
                                  'isEdit':true
                                });

                              },child: Icon(Icons.edit,size: AppSizes.icon,color: AppColors.primary,)),
                              SizedBox(width: AppSizes.smallGap,),
                              Icon(Icons.delete_outline_outlined,size: AppSizes.icon,color: Colors.red,),
                            ],
                          ),
                          SizedBox(height: AppSizes.itemGap,),
                          TextTitleWidget(title: "Scholarship Facility ",color: AppColors.primary,),
                          SizedBox(height: AppSizes.smallGap),

                          TextBodyStyleWidget(
                            title: "100% admission fee waiver for Classes III–V scholarships.",
                            maxLines: 4,
                            fontbold: false,
                            size: AppSizes.cardTitle,
                          ),

                          SizedBox(height: AppSizes.appbarGap),
                          Divider(),
                          SizedBox(height: AppSizes.appbarGap),
                          Row(
                            mainAxisAlignment: .end,
                            children: [
                              CustomStatusBadge(title: "IMAGE MODE"),

                            ],
                          )
                        ],
                      )),
                    );
                  })
          )

        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(


            heroTag: "add",
            backgroundColor: AppColors.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.add_new_card_manage);

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
