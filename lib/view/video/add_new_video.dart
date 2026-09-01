import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/routes/routes_name.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';
import 'package:storio_app/widget/universal/custom_drop_down.dart';
import 'package:storio_app/widget/universal/status_button_row.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_card2.dart';
import '../../widget/universal/custom_text_field.dart';

class AddNewVideo extends StatefulWidget {
  const AddNewVideo({super.key,  this.isEdit=false});

  final bool isEdit ;

  @override
  State<AddNewVideo> createState() => _AddNewVideoState();
}

class _AddNewVideoState extends State<AddNewVideo> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController embedCodeController = TextEditingController();
  final TextEditingController externalLinkCodeController = TextEditingController();



  final List<String> contentType = [
    "Video",
    "Reel",
  ];

  int selectedContentType = 0;


  final List<String> videoSource = [
    "External Link",
    "Upload Video",
    "Embed Code"
  ];

  int selectedVideoSource = 0;


  final List<String> visibilityStatus = [
    "Active",
    "Draft",
    "Archived"
  ];

  int selectedVisibilityStatus = 0;


  final List<String> platformType = [
    "Custom / Native",
    "Youtube",
    "Instagram",
    "TikTok",
    "Vimeo"
  ];

  String selectedPlatformType = "Custom / Native";

  bool isfeature = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    embedCodeController.dispose();
    externalLinkCodeController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(

      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title:widget.isEdit? "Edit Video" :"Create New Video",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [

                        // Title
                        TextBodyStyleWidget(title: "Title", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "e.g. Enter video title", controller: titleController),
                        SizedBox(height: AppSizes.itemGap,),


                        // Content Type & Platform
                        Row(
                          children: [
                            Flexible(
                              child: Column(
                                children: [
                                  TextBodyStyleWidget(title: "Content Type", color: color.primary,size: AppSizes.sectionTitle,),
                                  SizedBox(height: AppSizes.appbarGap,),
                                  StatusButtonRow(items: contentType, selectedIndex: selectedContentType,
                                    onSelected:(index){
                                    setState(() {
                                      selectedContentType = index;
                                    });
                                    },
                                    onTap: (status) {
                                      print("Clicked: $status");
                                    },)

                                ],
                              ),
                            ),
                            SizedBox(width: AppSizes.sectionGap,),
                            SizedBox(width: AppSizes.sectionGap,),
                            SizedBox(width: AppSizes.sectionGap,),
                            Column(
                              children: [

                                TextBodyStyleWidget(title: "Platform", color: color.primary,size: AppSizes.sectionTitle,),
                                SizedBox(height: AppSizes.appbarGap,),
                                CustomDropdown(items: platformType,initialValue: selectedPlatformType,width: 38.w,)

                              ],
                            )
                          ],
                        ),
                        SizedBox(height: AppSizes.itemGap,),


                        // Video sources
                        TextBodyStyleWidget(title: "Video Source", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        StatusButtonRow(items: videoSource, selectedIndex: selectedVideoSource,
                          onSelected:(index){
                            setState(() {
                              selectedVideoSource = index;

                            });
                          },
                          onTap: (status) {
                            print("Clicked: $status");
                          },),
                        if(selectedVideoSource == 0)...[
                          SizedBox(height: AppSizes.itemGap,),
                          CustomTextFieldWidget(controller: externalLinkCodeController, hintText: "https://...")
                        ],
                        if(selectedVideoSource == 1)...[
                          SizedBox(height: AppSizes.itemGap,),
                          GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, RoutesName.media_manage_details);
                            },
                            child: CustomCard2(child: Padding(
                              padding:  EdgeInsets.all(AppSizes.contentPadding),
                              child: Column(
                                children: [
                                  Icon(Icons.cloud_upload_outlined,size: AppSizes.appBarIcon,color: Colors.grey,),
                                  SizedBox(height: AppSizes.itemGap,),
                                  TextBodyStyleWidget(title: "Select video from Media Library",)
                                ],
                              ),
                            )),
                          )
                        ],
                        if(selectedVideoSource == 2)...[
                          SizedBox(height: AppSizes.itemGap,),
                          CustomTextFieldWidget(controller: embedCodeController, minLines: 3,maxLines:4,hintText: "Paste iframe embed code here ...")
                        ],
                        SizedBox(height: AppSizes.itemGap,),


                        TextBodyStyleWidget(title: "Description", color: color.primary,size: AppSizes.sectionTitle,),
                        SizedBox(height: AppSizes.appbarGap),
                        CustomTextFieldWidget(hintText: "e.g. Enter video description", controller: descriptionController,minLines: 4,maxLines: 6,),

                      ],
                    )),
                    SizedBox(height: AppSizes.sectionGap,),
                    CustomCard(child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.remove_red_eye_outlined,size: AppSizes.iconLarge,color: Colors.grey,),
                            SizedBox(width: AppSizes.appbarGap,),
                            TextBodyStyleWidget(title: "Visibility & Status", color: color.primary,size: AppSizes.sectionTitle,),

                          ],
                        ),
                        SizedBox(height: AppSizes.appbarGap,),
                        StatusButtonRow(items: visibilityStatus, selectedIndex: selectedVisibilityStatus,
                            onSelected: (index){
                          setState(() {
                            selectedVisibilityStatus = index;
                          });
                        },onTap: (status){
                          print(status);
                          },),
                      ],
                    )),
                    SizedBox(height: AppSizes.sectionGap,),
                    CustomCard(child: Row(
                      children: [
                        Checkbox(
                          value: isfeature,
                          onChanged: (value) {
                            setState(() {
                              isfeature = value ?? false;
                            });
                          },
                        ),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              TextTitleWidget(title: "Featured Content",color: color.primary,maxLines: 1,),
                              TextBodyStyleWidget(title: "Display this video in the landing page carousel.",maxLines: 1,)
                            ],
                          ),
                        ),
                      ],
                    )),
                    SizedBox(height: AppSizes.sectionGap,),

                    // Cover image
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        TextTitleWidget(title: "Cover Image",color: color.primary,),
                        SizedBox(height: AppSizes.appbarGap,),
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, RoutesName.media_manage_details);
                          },
                          child:widget.isEdit?Container(
                            width: 100.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              'assets/images/institute.png',
                              fit: BoxFit.fitWidth,
                            ),
                          ) : CustomCard2(child: Padding(
                            padding:  EdgeInsets.all(AppSizes.contentPadding),
                            child: Column(
                              children: [
                                Icon(Icons.cloud_upload_outlined,size: AppSizes.appBarIcon,color: Colors.grey,),
                                SizedBox(height: AppSizes.itemGap,),
                                TextBodyStyleWidget(title: "Choose From Media Library",)
                              ],
                            ),
                          )),
                        )

                      ],
                    )),


                    SizedBox(height: AppSizes.sectionGap,),

                    //Live preview
                    CustomCard(child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        TextTitleWidget(title: "Live Preview",color: color.primary,),
                        SizedBox(height: AppSizes.appbarGap,),
                        CustomCard2(child: Padding(
                          padding:  EdgeInsets.all(AppSizes.contentPadding),
                          child: Container(
                            height: 14.h,
                            child: Column(
                              mainAxisAlignment: .center,
                              children: [


                              ],
                            ),
                          ),
                        ))

                      ],
                    )),



                    SizedBox(height: AppSizes.sectionGap,),
                    // Save Button
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text: "Cancel", onTap: (){},width: 30.w,backgroundColor: color.cardBackground,foregroundColor: color.primary,),
                        SizedBox(width: AppSizes.appbarGap,),
                        Flexible(child: CustomButton(text:widget.isEdit? "Edit Post":"Save Video", onTap: (){},)),
                      ],
                    ),
                    SizedBox(height: AppSizes.sectionGap),

                  ],
                )

              ]),
            ),
          ),

        ],
      ),
    );
  }
}
