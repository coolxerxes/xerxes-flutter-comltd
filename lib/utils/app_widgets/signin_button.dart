import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_fonts.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({
    Key? key,
    required this.btnText,
    required this.onPressed,
    required this.iconPath,
    this.height = 48.5,
    this.margin,
    this.borderRadius = 100.0,
    this.innerPadding ,
  }) : super(key: key);

  final String? btnText;
  final VoidCallback? onPressed;
  final String? iconPath;
  final double? height;
  final EdgeInsets? margin;
  final double? borderRadius;
  final EdgeInsets? innerPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height!.h,
      margin: margin??EdgeInsets.symmetric(horizontal: 48.w),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.btnStrokeColor),
          borderRadius: BorderRadius.circular(borderRadius!.r)),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius!.r),
          onTap: onPressed,
          child: Container(
            padding: innerPadding ??EdgeInsets.symmetric(horizontal: 24.w),
            // decoration: BoxDecoration(
            //     border: Border.all(color: AppColors.btnStrokeColor),
            //     borderRadius: BorderRadius.circular(100)),
            // height: 48.5,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SvgPicture.asset(
                  iconPath!,
                  width: 16.5.w,
                  height: 20.5.h,
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    btnText!,
                    style:  TextStyle(
                        color: AppColors.textColor,
                        fontSize: 16.sp,
                        fontFamily: interMedium),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
