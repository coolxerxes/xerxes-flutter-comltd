import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view_model/login_vm.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../utils/app_widgets/signin_button.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginVM>(
      builder: (c) {
        return Scaffold(
            backgroundColor: AppColors.appBkgColor,
            body: Center(
                child: ListView(
              shrinkWrap: true,
              children: [
                sizedBoxH(
                  height: 120,
                ),
                SizedBox(
                  height: 211,
                  width: 96.w,
                  child: Image.asset(AppImage.jioLogo),
                ),
                sizedBoxH(
                  height: 91,
                ),
                Platform.isIOS
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 48.w),
                        child: SignInWithAppleButton(
                          height: 48.5,
                          iconAlignment: IconAlignment.left,
                          style: SignInWithAppleButtonStyle.black,
                          borderRadius: BorderRadius.circular(100),
                          onPressed: c.appleLogin,
                        ),
                      )
                    : Container(),
                sizedBoxH(
                  height: 16,
                ),
                SignInButton(
                  iconPath: AppIcons.googleIcon,
                  btnText: AppStrings.signInWith + AppStrings.google,
                  onPressed: c.googleLogin,
                ),
                sizedBoxH(
                  height: 16,
                ),
                SignInButton(
                  iconPath: AppIcons.facebookIcon,
                  btnText: AppStrings.signInWith + AppStrings.facebook,
                  onPressed: c.fbLogin,
                ),
                sizedBoxH(
                  height: 16,
                ),
                SignInButton(
                  iconPath: AppIcons.phoneIcon,
                  btnText: AppStrings.signInWith + AppStrings.phoneNo,
                  onPressed: () {
                    getToNamed(phoneNumberRoute);
                  },
                ),
                sizedBoxH(
                  height: 26,
                ),
                Center(
                  child: Text(AppStrings.tncL1,
                      style: AppStyles.interRegularStyle()),
                ),
                Center(
                    child: RichText(
                  text: TextSpan(
                      text: AppStrings.tncL2,
                      style: AppStyles.interRegularStyle(fontSize: 14),
                      children: [
                        TextSpan(
                          text: AppStrings.terms,
                          style: AppStyles.interRegularStyle(
                              fontSize: 14, color: AppColors.orangePrimary),
                          //recognizer:
                        )
                      ]),
                ))
              ],
            )));
      },
    );
  }
}
