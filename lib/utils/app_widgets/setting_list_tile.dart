// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_styles.dart';

class SettingListTile extends StatelessWidget {
  SettingListTile({
    required this.text,
    required this.icon,
    this.onTap,
    this.height = 52,
    this.margin = const EdgeInsets.symmetric(horizontal: 22),
    this.padding = const EdgeInsets.symmetric(horizontal: 22),
    this.radiusBottomLeft = 10.0,
    this.radiusBottomRight = 10.0,
    this.radiusTopLeft = 10.0,
    this.radiusTopRight = 10.0,
    this.isLogout = false,
    Key? key,
  }) : super(key: key);
  Widget? icon;
  String? text;
  double? height;
  EdgeInsets? margin;
  EdgeInsets? padding;
  double? radiusBottomLeft, radiusBottomRight, radiusTopLeft, radiusTopRight;
  VoidCallback? onTap;
  bool? isLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height!.h, //52,
        //padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(radiusBottomLeft!.r),
              bottomRight: Radius.circular(radiusBottomRight!.r),
              topLeft: Radius.circular(radiusTopLeft!.r),
              topRight: Radius.circular(radiusTopRight!.r),
            ),
            color: AppColors.texfieldColor),
        child: Material(
            type: MaterialType.transparency,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(radiusBottomLeft!.r),
              bottomRight: Radius.circular(radiusBottomRight!.r),
              topLeft: Radius.circular(radiusTopLeft!.r),
              topRight: Radius.circular(radiusTopRight!.r),
            ),
            child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(radiusBottomLeft!.r),
                  bottomRight: Radius.circular(radiusBottomRight!.r),
                  topLeft: Radius.circular(radiusTopLeft!.r),
                  topRight: Radius.circular(radiusTopRight!.r),
                ),
                child: Container(
                  height: height!.h, //52,
                  padding: padding?? EdgeInsets.symmetric(horizontal: 22.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(radiusBottomLeft!.r),
                      bottomRight: Radius.circular(radiusBottomRight!.r),
                      topLeft: Radius.circular(radiusTopLeft!.r),
                      topRight: Radius.circular(radiusTopRight!.r),
                    ),
                    //  color: AppColors.texfieldColor
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: isLogout! ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(text!,
                          style: AppStyles.interRegularStyle(
                            fontSize: 15.6,
                            color: isLogout! ? Colors.red : AppColors.textColor,
                          ),textAlign: isLogout! ? TextAlign.center : null, ),
                      icon ?? Container()
                    ],
                  ),
                ))));
  }
}
