import 'package:flutter/gestures.dart';
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
import 'package:jyo_app/view_model/group_details_screen_vm.dart';
import 'package:jyo_app/view_model/notification_screen_vm.dart';
import 'package:jyo_app/view_model/single_post_screen_vm.dart';

import '../data/local/notification_type.dart';
import '../data/local/user_search_model.dart';
import '../data/remote/api_interface.dart';
import '../data/remote/endpoints.dart';
import '../models/notification_model/notification_history_response.dart';
import '../resources/app_colors.dart';
import '../resources/app_routes.dart';
import '../view_model/activity_details_screen_vm.dart';

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
            userId: list[index].friendId.toString(),
            firstName: list[index].friendName.toString(),
            //lastName: list[index].user!.userInfo!.lastName.toString(),
            createdDate: list[index].createdDate.toString(),
            profilePic: list[index].relatedImage!.toString(),
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
          return notification(c, index, list, type);
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

  Widget notification(
      NotificationScreenVM c, int index, List<Datum> list, type) {
    return Container(
      margin: EdgeInsets.only(
          top: index == 0 ? 0 : 8.h, bottom: 8.h, right: 22.w, left: 22.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          color: AppColors.notifiCardBkg,
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(22.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(22.r),
            onTap: () {
              if (!(isGroupNotification(
                      list[index].notificationType.toString()) ||
                  isActivityNotification(
                      list[index].notificationType.toString()) ||
                  isPostNotification(
                      list[index].notificationType.toString()))) {
                debugPrint("IN HERE !");
                redirect(list[index].notificationType.toString(),
                    list[index].friendId.toString());
              } else {
                redirect(list[index].notificationType.toString(),
                    list[index].relatedId.toString());
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.r),
                // color: AppColors.notifiCardBkg,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  list[index].relatedImage.toString().trim().isEmpty
                      ? InkWell(
                          onTap: isPromotted(list, index)
                              ? null
                              : () {
                                  onPrimaryNameClicked(
                                      list[index].notificationType.toString(),
                                      list[index].notificationType.toString() ==
                                              NotificationTypes
                                                  .createdActivityInsideGroup
                                          ? list[index].relatedId.toString()
                                          : list[index].friendId.toString(),
                                      toGroup: list[index]
                                              .notificationType
                                              .toString() ==
                                          NotificationTypes
                                              .createdActivityInsideGroup);
                                },
                          child: MyAvatar(
                            url: AppImage.sampleAvatar,
                            width: 56,
                            height: 56,
                            radiusAll: 22.4,
                          ),
                        )
                      : InkWell(
                          onTap: isPromotted(list, index)
                              ? null
                              : () {
                                  onPrimaryNameClicked(
                                      list[index].notificationType.toString(),
                                      list[index].notificationType.toString() ==
                                              NotificationTypes
                                                  .createdActivityInsideGroup
                                          ? list[index].relatedId.toString()
                                          : list[index].friendId.toString(),
                                      toGroup: list[index]
                                              .notificationType
                                              .toString() ==
                                          NotificationTypes
                                              .createdActivityInsideGroup);
                                },
                          child: MyAvatar(
                            url: ApiInterface.baseUrl +
                                Endpoints.user +
                                Endpoints.profileImage +
                                list[index].relatedImage!.toString().trim(),
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
                          onTap: null,
                          child: Row(
                            children: [
                              Expanded(
                                child: RichText(
                                    text: TextSpan(
                                        text: isPromotted(list, index)
                                            ? ""
                                            : list[index]
                                                        .notificationType
                                                        .toString() ==
                                                    NotificationTypes
                                                        .createdActivityInsideGroup
                                                ? list[index]
                                                    .relatedName
                                                    .toString()
                                                : list[index]
                                                    .friendName
                                                    .toString(),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = isPromotted(list, index)
                                              ? null
                                              : () {
                                                  onPrimaryNameClicked(
                                                      list[index]
                                                          .notificationType
                                                          .toString(),
                                                      list[index]
                                                                  .notificationType
                                                                  .toString() ==
                                                              NotificationTypes
                                                                  .createdActivityInsideGroup
                                                          ? list[index]
                                                              .relatedId
                                                              .toString()
                                                          : list[index]
                                                              .friendId
                                                              .toString(),
                                                      toGroup: list[index]
                                                              .notificationType
                                                              .toString() ==
                                                          NotificationTypes
                                                              .createdActivityInsideGroup);
                                                },
                                        //     +
                                        // " " +
                                        // list[index]
                                        //     .user!
                                        //     .userInfo!
                                        //     .lastName
                                        //     .toString() +
                                        //" ",
                                        style: AppStyles.interSemiBoldStyle(
                                            fontSize: 16),
                                        children: [
                                      TextSpan(
                                          text: " " +
                                              c.getLine(list[index]
                                                  .notificationType
                                                  .toString()),
                                          style: AppStyles.interRegularStyle(
                                              fontSize: 16)),
                                      TextSpan(
                                        text: " " +
                                            ((list[index]
                                                        .notificationType
                                                        .toString() ==
                                                    NotificationTypes
                                                        .createdActivityInsideGroup)
                                                ? list[index]
                                                    .friendName //Here Friend name is for activity name
                                                    .toString()
                                                : list[index]
                                                    .relatedName
                                                    .toString()),
                                        style: AppStyles.interSemiBoldStyle(
                                          fontSize: 16,
                                        ),
                                        // recognizer: TapGestureRecognizer()
                                        //   ..onTap = () {}
                                      )
                                    ])),
                              ),
                            ],
                          ),
                        ),
                        (list[index].notificationType.toString() ==
                                    NotificationTypes
                                        .sentJoinActivityInvitation ||
                                list[index].notificationType.toString() ==
                                    NotificationTypes
                                        .sentRequestToJoinActivity ||
                                list[index].notificationType.toString() ==
                                    NotificationTypes.sentJoinGroupInvitaion ||
                                list[index].notificationType.toString() ==
                                    NotificationTypes.sentJoinGroupRequest)
                            ? sizedBoxH(height: 12.h)
                            : sizedBoxH(height: 0.h),
                        (list[index].notificationType.toString() ==
                                    NotificationTypes
                                        .sentJoinActivityInvitation ||
                                list[index].notificationType.toString() ==
                                    NotificationTypes
                                        .sentRequestToJoinActivity ||
                                list[index].notificationType.toString() ==
                                    NotificationTypes.sentJoinGroupInvitaion ||
                                list[index].notificationType.toString() ==
                                    NotificationTypes.sentJoinGroupRequest)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (list[index]
                                              .notificationType
                                              .toString() ==
                                          NotificationTypes
                                              .sentJoinGroupInvitaion) {
                                        c.acceptOrRejetInvite({
                                          "groupId":
                                              list[index].relatedId.toString(),
                                          "userId": c.userId.toString(),
                                          "isAccept": "1"
                                        });
                                      } else if (list[index]
                                              .notificationType
                                              .toString() ==
                                          NotificationTypes
                                              .sentJoinGroupRequest) {
                                        c.acceptRequestToJoinGroup({
                                          "role": GroupRoles.superAdmin,
                                          "adminId": c.userId.toString(),
                                          "userId":
                                              list[index].friendId!.toString(),
                                          "groupId":
                                              list[index].relatedId.toString(),
                                          "isAccept": "1"
                                        },
                                            groupId: list[index]
                                                .relatedId
                                                .toString(),
                                            uid: list[index]
                                                .friendId!
                                                .toString(),
                                            name: list[index]
                                                .friendName
                                                .toString());
                                      } else if (list[index]
                                              .notificationType
                                              .toString() ==
                                          NotificationTypes
                                              .sentRequestToJoinActivity) {
                                        c.acceptRequestToJoin({
                                          "hostId": c.userId.toString(),
                                          "userId":
                                              list[index].friendId.toString(),
                                          "activityId":
                                              list[index].relatedId.toString(),
                                          "isAccept": "1"
                                        });
                                      } else {
                                        c.acceptActivityInvite(
                                            index: index,
                                            activityId: list[index]
                                                .relatedId
                                                .toString(),
                                            type: type,
                                            data: {
                                              "userId": c.userId.toString(),
                                              "activityId": list[index]
                                                  .relatedId
                                                  .toString()
                                            });
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(100.r),
                                    child: Container(
                                        height: 34.h,
                                        width: 84.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100.r),
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
                                          AppStrings.accept,
                                          style: AppStyles.interMediumStyle(
                                              color: AppColors.white,
                                              fontSize: 14.4),
                                        ))),
                                  ),
                                  sizedBoxW(width: 12.w),
                                  InkWell(
                                    onTap: () {
                                      if (list[index]
                                              .notificationType
                                              .toString() ==
                                          NotificationTypes
                                              .sentJoinGroupInvitaion) {
                                        c.acceptOrRejetInvite({
                                          "groupId":
                                              list[index].relatedId.toString(),
                                          "userId": c.userId.toString(),
                                          "isAccept": "0"
                                        });
                                      } else if (list[index]
                                              .notificationType
                                              .toString() ==
                                          NotificationTypes
                                              .sentJoinGroupRequest) {
                                        c.acceptRequestToJoinGroup({
                                          "role": GroupRoles.superAdmin,
                                          "adminId": c.userId.toString(),
                                          "userId":
                                              list[index].friendId!.toString(),
                                          "groupId":
                                              list[index].relatedId.toString(),
                                          "isAccept": "0"
                                        },
                                            groupId: list[index]
                                                .relatedId
                                                .toString(),
                                            uid: list[index]
                                                .friendId!
                                                .toString(),
                                            name: list[index]
                                                .friendName
                                                .toString());
                                      } else if (list[index]
                                              .notificationType
                                              .toString() ==
                                          NotificationTypes
                                              .sentRequestToJoinActivity) {
                                        c.acceptRequestToJoin({
                                          "hostId": c.userId.toString(),
                                          "userId":
                                              list[index].friendId.toString(),
                                          "activityId":
                                              list[index].relatedId.toString(),
                                          "isAccept": "0"
                                        });
                                      } else {
                                        c.rejectActivityInvite(
                                            index: index,
                                            activityId: list[index]
                                                .relatedId
                                                .toString(),
                                            type: type,
                                            data: {
                                              "userId": c.userId.toString(),
                                              "activityId": list[index]
                                                  .relatedId
                                                  .toString(),
                                            });
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(100.r),
                                    child: Container(
                                        height: 34.h,
                                        width: 84.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100.r),
                                          border: Border.all(
                                              color: AppColors.orangePrimary),
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
                            : Container()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isPromotted(List<Datum> list, int index) {
    return (list[index].notificationType == NotificationTypes.promottedToHost ||
        list[index].notificationType == NotificationTypes.pramottedToSubHost ||
        list[index].notificationType == NotificationTypes.pramotedToAdmin ||
        list[index].notificationType == NotificationTypes.pramotedToSupAdmin);
  }

  void redirect(String type, String id) {
    debugPrint("ID IN REDIRECT $id");
    if (isActivityNotification(type)) {
      Get.delete<ActivityDetailsScreenVM>();
      getToNamed(activityDetailsScreenRoute,
          argument: {"id": id.toString(), "isFromExplore": false});
    } else if (isGroupNotification(type)) {
      Get.delete<GroupDetailsScreenVM>();
      getToNamed(groupDetailsScreenRoute, argument: {"groupId": id.toString()});
    } else if (isPostNotification(type)) {
      Get.delete<SinglePostScreenVM>();
      NotiPost.setId = id.toString();
      getToNamed(singlePostScreenRoute, argument: null);
    } else {
      SearchUser.setId = id.toString();
      //list[index].user!.userInfo!.userId!.toString();
      getToNamed(friendUserProfileScreeRoute);
    }
  }

  void onNotificationCardClick() {}

  void onPrimaryNameClicked(type, primaryId, {toGroup = false}) {
    if (isGroupNotification(type) && toGroup) {
      Get.delete<GroupDetailsScreenVM>();
      getToNamed(groupDetailsScreenRoute,
          argument: {"groupId": primaryId.toString()});
    } else {
      SearchUser.setId = primaryId.toString();
      getToNamed(friendUserProfileScreeRoute);
    }
  }

  void onSecondaryNameClicked() {}

  bool isActivityNotification(type) {
    return (type == NotificationTypes.joinActivity ||
        type == NotificationTypes.acceptActivityJoinRequest ||
        type == NotificationTypes.acceptJoinActivityInvitation ||
        type == NotificationTypes.approvedJoinedActivityReq ||
        type == NotificationTypes.commentActivity ||
        type == NotificationTypes.sentJoinActivityInvitation ||
        type == NotificationTypes.sentRequestToJoinActivity ||
        type == NotificationTypes.pramottedToSubHost ||
        type == NotificationTypes.promottedToHost);
  }

  bool isGroupNotification(String type) {
    return (type == NotificationTypes.sentJoinGroupInvitaion ||
        type == NotificationTypes.acceptJoinGroupInvitation ||
        type == NotificationTypes.createdActivityInsideGroup ||
        type == NotificationTypes.joinGroup ||
        type == NotificationTypes.acceptGroupJoinRequest ||
        type == NotificationTypes.sentJoinGroupRequest ||
        type == NotificationTypes.acceptGroupJoinRequest ||
        type == NotificationTypes.pramotedToAdmin ||
        type == NotificationTypes.pramotedToSupAdmin);
  }

  bool isPostNotification(String type) {
    return (type == NotificationTypes.likePost ||
        type == NotificationTypes.jioMePost ||
        type == NotificationTypes.commentPost);
  }
}
