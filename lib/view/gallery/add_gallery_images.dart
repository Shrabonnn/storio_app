import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_image_picker.dart';
import '../../widget/universal/custom_text_field.dart';

class AddGalleryImages extends StatefulWidget {
  const AddGalleryImages({super.key});

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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Add New Gallery Image",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(

                  children: [
                    CustomImagePicker(
                      title: "Upload Institute Logo",
                      subtitle: "Choose New Photo",
                      supportedText: "Supported: JPG • PNG",
                      maxSizeText: "Maximum file size: 5 MB",
                      onImageSelected: (file) {
                        if (file != null) {
                          print(file.path);
                        }
                      },
                    ),
                    SizedBox(height: AppSizes.sectionGap,),

                    CustomCard(child: Column(
                     crossAxisAlignment: .start,
                     children: [
                       // Title
                       TextBodyStyleWidget(title: "Filename", color: AppColors.primary,size: AppSizes.cardTitle,),
                       SizedBox(height: AppSizes.appbarGap),
                       CustomTextFieldWidget(hintText: "e.g., sunset-beach.jpg", controller: filenameController),
                       SizedBox(height: AppSizes.itemGap),


                       // Activities
                       TextBodyStyleWidget(title: "Alt Text (for SEO) *", color: AppColors.primary,size: AppSizes.cardTitle,),
                       SizedBox(height: AppSizes.appbarGap),
                       CustomTextFieldWidget(hintText: "A short description of the image for accessibility", controller: filenameController,),
                       SizedBox(height: AppSizes.itemGap),


                       // Title
                       TextBodyStyleWidget(title: "Image Title (for SEO) *", color: AppColors.primary,size: AppSizes.cardTitle,),
                       SizedBox(height: AppSizes.appbarGap),
                       CustomTextFieldWidget(hintText: "Optional title for the image", controller: filenameController),
                       SizedBox(height: AppSizes.itemGap),


                       // Activities
                       TextBodyStyleWidget(title: "Caption", color: AppColors.primary,size: AppSizes.cardTitle,),
                       SizedBox(height: AppSizes.appbarGap),
                       CustomTextFieldWidget(hintText: "Optional caption to display with the image ...", controller: filenameController,),
                       SizedBox(height: AppSizes.itemGap),

                       // Title
                       TextBodyStyleWidget(title: "Tags (comma separated)", color: AppColors.primary,size: AppSizes.cardTitle,),
                       SizedBox(height: AppSizes.appbarGap),
                       CustomTextFieldWidget(hintText: "e.g., nature, travel, featured", controller: filenameController),
                       SizedBox(height: AppSizes.itemGap),

                       TextBodyStyleWidget(title: "Status", color: AppColors.primary,size: AppSizes.cardTitle,),
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
