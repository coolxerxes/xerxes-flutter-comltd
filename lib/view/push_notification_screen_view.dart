import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:jyo_app/view_model/push_notification_screen_vm.dart';

import '../resources/app_colors.dart';
import '../resources/app_image.dart';
import '../resources/app_strings.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_bar.dart';
import '../utils/app_widgets/app_divider.dart';
import '../utils/app_widgets/app_icon_button.dart';
import '../utils/app_widgets/setting_list_tile.dart';
import '../utils/common.dart';

class PushNotificaitonScreenView extends StatelessWidget {
  const PushNotificaitonScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PushNotificationScreenVM>(
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
              Text(AppStrings.pushNotification,
                  style: AppStyles.interSemiBoldStyle(
                      fontSize: 16.0, color: AppColors.textColor))
            ],
          ),
          body:  Container(
              padding:  EdgeInsets.symmetric(horizontal: 22.w),
              child: ListView(
                children: [
                  sizedBoxH(
                    height: 24,
                  ),
          
                  //Chat
                  SettingListTile(
                    text: AppStrings.directChat,
                    icon: FlutterSwitch(
                      width: 52.0.w,
                      height: 32.0.h,
                      valueFontSize: 0.0.sp,
                      toggleSize: 27.0.w,
                      borderRadius: 16.0.r,
                      value: c.isDirectChatEnabled!,
                      // padding: 8.0,
                      showOnOff: false,
                      activeColor: AppColors.orangePrimary,
          
                      onToggle: (val) {
                        c.toggleDirectChat();
                      },
                    ),
                    radiusBottomLeft: 0.0,
                    radiusBottomRight: 0.0,
                  ),
                  MyDivider(),
                  SettingListTile(
                    text: AppStrings.groupChat,
                    icon: FlutterSwitch(
                      width: 52.0.w,
                      height: 32.0.h,
                      valueFontSize: 0.0.sp,
                      toggleSize: 27.0.w,
                      borderRadius: 16.0.r,
                      value: c.isGroupChatEnabled!,
                      // padding: 8.0,
                      showOnOff: false,
                      activeColor: AppColors.orangePrimary,
          
                      onToggle: (val) {
                        c.toggleGroupChat();
                      },
                    ),
                    radiusTopLeft: 0.0,
                    radiusTopRight: 0.0,
                  ),
          
                  sizedBoxH(
                    height: 20,
                  ),
                  //Like and Comments
                  SettingListTile(
                    text: AppStrings.postLikeAndComments,
                    icon: FlutterSwitch(
                      width: 52.0.w,
                      height: 32.0.h,
                      valueFontSize: 0.0.sp,
                      toggleSize: 27.0.w,
                      borderRadius: 16.0.r,
                      value: c.isPostLikeNCommentsEnabled!,
                      // padding: 8.0,
                      showOnOff: false,
                      activeColor: AppColors.orangePrimary,
          
                      onToggle: (val) {
                        c.togglePostLikesAndComments();
                      },
                    ),
                  ),
          
                  sizedBoxH(
                    height: 20,
                  ),
          
                  //Activity
                  SettingListTile(
                    text: AppStrings.groupActivity,
                    icon: FlutterSwitch(
                      width: 52.0.w,
                      height: 32.0.h,
                      valueFontSize: 0.0.sp,
                      toggleSize: 27.0.w,
                      borderRadius: 16.0.r,
                      value: c.isGroupActivityEnabled!,
                      // padding: 8.0,
                      showOnOff: false,
                      activeColor: AppColors.orangePrimary,
          
                      onToggle: (val) {
                        c.toggleGroupActivity();
                      },
                    ),
                    radiusBottomLeft: 0.0,
                    radiusBottomRight: 0.0,
                  ),
                  MyDivider(),
                  SettingListTile(
                    text: AppStrings.friendActivity,
                    icon: FlutterSwitch(
                      width: 52.0.w,
                      height: 32.0.h,
                      valueFontSize: 0.0.sp,
                      toggleSize: 27.0.w,
                      borderRadius: 16.0.r,
                      value: c.isFriendActivityEnabled!,
                      // padding: 8.0,
                      showOnOff: false,
                      activeColor: AppColors.orangePrimary,
          
                      onToggle: (val) {
                        c.toggleFriendsActivity();
                      },
                    ),
                    radiusTopLeft: 0.0,
                    radiusTopRight: 0.0,
                    radiusBottomLeft: 0.0,
                    radiusBottomRight: 0.0,
                  ),
                  MyDivider(),
                  SettingListTile(
                    text: AppStrings.activityInvitation,
                    icon: FlutterSwitch(
                      width: 52.0.w,
                      height: 32.0.h,
                      valueFontSize: 0.0.sp,
                      toggleSize: 27.0.w,
                      borderRadius: 16.0.r,
                      value: c.isActivityInvitationEnabled!,                      
                      // padding: 8.0,
                      showOnOff: false,
                      activeColor: AppColors.orangePrimary,
          
                      onToggle: (val) {
                        c.toggleActivityInvitation();
                      },
                    ),
                    radiusTopLeft: 0.0,
                    radiusTopRight: 0.0,
                  ),
                ],
              )),
        ));
      },
    );
  }
}
