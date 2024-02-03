import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jyo_app/data/local/user_search_model.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/view/profile_screen_view.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/freind_user_profile_screen_vm.dart';
import 'package:jyo_app/view_model/freindlist_screen_vm.dart';

import '../data/remote/api_interface.dart';
import '../data/remote/endpoints.dart';
import '../resources/app_colors.dart';
import '../resources/app_routes.dart';
import '../resources/app_strings.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_bar.dart';
import '../utils/app_widgets/app_icon_button.dart';
import '../utils/common.dart';
import '../view_model/profile_screen_vm.dart';

class FriendUserProfileScreenView extends StatelessWidget {
  const FriendUserProfileScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FriendUserProfileScreenVM>(builder: (c) {
      return WillPopScope(
        onWillPop: () async {
          if (c.isAppStartingFromNotification!) {
            getOffAllNamed(splashScreenRoute);
          } else {
            Get.back();
            c.baseVM.changePage(2, deleteVM: false);
            c.baseVM.selectedIndex = 2;
          }

          return true;
        },
        child: SafeArea(
            child: Scaffold(
                backgroundColor:
                    (c.isThisUserBlocked! || c.amIBlockedByThisUser!)
                        ? AppColors.white
                        : AppColors.appBkgColor,
                appBar: MyAppBar(
                  color: 0xffffffff,
                  leading: [
                    MyIconButton(
                      onTap: () {
                        Get.back();
                        c.baseVM.changePage(2, deleteVM: false);
                        c.baseVM.selectedIndex = 2;
                        c.baseVM.update();
                      },
                      icon: AppBarIcons.arrowBack,
                      isSvg: true,
                      size: 24,
                    )
                  ],
                  actions: [
                    c.isThisMyProfile!
                        ? Container()
                        : MyIconButton(
                            onTap: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoActionSheet(
                                        // title: const Text('Choose Options'),
                                        // message: const Text('Your options are '),
                                        actions: <Widget>[
                                      CupertinoActionSheetAction(
                                          child: Text(
                                            AppStrings.hideMyPost,
                                            style: AppStyles.interRegularStyle(
                                              color: AppColors.iosBlue,
                                            ),
                                          ),
                                          onPressed: () {}),
                                      CupertinoActionSheetAction(
                                        child: Text(
                                          AppStrings.reportUser,
                                          style: AppStyles.interRegularStyle(
                                              color: Colors.red),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(
                                              context, AppStrings.reportUser);
                                        },
                                      ),
                                      CupertinoActionSheetAction(
                                        child: Text(
                                          c.isThisUserBlocked!
                                              ? AppStrings.unblockUser
                                              : AppStrings.blockUser,
                                          style: AppStyles.interRegularStyle(
                                              color: Colors.red),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(
                                              context,
                                              c.isThisUserBlocked!
                                                  ? AppStrings.unblockUser
                                                  : AppStrings.blockUser);
                                          c.isThisUserBlocked!
                                              ? c.unblockUser()
                                              : c.blockUserProfile();
                                        },
                                      )
                                    ],
                                        cancelButton:
                                            CupertinoActionSheetAction(
                                          child: Text(
                                            AppStrings.cancel,
                                            style: AppStyles.interRegularStyle(
                                                color: AppColors.iosBlue),
                                          ),
                                          isDefaultAction: true,
                                          onPressed: () {
                                            Navigator.pop(
                                                context, AppStrings.cancel);
                                          },
                                        )),
                              );
                            },
                            icon: AppBarIcons.menuSvg,
                            isSvg: true,
                            size: 24,
                          )
                  ],
                ),
                body: RefreshIndicator(
                  color: AppColors.orangePrimary,
                  onRefresh: () async {
                    c.init();
                    return;
                  },
                  child: ListView(
                    children: [
                      //Propic and edit
                      Container(
                          color: AppColors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 22.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.dialog(Material(
                                    type: MaterialType.transparency,
                                    child: Container(
                                      color: AppColors.black,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 22.w,
                                                vertical: 22.h),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: AppColors.white,
                                                    ))
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 138.h,
                                          ),
                                          Expanded(
                                              child: AnimatedContainer(
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.easeInOutCubic,
                                                  // margin: EdgeInsets.all(margin),
                                                  decoration: BoxDecoration(
                                                      image: (c.imageFileName !=
                                                                  null &&
                                                              c.imageFileName!
                                                                  .isEmpty)
                                                          ? const DecorationImage(
                                                              image: AssetImage(
                                                                AppImage
                                                                    .sampleAvatar,
                                                              ),
                                                              fit: BoxFit.cover,
                                                            )
                                                          : DecorationImage(
                                                              image:
                                                                  NetworkImage(
                                                                ApiInterface.baseUrl +
                                                                    Endpoints
                                                                        .user +
                                                                    Endpoints
                                                                        .profileImage +
                                                                    c.imageFileName
                                                                        .toString(),
                                                              ),
                                                              fit: BoxFit.cover,
                                                            )))),
                                          SizedBox(
                                            height: 138.h,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                                },
                                child: Container(
                                  width: 72.w,
                                  height: 72.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28.8.r),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(28.8.r),
                                    child: (c.imageFileName != null &&
                                            c.imageFileName!.isEmpty)
                                        ? Image.asset(
                                            AppImage.sampleAvatar,
                                            fit: BoxFit.fill,
                                          )
                                        : Image.network(
                                            ApiInterface.baseUrl +
                                                Endpoints.user +
                                                Endpoints.profileImage +
                                                c.imageFileName.toString(),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                              c.isThisMyProfile!
                                  ? Container()
                                  : c.amIBlockedByThisUser!
                                      ? Container()
                                      : c.isThisUserBlocked!
                                          ? Row(
                                              children: [
                                                InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100.r),
                                                    onTap: () {},
                                                    child: Container(
                                                      height: 34.h,
                                                      // width: 90.w,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12.w,
                                                              vertical: 5.h),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    100.r),
                                                        border: Border.all(
                                                            color: AppColors
                                                                .editBorderColor),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          // sizedBoxW(
                                                          //   width: 12,
                                                          // ),
                                                          // SvgPicture.asset(
                                                          //   AppIcons.tick,
                                                          //   width: 10.w,
                                                          //   height: 10.h,
                                                          // ),
                                                          // sizedBoxW(
                                                          //   width: 6,
                                                          // ),
                                                          Center(
                                                            child: Text(
                                                              "Blocked",
                                                              style: AppStyles
                                                                  .interMediumStyle(
                                                                fontSize: 14.4,
                                                                color: AppColors
                                                                    .editBorderColor,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                          // sizedBoxW(
                                                          //   width: 8,
                                                          // ),
                                                        ],
                                                      ),
                                                    )),
                                              ],
                                            )
                                          : c.isThisUserMyFriend!
                                              ? Row(
                                                  children: [
                                                    InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    100.r),
                                                        child: MyAvatar(
                                                          url: AppIcons.cal,
                                                          width: 34,
                                                          height: 34,
                                                          radiusAll: 100,
                                                          isSVG: true,
                                                        )),
                                                    sizedBoxW(width: 8.w),
                                                    InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    100.r),
                                                        child: MyAvatar(
                                                          url: AppIcons.msg,
                                                          width: 34,
                                                          height: 34,
                                                          radiusAll: 100,
                                                          isSVG: true,
                                                        )),
                                                    sizedBoxW(width: 8.w),
                                                    InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    100.r),
                                                        onTap: () {
                                                          showCupertinoModalPopup(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                CupertinoActionSheet(
                                                                    // title: const Text('Choose Options'),
                                                                    // message: const Text('Your options are '),
                                                                    actions: <
                                                                        Widget>[
                                                                  // CupertinoActionSheetAction(
                                                                  //   isDefaultAction: false,
                                                                  //   isDestructiveAction: true,
                                                                  //   child: Text(
                                                                  //     c.firstName!+" "+c.lastName!,
                                                                  //     style: AppStyles
                                                                  //         .interRegularStyle(
                                                                  //             color: AppColors
                                                                  //                 .hintTextColor,fontSize: 10),
                                                                  //   ),
                                                                  //   onPressed: (){}
                                                                  // ),
                                                                  CupertinoActionSheetAction(
                                                                    child: Text(
                                                                      AppStrings
                                                                          .unfriend,
                                                                      style: AppStyles.interRegularStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context,
                                                                          AppStrings
                                                                              .unfriend);
                                                                      c.acceptOrRejectRequest(
                                                                          isAccept:
                                                                              "0");
                                                                    },
                                                                  )
                                                                ],
                                                                    cancelButton:
                                                                        CupertinoActionSheetAction(
                                                                      child:
                                                                          Text(
                                                                        AppStrings
                                                                            .cancel,
                                                                        style: AppStyles.interRegularStyle(
                                                                            color:
                                                                                AppColors.iosBlue),
                                                                      ),
                                                                      isDefaultAction:
                                                                          true,
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context,
                                                                            AppStrings.cancel);
                                                                      },
                                                                    )),
                                                          );
                                                        },
                                                        child: Container(
                                                          height: 34.h,
                                                          //width: 84.w,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 12.w,
                                                                  top: 5.h,
                                                                  bottom: 5.h),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.r),
                                                            border: Border.all(
                                                                color: AppColors
                                                                    .editBorderColor),
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              sizedBoxW(
                                                                width: 12,
                                                              ),
                                                              SvgPicture.asset(
                                                                AppIcons.tick,
                                                                width: 10.w,
                                                                height: 10.h,
                                                              ),
                                                              sizedBoxW(
                                                                width: 6,
                                                              ),
                                                              Text(
                                                                  AppStrings
                                                                      .friend,
                                                                  style: AppStyles
                                                                      .interMediumStyle(
                                                                    fontSize:
                                                                        14.4,
                                                                    color: AppColors
                                                                        .editBorderColor,
                                                                  )),
                                                              sizedBoxW(
                                                                width: 8,
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ],
                                                )
                                              : c.isRequestRecieved!
                                                  ? Row(
                                                      children: [
                                                        InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.r),
                                                            child: MyAvatar(
                                                              url: AppIcons.msg,
                                                              width: 34,
                                                              height: 34,
                                                              radiusAll: 100,
                                                              isSVG: true,
                                                            )),
                                                        sizedBoxW(width: 8.w),
                                                        InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.r),
                                                            onTap: c.isEnabled!
                                                                ? () {
                                                                    c.acceptOrRejectRequest(
                                                                        isAccept:
                                                                            "1");
                                                                  }
                                                                : null,
                                                            child: Container(
                                                                height: 34.h,
                                                                width: 84.w,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(100
                                                                                .r),
                                                                        // border:
                                                                        // Border.all(
                                                                        //     color: AppColors.editBorderColor),
                                                                        gradient: const LinearGradient(
                                                                            transform:
                                                                                GradientRotation(94.37),
                                                                            colors: [
                                                                              Color(0xffFFD036),
                                                                              Color(0xffFFA43C)
                                                                            ])),
                                                                child: Center(
                                                                    child: Text(
                                                                  AppStrings
                                                                      .accept,
                                                                  style: AppStyles.interMediumStyle(
                                                                      color: AppColors
                                                                          .white,
                                                                      fontSize:
                                                                          14.4),
                                                                )))),
                                                        sizedBoxW(width: 8.w),
                                                        InkWell(
                                                          onTap: () {
                                                            c.acceptOrRejectRequest(
                                                                isAccept: "0");
                                                          },
                                                          child: Container(
                                                              height: 34.h,
                                                              width: 84.w,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100.r),
                                                                border: Border.all(
                                                                    color: AppColors
                                                                        .orangePrimary),
                                                                // gradient: const LinearGradient(
                                                                //     transform: GradientRotation(94.37),
                                                                //     colors: [Color(0xffFFD036), Color(0xffFFA43C)])
                                                              ),
                                                              child: Center(
                                                                  child: Text(
                                                                AppStrings
                                                                    .ignore,
                                                                style: AppStyles
                                                                    .interMediumStyle(
                                                                        color: AppColors
                                                                            .orangePrimary,
                                                                        fontSize:
                                                                            14.4),
                                                              )))
                                                          //  Container(
                                                          //     height: 34.h,
                                                          //     width: 84.w,
                                                          //     decoration: BoxDecoration(
                                                          //       color: Colors.red,
                                                          //       borderRadius:
                                                          //           BorderRadius.circular(
                                                          //               100.r),
                                                          //       border: Border.all(
                                                          //           color: Colors.red),
                                                          //       //         gradient: const LinearGradient(
                                                          //       // transform: GradientRotation(94.37),
                                                          //       // colors: [Color(0xffFFD036), Color(0xffFFA43C)])
                                                          //     ),
                                                          //     child: Center(
                                                          //         child: Text(
                                                          //       AppStrings.reject,
                                                          //       style: AppStyles
                                                          //           .interMediumStyle(
                                                          //               color: AppColors
                                                          //                   .white,
                                                          //               fontSize: 14.4),
                                                          //     )))
                                                          ,
                                                        ),
                                                      ],
                                                    )
                                                  : Row(
                                                      children: [
                                                        InkWell(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.r),
                                                            child: MyAvatar(
                                                              url: AppIcons.msg,
                                                              width: 34,
                                                              height: 34,
                                                              radiusAll: 100,
                                                              isSVG: true,
                                                            )),
                                                        sizedBoxW(width: 8.w),
                                                        !c.isRequestSent!
                                                            ? InkWell(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(100
                                                                            .r),
                                                                onTap:
                                                                    c.isEnabled!
                                                                        ? () {
                                                                            c.addFriend();
                                                                          }
                                                                        : null,
                                                                child: Container(
                                                                    height: 34.h,
                                                                    //width: 84.w,
                                                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.circular(100.r),
                                                                        // border:
                                                                        // Border.all(
                                                                        //     color: AppColors.editBorderColor),
                                                                        gradient: const LinearGradient(transform: GradientRotation(94.37), colors: [Color(0xffFFD036), Color(0xffFFA43C)])),
                                                                    child: Center(
                                                                        child: Text(
                                                                      AppStrings
                                                                          .addFriend,
                                                                      style: AppStyles.interMediumStyle(
                                                                          color: AppColors
                                                                              .white,
                                                                          fontSize:
                                                                              14.4),
                                                                    ))))
                                                            : InkWell(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100.r),
                                                                onTap: () {
                                                                  showCupertinoModalPopup(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        CupertinoActionSheet(
                                                                            actions: <
                                                                                Widget>[
                                                                          CupertinoActionSheetAction(
                                                                            child:
                                                                                Text(
                                                                              AppStrings.cancelFriendReq,
                                                                              style: AppStyles.interRegularStyle(color: Colors.red),
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context, AppStrings.cancelFriendReq);
                                                                              c.cancelFriendRequest();
                                                                            },
                                                                          )
                                                                        ],
                                                                            cancelButton:
                                                                                CupertinoActionSheetAction(
                                                                              child: Text(
                                                                                AppStrings.cancel,
                                                                                style: AppStyles.interRegularStyle(color: AppColors.iosBlue),
                                                                              ),
                                                                              isDefaultAction: true,
                                                                              onPressed: () {
                                                                                Navigator.pop(context, AppStrings.cancel);
                                                                              },
                                                                            )),
                                                                  );
                                                                },
                                                                child: Container(
                                                                    height: 34.h,
                                                                    // width: 84.w,
                                                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                                                                    decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100.r),
                                                                      border: Border.all(
                                                                          color:
                                                                              AppColors.editBorderColor),
                                                                      //         gradient: const LinearGradient(
                                                                      // transform: GradientRotation(94.37),
                                                                      // colors: [Color(0xffFFD036), Color(0xffFFA43C)])
                                                                    ),
                                                                    child: Center(
                                                                        child: Text(AppStrings.requestSent,
                                                                            style: AppStyles.interMediumStyle(
                                                                              color: AppColors.editBorderColor,
                                                                              fontSize: Platform.isIOS ? 13 : 14.4,
                                                                            ),
                                                                            textAlign: TextAlign.center))),
                                                              ),
                                                      ],
                                                    )
                            ],
                          )),

                      //Bio
                      Container(
                        color: AppColors.white,
                        padding: EdgeInsets.only(
                            bottom: 24.h, right: 22.w, left: 22.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  c.firstName! + " " + c.lastName!,
                                  style: AppStyles.interSemiBoldStyle(
                                      fontSize: 18.0),
                                ),
                                sizedBoxW(
                                  width: 4,
                                ),
                                Text(
                                  c.age!,
                                  style: AppStyles.interMediumStyle(
                                      fontSize: 18.0,
                                      color: AppColors.ageColor),
                                )
                              ],
                            ),
                            sizedBoxH(
                              height: 8,
                            ),
                            c.userName!.trim().isEmpty
                                ? Container()
                                : Row(
                                    children: [
                                      Text(
                                        "@" + c.userName!,
                                        style: AppStyles.interRegularStyle(
                                            fontSize: 15.0,
                                            color: AppColors.hintTextColor),
                                      ),
                                    ],
                                  ),
                            sizedBoxH(
                              height: c.userName!.trim().isEmpty ? 0 : 8,
                            ),
                            c.bio!.trim().isEmpty
                                ? Container()
                                : Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          c.bio!,
                                          style: AppStyles.interRegularStyle(
                                              fontSize: 17.2,
                                              color: AppColors.textColor),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                            sizedBoxH(
                              height: c.bio!.trim().isEmpty ? 0 : 8,
                            ),
                            c.amIBlockedByThisUser!
                                ? Container()
                                : Row(
                                    children: [
                                      InkWell(
                                          onTap: () async {
                                            if (c.isThisUserBlocked!) {
                                            } else if (c.isPrivateAccount! &&
                                                !c.isThisUserMyFriend!) {
                                              debugPrint("I am hrer");
                                            } else {
                                              SearchUser.setId = c.userId;
                                              await Get.delete<
                                                      FriendlistScreenVM>(
                                                  force: true);
                                              getToNamed(friendlistScreenRoute);
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                c.freinds!,
                                                style:
                                                    AppStyles.interMediumStyle(
                                                        fontSize: 17.2,
                                                        color: AppColors
                                                            .textColor),
                                              ),
                                              sizedBoxW(
                                                width: 4,
                                              ),
                                              Text(
                                                "Friends",
                                                style:
                                                    AppStyles.interRegularStyle(
                                                        fontSize: 15.0,
                                                        color: AppColors
                                                            .hintTextColor),
                                              ),
                                            ],
                                          )),
                                      sizedBoxW(
                                        width: 32,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            c.posts!,
                                            style: AppStyles.interMediumStyle(
                                                fontSize: 17.2,
                                                color: AppColors.textColor),
                                          ),
                                          sizedBoxW(
                                            width: 4,
                                          ),
                                          Text(
                                            "Posts",
                                            style: AppStyles.interRegularStyle(
                                                fontSize: 15.0,
                                                color: AppColors.hintTextColor),
                                          ),
                                        ],
                                      ),
                                      sizedBoxW(
                                        width: 32,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            c.activities!,
                                            style: AppStyles.interMediumStyle(
                                                fontSize: 17.2,
                                                color: AppColors.textColor),
                                          ),
                                          sizedBoxW(
                                            width: 4,
                                          ),
                                          Text(
                                            "Activities",
                                            style: AppStyles.interRegularStyle(
                                                fontSize: 15.0,
                                                color: AppColors.hintTextColor),
                                          ),
                                        ],
                                      ),
                                      sizedBoxW(
                                        width: 32,
                                      ),
                                    ],
                                  ),
                            sizedBoxH(
                              height: 8,
                            ),
                            (c.amIBlockedByThisUser! ||
                                    (c.isPrivateAccount! &&
                                        !c.isThisUserMyFriend!))
                                ? Container()
                                : Row(
                                    children: [
                                      Text(
                                        "Interests",
                                        style: AppStyles.interRegularStyle(
                                            fontSize: 15.0,
                                            color: AppColors.hintTextColor),
                                      ),
                                    ],
                                  ),
                            (c.amIBlockedByThisUser! ||
                                    (c.isPrivateAccount! &&
                                        !c.isThisUserMyFriend!))
                                ? Container()
                                : sizedBoxH(
                                    height: 8,
                                  ),
                            (c.amIBlockedByThisUser! ||
                                    (c.isPrivateAccount! &&
                                        !c.isThisUserMyFriend!))
                                ? Container()
                                : SizedBox(
                                    height: 46.h,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: c.userIntrests.length,
                                        itemBuilder: (context, index) {
                                          return ProfileScreenView
                                              .mostLikedCard(context, c, index);
                                        }),
                                  )
                          ],
                        ),
                      ),

                      //Posts and activity tabs
                      (c.isThisUserBlocked! ||
                              c.amIBlockedByThisUser! ||
                              (c.isPrivateAccount! && !c.isThisUserMyFriend!))
                          ? Container()
                          : Container(
                              color: AppColors.white,
                              padding: EdgeInsets.only(
                                  right: 22.w, left: 22.w, bottom: 16.w),
                              child: Container(
                                height: 41.h,
                                // margin: EdgeInsets.symmetric(horizontal: 22.w),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14.r),
                                    color: AppColors.tabBkgColor),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 41.h,
                                          // padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14.r),
                                              boxShadow: c.profileSection ==
                                                      ProfileSection.posts
                                                  ? [
                                                      BoxShadow(
                                                          blurRadius: 4.r,
                                                          offset: const Offset(
                                                              1, 1),
                                                          color: AppColors
                                                              .tabShadowColor)
                                                    ]
                                                  : null,
                                              color: c.profileSection ==
                                                      ProfileSection.posts
                                                  ? AppColors.white
                                                  : AppColors.tabBkgColor),
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(14.r),
                                            type: MaterialType.transparency,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(14.r),
                                              onTap: () {
                                                c.profileSection =
                                                    ProfileSection.posts;
                                                c.update();
                                              },
                                              child: Center(
                                                child: Text(
                                                  AppStrings.posts,
                                                  style: AppStyles.interMediumStyle(
                                                      fontSize: 12.8,
                                                      color: c.profileSection ==
                                                              ProfileSection
                                                                  .posts
                                                          ? AppColors.textColor
                                                          : AppColors
                                                              .editBorderColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 41.h,
                                          // padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14.r),
                                              boxShadow: c.profileSection ==
                                                      ProfileSection.activities
                                                  ? [
                                                      BoxShadow(
                                                          blurRadius: 4.r,
                                                          offset: const Offset(
                                                              1, 1),
                                                          color: AppColors
                                                              .tabShadowColor)
                                                    ]
                                                  : null,
                                              color: c.profileSection ==
                                                      ProfileSection.activities
                                                  ? AppColors.white
                                                  : AppColors.tabBkgColor),
                                          child: Material(
                                              borderRadius:
                                                  BorderRadius.circular(14.r),
                                              type: MaterialType.transparency,
                                              child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          14.r),
                                                  onTap: () {
                                                    c.profileSection =
                                                        ProfileSection
                                                            .activities;
                                                    c.update();
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      AppStrings.activities,
                                                      style: AppStyles.interMediumStyle(
                                                          fontSize: 12.8,
                                                          color: c.profileSection ==
                                                                  ProfileSection
                                                                      .activities
                                                              ? AppColors
                                                                  .textColor
                                                              : AppColors
                                                                  .editBorderColor),
                                                    ),
                                                  ))),
                                        ))
                                  ],
                                ),
                              ),
                            ),

                      //Post anc activity sections
                      c.profileSection == ProfileSection.posts
                          ? c.isLoadingPost!
                              ? SizedBox(
                                  height: 150.h,
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                    color: AppColors.orangePrimary,
                                  )),
                                )
                              : c.postsVM.postsList.isEmpty
                                  ? SizedBox(
                                      height: 150.h,
                                      child: Center(
                                          child: Text(
                                        c.amIBlockedByThisUser!
                                            ? "User blocked you for some reason."
                                            : c.isFriendsPrivacy!
                                                ? "Only Friends can view posts"
                                                : c.isOnlyMePrivacy!
                                                    ? "Posts are hidden from all"
                                                    : (c.isPrivateAccount! &&
                                                            !c.isThisUserMyFriend!)
                                                        ? "This profile is private"
                                                        : "No posts available",
                                        style: AppStyles.interRegularStyle(),
                                      )),
                                    )
                                  : c.isThisUserBlocked!
                                      ? SizedBox(
                                          height: 150.h,
                                          child: Center(
                                              child: Text(
                                            "You have blocked this user.",
                                            style:
                                                AppStyles.interRegularStyle(),
                                          )),
                                        )
                                      : Column(
                                          children: c.isPrivateAccount!
                                              ? privatePostAndActivities
                                              : List.generate(
                                                  c.postsVM.postsList.length,
                                                  (index) {
                                                  return PostWidget.post(
                                                      c.postsVM, c, index,
                                                      isProfilePost: true,
                                                      andIsFreind: true);
                                                }),
                                        )
                          : c.isLoadingActs
                              ? SizedBox(
                                  height: 150.h,
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                    color: AppColors.orangePrimary,
                                  )),
                                )
                              : c.postsVM.activitiesList.isEmpty
                                  ? SizedBox(
                                      height: 150.h,
                                      child: Center(
                                          child: Text(
                                        c.amIBlockedByThisUser!
                                            ? "User blocked you for some reason."
                                            : c.isFriendsPrivacy!
                                                ? "Only Friends can view Activities"
                                                : c.isOnlyMePrivacy!
                                                    ? "Activities are hidden from all"
                                                    : "No Activities available",
                                        style: AppStyles.interRegularStyle(),
                                      )),
                                    )
                                  : c.isThisUserBlocked!
                                      ? SizedBox(
                                          height: 150.h,
                                          child: Center(
                                              child: Text(
                                            "You have blocked this user.",
                                            style:
                                                AppStyles.interRegularStyle(),
                                          )),
                                        )
                                      : Column(
                                          children: c.isPrivateAccount!
                                              ? privatePostAndActivities
                                              : List.generate(
                                                  c.postsVM.activitiesList
                                                      .length, (index) {
                                                  return ActivityWidget.activity(
                                                      c.postsVM.activitiesList[
                                                          index],
                                                      c.postsVM,
                                                      c,
                                                      isProfile: true);
                                                }),
                                        )
                    ],
                  ),
                ))),
      );
    });
  }

  List<Widget> get privatePostAndActivities {
    return [
      MyAvatar(
        url: AppIcons.lock,
        width: 24.w,
        height: 24.h,
        isSVG: true,
      ),
      sizedBoxH(height: 8.h),
      Text(
        AppStrings.thisProfileIsPrivate,
        style: AppStyles.interSemiBoldStyle(
          fontSize: 16,
        ),
      ),
      sizedBoxH(height: 8.h),
      Center(
        child: Text(
          AppStrings.privateProfDesc,
          style: AppStyles.interRegularStyle(
            fontSize: 15,
            color: AppColors.editBorderColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ];
  }
}
