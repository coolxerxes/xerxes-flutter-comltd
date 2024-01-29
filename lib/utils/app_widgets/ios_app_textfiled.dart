// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_styles.dart';

class IosTextField extends StatelessWidget {
  IosTextField({
    required this.controller,
    this.hintText = "",
    this.onChanged,
    this.icon,
    this.maxLines,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    //this.height = 52,
    this.margin,
    this.radiusBottomLeft = 10.0,
    this.radiusBottomRight = 10.0,
    this.radiusTopLeft = 10.0,
    this.radiusTopRight = 10.0,
    this.style,
    this.keyboardType,
    this.onSubmitted,
    this.autoFocus = false,
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
  double? radius;
  double? contentPaddingTop;
  TextStyle? style;
  TextInputType? keyboardType;
  void Function(String)? onSubmitted;
  bool? autoFocus;
  double? radiusBottomLeft, radiusBottomRight, radiusTopLeft, radiusTopRight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ??EdgeInsets.symmetric(
              horizontal: 22.w), 
      child: TextField(
        controller: controller,
        onChanged: onChanged ?? (t) {},
        autofocus: autoFocus??false,
        maxLength: maxLength,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType ?? TextInputType.text,
          focusNode: focusNode,
          textAlignVertical: TextAlignVertical.top,
          textAlign: TextAlign.start,
          
          onSubmitted: onSubmitted,
          style: style ??
              AppStyles.interRegularStyle(
                  fontSize: 20, color: AppColors.hintTextColor),
        decoration: InputDecoration(
          contentPadding:  EdgeInsets.symmetric(vertical: 14.95.h, horizontal: 15.w),
          //isCollapsed: true,
          
          border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(radiusBottomLeft!.r),
              bottomRight: Radius.circular(radiusBottomRight!.r),
              topLeft: Radius.circular(radiusTopLeft!.r),
              topRight: Radius.circular(radiusTopRight!.r),
            ),
            borderSide: BorderSide(
                color: AppColors.texfieldColor,
                width: 1.0.w,
                style: BorderStyle.none),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(radiusBottomLeft!.r),
              bottomRight: Radius.circular(radiusBottomRight!.r),
              topLeft: Radius.circular(radiusTopLeft!.r),
              topRight: Radius.circular(radiusTopRight!.r),
            ),
            borderSide: BorderSide(
                color: AppColors.texfieldColor,
                width: 1.0.w,
                style: BorderStyle.none),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(radiusBottomLeft!.r),
              bottomRight: Radius.circular(radiusBottomRight!.r),
              topLeft: Radius.circular(radiusTopLeft!.r),
              topRight: Radius.circular(radiusTopRight!.r),
            ),
            borderSide: BorderSide(
                color: AppColors.texfieldColor,
                width: 1.0.w,
                style: BorderStyle.none),
          ),
          prefixIcon: icon,
            hintText: hintText,
            counterText: "",
            hintStyle: AppStyles.interRegularStyle(
                fontSize: 20, color: AppColors.hintTextColor),
          filled: true,
          fillColor: AppColors.texfieldColor,
          
        ),
        
      ),
    );
  }
}
