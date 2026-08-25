import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/utils/sizes.dart';
import 'package:storio_app/widget/custom_button/custom_buttom.dart';
import 'package:storio_app/widget/textStyle/text_body_style.dart';
import 'package:storio_app/widget/universal/custom_card.dart';
import 'package:storio_app/widget/universal/search_text_field.dart';

import '../../widget/universal/custom_app_bar.dart';

class MediaManageScreen extends StatefulWidget {
  const MediaManageScreen({super.key});

  @override
  State<MediaManageScreen> createState() => _MediaManageScreenState();
}

class _MediaManageScreenState extends State<MediaManageScreen> {

  final TextEditingController searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(title: "Media Manage",showBackButton: true,),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                CustomCard(child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SearchTextField(onChanged:(value){},
                              hinText: "Search Media...",
                              controller: searchController)
                        ),
                        SizedBox(width: AppSizes.appbarGap),

                        CustomButton(text: "+ Add New File", width: 25.w,height: 4.5.h,onTap: (){
                          Navigator.pushNamed(context, RoutesName.media_manage_details);
                        })
                      ],
                    ),
                    SizedBox(height: AppSizes.sectionGap,),
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 8,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.80,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, RoutesName.media_manage_details);
                          },
                          child: Card(
                            elevation: 2,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    color: Colors.grey.shade200,
                                    child: Image.asset(
                                      "assets/images/person.png",
                                      width: double.infinity,
                                      fit: BoxFit.fitHeight,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.image_not_supported,
                                            color: Colors.grey);
                                      },
                                    ),
                                  ),
                                ),


                                Flexible(
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.all( 1.w,),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextBodyStyleWidget(
                                            title: "Caption",
                                            color: Colors.black,
                                            size: AppSizes.cardTitle,
                                          ),
                                          SizedBox(height: AppSizes.appbarGap ),
                                          TextBodyStyleWidget(
                                            title: "This is sample description of media file.",
                                            maxLines: 2,
                                            size: AppSizes.cardSubTitle,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )

                  ],

                ))
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
