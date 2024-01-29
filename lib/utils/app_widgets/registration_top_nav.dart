// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_fonts.dart';

class RegistrationTopBar extends StatelessWidget {
  RegistrationTopBar({
    required this.progress,
    required this.text,
    required this.onBackPressed,
    required this.onNextPressed,
    this.visible = true,
    this.enabled = true,
    Key? key,
  }) : super(key: key);

  int? progress;
  String? text;
  bool? visible;
  bool? enabled;
  VoidCallback? onBackPressed;
  VoidCallback? onNextPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65.h,
      child: Column(
        children: [
          Row(children: [
            Expanded(
              flex: progress!,
              child: Container(
                height: 3.h,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xffFFD036), Color(0xffFFA43C)])),
              ),
            ),
            progress == 7
                ? Container()
                : Expanded(
                    flex: 7-progress!,
                    child: Container(
                      height: 3.h,
                      color: AppColors.appBkgColor,
                    ),
                  ),
          ]),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: onBackPressed ?? () {},
                      child:  Icon(
                        Icons.keyboard_arrow_left,
                        color: AppColors.textColor,
                        size: 34.sm,
                      )),
                  !visible!
                      ? Container()
                      : InkWell(
                          onTap: !enabled! ? null : onNextPressed ?? () {},
                          child: Text(text!,
                              style: enabled!
                                  ? TextStyle(
                                      foreground: Paint()
                                        ..shader = const LinearGradient(
                                          colors: <Color>[
                                            Color(0xffFFD036),
                                            Color(0xffFFA43C)
                                          ],
                                        ).createShader(const Rect.fromLTWH(
                                            0.0, 0.0, 200.0, 70.0)),
                                      fontSize: 21.sp,
                                      fontFamily: interMedium)
                                  :  TextStyle(
                                      fontSize: 21.sp,
                                      fontFamily: interMedium,
                                      color: AppColors.disabledColor)))
                ],
              ))
        ],
      ),
    );
  }
}
