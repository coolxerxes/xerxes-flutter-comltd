// ignore_for_file: must_be_immutable, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/app_widgets/ios_app_textfiled.dart';
import 'package:jyo_app/utils/common.dart';

import '../utils/app_widgets/registration_top_nav.dart';
import '../view_model/phone_number_vm.dart';

class PhoneNumberView extends StatelessWidget {
  const PhoneNumberView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PhoneNumberVM>(
      builder: (c) {
        return SafeArea(
          child: Scaffold(
              backgroundColor: AppColors.appBkgColor,
              appBar: PreferredSize(preferredSize: Size(double.infinity,65.w,),
                child:RegistrationTopBar(
                    progress: 1,
                    text: AppStrings.next,
                    enabled: c.isEnabled,
                    onBackPressed: () {
                      c.onBackPressed();
                    },
                    onNextPressed: () {
                      c.onNextPressed();
                    },
                  ),
                   ),
              body: ListView(
                children: [
                  sizedBoxH(
                    height: 82,
                  ),
                  Center(
                    child: Text(
                      AppStrings.myNo,
                      style: AppStyles.interMediumStyle(
                        fontSize: 28,
                      ),
                    ),
                  ),
                  sizedBoxH(height: 10),
                  Center(
                    child: Text(
                      AppStrings.otpLine1,
                      style: AppStyles.interRegularStyle(
                          fontSize: 15, color: AppColors.hintTextColor),
                    ),
                  ),
                  Center(
                    child: Text(
                      AppStrings.otpLine2,
                      style: AppStyles.interRegularStyle(
                          fontSize: 15, color: AppColors.hintTextColor),
                    ),
                  ),
                  sizedBoxH(height: 32),
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            c.showCountryCodePicker(context);
                          },
                          child: Container(
                            // height: 52.h,
                            margin: EdgeInsets.only(left: 22.w),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 14.2.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.r),
                                  topLeft: Radius.circular(10.r)),
                              color: AppColors.texfieldColor,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                c.flage ??
                                    Container(
                                      child: Image.asset(AppIcons.flagIcon),
                                    ),
                                sizedBoxW(
                                  width: 5,
                                ),
                                Text(
                                  c.cCode ?? "+65",
                                  style: AppStyles.interRegularStyle(
                                      fontSize: 20,
                                      color: AppColors.hintTextColor),
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: IosTextField(
                            controller: c.phoneNoCtr,
                            onChanged: (t) {
                              if (t.trim().length == 8 && !c.isChangingPhoneNo!) {
                                c.isEnabled = true;
                                c.update();
                              } else if (t.trim().length == 8 &&
                                  c.isChangingPhoneNo! &&
                                  ((c.cCode.toString().trim() + t.trim()) !=
                                      (c.existingCCode.toString().trim() +
                                          c.existingPhNo.toString().trim()))) {
                                c.isEnabled = true;
                                c.update();
                              } else {
                                c.isEnabled = false;
                                c.update();
                              }
                            },
                            hintText: "",
                            margin: EdgeInsets.only(right: 22.w),
                            //radius: ,
                            radiusTopLeft: 0.0,
                            radiusBottomLeft: 0.0,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            maxLines: 1,
                          ))
                    ],
                  )
                ],
              )),
        );
      },
    );
  }
}
