import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/app_widgets/app_bar.dart';
import 'package:jyo_app/utils/app_widgets/app_icon_button.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/notification_screen_vm.dart';

import '../data/local/notification_type.dart';
import '../data/local/user_search_model.dart';
import '../data/remote/api_interface.dart';
import '../data/remote/endpoints.dart';
import '../models/notification_model/notification_history_response.dart';
import '../resources/app_colors.dart';
import '../resources/app_routes.dart';

class NotificationScreenView extends StatelessWidget {
  const NotificationScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationScreenVM>(builder: (c) {
      return SafeArea(
          child: Scaffold(
              appBar: MyAppBar(
                color: 0xffffffff,
                leading: [
                  MyIconButton(
                    icon: AppBarIcons.arrowBack,
                    size: 24,
                    isSvg: true,
                    onTap: () {
                      Get.back();
                    },
                  )
                ],
                middle: [
                  Text(
                    AppStrings.notification,
                    style: AppStyles.interSemiBoldStyle(fontSize: 16),
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
                    Container(
                      color: AppColors.white,
                      padding: EdgeInsets.only(top: 24.h),
                      child: Container(
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
                                        boxShadow: c.currentTab ==
                                                NotificationType.allActivities
                                            ? [
                                                BoxShadow(
                                                    blurRadius: 4.r,
                                                    offset: const Offset(1, 1),
                                                    color: AppColors
                                                        .tabShadowColor)
                                              ]
                                            : null,
                                        color: c.currentTab ==
                                                NotificationType.allActivities
                                            ? AppColors.white
                                            : AppColors.tabBkgColor),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(14.r),
                                      type: MaterialType.transparency,
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(14.r),
                                        onTap: () async {
                                          c.currentTab =
                                              NotificationType.allActivities;
                                          await c.init();
                                          c.update();
                                        },
                                        child: Center(
                                          child: Text(
                                            AppStrings.allActivity,
                                            style: AppStyles.interMediumStyle(
                                                fontSize: 12.8,
                                                color: c.currentTab ==
                                                        NotificationType
                                                            .allActivities
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
                                        boxShadow: c.currentTab ==
                                                NotificationType.friendRequest
                                            ? [
                                                BoxShadow(
                                                    blurRadius: 4.r,
                                                    offset: const Offset(1, 1),
                                                    color: AppColors
                                                        .tabShadowColor)
                                              ]
                                            : null,
                                        color: c.currentTab ==
                                                NotificationType.friendRequest
                                            ? AppColors.white
                                            : AppColors.tabBkgColor),
                                    child: Material(
                                        borderRadius:
                                            BorderRadius.circular(14.r),
                                        type: MaterialType.transparency,
                                        child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(14.r),
                                            onTap: () async {
                                              c.currentTab = NotificationType
                                                  .friendRequest;
                                              await c.init();
                                              c.update();
                                            },
                                            child: Center(
                                              child: Text(
                                                AppStrings.friendRequest,
                                                style: AppStyles.interMediumStyle(
                                                    fontSize: 12.8,
                                                    color: c.currentTab ==
                                                            NotificationType
                                                                .friendRequest
                                                        ? AppColors.textColor
                                                        : AppColors
                                                            .editBorderColor),
                                              ),
                                            ))),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    c.currentTab == NotificationType.friendRequest
                        ? Column(
                            children: List.generate(c.pendingRequests!.length,
                                (index) {
                              return notificationCard(c, index,
                                  friendsOnly: c.currentTab ==
                                          NotificationType.friendRequest
                                      ? true
                                      : false);
                            }),
                          )
                        : Column(
                            children: [
                              Column(
                                children: List.generate(c.notifications!.length,
                                    (index) {
                                  return notificationCard(c, index,
                                      friendsOnly: c.currentTab ==
                                              NotificationType.friendRequest
                                          ? true
                                          : false);
                                }),
                              ),
                              //       c.currentTab == NotificationType.friendRequest
                              // ? Container()
                              // :
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 22.w, vertical: 10),
                                    child: Text(
                                      "Earlier",
                                      style: AppStyles.interMediumStyle(
                                          fontSize: 18),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: c.notificationsEarlier!.isEmpty
                                    ? [
                                        Text(
                                          "No earlier notifications",
                                          style: AppStyles.interRegularStyle(),
                                        )
                                      ]
                                    : List.generate(
                                        c.notificationsEarlier!.length,
                                        (index) {
                                        return notificationCard(c, index,
                                            friendsOnly: c.currentTab ==
                                                    NotificationType
                                                        .friendRequest
                                                ? true
                                                : false,
                                            earlier: true);
                                      }),
                              ),
                            ],
                          ),
                    c.currentTab == NotificationType.friendRequest
                        ? Container()
                        : sizedBoxH(height: 8),
                  ],
                ),
              )));
    });
  }

  Widget notificationCard(NotificationScreenVM c, int index,
      {friendsOnly = false, earlier = false}) {
    List<Datum> list = List.empty(growable: true);
    var type = earlier! ? "3" : "2";
    list = earlier! ? c.notificationsEarlier! : c.notifications!;
    if (friendsOnly) {
      return frienRequestCard(c, index,
          userId: c.pendingRequests![index].userInfo!.userId.toString(),
          firstName: c.pendingRequests![index].userInfo!.firstName.toString(),
          lastName: c.pendingRequests![index].userInfo!.lastName.toString(),
          createdDate: c.pendingRequests![index].createdAt.toString(),
          profilePic: c.pendingRequests![index].userInfo!.profilePic.toString(),
          type: "1");
    } else {
      switch (list[index].notificationType) {
        // case NotificationTypes.accetpFriendReq:
        //   return Container(
        //     child: Text("accept friend req"),
        //   );
        case NotificationTypes.friendReqSent:
          return frienRequestCard(
            c,
            index,
            userId: list[index].user!.userInfo!.userId.toString(),
            firstName: list[index].user!.userInfo!.firstName.toString(),
            lastName: list[index].user!.userInfo!.lastName.toString(),
            createdDate: list[index].createdDate.toString(),
            profilePic: list[index].user!.userInfo!.profilePic.toString(),
            type: type,
          );
        // case NotificationTypes.commentPost:
        //   return Container(
        //     child: Text("Comment"),
        //   );
        // case NotificationTypes.likePost:
        //   return likeCard(c, index);
        // // case invite:
        // //   return;
        // // case activity:
        // //   return;
        // case NotificationTypes.jioMePost:
        //   return Container(
        //     child: Text("JioMe"),
        //   );
        default:
          return notification(c, index, list);
      }
    }
  }

  Widget frienRequestCard(NotificationScreenVM c, int index,
      {String? userId,
      String? profilePic = "",
      String? firstName = "",
      String? lastName = "",
      String? createdDate,
      String? type}) {
    return Container(
      margin: EdgeInsets.only(
          top: index == 0 ? 0 : 8.h, bottom: 8.h, right: 22.w, left: 22.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          color: AppColors.primaryOrange8Per,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profilePic.toString().isNotEmpty
                ? InkWell(
                    onTap: () {
                      SearchUser.setId = userId!.toString();
                      getToNamed(friendUserProfileScreeRoute);
                    },
                    child: MyAvatar(
                        url: ApiInterface.baseUrl +
                            Endpoints.user +
                            Endpoints.profileImage +
                            profilePic!.toString(),
                        isNetwork: true,
                        width: 56,
                        height: 56,
                        radiusAll: 22.4),
                  )
                : InkWell(
                    onTap: () {
                      SearchUser.setId = userId!.toString();
                      getToNamed(friendUserProfileScreeRoute);
                    },
                    child: MyAvatar(
                      url: AppImage.sampleAvatar,
                      width: 56,
                      height: 56,
                      radiusAll: 22.4,
                    ),
                  ),
            sizedBoxW(width: 12.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.getTime(createdDate!),
                    style: AppStyles.interRegularStyle(
                        fontSize: 13.2, color: AppColors.orangePrimary),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            SearchUser.setId = userId!.toString();
                            getToNamed(friendUserProfileScreeRoute);
                          },
                          child: RichText(
                              text: TextSpan(
                                  text: firstName.toString() +
                                      " " +
                                      lastName.toString(),
                                  style: AppStyles.interSemiBoldStyle(
                                      fontSize: 16),
                                  children: [
                                TextSpan(
                                    text: " send you a friend request",
                                    style: AppStyles.interRegularStyle(
                                        fontSize: 16))
                              ])),
                        ),
                      ),
                    ],
                  ),
                  sizedBoxH(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          c.acceptOrIgnoreRequest(index,
                              friendId: userId.toString(),
                              isAccept: "1",
                              type: type);
                        },
                        borderRadius: BorderRadius.circular(100.r),
                        child: Container(
                            height: 34.h,
                            width: 84.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.r),
                                // border:
                                // Border.all(
                                //     color: AppColors.editBorderColor),
                                gradient: const LinearGradient(
                                    transform: GradientRotation(94.37),
                                    colors: [
                                      Color(0xffFFD036),
                                      Color(0xffFFA43C)
                                    ])),
                            child: Center(
                                child: Text(
                              AppStrings.accept,
                              style: AppStyles.interMediumStyle(
                                  color: AppColors.white, fontSize: 14.4),
                            ))),
                      ),
                      sizedBoxW(width: 12.w),
                      InkWell(
                        onTap: () {
                          c.acceptOrIgnoreRequest(index,
                              friendId: userId.toString(), isAccept: "0");
                        },
                        borderRadius: BorderRadius.circular(100.r),
                        child: Container(
                            height: 34.h,
                            width: 84.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.r),
                              border:
                                  Border.all(color: AppColors.orangePrimary),
                              // gradient: const LinearGradient(
                              //     transform: GradientRotation(94.37),
                              //     colors: [Color(0xffFFD036), Color(0xffFFA43C)])
                            ),
                            child: Center(
                                child: Text(
                              AppStrings.ignore,
                              style: AppStyles.interMediumStyle(
                                  color: AppColors.orangePrimary,
                                  fontSize: 14.4),
                            ))),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget notification(NotificationScreenVM c, int index, list) {
    return Container(
      margin: EdgeInsets.only(
          top: index == 0 ? 0 : 8.h, bottom: 8.h, right: 22.w, left: 22.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          color: AppColors.notifiCardBkg,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            list[index].user!.userInfo!.profilePic.toString().trim().isEmpty
                ? InkWell(
                    onTap: () {
                      SearchUser.setId =
                          list[index].user!.userInfo!.userId!.toString();
                      getToNamed(friendUserProfileScreeRoute);
                    },
                    child: MyAvatar(
                      url: AppImage.sampleAvatar,
                      width: 56,
                      height: 56,
                      radiusAll: 22.4,
                    ),
                  )
                : InkWell(
                    onTap: () {
                      SearchUser.setId =
                          list[index].user!.userInfo!.userId!.toString();
                      getToNamed(friendUserProfileScreeRoute);
                    },
                    child: MyAvatar(
                      url: ApiInterface.baseUrl +
                          Endpoints.user +
                          Endpoints.profileImage +
                          list[index]
                              .user!
                              .userInfo!
                              .profilePic
                              .toString()
                              .trim()
                              .toString(),
                      width: 56,
                      height: 56,
                      radiusAll: 22.4,
                      isNetwork: true,
                    ),
                  ),
            sizedBoxW(width: 12.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.getTime(list[index].createdDate.toString()),
                    style: AppStyles.interRegularStyle(
                        fontSize: 13.2, color: AppColors.hintTextColor),
                  ),
                  InkWell(
                    onTap: () {
                      SearchUser.setId =
                          list[index].user!.userInfo!.userId!.toString();
                      getToNamed(friendUserProfileScreeRoute);
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: RichText(
                              text: TextSpan(
                                  text: list[index]
                                          .user!
                                          .userInfo!
                                          .firstName
                                          .toString() +
                                      " " +
                                      list[index]
                                          .user!
                                          .userInfo!
                                          .lastName
                                          .toString() +
                                      " ",
                                  style: AppStyles.interSemiBoldStyle(
                                      fontSize: 16),
                                  children: [
                                // TextSpan(
                                //     text: "and",
                                //     style: AppStyles.interRegularStyle(
                                //         fontSize: 16)),
                                // TextSpan(
                                //   text: "44 others ",
                                //   style:
                                //       AppStyles.interSemiBoldStyle(fontSize: 16),
                                // ),
                                TextSpan(
                                    text: c.getLine(list[index]
                                        .notificationType
                                        .toString()),
                                    style: AppStyles.interRegularStyle(
                                        fontSize: 16)),
                              ])),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
