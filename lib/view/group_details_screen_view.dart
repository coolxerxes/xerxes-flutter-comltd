import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jyo_app/utils/app_widgets/share_modals.dart';
import 'package:jyo_app/view/activity_details_screen_view.dart';
import 'package:jyo_app/view/profile_screen_view.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/activity_details_screen_vm.dart';
import 'package:jyo_app/view_model/create_activity_screen_vm.dart';
import 'package:jyo_app/view_model/create_group_screen_vm.dart';
import 'package:jyo_app/view_model/group_details_screen_vm.dart';

import '../data/local/group_edit_model.dart';
import '../data/local/user_search_model.dart';
import '../data/remote/api_interface.dart';
import '../resources/app_colors.dart';
import '../resources/app_image.dart';
import '../resources/app_routes.dart';
import '../resources/app_strings.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_bar.dart';
import '../utils/app_widgets/app_gradient_btn.dart';
import '../utils/app_widgets/app_icon_button.dart';
import '../utils/common.dart';
import '../view_model/chat_screen_vm.dart';
import '../view_model/freind_user_profile_screen_vm.dart';
import 'create_post_screen_view.dart';

class GroupDetailsScreenView extends StatelessWidget {
  const GroupDetailsScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupDetailsScreenVM>(builder: (c) {
      return WillPopScope(
        onWillPop: () async {
          if (c.isAppStartingFromNotification!) {
            getOffAllNamed(splashScreenRoute);
          } else {
            Get.back();
          }

          return true;
        },
        child: SafeArea(
            child: Scaffold(
                appBar: MyAppBar(
                  color: 0xffffffff,
                  leading: [
                    MyIconButton(
                      onTap: () {
                        if (c.isAppStartingFromNotification!) {
                          getOffAllNamed(splashScreenRoute);
                        } else {
                          Get.back();
                        }

                        // Get.back();
                      },
                      icon: AppBarIcons.arrowBack,
                      isSvg: true,
                      size: 24,
                    )
                  ],
                  actions: c.isLoadingGrp
                      ? []
                      :
                      //c.postsVM.activitiesList.isEmpty
                      //  ? []
                      //:
                      [
                          MyIconButton(
                            onTap: () async {
                              // //getToNamed(createGroupScreenRoute);
                              // showAppDialog(
                              //   msg:
                              //       "Are you sure you want to share this as post.",
                              //   btnText: "Yes",
                              //   btnText2: "No",
                              //   onPressed: () async {
                              //     Get.back();
                              //     // await c.shareActivityAsPost({
                              //     //   "activityId": c.activityId.toString(),
                              //     //   "userId": c.userId.toString(),
                              //     //   "groupId": null
                              //     // });
                              //   },
                              // );

                              await shareModals(
                                context,
                                onCreatePostTap: () async {
                                  final ActivityDetailsScreenVM
                                      activityDetailsScreenVM =
                                      Get.put(ActivityDetailsScreenVM());
                                  Navigator.of(context, rootNavigator: false)
                                      .pop();
                                  await activityDetailsScreenVM
                                      .shareActivityAsPost({
                                    "userId": c.userId.toString(),
                                    "activityId": null,
                                    "groupId": c.groupId.toString(),
                                  });
                                },
                                onShareTap: () async => await c.shareVia(),
                                onCopyLinkTap: () async => await c.copyLink(),
                                onSendToFriend: () async {},
                              );
                            },
                            icon: AppBarIcons.shareHSvg,
                            isSvg: true,
                            size: 34,
                          ),
                          sizedBoxW(width: 12),

                          //?

                          MyIconButton(
                            onTap: () {
                              showCupertinoModalPopup(
                                  context: getContext(),
                                  builder: (BuildContext context) {
                                    List<CupertinoActionSheetAction> actions =
                                        List.empty(growable: true);
                                    if (c.isSupAd) {
                                      actions.add(
                                        CupertinoActionSheetAction(
                                            child: Text(
                                              AppStrings.editGrp,
                                              style:
                                                  AppStyles.interRegularStyle(
                                                      color: AppColors.iosBlue),
                                            ),
                                            onPressed: () async {
                                              Navigator.pop(
                                                  context, AppStrings.editGrp);
                                              GroupEdit.setGroup = c.group;
                                              Get.delete<CreateGroupScreenVM>();
                                              getToNamed(
                                                  createGroupScreenRoute);
                                            }),
                                      );
                                      actions.add(
                                        CupertinoActionSheetAction(
                                            child: Text(
                                              AppStrings.leaveGrpAndAppntAdmin,
                                              style:
                                                  AppStyles.interRegularStyle(
                                                      color: Colors.red),
                                            ),
                                            onPressed: () async {
                                              Navigator.pop(
                                                  context,
                                                  AppStrings
                                                      .leaveGrpAndAppntAdmin);
                                              showAppDialog(
                                                msg:
                                                    "Are you sure you want to leave this group",
                                                btnText: "yes",
                                                onPressed: () async {
                                                  Get.back();
                                                  showAssignmentSheet();
                                                  // await c.postsVM.leaveActivity({
                                                  //   "userId":
                                                  //       c.postsVM.userId.toString(),
                                                  //   "activityId":
                                                  //       c.activityId.toString()
                                                  // });
                                                  // c.init(withoutArg: true);
                                                },
                                                btnText2: "No",
                                              );
                                            }),
                                      );
                                    } else {
                                      actions.add(
                                        CupertinoActionSheetAction(
                                            child: Text(
                                              AppStrings.leaveGroup,
                                              style:
                                                  AppStyles.interRegularStyle(
                                                      color: Colors.red),
                                            ),
                                            onPressed: () async {
                                              Navigator.pop(context,
                                                  AppStrings.leaveGroup);
                                              showAppDialog(
                                                msg:
                                                    "Are you sure you want to leave this group",
                                                btnText: "yes",
                                                onPressed: () async {
                                                  Get.back();
                                                  await c.leaveGroup({
                                                    "userId":
                                                        c.userId.toString(),
                                                    "groupId":
                                                        c.groupId.toString()
                                                  });
                                                  c.init(withoutArg: true);
                                                },
                                                btnText2: "No",
                                              );
                                            }),
                                      );
                                    }
                                    return CupertinoActionSheet(
                                        // title: const Text('Choose Options'),
                                        // message: const Text('Your options are '),
                                        actions: actions,
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
                                        ));
                                  });
                            },
                            icon: AppBarIcons.moreHSvg,
                            isSvg: true,
                            size: 34,
                          )

                          //: Container()
                        ],
                ),
                body: c.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.orangePrimary,
                        ),
                      )
                    : ListView(
                        children: [
                          !c.isInvited
                              ? Container()
                              : Container(
                                  color: AppColors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 22.w, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          "You have been invited to join this group\nDo you want to join.",
                                          style: AppStyles.interMediumStyle()),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                  onTap: () async {
                                                    await c
                                                        .acceptOrRejetInvite({
                                                      "groupId":
                                                          c.groupId.toString(),
                                                      "userId":
                                                          c.userId.toString(),
                                                      "isAccept": "0"
                                                    });
                                                    c.init(withoutArg: true);
                                                  },
                                                  child: SvgPicture.asset(
                                                      AppIcons.ignoreActSvg)),
                                              sizedBoxW(width: 8),
                                              InkWell(
                                                  onTap: () async {
                                                    await c
                                                        .acceptOrRejetInvite({
                                                      "groupId":
                                                          c.groupId.toString(),
                                                      "userId":
                                                          c.userId.toString(),
                                                      "isAccept": "1"
                                                    });
                                                    c.init(withoutArg: true);
                                                  },
                                                  child: SvgPicture.asset(
                                                      AppIcons.acceptActSvg)),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                          sizedBoxH(height: !c.isInvited ? 0 : 8),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 22.w, vertical: 16.h),
                            child: Column(
                              children: [
                                isValidString(c.group!.groupImage)
                                    ? MyAvatar(
                                        url: ApiInterface.profileImgUrl +
                                            c.group!.groupImage.toString(),
                                        height: 80,
                                        width: 80,
                                        isNetwork: true,
                                        radiusAll: 32,
                                      )
                                    : MyAvatar(
                                        url: AppImage.groupImage,
                                        height: 80,
                                        width: 80,
                                        radiusAll: 32,
                                      ),
                                sizedBoxH(height: 12),
                                (c.isSupAd || c.isAdmin)
                                    ? InkWell(
                                        borderRadius:
                                            BorderRadius.circular(100.r),
                                        onTap: () {
                                          Get.delete<CreateActivityScreenVM>();
                                          getToNamed(createActivityScreenRoute,
                                              argument: {
                                                "groupId": c.groupId.toString(),
                                                "groupImage": c
                                                    .group!.groupImage
                                                    .toString(),
                                                "groupName": c.group!.groupName
                                                    .toString()
                                              });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15.w, vertical: 10.h),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100.r),
                                              border: Border.all(
                                                  color: AppColors
                                                      .editBorderColor)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SvgPicture.asset(
                                                AppIcons.calIcon,
                                                width: 22.w,
                                                height: 22.h,
                                              ),
                                              sizedBoxW(width: 6),
                                              Text(
                                                AppStrings.startAnActivity,
                                                style:
                                                    AppStyles.interMediumStyle(
                                                        fontSize: 14.4,
                                                        color: AppColors
                                                            .editBorderColor),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                                (c.isSupAd || c.isAdmin)
                                    ? sizedBoxH(height: 12)
                                    : Container(),
                                Text(
                                  c.group!.groupName.toString(),
                                  style: AppStyles.interSemiBoldStyle(
                                      fontSize: 18, color: AppColors.textColor),
                                ),
                                sizedBoxH(height: 12),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(AppImage.peoplePng,
                                        width: 18.w,
                                        height: 18.h,
                                        color: AppColors.textColor),
                                    sizedBoxW(width: 4),
                                    Text(
                                      c.group!.memberCount.toString(),
                                      style: AppStyles.interMediumStyle(
                                          fontSize: 17.2),
                                    ),
                                    sizedBoxW(width: 4),
                                    Text(
                                      "Members",
                                      style: AppStyles.interRegularStyle(
                                          fontSize: 15,
                                          color: AppColors.hintTextColor),
                                    ),
                                    sizedBoxW(width: 24),
                                    SvgPicture.asset(AppIcons.actCal,
                                        width: 18.w,
                                        height: 18.h,
                                        color: AppColors.textColor),
                                    sizedBoxW(width: 4),
                                    Text(
                                      c.group!.activityCount.toString(),
                                      style: AppStyles.interMediumStyle(
                                          fontSize: 17.2),
                                    ),
                                    sizedBoxW(width: 4),
                                    Text(
                                      "Activities",
                                      style: AppStyles.interRegularStyle(
                                          fontSize: 15,
                                          color: AppColors.hintTextColor),
                                    ),
                                  ],
                                ),
                                c.group!.isMember!
                                    ? sizedBoxH(height: 12)
                                    : Container(),
                                c.group!.isMember!
                                    ? c.cometGroup == null
                                        ? Container()
                                        : Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.r),
                                                gradient: const LinearGradient(
                                                    colors: [
                                                      Color(0xffFFD036),
                                                      Color(0xffFFA43C)
                                                    ],
                                                    transform: GradientRotation(
                                                        240) //120
                                                    )),
                                            child: Material(
                                              type: MaterialType.transparency,
                                              borderRadius:
                                                  BorderRadius.circular(100.r),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.r),
                                                onTap: () {
                                                  Get.delete<ChatScreenVM>(
                                                      force: true);
                                                  final cvm =
                                                      Get.put(ChatScreenVM());
                                                  cvm.group = c.cometGroup;
                                                  getToNamed(chatScreenRoute);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15.w,
                                                      vertical: 10.h),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100.r),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SvgPicture.asset(
                                                        AppIcons.grpMsg,
                                                        width: 22.w,
                                                        height: 22.h,
                                                      ),
                                                      sizedBoxW(width: 6),
                                                      Text(
                                                        AppStrings.groupChat,
                                                        style: AppStyles
                                                            .interMediumStyle(
                                                                fontSize: 14.4,
                                                                color: AppColors
                                                                    .white),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                    : Container(),
                              ],
                            ),
                          ),
                          sizedBoxH(height: 8),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 22.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "About",
                                  style: AppStyles.interSemiBoldStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      (c.group!.about.toString().trim().length >
                                                  100 &&
                                              !c.isReadingMore)
                                          ? c.group!.about
                                                  .toString()
                                                  .trim()
                                                  .substring(0, 100) +
                                              "..."
                                          : c.group!.about.toString().trim(),
                                      style: AppStyles.interRegularStyle(
                                          fontSize: 17.2,
                                          color: AppColors.textColor),
                                    ))
                                  ],
                                ),
                                c.group!.about.toString().trim().length > 100
                                    ? InkWell(
                                        onTap: () {
                                          c.isReadingMore = !c.isReadingMore;
                                          c.update();
                                        },
                                        child: Text(
                                          c.isReadingMore
                                              ? "Hide"
                                              : "Read more",
                                          style: AppStyles.interMediumStyle(
                                              fontSize: 15,
                                              color: AppColors.hintTextColor),
                                        ),
                                      )
                                    : Container(),
                                sizedBoxH(height: 8),
                                SizedBox(
                                  height: 46.h,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: c.group!.category!.length,
                                      itemBuilder: (context, index) {
                                        return ActivityDetailsScreeView
                                            .mostLikedCard(
                                                category:
                                                    c.group!.category![index]);
                                      }),
                                ),
                                sizedBoxH(height: 24),
                                MyTabBar(
                                  children:
                                      List.generate(c.tabs.length, (index) {
                                    return TabChild(
                                      tabData: c.tabs[index],
                                      selectedIndex: c.selectedTab!.index,
                                      showBadge: c.tabs[index].showBadge,
                                      onTabSelected: () {
                                        c.selectedTab = c.tabs[index];
                                        c.update();
                                      },
                                    );
                                  }),
                                )
                              ],
                            ),
                          ),
                          c.selectedTab!.index == GroupTabs.activities
                              ? c.postsVM.activitiesList.isEmpty
                                  ? SizedBox(
                                      width: double.infinity,
                                      height: 250.h,
                                      child: Center(
                                          child: Text(
                                        "No activities available.",
                                        style: AppStyles.interRegularStyle(
                                            fontSize: 15),
                                      )),
                                    )
                                  : Container(
                                      color: AppColors.white,
                                      child: Column(
                                        children: List.generate(
                                            c.postsVM.activitiesList.length,
                                            (index) {
                                          return ActivityWidget.activity(
                                            c.postsVM.activitiesList[index],
                                            c.postsVM,
                                            c,
                                            isProfile: false,
                                            margin: EdgeInsets.zero,
                                          );
                                        }),
                                      ),
                                    )
                              : c.selectedTab!.index == GroupTabs.members
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(32.r),
                                              topRight: Radius.circular(32.r))),
                                      child: Column(
                                        //shrinkWrap: true,
                                        //controller: b,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 22.w,
                                                vertical: 16.h),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                c.isSupAd
                                                    ? InkWell(
                                                        onTap: () {
                                                          showInviteSheet();
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      22.w,
                                                                  vertical:
                                                                      16.h),
                                                          color:
                                                              AppColors.white,
                                                          child: Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                AppImage.invite,
                                                                width: 40.w,
                                                                height: 40.h,
                                                              ),
                                                              sizedBoxW(
                                                                  width: 12),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Add participants",
                                                                      style: AppStyles
                                                                          .interSemiBoldStyle(
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      AppStrings
                                                                          .inviteYFinfo,
                                                                      style: AppStyles.interRegularStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              AppColors.hintTextColor),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () {},
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .keyboard_arrow_right,
                                                                  size: 24,
                                                                  color: AppColors
                                                                      .textColor,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                c.isSupAd
                                                    ? sizedBoxH(height: 8)
                                                    : Container(),
                                                SearchTextField(
                                                    controller: c.searchCtrl,
                                                    onChanged: (t) {
                                                      if (t.trim().isEmpty) {
                                                        c.searchedMembers!
                                                            .clear();
                                                        c.searchedMembers!
                                                            .addAll(
                                                                c.membersList);
                                                      } else {
                                                        c.search(t);
                                                      }
                                                      c.update();
                                                    },
                                                    radius: 30)
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 22.w,
                                                vertical: 22.h),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                c.searchedMembers!.isEmpty
                                                    ? Center(
                                                        child: Text(
                                                        "No participants available",
                                                        style: AppStyles
                                                            .interRegularStyle(),
                                                      ))
                                                    : GridView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 3,
                                                          crossAxisSpacing:
                                                              12.h,
                                                          mainAxisSpacing: 16.w,
                                                          mainAxisExtent: 105.h,
                                                        ),
                                                        itemCount: c
                                                            .searchedMembers!
                                                            .length, //25, //c.list.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return userCard(
                                                              c, index);
                                                        })
                                              ],
                                            ),
                                          ),
                                        ],
                                      ))
                                  : c.selectedTab!.index == GroupTabs.requests
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 22.w),
                                          color: AppColors.white,
                                          child: RequestSection(
                                            children: c.requestList.isEmpty
                                                ? [
                                                    SizedBox(
                                                      width: double.infinity,
                                                      height: 250.h,
                                                      child: Center(
                                                          child: Text(
                                                        "No requests found.",
                                                        style: AppStyles
                                                            .interRegularStyle(
                                                                fontSize: 15),
                                                      )),
                                                    )
                                                  ]
                                                : List.generate(
                                                    c.requestList.length,
                                                    (index) {
                                                    return RequestsUI(
                                                      requestData:
                                                          c.requestList[index],
                                                      onAccept: () async {
                                                        c.acceptRequestToJoin({
                                                          "role":
                                                              c.role.toString(),
                                                          "adminId": c.userId
                                                              .toString(),
                                                          "userId": c
                                                              .requestList[
                                                                  index]
                                                              .user!
                                                              .id
                                                              .toString(),
                                                          "groupId": c.groupId
                                                              .toString(),
                                                          "isAccept": "1"
                                                        },
                                                            user: c
                                                                .requestList[
                                                                    index]
                                                                .user);
                                                        c.init(
                                                            withoutArg: true);
                                                      },
                                                      onReject: () {
                                                        c.acceptRequestToJoin({
                                                          "role":
                                                              c.role.toString(),
                                                          "adminId": c.userId
                                                              .toString(),
                                                          "userId": c
                                                              .requestList[
                                                                  index]
                                                              .user!
                                                              .id
                                                              .toString(),
                                                          "groupId": c.groupId
                                                              .toString(),
                                                          "isAccept": "0"
                                                        });
                                                        c.init(
                                                            withoutArg: true);
                                                      },
                                                    );
                                                  }),
                                          ),
                                        )
                                      : Container()
                        ],
                      ))),
      );
    });
  }

  static showInviteSheet() {
    showFlexibleBottomSheet(
      initHeight: 0.84,
      //isExpand: true,
      minHeight: 0.83,
      maxHeight: 0.85,
      //isCollapsible: true,
      bottomSheetColor: Colors.transparent,
      context: getContext(),
      builder: (a, b, c) {
        return showUsers(b);
      },
      anchors: [0.83, 0.84, 0.85],
      isSafeArea: true,
    );
  }

  static Widget showUsers(ScrollController b) {
    return GetBuilder<GroupDetailsScreenVM>(
      builder: (c) {
        return ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
          child: Scaffold(
            body: Container(
                // padding: EdgeInsets.only(
                // bottom: MediaQuery.of(getContext()).viewInsets.bottom,),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.r),
                        topRight: Radius.circular(32.r))),
                child: ListView(
                  controller: b,
                  children: [
                    sizedBoxH(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 54.w,
                          height: 4.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.r),
                              color: AppColors.disabledColor),
                        )
                      ],
                    ),
                    sizedBoxH(
                      height: 10,
                    ),
                    MyAppBar(
                      leading: [
                        MyIconButton(
                          onTap: () {
                            Get.back();
                          },
                          icon: AppBarIcons.closeIcon,
                          isSvg: true,
                        )
                      ],
                      middle: [
                        Text(AppStrings.inviteFriend,
                            style: AppStyles.interSemiBoldStyle(
                                fontSize: 16.0, color: AppColors.textColor))
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 22.w, vertical: 16.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchTextField(
                            controller: c.fsearchCtrl,
                            onChanged: (t) {
                              if (t.trim().isEmpty) {
                                c.friends!.clear();
                                c.friends!.addAll(c.searchedFriends!);
                              } else {
                                c.searchInvities(t);
                              }
                              c.update();
                            },
                            radius: 30,
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              height: 8.h,
                              decoration: const BoxDecoration(
                                  //borderRadius: BorderRadius.circular(100),
                                  color: AppColors.texfieldColor),
                            ))
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 22.w, vertical: 22.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          c.friends!.isEmpty
                              ? Center(
                                  child: Text(
                                  "No freinds available",
                                  style: AppStyles.interRegularStyle(),
                                ))
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 12.h,
                                    mainAxisSpacing: 16.w,
                                    mainAxisExtent: 105.h,
                                  ),
                                  itemCount:
                                      c.friends!.length, //25, //c.list.length,
                                  itemBuilder: (context, index) {
                                    return usserCard(c, index);
                                  })
                        ],
                      ),
                    ),
                    sizedBoxH(
                      height: 10,
                    ),
                    c.friends!.isEmpty
                        ? Container()
                        : AppGradientButton(
                            btnText: AppStrings.done,
                            onPressed: () {
                              c.inviteFriends();
                            },
                            height: 56,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                horizontal: 22.w, vertical: 16.h),
                          )
                  ],
                )),
          ),
        );
      },
    );
  }

  static Widget usserCard(GroupDetailsScreenVM c, index) {
    return GetBuilder<GroupDetailsScreenVM>(builder: (c) {
      return InkWell(
        onTap: () {
          debugPrint("Is Hidden ${c.friends![index].getIsHidden!}");
          if (!c.friends![index].getIsHidden!) {
            c.friends![index].setIsHidden = true;
          } else {
            c.friends![index].setIsHidden = false;
          }
          c.update();
        },
        child: Container(
          color: AppColors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    height: 76.h,
                    width: 72.w,
                  ),
                  Positioned(
                    child: c.friends![index].user!.profilePic!.trim().isNotEmpty
                        ? MyAvatar(
                            url: ApiInterface.profileImgUrl +
                                c.friends![index].user!.profilePic!.toString(),
                            height: 72,
                            width: 72,
                            radiusAll: 28.8,
                            isNetwork: true,
                          )
                        : MyAvatar(
                            url: AppImage.sampleAvatar,
                            height: 72,
                            width: 72,
                            radiusAll: 28.8,
                          ),
                  ),
                  Positioned(
                    top: 58.h,
                    left: 27.w,
                    child: Container(
                      width: 22.w,
                      height: 22.h,
                      decoration: BoxDecoration(
                        color: c.friends![index].getIsHidden!
                            ? AppColors.orangePrimary
                            : AppColors.btnStrokeColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.asset(
                          c.friends![index].getIsHidden!
                              ? AppIcons.checkedIcon
                              : AppIcons.uncheckedIcon,
                          fit: BoxFit.fill,
                          width: 22.w,
                          height: 22.h,
                        ),
                      ),
                    ),
                  )
                ],
              )),
              sizedBoxH(
                height: 7,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      c.friends![index].user!.firstName.toString() +
                          " " +
                          c.friends![index].user!.lastName.toString(),
                      style: AppStyles.interMediumStyle(fontSize: 15.4),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  Widget userCard(GroupDetailsScreenVM c, index) {
    return InkWell(
      onTap: () {
        showCupertinoModalPopup(
            context: getContext(),
            builder: (BuildContext context) {
              List<CupertinoActionSheetAction> actions =
                  List.empty(growable: true);
              actions.add(CupertinoActionSheetAction(
                child: Text(
                  AppStrings.viewProfile,
                  style: AppStyles.interRegularStyle(color: AppColors.iosBlue),
                ),
                onPressed: () async {
                  Navigator.pop(context, AppStrings.viewProfile);
                  SearchUser.setId =
                      c.searchedMembers![index].user!.id.toString();
                  //Get.back();
                  Get.delete<FriendUserProfileScreenVM>(force: true);
                  getToNamed(friendUserProfileScreeRoute);
                  // await c.postsVM.deleteActivity(
                  //     c.activityId.toString().toString(),
                  //     c);
                },
              ));

              if (c.isSupAd &&
                  c.searchedMembers![index].role == GroupRoles.member) {
                actions.add(CupertinoActionSheetAction(
                  child: Text(
                    AppStrings.setAsAdmin,
                    style:
                        AppStyles.interRegularStyle(color: AppColors.iosBlue),
                  ),
                  onPressed: () async {
                    Navigator.pop(context, AppStrings.setAsAdmin);
                    c.memberToAdmin({
                      "superAdminId": c.userId.toString(),
                      "toBeAdmin":
                          c.searchedMembers![index].user!.id.toString(),
                      "groupId": c.groupId.toString()
                    });
                  },
                ));
              }

              if (c.isSupAd &&
                  c.searchedMembers![index].role == GroupRoles.admin) {
                actions.add(CupertinoActionSheetAction(
                    child: Text(
                      "Set as Super Admin and demote yourself to Admin",
                      style:
                          AppStyles.interRegularStyle(color: AppColors.iosBlue),
                    ),
                    onPressed: () async {
                      Navigator.pop(context, AppStrings.setAsSubHost);
                      c.setSuperAdminDemoteToAdmin({
                        "superAdminId": c.userId.toString(),
                        "toBeSuperAdmin":
                            c.searchedMembers![index].user!.id.toString(),
                        "groupId": c.groupId.toString(),
                        //"demoteToNormalParticipant": "0"
                      });
                    }));
              }

              if (c.isSupAd &&
                  c.searchedMembers![index].role == GroupRoles.admin) {
                actions.add(CupertinoActionSheetAction(
                  child: Text(
                    "Demote to normal member",
                    style: AppStyles.interRegularStyle(color: Colors.red),
                  ),
                  onPressed: () async {
                    Navigator.pop(context, AppStrings.setAsSubHost);
                    c.demoteAdminToMember({
                      "superAdminId": c.userId.toString(),
                      "toBeMember":
                          c.searchedMembers![index].user!.id.toString(),
                      "groupId": c.groupId.toString()
                    });
                  },
                ));
              }

              //Host View for SubHost.
              // if (c.isAdmin!) {
              //   actions.add(CupertinoActionSheetAction(
              //     child: Text(
              //       AppStrings.deleteAcc,
              //       style: AppStyles.interRegularStyle(color: Colors.red),
              //     ),
              //     onPressed: () async {
              //       Navigator.pop(context, AppStrings.deleteAcc);
              //       showAppDialog(
              //           msg: "Are you want to delete this activity?",
              //           btnText: "Yes",
              //           btnText2: "No",
              //           onPressed: () async {
              //             Get.back();
              //             await c.postsVM.deleteActivity(
              //                 c.activityId.toString().toString(), c);
              //             Get.back();
              //           });
              //     },
              //   ));
              // }

              if ((c.isSupAd &&
                      c.searchedMembers![index].role !=
                          GroupRoles.superAdmin) ||
                  (c.isAdmin &&
                      c.searchedMembers![index].role != GroupRoles.superAdmin &&
                      c.searchedMembers![index].role != GroupRoles.admin)) {
                actions.add(
                  CupertinoActionSheetAction(
                      child: Text(
                        AppStrings.removeMember,
                        style: AppStyles.interRegularStyle(color: Colors.red),
                      ),
                      onPressed: () async {
                        Navigator.pop(context, AppStrings.removeParticipants);
                        c.removeMember({
                          "admminId": c.userId.toString(),
                          "memberId":
                              c.searchedMembers![index].user!.id.toString(),
                          "groupId": c.groupId.toString()
                        });
                        //c.init();

                        //Edit activity,
                      }),
                );
              }

              return CupertinoActionSheet(
                  // title: const Text('Choose Options'),
                  // message: const Text('Your options are '),
                  actions: actions,
                  cancelButton: CupertinoActionSheetAction(
                    child: Text(
                      AppStrings.cancel,
                      style:
                          AppStyles.interRegularStyle(color: AppColors.iosBlue),
                    ),
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context, AppStrings.cancel);
                    },
                  ));
            });

        // showCupertinoModalPopup(
        //     context: getContext(),
        //     builder: (BuildContext context) {
        //       List<CupertinoActionSheetAction> actions =
        //           List.empty(growable: true);
        //       actions.add(CupertinoActionSheetAction(
        //         child: Text(
        //           AppStrings.viewProfile,
        //           style: AppStyles.interRegularStyle(color: AppColors.iosBlue),
        //         ),
        //         onPressed: () async {
        //           Navigator.pop(context, AppStrings.viewProfile);
        //           SearchUser.setId =
        //               c.searchedMembers![index].user!.id.toString();
        //           //Get.back();
        //           Get.delete<FriendUserProfileScreenVM>(force: true);
        //           getToNamed(friendUserProfileScreeRoute);
        //           // await c.postsVM.deleteActivity(
        //           //     c.activityId.toString().toString(),
        //           //     c);
        //         },
        //       ));

        //       if (c.isAdmin &&
        //           !isAdmin(c, c.searchedMembers![index].user!.id.toString())) {
        //         actions.add(CupertinoActionSheetAction(
        //           child: Text(
        //             AppStrings.setAsAdmin,
        //             style:
        //                 AppStyles.interRegularStyle(color: AppColors.iosBlue),
        //           ),
        //           onPressed: () async {
        //             Navigator.pop(context, AppStrings.setAsSubHost);
        //           },
        //         ));
        //       }

        //       //Host View for SubHost.
        //       // if (c.isAdmin!) {
        //       //   actions.add(CupertinoActionSheetAction(
        //       //     child: Text(
        //       //       AppStrings.deleteAcc,
        //       //       style: AppStyles.interRegularStyle(color: Colors.red),
        //       //     ),
        //       //     onPressed: () async {
        //       //       Navigator.pop(context, AppStrings.deleteAcc);
        //       //       showAppDialog(
        //       //           msg: "Are you want to delete this activity?",
        //       //           btnText: "Yes",
        //       //           btnText2: "No",
        //       //           onPressed: () async {
        //       //             Get.back();
        //       //             await c.postsVM.deleteActivity(
        //       //                 c.activityId.toString().toString(), c);
        //       //             Get.back();
        //       //           });
        //       //     },
        //       //   ));
        //       // }

        //       if (c.isAdmin) {
        //         actions.add(
        //           CupertinoActionSheetAction(
        //               child: Text(
        //                 AppStrings.removeParticipants,
        //                 style: AppStyles.interRegularStyle(color: Colors.red),
        //               ),
        //               onPressed: () async {
        //                 Navigator.pop(context, AppStrings.removeParticipants);

        //                 //c.init();

        //                 //Edit activity,
        //               }),
        //         );
        //       }

        //       return CupertinoActionSheet(
        //           // title: const Text('Choose Options'),
        //           // message: const Text('Your options are '),
        //           actions: actions,
        //           cancelButton: CupertinoActionSheetAction(
        //             child: Text(
        //               AppStrings.cancel,
        //               style:
        //                   AppStyles.interRegularStyle(color: AppColors.iosBlue),
        //             ),
        //             isDefaultAction: true,
        //             onPressed: () {
        //               Navigator.pop(context, AppStrings.cancel);
        //             },
        //           ));
        //     });

        //c.baseScreenVM.changePage(5);
        //c.baseScreenVM.update();
      },
      child: Container(
        color: AppColors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 76.h,
                  width: 72.w,
                ),
                Positioned(
                  child:
                      (c.searchedMembers![index].user!.userInfo!.profilePic !=
                                  null &&
                              c.searchedMembers![index].user!.userInfo!
                                  .profilePic!.isNotEmpty)
                          ? MyAvatar(
                              url: ApiInterface.profileImgUrl +
                                  c.searchedMembers![index].user!.userInfo!
                                      .profilePic!
                                      .toString(),
                              height: 72,
                              width: 72,
                              radiusAll: 28.8,
                              isNetwork: true,
                            )
                          : MyAvatar(
                              url: AppImage.sampleAvatar,
                              height: 72,
                              width: 72,
                              radiusAll: 28.8,
                            ),
                ),
                Positioned(
                  top: 58.h,
                  left: 28.w,
                  child: (c.searchedMembers![index].role.toString() ==
                              GroupRoles.superAdmin ||
                          c.searchedMembers![index].role.toString() ==
                              GroupRoles.admin)
                      ? Container(
                          width: 22.w,
                          height: 22.h,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.r),
                            child: Image.asset(
                              c.searchedMembers![index].role.toString() ==
                                      GroupRoles.superAdmin
                                  ? AppIcons.crownPng
                                  : AppIcons.subCrown,
                              //fit: BoxFit.fill,
                              width: 16.w,
                              height: 12.h,
                            ),
                          ),
                        )
                      : Container(),
                )
              ],
            )),
            sizedBoxH(
              height: 7,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  c.searchedMembers![index].user!.userInfo!.firstName
                          .toString() +
                      " " +
                      c.searchedMembers![index].user!.userInfo!.lastName
                          .toString(),
                  style: AppStyles.interMediumStyle(fontSize: 15.4),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ))
              ],
            )
          ],
        ),
      ),
    );
  }

  isAdmin(GroupDetailsScreenVM c, String userId) {
    if (userId.toString() == c.userId.toString() && c.isAdmin) {
      return true;
    } else {
      return false;
    }
  }

  static showAssignmentSheet() {
    showFlexibleBottomSheet(
      initHeight: 0.84,
      //isExpand: true,
      minHeight: 0.83,
      maxHeight: 0.85,
      //isCollapsible: true,
      bottomSheetColor: Colors.transparent,
      context: getContext(),
      builder: (a, b, c) {
        return showAssignUsers(b);
      },
      anchors: [0.83, 0.84, 0.85],
      isSafeArea: true,
    );
  }

  static Widget showAssignUsers(ScrollController b) {
    return GetBuilder<GroupDetailsScreenVM>(
      builder: (c) {
        return WillPopScope(
          onWillPop: () async {
            c.toSAId = -1;
            c.toSAIndex = -1;
            c.searchCtrl!.clear();
            c.searchedMembers!.clear();
            c.searchedMembers!.addAll(c.membersList);
            c.update();
            return true;
          },
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32.r),
                topRight: Radius.circular(32.r)),
            child: Scaffold(
              body: Container(
                  // padding: EdgeInsets.only(
                  // bottom: MediaQuery.of(getContext()).viewInsets.bottom,),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32.r),
                          topRight: Radius.circular(32.r))),
                  child: ListView(
                    controller: b,
                    children: [
                      sizedBoxH(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 54.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.r),
                                color: AppColors.disabledColor),
                          )
                        ],
                      ),
                      sizedBoxH(
                        height: 10,
                      ),
                      MyAppBar(
                        leading: [
                          MyIconButton(
                            onTap: () {
                              c.toSAId = -1;
                              c.toSAIndex = -1;
                              c.searchCtrl!.clear();
                              c.searchedMembers!.clear();
                              c.searchedMembers!.addAll(c.membersList);
                              c.update();
                              Get.back();
                            },
                            icon: AppBarIcons.closeIcon,
                            isSvg: true,
                          )
                        ],
                        middle: [
                          Text(AppStrings.appointAsSA,
                              style: AppStyles.interSemiBoldStyle(
                                  fontSize: 16.0, color: AppColors.textColor))
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 22.w, vertical: 16.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SearchTextField(
                              controller: c.searchCtrl,
                              onChanged: (t) {
                                if (t.trim().isEmpty) {
                                  c.searchedMembers!.clear();
                                  c.searchedMembers!.addAll(c.membersList);
                                } else {
                                  c.search(t);
                                }
                                c.update();
                              },
                              radius: 30,
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Container(
                                height: 8.h,
                                decoration: const BoxDecoration(
                                    //borderRadius: BorderRadius.circular(100),
                                    color: AppColors.texfieldColor),
                              ))
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 22.w, vertical: 22.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            c.searchedMembers!.isEmpty
                                ? Center(
                                    child: Text(
                                    "No participants available",
                                    style: AppStyles.interRegularStyle(),
                                  ))
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 12.h,
                                      mainAxisSpacing: 16.w,
                                      mainAxisExtent: 105.h,
                                    ),
                                    itemCount: c.searchedMembers!
                                        .length, //25, //c.list.length,
                                    itemBuilder: (context, index) {
                                      return assigneeCard(c, index);
                                    })
                          ],
                        ),
                      ),
                      sizedBoxH(
                        height: 10,
                      ),
                      c.searchedMembers!.isEmpty
                          ? Container()
                          : AppGradientButton(
                              btnText: AppStrings.done,
                              onPressed: () {
                                //c.inviteFriends();
                                if (c.toSAId == -1) {
                                  showAppDialog(
                                      msg:
                                          "Please select someone to assign as Super Admin");
                                  return;
                                }
                                c.leaveAndSetAsHost({
                                  "superAdminId": c.userId.toString(),
                                  "groupId": c.groupId.toString(),
                                  "toBeSuperAdmin": c.toSAId.toString()
                                });
                              },
                              height: 56,
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 22.w, vertical: 16.h),
                            )
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }

  static Widget assigneeCard(GroupDetailsScreenVM c, index) {
    return GetBuilder<GroupDetailsScreenVM>(builder: (c) {
      return InkWell(
        onTap: () {
          c.toSAIndex = index;
          c.toSAId = c.searchedMembers![index].user!.id!;

          // debugPrint("Is Hidden ${c.searchedMembers![index].getIsHidden!}");
          // if (!c.searchedMembers![index].getIsHidden!) {
          //   c.searchedMembers![index].setIsHidden = true;
          // } else {
          //   c.searchedMembers![index].setIsHidden = false;
          // }
          c.update();
        },
        child: Container(
          color: AppColors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                  child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    height: 76.h,
                    width: 72.w,
                  ),
                  Positioned(
                    child: c.searchedMembers![index].user!.userInfo!.profilePic!
                            .trim()
                            .isNotEmpty
                        ? MyAvatar(
                            url: ApiInterface.profileImgUrl +
                                c.searchedMembers![index].user!.userInfo!
                                    .profilePic!
                                    .toString(),
                            height: 72,
                            width: 72,
                            radiusAll: 28.8,
                            isNetwork: true,
                          )
                        : MyAvatar(
                            url: AppImage.sampleAvatar,
                            height: 72,
                            width: 72,
                            radiusAll: 28.8,
                          ),
                  ),
                  Positioned(
                    top: 58.h,
                    left: 27.w,
                    child: Container(
                      width: 22.w,
                      height: 22.h,
                      decoration: BoxDecoration(
                        color: c.toSAIndex ==
                                index //c.searchedMembers![index].getIsHidden!
                            ? AppColors.orangePrimary
                            : AppColors.btnStrokeColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.asset(
                          c.toSAIndex == index
                              //c.searchedMembers![index].getIsHidden!
                              ? AppIcons.checkedIcon
                              : AppIcons.uncheckedIcon,
                          fit: BoxFit.fill,
                          width: 22.w,
                          height: 22.h,
                        ),
                      ),
                    ),
                  )
                ],
              )),
              sizedBoxH(
                height: 7,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      c.searchedMembers![index].user!.userInfo!.firstName
                              .toString() +
                          " " +
                          c.searchedMembers![index].user!.userInfo!.lastName
                              .toString(),
                      style: AppStyles.interMediumStyle(fontSize: 15.4),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
