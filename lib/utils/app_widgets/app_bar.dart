// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyAppBar({
    this.leading,
    this.middle,
    this.actions,
    this.color,
    this.padding,
    this.isGradient = false,
    Key? key,
  }) : super(key: key);

  List<Widget>? leading;
  List<Widget>? middle;
  List<Widget>? actions;
  int? color;
  EdgeInsets? padding;
  bool? isGradient;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(double.infinity, 56.h),
      child: Container(
        decoration: BoxDecoration(
            color: Color(color ?? 0x00000000),
            gradient: isGradient! ? const LinearGradient(
                colors: [Color(0xffFFD036), Color(0xffFFA43C)],
                transform: GradientRotation(240) //120
                ): null ),
        margin: EdgeInsets.only(top: 10.h),
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 22.w, vertical: 6.h),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: leading ?? [Container()],
            ),
            Row(
              children: middle ?? [Container()],
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: actions ??
                  [
                    Container(
                      width: 25.w,
                    )
                  ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 56.h);
}
