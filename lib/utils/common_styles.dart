
import 'package:flutter/material.dart';
import 'package:indisk_app/utils/common_colors.dart';

TextStyle? getNormalTextStyle(
    {Color? fontColor, double? fontSize, FontWeight? fontWeight}) {
  return TextStyle(
      color: fontColor ?? CommonColors.black,
      fontSize: fontSize ?? 14.0,
      fontWeight: fontWeight ?? FontWeight.normal);
}

TextStyle? getBoldTextStyle(
    {Color? fontColor, double? fontSize, FontWeight? fontWeight}) {
  return TextStyle(
      color: fontColor ?? CommonColors.black,
      fontSize: fontSize ?? 14.0,
      fontWeight: fontWeight ?? FontWeight.bold);
}

TextStyle? getMediumTextStyle(
    {Color? fontColor, double? fontSize, FontWeight? fontWeight}) {
  return TextStyle(
      color: fontColor ?? CommonColors.black,
      fontSize: fontSize ?? 14.0,
      fontWeight: fontWeight ?? FontWeight.w500);
}

TextStyle? getSemiBoldTextStyle(
    {Color? fontColor, double? fontSize, FontWeight? fontWeight}) {
  return TextStyle(
      color: fontColor ?? CommonColors.black,
      fontSize: fontSize ?? 14.0,
      fontWeight: fontWeight ?? FontWeight.w600);
}
