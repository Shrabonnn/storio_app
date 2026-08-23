import 'package:flutter/material.dart';
import 'package:storio_app/utils/app_colors.dart';

import '../../utils/sizes.dart';

class ColorPicketDialog extends StatelessWidget{

  final String title;
  final List<Color> colors;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPicketDialog({super.key,
    required this.title,
    this.colors = const[
      AppColors.primary,
      AppColors.secondary,
      Colors.white,
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.black,
      Colors.grey,
      Colors.amber,
      Colors.indigo,
      Colors.cyan,
      Colors.lime,
      Colors.brown,
      Colors.deepOrange,
      Colors.deepPurple,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.yellow,
      Colors.redAccent,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.pinkAccent,
      Colors.tealAccent,
      Colors.amberAccent,
      Colors.cyanAccent,
      Colors.limeAccent,
      Colors.indigoAccent,
      Colors.lightBlueAccent,
      Colors.lightGreenAccent,
      Colors.deepOrangeAccent,
      Colors.deepPurpleAccent,
      Colors.yellowAccent,
    ], required this.selectedColor, required this.onColorSelected});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Wrap(
        spacing: 12,
        runSpacing: 12,

        children: colors.map((color) {
          return InkWell(
            onTap: () {
              onColorSelected(color);

              Navigator.pop(context);
            },

            borderRadius:
            BorderRadius.circular(AppSizes.cardRadius),

            child: Container(
              width: 45,
              height: 45,

              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,

                border: Border.all(
                  color: selectedColor == color
                      ? Colors.white
                      : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

}