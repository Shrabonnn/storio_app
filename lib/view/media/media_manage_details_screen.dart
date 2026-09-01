import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/app_colors.dart';
import 'package:storio_app/widget/textStyle/text_title_style.dart';

import '../../routes/routes_name.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../../widget/custom_button/custom_buttom.dart';
import '../../widget/institute_profile/Institute_overview_screen.dart';
import '../../widget/textStyle/text_body_style.dart';
import '../../widget/universal/custom_app_bar.dart';
import '../../widget/universal/custom_card.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../widget/universal/custom_drop_down.dart';
import '../../widget/universal/custom_image_picker.dart';
import '../../widget/universal/custom_text_field.dart';


class MediaManageDetailsScreen extends StatefulWidget {
  const MediaManageDetailsScreen({super.key});

  @override
  State<MediaManageDetailsScreen> createState() =>
      _MediaManageDetailsScreenState();
}

class _MediaManageDetailsScreenState extends State<MediaManageDetailsScreen> {

  bool isUploadSelected = false;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController captionController = TextEditingController();

  int selectedIndex = 0;




  final List<String> itemTypes = ["All media", "Images", "Views", "Docs"];





  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBar(
            title: "Media Manage Details",
            showBackButton: true,
          ),
          SliverPadding(
            padding: EdgeInsetsGeometry.all(AppSizes.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                CustomCard(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 4.5.h,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search...",
                                  prefixIcon: const Icon(Icons.search),
                                  filled: true,
                                  fillColor: color.cardBackground,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: AppSizes.appbarGap),
                          CustomDropdown(
                            items: itemTypes,
                            initialValue: "All media",
                            width: 25.w,
                            height: 4.5.h,
                            onChanged: (value) {
                              print("Selected: $value");

                            },
                          ),
                          SizedBox(width: AppSizes.appbarGap),
                          Container(
                            height: 4.5.h,
                            width: 25.w,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(
                                AppSizes.buttonRadius,
                              ),
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isUploadSelected = true;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isUploadSelected
                                            ? color.primary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          AppSizes.buttonRadius,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: TextBodyStyleWidget(
                                        title: "Upload",
                                        color: isUploadSelected
                                            ? color.cardBackground
                                            : Colors.black,
                                        size: AppSizes.cardSubTitle,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isUploadSelected = false;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      decoration: BoxDecoration(
                                        color: !isUploadSelected
                                            ? color.primary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          AppSizes.buttonRadius,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: TextBodyStyleWidget(
                                        title: "Library",
                                        size: AppSizes.cardSubTitle,
                                        color: !isUploadSelected
                                            ? color.cardBackground
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.sectionGap),
                      isUploadSelected ? CustomImagePicker(
                        title: "Upload Institute Logo",
                        subtitle: "Choose your institute logo",
                        supportedText: "Supported: JPG • PNG",
                        maxSizeText: "Maximum file size: 5 MB",
                        onImageSelected: (file) {
                          if (file != null) {
                            print(file.path);
                          }
                        },
                      ) : _buildLibrary(),
                      SizedBox(height: AppSizes.sectionGap),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Use Selected File"),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }



  Column _buildLibrary() {
    final color = context.Appcolor;
    return Column(
      crossAxisAlignment: .start,
      children: [
        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 8,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 1.5,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Card(
                elevation: 2,
                color: color.cardBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                  side: BorderSide(
                    color: selectedIndex == index
                        ? Colors.lightGreenAccent
                        : Colors.transparent,
                    width: 1,
                  ),
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
                            return const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        SizedBox(height: AppSizes.sectionGap),
        TextBodyStyleWidget(
          title: "Attachment Details",
          color: color.primary,
        ),
        SizedBox(height: AppSizes.appbarGap),
        Container(
          width: 100.w,
          height: 18.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/institute.png',
            fit: BoxFit.fitWidth,
          ),
        ),
        SizedBox(height: AppSizes.itemGap),

        // title
        TextBodyStyleWidget(title: "Title", color: color.primary,size: AppSizes.cardTitle,),
        SizedBox(height: AppSizes.appbarGap),
        CustomTextFieldWidget(hintText: "Title", controller: titleController),
        SizedBox(height: AppSizes.itemGap),

        // description
        TextBodyStyleWidget(title: "Alt/description", color: color.primary,size: AppSizes.cardTitle),
        SizedBox(height: AppSizes.appbarGap),
        CustomTextFieldWidget(
          hintText: "Description...",
          controller: descriptionController,
        ),
        SizedBox(height: AppSizes.itemGap),

        // caption
        TextBodyStyleWidget(title: "Caption", color: color.primary,size: AppSizes.cardTitle),
        SizedBox(height: AppSizes.appbarGap),
        CustomTextFieldWidget(
          hintText: "Caption",
          controller: captionController,
        ),
        SizedBox(height: AppSizes.itemGap),

        Divider(),
        SizedBox(height: AppSizes.itemGap),

        Column(
          crossAxisAlignment: .start,
          children: [
            RichText(
              text: TextSpan(
                text: "Full Name: ",
                style: TextStyle(
                  color: color.primary,
                  fontSize: AppSizes.cardSubTitle,
                ),
                children: [
                  TextSpan(
                    text: "Images_name",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.appbarGap),
            RichText(
              text: TextSpan(
                text: "File Type: ",
                style: TextStyle(
                  color: color.primary,
                  fontSize: AppSizes.cardSubTitle,
                ),
                children: [
                  TextSpan(
                    text: "images",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.appbarGap),
            RichText(
              text: TextSpan(
                text: "Size: ",
                style: TextStyle(
                  color: color.primary,
                  fontSize: AppSizes.cardSubTitle,
                ),
                children: [
                  TextSpan(
                    text: "1090.00KB",
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: AppSizes.sectionGap),

        CustomButton(
          text: "Delete Permanently",
          backgroundColor: Colors.red,
          onTap: () {},
          size: AppSizes.cardTitle,
        ),
      ],
    );
  }
}





