import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/sizes.dart';
import '../custom_button/custom_buttom.dart';

class FilePickerWidget extends StatefulWidget {
  const FilePickerWidget({super.key});

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  PlatformFile? selectedFile;

  Future<void> pickFile() async {
    final result = await FilePicker.pickFiles();

    print("Click pick file");
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedFile = result.files.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedFile == null) {
      return CustomButton(
        text: "Browse files",
        onTap: pickFile,
        backgroundColor: AppColors.cartBackgroundLight,
        foregroundColor: AppColors.primary,
        size: AppSizes.cardTitle,
      );
    }

     return Row(
      children: [
        Expanded(
          child: Container(
            height: 45,
            padding:  EdgeInsets.symmetric(horizontal: AppSizes.cardPadding),
            decoration: BoxDecoration(
              color: AppColors.cartBackgroundLight,
              borderRadius: BorderRadius.circular(AppSizes.textFieldRadius),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.insert_drive_file_outlined,
                  color: AppColors.primary,
                ),

                 SizedBox(width: AppSizes.appbarGap),

                Expanded(
                  child: Text(
                    selectedFile!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),

         SizedBox(width: AppSizes.appbarGap),

        SizedBox(
          width: 90,
          child: CustomButton(
            text: "Browse",
            onTap: pickFile,
            backgroundColor: AppColors.cartBackgroundLight,
            foregroundColor: AppColors.primary,
            size: AppSizes.cardTitle,
          ),
        ),
      ],
    );
  }
}