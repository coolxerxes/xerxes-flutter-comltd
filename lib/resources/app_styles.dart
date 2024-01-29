import 'package:flutter/material.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  static TextStyle? interMediumStyle(
      {double? fontSize = 16, Color? color = AppColors.textColor}) {
    return TextStyle(
        fontSize: fontSize!.sp, color: color, fontFamily: interMedium);
  }

  static TextStyle? interRegularStyle(
      {double? fontSize = 15, Color? color = AppColors.textColor, TextOverflow? textOverflow}) {
    return TextStyle(
        fontSize: fontSize!.sp, color: color, fontFamily: interRegular, overflow: textOverflow );
  }

  static TextStyle? interSemiBoldStyle(
      {double? fontSize = 15, Color? color = AppColors.textColor,TextOverflow? textOverflow}) {
    return TextStyle(
        fontSize: fontSize!.sp, color: color, fontFamily: interSemiBold, overflow: textOverflow);
  }

  static TextStyle? interBoldStyle(
      {double? fontSize = 15, Color? color = AppColors.textColor}) {
    return TextStyle(
        fontSize: fontSize!.sp, color: color, fontFamily: interSemiBold);
  }
}
