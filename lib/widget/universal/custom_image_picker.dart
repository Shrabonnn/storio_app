import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

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

  /// Options: 'image', 'video', 'document', or null / 'all'
  final String? allowedType;

  final double? height;
  final bool showPreview;

  const CustomImagePicker({
    super.key,
    this.onImageSelected,
    this.title = "Upload Media",
    this.subtitle = "Tap here to choose files from gallery",
    this.supportedText = "Supported: JPG • PNG • MP4 • PDF",
    this.maxSizeText = "Maximum file size: 50 MB",
    this.allowedType,
    this.height,
    this.showPreview = true,
  });

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  XFile? _selectedFile;

  // ============================================================
  // File Picker Method (Supports Image, Video & Documents)
  // ============================================================
  Future<void> _pickFile() async {
    try {
      FileType pickerType = FileType.any;
      List<String>? allowedExtensions;

      // Filter by dynamic allowedType passed from parent screen
      if (widget.allowedType == 'image') {
        pickerType = FileType.image;
      } else if (widget.allowedType == 'video') {
        pickerType = FileType.video;
      } else if (widget.allowedType == 'document') {
        pickerType = FileType.custom;
        allowedExtensions = ['pdf', 'doc', 'docx', 'txt', 'xls', 'xlsx'];
      }

      final FilePickerResult? result = await FilePicker.pickFiles(
        type: pickerType,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result == null || result.files.single.path == null) return;

      final String path = result.files.single.path!;
      final XFile pickedXFile = XFile(path);

      setState(() {
        _selectedFile = pickedXFile;
      });

      widget.onImageSelected?.call(pickedXFile);
    } catch (e) {
      debugPrint("File picker error: $e");
    }
  }

  // ============================================================
  // Helpers to Check File Category
  // ============================================================
  bool _isImage(String path) {
    final ext = path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp'].contains(ext);
  }

  IconData _getFileIcon(String path) {
    final ext = path.split('.').last.toLowerCase();
    if (['mp4', 'mov', 'avi', 'mkv', 'flv'].contains(ext)) {
      return Icons.videocam_outlined;
    } else if (['pdf'].contains(ext)) {
      return Icons.picture_as_pdf_outlined;
    } else if (['doc', 'docx', 'txt'].contains(ext)) {
      return Icons.description_outlined;
    } else if (['xls', 'xlsx'].contains(ext)) {
      return Icons.table_chart_outlined;
    }
    return Icons.insert_drive_file_outlined;
  }

  // ============================================================
  // Build Method
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final color = context.Appcolor;

    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      onTap: _pickFile,
      child: Container(
        width: double.infinity,
        height: widget.height,
        padding: EdgeInsets.symmetric(
          vertical: 3.h,
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
            ? _buildSelectedFilePreview()
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
          size: 60,
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
          onTap: _pickFile,
        ),
        SizedBox(height: AppSizes.sectionGap),
        TextBodyStyleWidget(
          title: widget.supportedText,
          size: AppSizes.cardSubTitle,
        ),
        const SizedBox(height: 4),
        TextBodyStyleWidget(
          title: widget.maxSizeText,
          size: AppSizes.cardSubTitle,
        ),
      ],
    );
  }

  Widget _buildSelectedFilePreview() {
    final color = context.Appcolor;
    final filePath = _selectedFile!.path;
    final isImg = _isImage(filePath);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(
            AppSizes.cardRadius,
          ),
          child: isImg
              ? Image.file(
            File(filePath),
            width: double.infinity,
            height: 22.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 22.h,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  size: 50,
                  color: Colors.grey,
                ),
              );
            },
          )
              : Container(
            height: 22.h,
            width: double.infinity,
            color: Colors.grey.shade200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getFileIcon(filePath),
                  size: 55,
                  color: color.primary,
                ),
                SizedBox(height: AppSizes.smallGap),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextBodyStyleWidget(
                    title: _selectedFile!.name,
                    size: AppSizes.cardSubTitle,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSizes.sectionGap),
        TextTitleWidget(
          title: isImg ? "Image Selected" : "File Selected",
        ),
        SizedBox(height: AppSizes.appbarGap),
        TextBodyStyleWidget(
          title: _selectedFile!.name,
          size: AppSizes.cardSubTitle,
          maxLines: 1,
        ),
        SizedBox(height: AppSizes.sectionGap),
        CustomButton(
          text: "Change File",
          onTap: _pickFile,
        ),
      ],
    );
  }
}