import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../utils/theme/theme_ext.dart';
import '../../utils/app_sizes.dart';
import '../../utils/theme/theme_ext.dart';
import '../custom_button/custom_buttom.dart';
import '../textStyle/text_body_style.dart';
import '../textStyle/text_title_style.dart';

class CustomImagePicker extends StatefulWidget {
  final ValueChanged<XFile?>? onImageSelected;

  final String title;
  final String subtitle;
  final String supportedText;
  final String maxSizeText;

  final double? height;
  final bool showPreview;

  const CustomImagePicker({
    super.key,
    this.onImageSelected,
    this.title = "Upload Media",
    this.subtitle = "Tap here to choose files from gallery",
    this.supportedText = "Supported: JPG • PNG • PDF",
    this.maxSizeText = "Maximum file size: 10 MB",
    this.height,
    this.showPreview = true,
  });

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  final ImagePicker _picker = ImagePicker();

  XFile? _selectedFile;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) return;

      setState(() {
        _selectedFile = image;
      });

      widget.onImageSelected?.call(image);
    } catch (e) {
      debugPrint("Image picker error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;
    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: widget.height,
        padding: EdgeInsets.symmetric(
          vertical: 4.h,
          horizontal: AppSizes.screenPadding,
        ),
        decoration: BoxDecoration(
          color: color.cardBackground,
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: _selectedFile != null && widget.showPreview
            ? _buildSelectedImage()
            : _buildEmptyPicker(),
      ),
    );
  }

  Widget _buildEmptyPicker() {
    final color = context.Appcolor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.cloud_upload_outlined,
          size: 70,
          color: color.primary,
        ),

        SizedBox(height: AppSizes.sectionGap),

        TextTitleWidget(
          title: widget.title,
        ),

        SizedBox(height: AppSizes.appbarGap),

        TextBodyStyleWidget(
          title: widget.subtitle,
        ),

        SizedBox(height: AppSizes.sectionGap),

        CustomButton(
          text: "Browse Files",
          onTap: _pickImage,
        ),

        SizedBox(height: AppSizes.sectionGap),

        TextBodyStyleWidget(
          title: widget.supportedText,
          size: AppSizes.cardSubTitle,
        ),

        SizedBox(height: 4),

        TextBodyStyleWidget(
          title: widget.maxSizeText,
          size: AppSizes.cardSubTitle,
        ),
      ],
    );
  }

  Widget _buildSelectedImage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(
            AppSizes.cardRadius,
          ),
          child: Image.network(
            _selectedFile!.path,
            width: double.infinity,
            height: 25.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 25.h,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  size: 50,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),

        SizedBox(height: AppSizes.sectionGap),

        TextTitleWidget(
          title: "Image Selected",
        ),

        SizedBox(height: AppSizes.appbarGap),

        TextBodyStyleWidget(
          title: _selectedFile!.name,
          size: AppSizes.cardSubTitle,
        ),

        SizedBox(height: AppSizes.sectionGap),

        CustomButton(
          text: "Change Image",
          onTap: _pickImage,
        ),
      ],
    );
  }
}