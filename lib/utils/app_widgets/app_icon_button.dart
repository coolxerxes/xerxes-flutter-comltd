// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MyIconButton extends StatelessWidget {
  MyIconButton({
    required this.onTap,
    required this.icon,
    this.isSvg = false,
    this.color,
    this.size = 34.0,
    Key? key,
  }) : super(key: key);

  VoidCallback? onTap;
  String? icon;
  bool? isSvg;
  dynamic color;
  double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
            borderRadius: BorderRadius.circular(10.r),
            type: MaterialType.transparency,
            child: InkWell(
                borderRadius: BorderRadius.circular(10.r),
                onTap: onTap,
                child: Center(
                    child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: isSvg!
                        ? color == null
                            ? SvgPicture.asset(
                                icon!,
                                width: size!.w,
                                height: size!.h,
                                //color: color??Color(color),
                              )
                            : SvgPicture.asset(icon!,
                                width: size!.w, height: size!.h, color: Color(color))
                        : Image.asset(
                            icon!,
                            width: size!.w,
                            height: size!.h,
                            fit: BoxFit.fill,
                          ),
                  ),
                )))));
  }
}
