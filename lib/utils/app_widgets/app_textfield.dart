// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_styles.dart';

class AppTextField extends StatelessWidget {
  AppTextField({
    required this.controller,
    this.hintText = "",
    this.onChanged,
    this.icon,
    this.maxLines,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.height = 52,
    this.margin,
    this.radiusBottomLeft = 10.0,
    this.radiusBottomRight = 10.0,
    this.radiusTopLeft = 10.0,
    this.radiusTopRight = 10.0,
    this.contentPaddingTop = 14.0,
    this.style,
    this.keyboardType,
    this.onSubmitted,
    this.autoFocus = false,
    this.prefixText,
    Key? key,
  }) : super(key: key);

  TextEditingController? controller;
  String? hintText;
  Widget? icon;
  Function(String)? onChanged;
  int? maxLines;
  int? maxLength;
  List<TextInputFormatter>? inputFormatters;
  FocusNode? focusNode;
  double? height;
  EdgeInsets? margin;
  double? radiusBottomLeft, radiusBottomRight, radiusTopLeft, radiusTopRight;
  double? contentPaddingTop;
  TextStyle? style;
  TextInputType? keyboardType;
  String? prefixText;
  void Function(String)? onSubmitted;
  bool? autoFocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height!.h, //52,
      margin: margin ??
          EdgeInsets.symmetric(
              horizontal: 22.w), //EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(radiusBottomLeft!.r),
            bottomRight: Radius.circular(radiusBottomRight!.r),
            topLeft: Radius.circular(radiusTopLeft!.r),
            topRight: Radius.circular(radiusTopRight!.r),
          ),
          color: AppColors.texfieldColor),
      child: TextField(
        controller: controller,
        onChanged: onChanged ?? (t) {},
        maxLength: maxLength,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType ?? TextInputType.text,
        focusNode: focusNode,
        textAlignVertical: TextAlignVertical.top,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: icon == null
              ? EdgeInsets.only(
                  left: 14.w,
                  bottom: MediaQuery.of(context).size.width <= 400 ? 8.h : 0.0)
              : contentPaddingTop == null
                  ? EdgeInsets.only(
                      top: 14.0.h,
                      // bottom:
                      //     MediaQuery.of(context).size.width <= 400 ? 20.h : 0.0
                    )
                  : EdgeInsets.only(
                      top: contentPaddingTop!.h,
                      bottom: MediaQuery.of(context).size.width <= 400
                          ? 14.h
                          : 0.0),
          prefixIcon: icon,
          prefixText: prefixText,
          hintText: hintText,
          counterText: "",
          hintStyle: AppStyles.interRegularStyle(
              fontSize: 20, color: AppColors.hintTextColor),
        ),
        autofocus: autoFocus ?? false,
        onSubmitted: onSubmitted,
        style: style ??
            AppStyles.interRegularStyle(
                fontSize: 20, color: AppColors.hintTextColor),
      ),
    );
  }
}
