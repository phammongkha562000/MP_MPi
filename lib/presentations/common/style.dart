import 'package:flutter/material.dart';

import 'colors.dart';

class MyStyle {
  static const double sizeTextDefault = 13;
  static const double sizeTextHeader = 15;

  static const styleDefaultText =
      TextStyle(fontSize: sizeTextDefault, fontWeight: FontWeight.w600);

  static const styleTextButton = TextStyle(
      fontSize: sizeTextHeader,
      color: MyColor.textWhite,
      fontWeight: FontWeight.w600);

  static const styleTextError = TextStyle(
      color: MyColor.textRed,
      fontSize: sizeTextDefault,
      fontWeight: FontWeight.w500);

  static const styleLabelInput = TextStyle(
      fontSize: sizeTextHeader,
      color: MyColor.textBlack,
      fontWeight: FontWeight.bold);

  static const styleHintInput =
      TextStyle(fontSize: sizeTextDefault, fontWeight: FontWeight.w600);

  static const styleTextTitle =
      TextStyle(color: MyColor.defaultColor, fontWeight: FontWeight.bold);
}
