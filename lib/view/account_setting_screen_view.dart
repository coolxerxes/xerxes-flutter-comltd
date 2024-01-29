// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jyo_app/data/local/condition_model.dart' as cd;
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view_model/account_setting_screen_vm.dart';

import '../resources/app_colors.dart';
import '../resources/app_image.dart';
import '../resources/app_styles.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../utils/app_widgets/app_bar.dart';
import '../utils/app_widgets/app_divider.dart';
import '../utils/app_widgets/app_icon_button.dart';
import '../utils/app_widgets/setting_list_tile.dart';

class AccountSettingScreenView extends StatelessWidget {
  const AccountSettingScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountSettingScreenVM>(
      builder: (c) {
        return SafeArea(
            child: Scaffold(
          appBar: MyAppBar(
            leading: [
              MyIconButton(
                onTap: () {
                  Get.back();
                },
                icon: AppBarIcons.arrowBack,
                isSvg: true,
                size: 24,
              )
            ],
            middle: [
              Text(AppStrings.accountSettings,
                  style: AppStyles.interSemiBoldStyle(
                      fontSize: 16.0, color: AppColors.textColor))
            ],
          ),
          body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: ListView(
                children: [
                  sizedBoxH(
                    height: 24,
                  ),

                  //Private Account etc,
                  SettingListTile(
                    text: AppStrings.privateAcc,
                    icon: FlutterSwitch(
                      width: 52.0.w,
                      height: 32.0.h,
                      valueFontSize: 0.0.sp,
                      toggleSize: 27.0.w,
                      value: c.isPrivateAcc!,
                      borderRadius: 16.0.r,
                      // padding: 8.0,
                      showOnOff: false,
                      activeColor: AppColors.orangePrimary,

                      onToggle: (val) {
                        c.toggleAccountPrivacy();
                      },
                    ),
                    radiusBottomLeft: 0.0,
                    radiusBottomRight: 0.0,
                  ),
                  MyDivider(),
                  SettingListTile(
                    text: AppStrings.showActToFriends,
                    icon: FlutterSwitch(
                      width: 52.0.w,
                      height: 32.0.h,
                      valueFontSize: 0.0.sp,
                      toggleSize: 27.0.w,
                      value: c.isPrivateActivity!,
                      borderRadius: 16.0.r,
                      // padding: 8.0,
                      showOnOff: false,
                      activeColor: AppColors.orangePrimary,

                      onToggle: (val) {
                        c.toggleActivityPrivacy();
                      },
                    ),
                    radiusTopLeft: 0.0,
                    radiusTopRight: 0.0,
                    radiusBottomLeft: 0.0,
                    radiusBottomRight: 0.0,
                  ),
                  MyDivider(),
                  SettingListTile(
                    text: AppStrings.appearanceOnSearch,
                    icon: FlutterSwitch(
                      width: 52.0.w,
                      height: 32.0.h,
                      valueFontSize: 0.0.sp,
                      toggleSize: 27.0.w,
                      value: c.isAppearanceSearch!,
                      borderRadius: 16.0.r,
                      // padding: 8.0,
                      showOnOff: false,
                      activeColor: AppColors.orangePrimary,

                      onToggle: (val) {
                        c.toggleAppearanceSearch();
                      },
                    ),
                    radiusTopLeft: 0.0,
                    radiusTopRight: 0.0,
                  ),

                  sizedBoxH(
                    height: 20,
                  ),
                  //Post Privacy, etc
                  SettingListTile(
                    text: AppStrings.postPrivacy,
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      color: AppColors.textColor,
                    ),
                    onTap: () {
                      getToNamed(postPrivacyRoute);
                    },
                    radiusBottomRight: 0.0,
                    radiusBottomLeft: 0.0,
                  ),
                  MyDivider(),
                  SettingListTile(
                    text: AppStrings.pushNotification,
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      color: AppColors.textColor,
                    ),
                    onTap: () {
                      getToNamed(pushNotificationRoute);
                    },
                    radiusBottomRight: 0.0,
                    radiusBottomLeft: 0.0,
                    radiusTopLeft: 0.0,
                    radiusTopRight: 0.0,
                  ),
                  MyDivider(),
                  SettingListTile(
                    text: AppStrings.changePhNo,
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      color: AppColors.textColor,
                    ),
                    onTap: () {
                      cd.Condition.setIsChangingPhoneNo = true;
                      getToNamed(phoneNumberRoute);
                    },
                    radiusBottomRight: 0.0,
                    radiusBottomLeft: 0.0,
                    radiusTopLeft: 0.0,
                    radiusTopRight: 0.0,
                  ),
                  MyDivider(),
                  SettingListTile(
                    text: AppStrings.blockedUser,
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      color: AppColors.textColor,
                    ),
                    onTap: () {
                      getToNamed(blockedUserRoute);
                    },
                    radiusTopLeft: 0.0,
                    radiusTopRight: 0.0,
                  ),

                  sizedBoxH(
                    height: 20,
                  ),

                  //About JYO etc
                  SettingListTile(
                    text: AppStrings.aboutJYO,
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      color: AppColors.textColor,
                    ),
                    onTap: () {},
                    radiusBottomRight: 0.0,
                    radiusBottomLeft: 0.0,
                  ),
                  MyDivider(),
                  SettingListTile(
                    text: AppStrings.giveUsFeedback,
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      color: AppColors.textColor,
                    ),
                    onTap: () {},
                    radiusBottomRight: 0.0,
                    radiusBottomLeft: 0.0,
                    radiusTopLeft: 0.0,
                    radiusTopRight: 0.0,
                  ),
                  MyDivider(),
                  SettingListTile(
                    text: AppStrings.deleteAcc,
                    icon: const Icon(
                      Icons.keyboard_arrow_right,
                      color: AppColors.textColor,
                    ),
                    onTap: () {
                      getToNamed(deleteAccRoute);
                    },
                    radiusTopLeft: 0.0,
                    radiusTopRight: 0.0,
                  ),

                  sizedBoxH(
                    height: 20,
                  ),
                  SettingListTile(
                    text: AppStrings.logOut,
                    icon: null,
                    onTap: () async {
                      await logoutTo(splashScreenRoute);
                    },
                    isLogout: true,
                  ),
                ],
              )),
        ));
      },
    );
  }
}
