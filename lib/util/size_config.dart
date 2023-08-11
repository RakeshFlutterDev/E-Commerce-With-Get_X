import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static double? screenHeight;
  static double? screenWidth;
  static double? blockSizeVertical;
  static double? blockSizeHorizontal;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenHeight = _mediaQueryData.size.height;
    screenWidth = _mediaQueryData.size.width;
    blockSizeVertical = screenHeight! / 100;
    blockSizeHorizontal = screenWidth! / 100;
  }
}
