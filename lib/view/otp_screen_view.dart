// ignore_for_file: must_be_immutable, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:otp_text_field/otp_text_field.dart';

import '../utils/app_widgets/registration_top_nav.dart';
import '../view_model/otp_screen_vm.dart';

class OtpScreenView extends StatelessWidget {
  const OtpScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtpScreenVM>(
      builder: (c) {
        return SafeArea(
          child: Scaffold(
              backgroundColor: AppColors.appBkgColor,
              appBar:PreferredSize(preferredSize: Size(double.infinity,65.w,),
              child:  RegistrationTopBar(
                    progress: 1,
                    text: AppStrings.next,
                    onBackPressed: () {
                      getToNamed(loginScreenRoute);
                    },
                    onNextPressed: () {
                      getToNamed(displayNameRoute);
                    },
                    visible: false,
                  ),
          ),
              body: ListView(
                children: [
                  
                  sizedBoxH(
                    height: 82,
                  ),
                  Center(
                    child: Text(
                      AppStrings.insertCode,
                      style: AppStyles.interMediumStyle(
                        fontSize: 28,
                      ),
                    ),
                  ),
                  sizedBoxH(height: 24),
                  OTPTextField(
                    controller: c.otpCrl,
                    onCompleted: (otp) {
                      debugPrint("OTP OC $otp");
                      c.otp = otp;
                      if (c.phoneNumberVM.isChangingPhoneNo!) {
                        c.checkOtpForChange();
                      } else {
                        c.checkOtp();
                      }
                    },
                    length: 5,
                    otpFieldStyle: OtpFieldStyle(
                        borderColor: AppColors.texfieldColor,
                        focusBorderColor: AppColors.texfieldColor),
                    contentPadding: const EdgeInsets.all(0),
                    spaceBetween: 4,
                    textFieldAlignment: MainAxisAlignment.center,
                    onChanged: (t) {},
                  ),
                  sizedBoxH(height: 24),
                  Center(
                      child: RichText(
                          text: TextSpan(children: [
                    TextSpan(
                        text: AppStrings.resendTheCodeIn,
                        style: AppStyles.interRegularStyle(
                            fontSize: 15, color: AppColors.hintTextColor)),
                    TextSpan(
                        text: c.timerTextMin! + ":" + c.timerTextSec!,
                        style: AppStyles.interRegularStyle(
                            fontSize: 15, color: AppColors.orangePrimary))
                  ]))),
                ],
              )),
        );
      },
    );
  }
}
