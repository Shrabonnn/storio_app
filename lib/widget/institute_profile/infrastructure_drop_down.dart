import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:storio_app/utils/sizes.dart';

import '../../model/form_field/form_feild_data.dart';
import '../../utils/app_colors.dart';
import '../textStyle/text_body_style.dart';
import '../textStyle/text_title_style.dart';

class InfrastructureDropDown extends StatelessWidget {
  final List<FormFieldData> fields;
  final VoidCallback onSave;


  final IconData?selectedIcon;
  final ValueChanged<IconData>? onIconSelected;
  final bool showIconPicker;



  const InfrastructureDropDown({
    super.key,
    required this.onSave,
    this.selectedIcon = Icons.people_alt_outlined,
    this.onIconSelected,
    this.showIconPicker = false, required this.fields,


  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...fields.map((field) => Padding(
          padding: EdgeInsets.only(bottom: AppSizes.itemGap),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextBodyStyleWidget(title: field.title,),
              SizedBox(height: AppSizes.smallGap),
              TextField(
                controller: field.controller,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: field.hint,
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(AppSizes.cardRadius),
                  ),
                ),
              ),
            ],
          ),
        )),

        if(showIconPicker) ...[
          SizedBox(height: AppSizes.itemGap),

          TextBodyStyleWidget(title: "Select Icon"),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              Icons.people_alt_outlined,
              Icons.school_outlined,
              Icons.groups_outlined,
              Icons.menu_book_outlined,
              Icons.class_outlined,
              Icons.computer_outlined,
              Icons.library_books_outlined,
              Icons.emoji_events_outlined,
            ].map((icon) {
              final selected = selectedIcon == icon;

              return InkWell(
                onTap: () => onIconSelected?.call(icon),
                child: Container(
                  padding:  EdgeInsets.all(AppSizes.cardPadding),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withValues(alpha: .1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(AppSizes.containerRadius),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : Colors.transparent,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: AppSizes.iconLarge,
                    color: selected
                        ? AppColors.primary
                        : Colors.grey,
                  ),
                ),
              );
            }).toList(),
          ),


        ],

        SizedBox(height: AppSizes.itemGap),

        ElevatedButton(
          onPressed: onSave,
          child: const Text("Add"),
        ),
        SizedBox(height: AppSizes.itemGap),
      ],
    );
  }
}