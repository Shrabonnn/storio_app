import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../routes/routes_name.dart';
import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_image_picker.dart';
import '../../widget/universal/custom_text_field.dart';

class AddGalleryImages extends StatefulWidget {
  const AddGalleryImages({super.key, this.isEdit =false});

  final bool isEdit;


  @override
  State<AddGalleryImages> createState() => _AddGalleryImagesState();
}

class _AddGalleryImagesState extends State<AddGalleryImages> {


  final TextEditingController tagsController = TextEditingController();
  final TextEditingController captionController = TextEditingController();
  final TextEditingController imageTitleController = TextEditingController();
  final TextEditingController altTextController = TextEditingController();
  final TextEditingController filenameController = TextEditingController();


  final List<String> statusList = [
    "Uncategorized",
    "Study Tour Bandarban"
  ];

  @override
  void dispose() {
    tagsController.dispose();
    captionController.dispose();
    imageTitleController.dispose();
    altTextController.dispose();
    filenameController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: widget.isEdit ? "Edit Images" : "Add New Gallery Image",
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

                       // Images
                       Column(
                         crossAxisAlignment: .center,
                         children: [
                           Row(
                             mainAxisAlignment: .spaceBetween,
                             children: [
                               TextBodyStyleWidget(title: "Gallery Images", color: color.primary,size: AppSizes.cardTitle,),
                               SizedBox(width: AppSizes.appbarGap),
                               CustomButton(
                                 height: 4.h,
                                 width: 30.w,
                                 text: widget.isEdit ? "Change Image":"Select Image",
                                 onTap: (){
                                   Navigator.pushNamed(context, RoutesName.media_manage_details);
                                 },
                               ),
                             ],
                           ),
                           SizedBox(height: AppSizes.itemGap),

                           widget.isEdit  ? Container(
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
                           ):TextBodyStyleWidget(title: "Click 'Add Photos' to start adding pictures.",size: AppSizes.cardTitle,),



                         ],


                       ),

                       SizedBox(height: AppSizes.itemGap),


                       // Title
                       TextBodyStyleWidget(title: "Filename", color: color.primary,size: AppSizes.cardTitle,),
                       SizedBox(height: AppSizes.appbarGap),
                       CustomTextFieldWidget(hintText: "e.g., sunset-beach.jpg", controller: filenameController),
                       SizedBox(height: AppSizes.itemGap),


                       // Activities
                       TextBodyStyleWidget(title: "Alt Text (for SEO) *", color: color.primary,size: AppSizes.cardTitle,),
                       SizedBox(height: AppSizes.appbarGap),
                       CustomTextFieldWidget(hintText: "A short description of the image for accessibility", controller: filenameController,),
                       SizedBox(height: AppSizes.itemGap),


                       // Title
                       TextBodyStyleWidget(title: "Image Title (for SEO) *", color: color.primary,size: AppSizes.cardTitle,),
                       SizedBox(height: AppSizes.appbarGap),
                       CustomTextFieldWidget(hintText: "Optional title for the image", controller: filenameController),
                       SizedBox(height: AppSizes.itemGap),


                       // Activities
                       TextBodyStyleWidget(title: "Caption", color: color.primary,size: AppSizes.cardTitle,),
                       SizedBox(height: AppSizes.appbarGap),
                       CustomTextFieldWidget(hintText: "Optional caption to display with the image ...", controller: filenameController,),
                       SizedBox(height: AppSizes.itemGap),

                       // Title
                       TextBodyStyleWidget(title: "Tags (comma separated)", color: color.primary,size: AppSizes.cardTitle,),
                       SizedBox(height: AppSizes.appbarGap),
                       CustomTextFieldWidget(hintText: "e.g., nature, travel, featured", controller: filenameController),
                       SizedBox(height: AppSizes.itemGap),

                       TextBodyStyleWidget(title: "Status", color: color.primary,size: AppSizes.cardTitle,),
                       SizedBox(height: AppSizes.appbarGap),
                       CustomDropdown(
                         items: statusList,
                         initialValue: statusList[0],
                         width: 100.w,
                         height: 4.5.h,
                         onChanged: (value) {
                           print("Selected: $value");

                         },
                       ),








                     ],
                   )),

                    SizedBox(height: AppSizes.sectionGap,),

                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CustomButton(text: "Cancel", onTap: (){},width: 30.w,backgroundColor: Colors.green.shade200,foregroundColor: Colors.black,),
                        SizedBox(width: AppSizes.appbarGap,),
                        Flexible(child: CustomButton(text: "Save", onTap: (){},)),
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
