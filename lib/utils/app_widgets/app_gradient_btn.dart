// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_styles.dart';
import '../common.dart';

class AppGradientButton extends StatelessWidget {
  AppGradientButton({
    required this.btnText,
    required this.onPressed,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.icon,
    this.isDisabled = false,
    Key? key,
  }) : super(key: key);

  String? btnText;
  VoidCallback? onPressed;
  double? height;
  double? width;
  EdgeInsets? margin;
  EdgeInsets? padding;
  Widget? icon;
  bool? isDisabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height == null ? 40.h : height!.h,
      width: width == null ? 100.h : width!.w,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
          color: isDisabled! ? AppColors.tabBkgColor : AppColors.orangePrimary ,
          borderRadius: BorderRadius.circular(100.r),
          gradient: isDisabled! ? null : const LinearGradient(
              colors: [Color(0xffFFD036), Color(0xffFFA43C)],
              transform: GradientRotation(240) //120
              )),
      child: Material(
          borderRadius: BorderRadius.circular(100.r),
          type: MaterialType.transparency,
          child: InkWell(
              onTap: isDisabled! ? null : onPressed,
              borderRadius: BorderRadius.circular(100.r),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    btnText!,
                    style: AppStyles.interMediumStyle(
                        fontSize: 14.4, color: isDisabled! ? AppColors.ageColor : Colors.white),
                  ),
                  sizedBoxW(
                    width: icon == null ? 0 : 10,
                  ),
                  icon ?? Container()
                ],
              )))),
    );
  }
}
