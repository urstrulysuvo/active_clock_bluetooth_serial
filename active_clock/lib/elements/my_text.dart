import 'package:flutter/material.dart';

import 'my_color.dart';

enum MyFontSize {
  normal,
  medium,
  large,
  small,
  extraLarge,
}

enum MyFontWeight { normal, light, bold }

class MyText extends StatelessWidget {
  const MyText({
    required this.label,
    this.fontSize = MyFontSize.normal,
    this.fontWeight = MyFontWeight.normal,
    this.isDisable = false,
    this.color = const Color(0xFF2C3E50),
  });
  final String label;
  final MyFontSize fontSize;
  final MyFontWeight fontWeight;
  final bool isDisable;
  final Color color;

  double get size {
    switch (fontSize) {
      case MyFontSize.large:
        return 34.0;
      case MyFontSize.medium:
        return 22.0;
      case MyFontSize.small:
        return 14.0;
      case MyFontSize.extraLarge:
        return 48.0;
      case MyFontSize.normal:
      default:
        return 18.0;
    }
  }

  FontWeight get weight {
    switch (fontWeight) {
      case MyFontWeight.bold:
        return FontWeight.bold;
      case MyFontWeight.light:
        return FontWeight.w200;

      case MyFontWeight.normal:
      default:
        return FontWeight.normal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: 1,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: isDisable ? MyColors.grey : color,
      ),
    );
  }
}
