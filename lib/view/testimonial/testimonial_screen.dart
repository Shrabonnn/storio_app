import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/widget/universal/custom_status_badge.dart';

import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/textStyle/text_title_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_text_field.dart';
import '../../widget/universal/search_text_field.dart';

class TestimonialScreen extends StatefulWidget {
  const TestimonialScreen({super.key});

  @override
  State<TestimonialScreen> createState() => _TestimonialScreenState();
}

class _TestimonialScreenState extends State<TestimonialScreen> {

  final TextEditingController searchController = TextEditingController();

  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController departmentController =
  TextEditingController();

  final TextEditingController descriptionController =
  TextEditingController();


  List<String> statusItem = ["All Status", "Published", "Draft"];

  @override
  void dispose() {
    searchController.dispose();
    nameController.dispose();
    departmentController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Testimonials",
            subtitle: "Manage user feedback and customer reviews",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SearchTextField(
                            onChanged:(value){},
                            hinText: "Search...",
                            controller: searchController,
                          ),
                        ),
                        SizedBox(width: AppSizes.appbarGap),
                        CustomDropdown(
                          items: statusItem,
                          initialValue: statusItem[0],
                          width: 32.w,
                          height: 4.5.h,
                          onChanged: (value) {
                            print("Selected: $value");
                          },
                        ),
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
                      children: [

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: color.primary,
                                  width: 1,
                                ),
                              ),
                              child: const CircleAvatar(
                                backgroundImage: AssetImage(
                                  "assets/images/person.png",
                                ),
                              ),
                            ),

                            SizedBox(width: AppSizes.smallGap),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextTitleWidget(
                                    title: "John Kabir",
                                    size: 18,
                                    color: color.primary,
                                  ),

                                  SizedBox(height: AppSizes.appbarGap),

                                  TextBodyStyleWidget(
                                    title: "CPES",
                                    size: 14,
                                    color: color.primary,
                                  ),

                                  SizedBox(height: AppSizes.appbarGap),

                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.amber, size: 20),
                                      Icon(Icons.star, color: Colors.amber, size: 20),
                                      Icon(Icons.star, color: Colors.amber, size: 20),
                                      Icon(Icons.star_border, color: Colors.grey, size: 20),
                                      Icon(Icons.star_border, color: Colors.grey, size: 20),

                                      Spacer(),
                                      CustomStatusBadge(
                                        title: "PUBLISHED",

                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),


                        SizedBox(height: AppSizes.itemGap),

                        TextBodyStyleWidget(
                          title:
                          "Participating in the demo was an enriching experience. "
                              "The platform effectively showcased the practical applications "
                              "of theoretical concepts, bridging the gap between classroom "
                              "learning and real-world research. The clarity of the presentation,...",

                          maxLines: 4,

                        ),

                        SizedBox(height: AppSizes.itemGap),
                        // Edit + Delete buttons
                        Row(
                          children: [

                            Flexible(child: CustomButton(text: "Edit", onTap: (){
                              Navigator.pushNamed(context, RoutesName.edit_testimonial);
                            },height: 4.5.h,)),
                            SizedBox(width: AppSizes.appbarGap,),
                            Flexible(child: CustomButton(text: "Delete", onTap: (){},height: 4.5.h,backgroundColor: Colors.red,)),


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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "add",
            backgroundColor: color.primary,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.add_new_testimonial);
            },
            child:  Icon(Icons.add, color: color.cardBackground),
          ),
        ],
      ),
    );
  }
}
