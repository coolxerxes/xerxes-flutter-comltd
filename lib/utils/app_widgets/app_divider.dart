// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/app_colors.dart';

class MyDivider extends StatelessWidget {
  MyDivider({
    this.height = 1.0,
    Key? key,
  }) : super(key: key);

  double? height;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: height!.h,
            color: AppColors.btnStrokeColor,
          ),
        )
      ],
    );
  }
}
