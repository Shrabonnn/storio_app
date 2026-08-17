import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_status_badge.dart';
import '../../widget/universal/image_card.dart';
import '../../widget/universal/search_text_field.dart';

class EventManagementScreen extends StatefulWidget {
  const EventManagementScreen({super.key});

  @override
  State<EventManagementScreen> createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen> {


  final TextEditingController searchController = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Event Management",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.only(top:AppSizes.screenPadding,left: AppSizes.screenPadding,right: AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Expanded(
                          child: SearchTextField(hinText: "Search", controller: searchController),
                        ),


                      ],
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
                    return ImageCard(
                      image: Image.asset(
                        "assets/images/institute.png",
                        width: double.infinity,
                        height: 18.h,
                        fit: BoxFit.cover,
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              CustomStatusBadge(title: "Published",size: AppSizes.cardTitle,),



                              // More
                              InkWell(
                                  onTap: (){},
                                  child: Icon(Icons.more_vert))
                            ],
                          ),

                          SizedBox(height: AppSizes.smallGap),


                          TextTitleWidget(
                            title: "AI & Machine Learning SeminarAI ",
                            color: AppColors.primary,
                            maxLines: 1,
                          ),

                          SizedBox(height: AppSizes.appbarGap),
                          Row(
                            children: [
                              Icon(Icons.calendar_month_outlined,color: AppColors.primary,size: AppSizes.icon,),
                              SizedBox(width: AppSizes.appbarGap,),
                              Flexible(child: TextBodyStyleWidget(title: "Aug 8, 2026, 02:51 PM",maxLines: 1,size: AppSizes.cardTitle)),
                            ],
                          ),
                          SizedBox(height: AppSizes.appbarGap),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,color: AppColors.primary,size: AppSizes.icon,),
                              SizedBox(width: AppSizes.appbarGap,),
                              Flexible(child: TextBodyStyleWidget(title: "North South University, Bashundhara, Dhaka",maxLines: 1,size: AppSizes.cardTitle)),
                            ],
                          ),


                          SizedBox(height: AppSizes.smallGap),

                          Divider(),

                          SizedBox(height: AppSizes.smallGap),

                          CustomButton(
                              height:4.5.h,
                              size:AppSizes.cardTitle,text: "View Details", onTap: () {
                            Navigator.pushNamed(context, RoutesName.view_event);
                          }),



                        ],
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
              Navigator.pushNamed(context, RoutesName.manage_event_category);
            },
            child: const Icon(
              Icons.grid_view_rounded,
              color: Colors.white,
            ),
          ),

          SizedBox(height: AppSizes.itemGap),

          FloatingActionButton(


            heroTag: "add",
            backgroundColor: AppColors.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.add_new_event);

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
