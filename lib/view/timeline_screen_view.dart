// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jyo_app/data/local/post_edit_model.dart';
import 'package:jyo_app/data/remote/api_interface.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/app_widgets/app_bar.dart';
import 'package:jyo_app/utils/app_widgets/app_icon_button.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view/create_post_screen_view.dart';
import 'package:jyo_app/view/profile_screen_view.dart';
import 'package:jyo_app/view_model/create_post_screen_vm.dart';
import 'package:jyo_app/view_model/freind_user_profile_screen_vm.dart';
import 'package:jyo_app/view_model/posts_and_activities_vm.dart';

import 'package:jyo_app/view_model/timeline_screen_vm.dart';
import 'package:path_provider/path_provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:video_player/video_player.dart';

import '../data/local/attachements.dart';
import '../data/local/tour.dart';
import '../data/local/user_search_model.dart';
import '../data/remote/endpoints.dart';
import '../models/group_suggestion_model/group_list_model.dart';
import '../models/posts_model/post_and_activity_model.dart';
import '../resources/app_fonts.dart';
import '../utils/secured_storage.dart';
import '../view_model/activity_details_screen_vm.dart';
import '../view_model/comments_vm.dart';
import 'explore_screen_view.dart';
import 'package:jyo_app/models/comment_model/get_comment_model.dart' as comm;

class TimelineScreenView extends StatelessWidget {
  const TimelineScreenView({Key? key}) : super(key: key);
  static dynamic ctx;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TimelineScreenVM>(builder: (c) {
      return ShowCaseWidget(
          disableBarrierInteraction: true,
          onComplete: (index, key) async {
            c.step++;
            await SecuredStorage.writeStringValue(
                Keys.overviewStep, c.step.toString());
            String? userId = await SecuredStorage.readStringValue(Keys.userId);
            SecuredStorage.updateTourStep(
                {"userId": userId.toString(), "steps": c.step.toString()});
          },
          onFinish: () {
            //End tour
            Tour.setIsTourRunning = false;
            c.update();
            c.bsvm.update();
          },
          builder: Builder(builder: (context) {
            ctx = context;
            return SafeArea(
              child: Scaffold(
                backgroundColor: AppColors.appBkgColor,
                appBar: MyAppBar(
                  color: 0xffFFFFFF,
                  padding: EdgeInsets.only(right: 22.w, top: 6.h, bottom: 6.h),
                  leading: [
                    SvgPicture.asset(AppBarIcons.jyoTimelineLogoSvg,
                        width: 140.w),
                  ],
                  actions: [
                    Showcase.withWidget(
                        disableMovingAnimation: true,
                        onBarrierClick: () {},
                        key: c.key4,
                        // description: "Find new activities, friends and groups in\none place!",
                        width: MediaQuery.of(context).size.width,
                        height: 100.h,
                        // targetPadding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                        targetShapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r)),
                        targetBorderRadius: BorderRadius.circular(14.r),
                        container: Container(
                          margin: EdgeInsets.only(left: 20.w),
                          child: TourToolTip(
                            tooltipPadding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.13),
                            isArrowDown: false,
                            tourText:
                                "Hey! you also can create your own activity here ✨",
                            width: MediaQuery.of(context).size.width - 45.w,
                            onTap: () {
                              ShowCaseWidget.of(ctx).next();
                            },
                          ),
                        ),
                        child: MyIconButton(
                          onTap: () {},
                          icon: AppBarIcons.timelineCalSvg,
                          isSvg: true,
                        )),
                    sizedBoxW(width: 12),
                    Showcase.withWidget(
                        disableMovingAnimation: true,
                        onBarrierClick: () {},
                        key: c.key3,
                        // description: "Find new activities, friends and groups in\none place!",
                        width: MediaQuery.of(context).size.width,
                        height: 100.h,
                        // targetPadding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                        targetShapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r)),
                        targetBorderRadius: BorderRadius.circular(14.r),
                        container: Container(
                          margin: EdgeInsets.only(left: 20.w),
                          child: TourToolTip(
                            tooltipPadding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.35),
                            isArrowDown: false,
                            tourText: "Check all of your group here.",
                            width: MediaQuery.of(context).size.width - 45.w,
                            onTap: () {
                              ShowCaseWidget.of(ctx).next();
                            },
                          ),
                        ),
                        child: MyIconButton(
                          onTap: () {
                            getToNamed(groupListScreenRoute);
                          },
                          icon: AppBarIcons.timelineCrownSvg,
                          isSvg: true,
                        )),
                    sizedBoxW(width: 12),
                    Showcase.withWidget(
                        disableMovingAnimation: true,
                        onBarrierClick: () {},
                        key: c.key2,
                        // description: "Find new activities, friends and groups in\none place!",
                        width: MediaQuery.of(context).size.width,
                        height: 100.h,
                        // targetPadding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                        targetShapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r)),
                        targetBorderRadius: BorderRadius.circular(14.r),
                        container: Container(
                          margin: EdgeInsets.only(left: 20.w),
                          child: TourToolTip(
                            tooltipPadding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.57),
                            isArrowDown: false,
                            tourText:
                                "See all notification and your new friend request here.",
                            width: MediaQuery.of(context).size.width - 45.w,
                            onTap: () {
                              ShowCaseWidget.of(ctx).next();
                            },
                          ),
                        ),
                        child: MyIconButton(
                          onTap: () {
                            getToNamed(notificationScreenRoute);
                          },
                          icon: AppBarIcons.notificationBellSvg,
                          isSvg: true,
                        ))
                  ],
                ),
                body: RefreshIndicator(
                  color: AppColors.orangePrimary,
                  onRefresh: () async {
                    await c.init();
                    return;
                  },
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: //Container(color: AppColors.black,)
                            SingleChildScrollView(
                          controller: c.scrollController,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  getToNamed(createPostScreenRoute);
                                },
                                child: Showcase.withWidget(
                                    disableMovingAnimation: true,
                                    onBarrierClick: () {},
                                    key: c.key1,
                                    // description: "Find new activities, friends and groups in\none place!",
                                    width: MediaQuery.of(context).size.width,
                                    height: 100.h,
                                    // targetPadding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                                    targetShapeBorder: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14.r)),
                                    //targetBorderRadius: BorderRadius.circular(14.r),
                                    container: TourToolTip(
                                      isArrowDown: false,
                                      tourText:
                                          "Share your latest experience here ☄️",
                                      width: MediaQuery.of(context).size.width -
                                          50.w,
                                      onTap: () {
                                        ShowCaseWidget.of(ctx).next();
                                      },
                                    ),
                                    child: Container(
                                      color: AppColors.white,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 22.w, vertical: 16.h),
                                      child: Row(children: [
                                        c.imageFileName!.trim().isEmpty
                                            ? MyAvatar(
                                                url: AppImage.sampleAvatar,
                                                height: 56,
                                                width: 56,
                                                radiusAll: 22.4,
                                              )
                                            : MyAvatar(
                                                url: ApiInterface.baseUrl +
                                                    Endpoints.user +
                                                    Endpoints.profileImage +
                                                    c.imageFileName.toString(),
                                                height: 56,
                                                width: 56,
                                                radiusAll: 22.4,
                                                isNetwork: true,
                                              ),
                                        sizedBoxW(width: 12.w),
                                        Text(
                                          AppStrings.whatsNewToday,
                                          style: AppStyles.interRegularStyle(
                                              fontSize: 17.2,
                                              color: AppColors.hintTextColor),
                                        )
                                      ]),
                                    )),
                              ),
                              sizedBoxH(height: 8.h),
                              c.isLoadingPost!
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
                                            "No posts available",
                                            style:
                                                AppStyles.interRegularStyle(),
                                          )),
                                        )
                                      : Column(children: [
                                          ...List.generate(
                                              c.postsVM.postsList.length > 2
                                                  ? 2
                                                  : c.postsVM.postsList.length,
                                              (index) {
                                            return c.postsVM.postsList[index]
                                                        .mode ==
                                                    'POST'
                                                ? PostWidget.post(
                                                    c.postsVM, c, index)
                                                : SizedBox();
                                          }),
                                          if (c.tSuggestedPeople!.data!
                                              .isNotEmpty)
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: 8.h,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 24,
                                                      horizontal: 22),
                                                  color: Colors.white,
                                                  height: 278,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'People to connect ✨',
                                                        style: AppStyles
                                                            .interSemiBoldStyle(
                                                                fontSize: 18),
                                                      ),
                                                      SizedBox(
                                                        height: 16.h,
                                                      ),
                                                      Expanded(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: ListView
                                                                  .separated(
                                                                controller: c
                                                                    .spScrollController,
                                                                clipBehavior:
                                                                    Clip.none,
                                                                itemBuilder: (context,
                                                                        index) =>
                                                                    suggestedPeople(
                                                                        c,
                                                                        index),
                                                                separatorBuilder:
                                                                    (context,
                                                                            index) =>
                                                                        SizedBox(
                                                                  width: 14.w,
                                                                ),
                                                                itemCount: c
                                                                    .tSuggestedPeople!
                                                                    .data!
                                                                    .length,
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                shrinkWrap:
                                                                    true,
                                                              ),
                                                            ),
                                                            // if (c
                                                            //     .tLoadMoreIsloading)
                                                            //   Padding(
                                                            //     padding: EdgeInsetsDirectional
                                                            //         .only(
                                                            //             start:
                                                            //                 8),
                                                            //     child: Center(
                                                            //       child:
                                                            //           CircularProgressIndicator(
                                                            //         color: AppColors
                                                            //             .orangePrimary,
                                                            //       ),
                                                            //     ),
                                                            //   )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          ...List.generate(
                                              c.postsVM.postsList.length - 2,
                                              (index) {
                                            return c
                                                        .postsVM
                                                        .postsList[index + 2]
                                                        .mode ==
                                                    'POST'
                                                ? PostWidget.post(
                                                    c.postsVM, c, index + 2)
                                                : PostWidget.activity(
                                                    c, index + 2);
                                          }),
                                        ]),
                            ],
                          ),
                        ),
                      ),
                      (c.fetchingMorePosts! && c.itIsTimeNow!)
                          ? const SizedBox(
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.orangePrimary,
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            );
          }));
    });
  }

  static void showcase(TimelineScreenVM c) async {
    bool? isOverviewed = await SecuredStorage.readBoolValue(Keys.isOverviewed);
    String? overViewStep =
        await SecuredStorage.readStringValue(Keys.overviewStep);
    debugPrint("Step $overViewStep, isOverview $isOverviewed");
    c.step = int.parse(overViewStep!);
    if (c.step == 3) {
      c.keyList.add(c.key1);
      c.keyList.add(c.key2);
      c.keyList.add(c.key3);
      c.keyList.add(c.key4);
    } else if (c.step == 4) {
      c.keyList.add(c.key2);
      c.keyList.add(c.key3);
      c.keyList.add(c.key4);
    } else if (c.step == 5) {
      c.keyList.add(c.key3);
      c.keyList.add(c.key4);
    } else if (c.step == 6) {
      c.keyList.add(c.key4);
    }

    if (!isOverviewed! && c.step < 7) {
      Tour.setIsTourRunning = true;
      ShowCaseWidget.of(ctx).startShowCase(c.keyList);
      c.update();
      c.bsvm.update();
    }
  }

  suggestedPeople(TimelineScreenVM c, int index) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(vertical: 24, horizontal: 22),
      height: 192,
      width: 304,
      decoration: BoxDecoration(
          color: AppColors.lightGray, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                                horizontal: 22.w, vertical: 22.h),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOutCubic,
                                  // margin: EdgeInsets.all(margin),
                                  decoration: BoxDecoration(
                                      image: (c.imageFileName != null &&
                                              c.imageFileName!.isEmpty)
                                          ? const DecorationImage(
                                              image: AssetImage(
                                                AppImage.sampleAvatar,
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : DecorationImage(
                                              image: NetworkImage(
                                                ApiInterface.baseUrl +
                                                    Endpoints.user +
                                                    Endpoints.profileImage +
                                                    c.imageFileName.toString(),
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
                  width: 62.w,
                  height: 62.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.4.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22.4.r),
                    child: (c.tSuggestedPeople!.data![index].userInfo!
                                    .profilePic ==
                                null ||
                            c.tSuggestedPeople!.data![index].userInfo!
                                .profilePic
                                .toString()
                                .trim()
                                .isEmpty)
                        ? Image.asset(
                            AppImage.sampleAvatar,
                            fit: BoxFit.fill,
                          )
                        : MyAvatar(
                            isNetwork: true,
                            url: ApiInterface.baseUrl +
                                Endpoints.user +
                                Endpoints.profileImage +
                                c.tSuggestedPeople!.data![index].userInfo!
                                    .profilePic!,
                            // fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              SizedBox(
                width: 14.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${c.tSuggestedPeople!.data![index].userInfo!.fullName}',
                        style: AppStyles.interSemiBoldStyle(fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      '${c.tSuggestedPeople!.data![index].userInfo!.biography ?? ''}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.interRegularStyle(fontSize: 13),
                    ),
                  ],
                ),
              )
            ],
          ),
          Spacer(),
          Row(
            children: [
              !c.tSuggestedPeople!.data![index].isRequestSent!
                  ? InkWell(
                      borderRadius: BorderRadius.circular(100.r),
                      onTap: c.isEnabled!
                          ? () {
                              c.addFriend(index);
                            }
                          : null,
                      child: Container(
                          height: 34.h,
                          //width: 84.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 5.h),
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
                            AppStrings.addFriend,
                            style: AppStyles.interMediumStyle(
                                color: AppColors.white, fontSize: 14.4),
                          ))))
                  : InkWell(
                      borderRadius: BorderRadius.circular(100.r),
                      onTap: () {
                        showCupertinoModalPopup(
                          context: Get.context!,
                          builder: (BuildContext context) =>
                              CupertinoActionSheet(
                                  actions: <Widget>[
                                CupertinoActionSheetAction(
                                  child: Text(
                                    AppStrings.cancelFriendReq,
                                    style: AppStyles.interRegularStyle(
                                        color: Colors.red),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(
                                        context, AppStrings.cancelFriendReq);
                                    c.cancelFriendRequest(index);
                                  },
                                )
                              ],
                                  cancelButton: CupertinoActionSheetAction(
                                    child: Text(
                                      AppStrings.cancel,
                                      style: AppStyles.interRegularStyle(
                                          color: AppColors.iosBlue),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.r),
                            border:
                                Border.all(color: AppColors.editBorderColor),
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
              SizedBox(
                width: 12.w,
              ),
              GestureDetector(
                onTap: () {
                  c.tSuggestedPeople!.data!.removeAt(index);
                  c.update();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),
                  child: Container(
                    padding: EdgeInsets.all(6),
                    color: AppColors.btnStrokeColor,
                    child: SvgPicture.asset(
                      AppIcons.closeSvg,
                      // width: 12.w,
                      // height: 12.h,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PostWidget {
  static activity(TimelineScreenVM c, index) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 22.w),
      child: Column(
        children: [
          Row(
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
                                horizontal: 22.w, vertical: 22.h),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOutCubic,
                                  // margin: EdgeInsets.all(margin),
                                  decoration: BoxDecoration(
                                      image: (c.imageFileName != null &&
                                              c.imageFileName!.isEmpty)
                                          ? const DecorationImage(
                                              image: AssetImage(
                                                AppImage.sampleAvatar,
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : DecorationImage(
                                              image: NetworkImage(
                                                  ApiInterface.baseUrl +
                                                      Endpoints.user +
                                                      Endpoints.profileImage +
                                                      c
                                                          .postsVM
                                                          .postsList[index]
                                                          .activityHost!
                                                          .profilePic!),
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
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19.4.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(19.4.r),
                    child:
                        (c.postsVM.postsList[index].activityHost!.profilePic ==
                                null)
                            ? Image.asset(
                                AppImage.sampleAvatar,
                                fit: BoxFit.fill,
                              )
                            : MyAvatar(
                                isNetwork: true,
                                url: ApiInterface.baseUrl +
                                    Endpoints.user +
                                    Endpoints.profileImage +
                                    c.postsVM.postsList[index].activityHost!
                                        .profilePic!,
                                // fit: BoxFit.cover,
                              ),
                  ),
                ),
              ),
              SizedBox(
                width: 14.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${c.postsVM.postsList[index].activityHost!.firstName} ${c.postsVM.postsList[index].activityHost!.lastName} ',
                        style: AppStyles.interSemiBoldStyle(fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      'Joined this activity',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.interRegularStyle(fontSize: 13),
                    ),
                  ],
                ),
              )
            ],
          ),
          ActivityWidget.activity(c.postsVM.postsList[index], c.postsVM, c,
              isProfile: true),
        ],
      ),
    );
  }

  static Widget post(PostsAndActivitiesVM c, orgC, index,
      {bool isProfilePost = false, bool andIsFreind = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: AppColors.white,
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 22.w),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isProfilePost
                      ? orgC.imageFileName!.isNotEmpty
                          ? InkWell(
                              onTap: () {},
                              child: MyAvatar(
                                url: ApiInterface.baseUrl +
                                    Endpoints.user +
                                    Endpoints.profileImage +
                                    orgC.imageFileName.toString(),
                                height: 48,
                                width: 48,
                                radiusAll: 19.2,
                                isNetwork: true,
                              ),
                            )
                          : InkWell(
                              onTap: () {},
                              child: MyAvatar(
                                url: AppImage.sampleAvatar,
                                height: 48,
                                width: 48,
                                radiusAll: 19.2,
                              ),
                            )
                      : c.postsList[index].userInfo!.userInfo!.profilePic!
                              .isNotEmpty
                          ? InkWell(
                              onTap: () {
                                if (c.postsList[index].userInfo!.userInfo!
                                        .userId!
                                        .toString() ==
                                    c.userId) {
                                  c.bsv.changePage(4);
                                } else {
                                  SearchUser.setId = c.postsList[index]
                                      .userInfo!.userInfo!.userId!
                                      .toString();
                                  getToNamed(friendUserProfileScreeRoute);
                                }
                              },
                              child: MyAvatar(
                                url: ApiInterface.baseUrl +
                                    Endpoints.user +
                                    Endpoints.profileImage +
                                    c.postsList[index].userInfo!.userInfo!
                                        .profilePic!,
                                height: 48,
                                width: 48,
                                radiusAll: 19.2,
                                isNetwork: true,
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                if (c.postsList[index].userInfo!.userInfo!
                                        .userId!
                                        .toString() ==
                                    c.userId) {
                                  c.bsv.changePage(4);
                                } else {
                                  SearchUser.setId = c.postsList[index]
                                      .userInfo!.userInfo!.userId!
                                      .toString();
                                  getToNamed(friendUserProfileScreeRoute);
                                }
                              },
                              child: MyAvatar(
                                url: AppImage.sampleAvatar,
                                height: 48,
                                width: 48,
                                radiusAll: 19.2,
                              ),
                            ),
                  sizedBoxW(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sizedBoxH(height: 4.h),
                        isProfilePost
                            ? InkWell(
                                onTap: () {
                                  // c.bsv.changePage(4);
                                },
                                child: Text(
                                  orgC.firstName.toString() +
                                      " " +
                                      orgC.lastName.toString(),
                                  style: AppStyles.interSemiBoldStyle(
                                      fontSize: 16, color: AppColors.black),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  if (c.postsList[index].userInfo!.userInfo!
                                          .userId!
                                          .toString() ==
                                      c.userId) {
                                    c.bsv.changePage(4);
                                  } else {
                                    SearchUser.setId = c.postsList[index]
                                        .userInfo!.userInfo!.userId!
                                        .toString();
                                    getToNamed(friendUserProfileScreeRoute);
                                  }
                                },
                                child: Text(
                                  c.postsList[index].userInfo!.userInfo!
                                          .firstName
                                          .toString() +
                                      " " +
                                      c.postsList[index].userInfo!.userInfo!
                                          .lastName
                                          .toString(),
                                  style: AppStyles.interSemiBoldStyle(
                                      fontSize: 16, color: AppColors.black),
                                ),
                              ),
                        sizedBoxH(height: 3.2.h),
                        Text(
                          getTime(c.postsList[index].createdAt.toString()),
                          style: AppStyles.interRegularStyle(
                              fontSize: 12.8, color: AppColors.hintTextColor),
                        )
                      ],
                    ),
                  ),
                  (((!isProfilePost && !andIsFreind) &&
                              (c.postsList[index].userInfo!.userInfo!.userId!
                                      .toString() ==
                                  c.userId)) ||
                          (isProfilePost && !andIsFreind))
                      ? InkWell(
                          onTap: () {
                            showCupertinoModalPopup(
                              context: getContext(),
                              builder: (BuildContext context) =>
                                  CupertinoActionSheet(
                                      // title: const Text('Choose Options'),
                                      // message: const Text('Your options are '),
                                      actions: <Widget>[
                                    CupertinoActionSheetAction(
                                        child: Text(
                                          AppStrings.editPost,
                                          style: AppStyles.interRegularStyle(
                                              color: AppColors.iosBlue),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(
                                              context, AppStrings.edit);
                                          PostEdit.setPostOrActivity =
                                              c.postsList[index];
                                          getToNamed(createPostScreenRoute);
                                        }),
                                    CupertinoActionSheetAction(
                                      child: Text(
                                        AppStrings.deletePost,
                                        style: AppStyles.interRegularStyle(
                                            color: Colors.red),
                                      ),
                                      onPressed: () async {
                                        await c.deletePost(
                                            c.postsList[index].id.toString(),
                                            orgC);
                                        Navigator.pop(
                                            context, AppStrings.deletePost);
                                      },
                                    )
                                  ],
                                      cancelButton: CupertinoActionSheetAction(
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
                          child: const RotatedBox(
                            quarterTurns: 1,
                            child: Icon(
                              Icons.more_vert_rounded,
                              color: AppColors.hintTextColor,
                            ),
                          ))
                      : Container()
                ],
              ),
              (c.postsList[index].text.toString().isEmpty ||
                      c.postsList[index].text.toString() == "null")
                  ? sizedBoxH(height: 0)
                  : sizedBoxH(height: 16),
              (c.postsList[index].text.toString().isEmpty ||
                      c.postsList[index].text.toString() == "null")
                  ? Container()
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Text(
                          c.postsList[index].text.toString(),
                          style: AppStyles.interRegularStyle(
                              fontSize: 17.2, color: AppColors.black),
                        ))
                      ],
                    ),
              sizedBoxH(height: c.postsList[index].userTags!.isEmpty ? 0 : 16),
              c.postsList[index].userTags!.isEmpty
                  ? Container()
                  : c.postsList[index].tagUserInfo == null
                      ? Container()
                      : InkWell(
                          onTap: () async {
                            await c.getTaggedUser(c.postsList[index].userTags);
                            showFlexibleBottomSheet(
                              initHeight: 0.3,
                              //isExpand: true,
                              minHeight: 0,
                              maxHeight: 0.85,
                              //isCollapsible: true,
                              bottomSheetColor: Colors.transparent,
                              context: getContext(),
                              builder: (a, b, d) {
                                return showUsers(c, c.taggedUsersList, 0, b);
                              },
                              anchors: [0, 0.3, 0.85],
                              isSafeArea: true,
                            );
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                AppIcons.taggedSvg,
                                color: AppColors.ageColor,
                                width: 18.w,
                                height: 18.h,
                              ),
                              RichText(
                                text: TextSpan(
                                    text: "with ",
                                    style: AppStyles.interRegularStyle(
                                        fontSize: 15,
                                        color: AppColors.ageColor),
                                    children: [
                                      TextSpan(
                                        text: c.postsList[index].tagUserInfo!
                                                .userData!.firstName! +
                                            " " +
                                            c.postsList[index].tagUserInfo!
                                                .userData!.lastName!,
                                        style: AppStyles.interMediumStyle(
                                            fontSize: 15,
                                            color: AppColors.orangePrimary),
                                      ),
                                      TextSpan(
                                        text: (c.postsList[index].tagUserInfo!
                                                            .countOfUserTags! -
                                                        1)
                                                    .toString() ==
                                                "0"
                                            ? ""
                                            : " and ${c.postsList[index].tagUserInfo!.countOfUserTags! - 1} others ",
                                        style: AppStyles.interMediumStyle(
                                            fontSize: 15,
                                            color: AppColors.ageColor),
                                      )
                                    ]),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: (c.postsList[index].tagUserInfo!
                                                    .countOfUserTags! -
                                                1)
                                            .toString() ==
                                        "0"
                                    ? Colors.transparent
                                    : AppColors.ageColor,
                                size: 22,
                              )
                            ],
                          ),
                        ),
              sizedBoxH(height: c.postsList[index].document!.isEmpty ? 0 : 16),
              c.postsList[index].document!.isEmpty
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Documents",
                          style: AppStyles.interMediumStyle(
                              fontSize: 14, color: AppColors.black),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        SizedBox(
                          height: 40.h,
                          child: ListView.builder(
                              itemCount: c.postsList[index].document!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, idx) {
                                return InkWell(
                                  onTap: () async {
                                    String? imgUrl = ApiInterface.postImgUrl +
                                        c.postsList[index].document![idx].s3Name
                                            .toString();
                                    Directory? tempDir;
                                    String? fullPath;
                                    if (Platform.isIOS) {
                                      tempDir = await getTemporaryDirectory();
                                      fullPath = tempDir
                                              .absolute.path + //tempDir!.path
                                          "/${c.postsList[index].document![idx].s3Name.toString()}"; //"/boo2.pdf'";
                                    } else if (Platform.isAndroid) {
                                      tempDir =
                                          await getExternalStorageDirectory(); //await getTemporaryDirectory();
                                      fullPath = tempDir!
                                              .absolute.path + //tempDir!.path
                                          "/${c.postsList[index].document![idx].s3Name.toString()}"; //"/boo2.pdf'";
                                    }

                                    debugPrint(
                                        'full path $fullPath, img Url $imgUrl');

                                    c.getRequiredPermission(imgUrl, fullPath);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 8.w),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        color: AppColors.texfieldColor),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          c.postsList[index].document![idx]
                                              .originalName
                                              .toString(),
                                          style: AppStyles.interMediumStyle(
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        // SizedBox(
                        //   height:  16.h,
                        // )
                      ],
                    ),

              sizedBoxH(
                  height: c.postsList[index].attachment!.isEmpty ? 0 : 16),
              c.postsList[index].attachment!.isEmpty
                  ? Container()
                  : InkWell(
                      onTap: () {
                        Attachements.setAttachements =
                            c.postsList[index].attachment!;
                        getToNamed(fullScreenImageViewRoute);
                      },
                      child: SizedBox(
                          height: 240.h,
                          child: c.postsList[index].attachment!.length == 1
                              ? c.postsList[index].attachment![0].type ==
                                      CaptureType.video
                                  ? MyVideoPlayer(
                                      controller: c.postsList[index]
                                          .attachment![0].getController!,
                                      radiusAll: 16,
                                    )
                                  : MyAvatar(
                                      url: ApiInterface.postImgUrl +
                                          c.postsList[index].attachment![0].name
                                              .toString(),
                                      isNetwork: true,
                                      height: 240,
                                      width: double.infinity,
                                      radiusAll: 16,
                                    )
                              : c.postsList[index].attachment!.length == 2
                                  ? Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        c.postsList[index].attachment![0]
                                                    .type ==
                                                CaptureType.video
                                            ? Expanded(
                                                flex: 1,
                                                child: MyVideoPlayer(
                                                  controller: c
                                                      .postsList[index]
                                                      .attachment![0]
                                                      .getController!,
                                                  radiusTL: 16,
                                                  radiusBL: 16,
                                                ),
                                              )
                                            : Expanded(
                                                flex: 1,
                                                child: MyAvatar(
                                                  url: ApiInterface.postImgUrl +
                                                      c.postsList[index]
                                                          .attachment![0].name
                                                          .toString(),
                                                  isNetwork: true,
                                                  height: 240,
                                                  radiusTL: 16,
                                                  radiusBL: 16,
                                                )),
                                        sizedBoxW(width: 4),
                                        c.postsList[index].attachment![1]
                                                    .type ==
                                                CaptureType.video
                                            ? Expanded(
                                                flex: 1,
                                                child: MyVideoPlayer(
                                                  controller: c
                                                      .postsList[index]
                                                      .attachment![1]
                                                      .getController!,
                                                  radiusTR: 16,
                                                  radiusBR: 16,
                                                ),
                                              )
                                            : Expanded(
                                                flex: 1,
                                                child: MyAvatar(
                                                  url: ApiInterface.postImgUrl +
                                                      c.postsList[index]
                                                          .attachment![1].name
                                                          .toString(),
                                                  isNetwork: true,
                                                  height: 240,
                                                  radiusTR: 16,
                                                  radiusBR: 16,
                                                ))
                                      ],
                                    )
                                  : c.postsList[index].attachment!.length == 3
                                      ? Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            c.postsList[index].attachment![0]
                                                        .type ==
                                                    CaptureType.video
                                                ? Expanded(
                                                    flex: 1,
                                                    child: MyVideoPlayer(
                                                      controller: c
                                                          .postsList[index]
                                                          .attachment![0]
                                                          .getController!,
                                                      radiusTL: 16,
                                                      radiusBL: 16,
                                                    ),
                                                  )
                                                : Expanded(
                                                    flex: 1,
                                                    child: MyAvatar(
                                                      url: ApiInterface
                                                              .postImgUrl +
                                                          c
                                                              .postsList[index]
                                                              .attachment![0]
                                                              .name
                                                              .toString(),
                                                      isNetwork: true,
                                                      height: 240,
                                                      radiusTL: 16,
                                                      radiusBL: 16,
                                                    )),
                                            sizedBoxW(width: 4),
                                            Expanded(
                                                flex: 1,
                                                child: Column(
                                                  children: [
                                                    c
                                                                .postsList[
                                                                    index]
                                                                .attachment![1]
                                                                .type ==
                                                            CaptureType.video
                                                        ? Expanded(
                                                            flex: 1,
                                                            child:
                                                                MyVideoPlayer(
                                                              controller: c
                                                                  .postsList[
                                                                      index]
                                                                  .attachment![
                                                                      1]
                                                                  .getController!,
                                                              radiusTR: 16,
                                                            ),
                                                          )
                                                        : Expanded(
                                                            flex: 1,
                                                            child: MyAvatar(
                                                              url: ApiInterface
                                                                      .postImgUrl +
                                                                  c
                                                                      .postsList[
                                                                          index]
                                                                      .attachment![
                                                                          1]
                                                                      .name
                                                                      .toString(),
                                                              isNetwork: true,
                                                              width: double
                                                                  .infinity,
                                                              radiusTR: 16,
                                                            )),
                                                    sizedBoxH(height: 4),
                                                    c
                                                                .postsList[
                                                                    index]
                                                                .attachment![2]
                                                                .type ==
                                                            CaptureType.video
                                                        ? Expanded(
                                                            flex: 1,
                                                            child:
                                                                MyVideoPlayer(
                                                              controller: c
                                                                  .postsList[
                                                                      index]
                                                                  .attachment![
                                                                      2]
                                                                  .getController!,
                                                              radiusBR: 16,
                                                            ),
                                                          )
                                                        : Expanded(
                                                            flex: 1,
                                                            child: MyAvatar(
                                                              url: ApiInterface
                                                                      .postImgUrl +
                                                                  c
                                                                      .postsList[
                                                                          index]
                                                                      .attachment![
                                                                          2]
                                                                      .name
                                                                      .toString(),
                                                              isNetwork: true,
                                                              width: double
                                                                  .infinity,
                                                              radiusBR: 16,
                                                            ))
                                                  ],
                                                )),
                                          ],
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            c.postsList[index].attachment![0]
                                                        .type ==
                                                    CaptureType.video
                                                ? Expanded(
                                                    flex: 1,
                                                    child: MyVideoPlayer(
                                                      controller: c
                                                          .postsList[index]
                                                          .attachment![0]
                                                          .getController!,
                                                      radiusTL: 16,
                                                      radiusBL: 16,
                                                    ),
                                                  )
                                                : Expanded(
                                                    flex: 1,
                                                    child: MyAvatar(
                                                      url: ApiInterface
                                                              .postImgUrl +
                                                          c
                                                              .postsList[index]
                                                              .attachment![0]
                                                              .name
                                                              .toString(),
                                                      isNetwork: true,
                                                      height: 240,
                                                      radiusTL: 16,
                                                      radiusBL: 16,
                                                    )),
                                            sizedBoxW(width: 4),
                                            Expanded(
                                                flex: 1,
                                                child: Column(
                                                  children: [
                                                    c
                                                                .postsList[
                                                                    index]
                                                                .attachment![1]
                                                                .type ==
                                                            CaptureType.video
                                                        ? Expanded(
                                                            flex: 1,
                                                            child:
                                                                MyVideoPlayer(
                                                              controller: c
                                                                  .postsList[
                                                                      index]
                                                                  .attachment![
                                                                      1]
                                                                  .getController!,
                                                              radiusTR: 16,
                                                            ),
                                                          )
                                                        : Expanded(
                                                            flex: 1,
                                                            child: MyAvatar(
                                                              url: ApiInterface
                                                                      .postImgUrl +
                                                                  c
                                                                      .postsList[
                                                                          index]
                                                                      .attachment![
                                                                          1]
                                                                      .name
                                                                      .toString(),
                                                              isNetwork: true,
                                                              width: double
                                                                  .infinity,
                                                              radiusTR: 16,
                                                            )),
                                                    sizedBoxH(height: 4),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Stack(
                                                          children: [
                                                            Column(
                                                              children: [
                                                                c.postsList[index].attachment![2].type ==
                                                                        CaptureType
                                                                            .video
                                                                    ? Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            MyVideoPlayer(
                                                                          controller: c
                                                                              .postsList[index]
                                                                              .attachment![2]
                                                                              .getController!,
                                                                          radiusBR:
                                                                              16,
                                                                        ),
                                                                      )
                                                                    : Expanded(
                                                                        child:
                                                                            MyAvatar(
                                                                          url: ApiInterface.postImgUrl +
                                                                              c.postsList[index].attachment![2].name.toString(),
                                                                          isNetwork:
                                                                              true,
                                                                          width:
                                                                              double.infinity,
                                                                          radiusBR:
                                                                              16,
                                                                        ),
                                                                      ),
                                                              ],
                                                            ),
                                                            Positioned(
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomRight,
                                                                    child:
                                                                        Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical: 12
                                                                              .h,
                                                                          horizontal:
                                                                              12.w),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.r),
                                                                            color: const Color(0x8A000000)),
                                                                        height:
                                                                            35.h,
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8.w,
                                                                            vertical: 8.h),
                                                                        child:
                                                                            Text(
                                                                          "3+",
                                                                          style: AppStyles.interMediumStyle(
                                                                              fontSize: 16,
                                                                              color: AppColors.white),
                                                                        ),
                                                                      ),
                                                                    )))
                                                          ],
                                                        ))
                                                  ],
                                                )),
                                          ],
                                        )),
                    ),
              sizedBoxH(
                  height: c.postsList[index].attachment!.isEmpty ? 16 : 16),

              c.postsList[index].activityData != null
                  ? ActivitySearchedCard(
                      onTap: () {
                        Get.delete<ActivityDetailsScreenVM>();
                        getToNamed(activityDetailsScreenRoute, argument: {
                          "id": c.postsList[index].activityId.toString()
                        });
                      },
                      margin: EdgeInsets.zero,
                      activity: PostOrActivity(
                          activityId: c.postsList[index].activityId.toString(),
                          activityName: c
                              .postsList[index].activityData!["activityName"]
                              .toString(),
                          activityDate: DateFormat("dd MMM yyyy").format(
                              DateTime.parse(c.postsList[index]
                                  .activityData!["activityDate"]
                                  .toString())),
                          coverImage: c
                              .postsList[index].activityData!["coverImage"]
                              .toString(),
                          group: c.postsList[index].activityData!["group"]))
                  : Container(),

              c.postsList[index].activityData != null
                  ? sizedBoxH(height: 16)
                  : Container(),

              //Add event card here
              !isProfilePost
                  ? Container()
                  : andIsFreind
                      ? Container()
                      : c.postsList[index].jioMeUserInfo!.isEmpty
                          ? Container()
                          : SizedBox(
                              height: 40.h,
                              child: InkWell(
                                onTap: () {
                                  showFlexibleBottomSheet(
                                    initHeight: 0.75,
                                    //isExpand: true,
                                    minHeight: 0,
                                    maxHeight: 0.85,
                                    //isCollapsible: true,
                                    bottomSheetColor: Colors.transparent,
                                    context: getContext(),
                                    builder: (a, b, d) {
                                      return showUsers(
                                          c,
                                          c.postsList[index].jioMeUserInfo,
                                          1,
                                          b);
                                    },
                                    anchors: [0, 0.75, 0.85],
                                    isSafeArea: true,
                                  );
                                },
                                child: Row(
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: List.generate(
                                            c.postsList[index].jioMeUserInfo!
                                                        .length >
                                                    5
                                                ? 5
                                                : c
                                                    .postsList[index]
                                                    .jioMeUserInfo!
                                                    .length, (indexx) {
                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 4.w),
                                            height: 40.h,
                                            width: 40.w,
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                c
                                                        .postsList[index]
                                                        .jioMeUserInfo![indexx]
                                                        .jioMeUserList!
                                                        .profilePic
                                                        .toString()
                                                        .isNotEmpty
                                                    ? MyAvatar(
                                                        url: ApiInterface
                                                                .profileImgUrl +
                                                            c
                                                                .postsList[
                                                                    index]
                                                                .jioMeUserInfo![
                                                                    indexx]
                                                                .jioMeUserList!
                                                                .profilePic
                                                                .toString(),
                                                        height: 40,
                                                        width: 40.w,
                                                        radiusAll: 16,
                                                        isNetwork: true,
                                                      )
                                                    : MyAvatar(
                                                        url: AppImage
                                                            .sampleAvatar,
                                                        height: 40,
                                                        width: 40.w,
                                                        radiusAll: 16,
                                                      ),
                                                Positioned(
                                                    top: 30.h,
                                                    left: 10.w,
                                                    child: MyAvatar(
                                                      url: AppImage.jioMeLogo,
                                                      isSVG: true,
                                                      height: 20.h,
                                                      width: 20.w,
                                                      radiusAll: 12,
                                                    ))
                                              ],
                                            ),
                                          );
                                        }))
                                    //})
                                    ,
                                    c.postsList[index].jioMeUserInfo!.length > 5
                                        ? Container(
                                            height: 40.h,
                                            width: 40.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                              color: AppColors.tabBkgColor,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                MyAvatar(
                                                    url: AppIcons.profile,
                                                    isSVG: true,
                                                    width: 11.24.w,
                                                    height: 11.24.h),
                                                sizedBoxH(height: 2.h),
                                                Text(
                                                  (c
                                                              .postsList[index]
                                                              .jioMeUserInfo!
                                                              .length -
                                                          5)
                                                      .toString(),
                                                  style: AppStyles
                                                      .interMediumStyle(
                                                          fontSize: 14,
                                                          color: AppColors
                                                              .hintTextColor),
                                                )
                                              ],
                                            ),
                                          )
                                        : Container()
                                  ],
                                ),
                              )),
              sizedBoxH(height: isProfilePost ? 24 : 16),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          c.like(c.postsList[index].id.toString(), index);
                        },
                        onLongPress: () async {
                          await c
                              .getLikedUser(c.postsList[index].id.toString());
                          showFlexibleBottomSheet(
                            initHeight: 0.75,
                            //isExpand: true,
                            minHeight: 0,
                            maxHeight: 0.85,
                            //isCollapsible: true,
                            bottomSheetColor: Colors.transparent,
                            context: getContext(),
                            builder: (a, b, d) {
                              return showUsers(c, c.likeUsers, 2, b);
                            },
                            anchors: [0, 0.75, 0.85],
                            isSafeArea: true,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 8.h),
                          //height: 32.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: AppColors.likeReactBkgColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              c.postsList[index].isLiked == 0
                                  ? SvgPicture.asset(AppIcons.loveReactSvg,
                                      height: 20.h,
                                      width: 20.h,
                                      color: AppColors.likeReactColor)
                                  : SvgPicture.asset(
                                      AppIcons.loveReactFilledSvg,
                                      height: 15.h,
                                      width: 15.h,
                                      color: AppColors.likeReactColor),
                              sizedBoxW(width: 2.w),
                              Text(
                                c.postsList[index].likeCount.toString(),
                                style: AppStyles.interRegularStyle(
                                  fontSize: 16,
                                  color: AppColors.likeReactColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      sizedBoxW(width: 8.w),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: AppColors.commentReactBkgColor,
                        ),
                        child: Material(
                          type: MaterialType.transparency,
                          borderRadius: BorderRadius.circular(12.r),
                          child: InkWell(
                              borderRadius: BorderRadius.circular(12.r),
                              onTap: () async {
                                await c.cvm.getComments(
                                    c.postsList[index].id.toString(),
                                    postIdIndex: index, callback: () {
                                  c.postsList[index].commentCount =
                                      c.postsList[index].commentCount! + 1;
                                  c.update();
                                });
                                // showCommentModal(c, c.postsList[index].id.toString());
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 8.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(AppIcons.commentReactSvg,
                                        height: 20.h,
                                        width: 20.h,
                                        color: AppColors.commentReactColor),
                                    sizedBoxW(width: 2.w),
                                    Text(
                                      c.postsList[index].commentCount
                                          .toString(),
                                      style: AppStyles.interRegularStyle(
                                        fontSize: 16,
                                        color: AppColors.commentReactColor,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      )
                    ],
                  ),
                  (isProfilePost && !andIsFreind)
                      ? Container()
                      : ((!isProfilePost && !andIsFreind) &&
                              (c.postsList[index].userInfo!.userInfo!.userId!
                                      .toString() ==
                                  c.userId))
                          ? Container()
                          : InkWell(
                              onTap: () {
                                c.jioMe(
                                    c.postsList[index].id.toString(), index);
                              },
                              child: c.postsList[index].isJioMe == 0
                                  ? SvgPicture.asset(
                                      AppIcons.reactBtnSvg,
                                      width: 64.w,
                                      height: 32.h,
                                    )
                                  : SvgPicture.asset(
                                      AppIcons.jioMeed,
                                      width: 64.w,
                                      height: 32.h,
                                    ),
                            )
                ],
              )
            ],
          ),
        ),
        sizedBoxH(height: 8.h),
      ],
    );
  }

  static Future<dynamic> showCommentModal(
      CommentsVM c, postId, postIdIndex, Function()? callback) {
    return showFlexibleBottomSheet(
      initHeight: 0.75,
      isExpand: true,
      minHeight: 0,
      maxHeight: 0.85,
      //isCollapsible: true,
      bottomSheetColor: Colors.transparent,
      context: getContext(),
      builder: (a, b, d) {
        return commentSheet(c, postId, postIdIndex, b, callback);
      },
      anchors: [0, 0.75, 0.85],
      isSafeArea: true,
    );
  }

  static Widget commentSheet(CommentsVM c, postId, postIdIndex,
      ScrollController b, Function()? callback) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
      child: Scaffold(
        //bottomSheet: bottomSheetWidget,
        backgroundColor: AppColors.white,
        body: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
          child: Container(
              decoration: BoxDecoration(
                  color: AppColors.appBkgColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32.r),
                      topRight: Radius.circular(32.r))),
              child: SingleChildScrollView(
                controller: b,
                child: SizedBox(
                  height: MediaQuery.of(getContext()).size.height -
                      (MediaQuery.of(getContext()).size.height * 0.25),
                  child: Column(
                    //shrinkWrap: true,
                    //controller: b,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      sizedBoxH(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 54,
                            height: 4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: AppColors.disabledColor),
                          )
                        ],
                      ),
                      sizedBoxH(
                        height: 10,
                      ),
                      Expanded(
                          flex: 1,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: c.commentList.length,
                            itemBuilder: (context, index) {
                              return commentCardWrapper(context, c, index,
                                  postId, postIdIndex, 1, callback);
                            },
                          )),
                    ],
                  ),
                ),
              )),
        ),
        bottomNavigationBar: !c.showCommentTextField!
            ? Container(
                height: 1,
              )
            : Container(
                color: AppColors.white,
                padding: EdgeInsets.only(
                    bottom: 15.h, right: 22.w, left: 22.w, top: 5.h),
                child: Row(
                  children: [
                    Expanded(
                      child: SearchTextField(
                        controller: c.commentCtrl,
                        radius: 100,
                        hint: AppStrings.saySomething,
                        autoFocus: false,
                      ),
                    ),
                    sizedBoxW(width: 12),
                    InkWell(
                      onTap: () {
                        if (c.commentCtrl.text.isNotEmpty) {
                          c.comment(null, postId, null, postIdIndex,
                              callback: callback);
                        }
                      },
                      child: Text(AppStrings.send,
                          style: TextStyle(
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: <Color>[
                                    Color(0xffFFD036),
                                    Color(0xffFFA43C)
                                  ],
                                ).createShader(
                                    const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                              fontSize: 16.sp,
                              fontFamily: interMedium)),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  static Column commentCardWrapper(BuildContext context, CommentsVM c,
      int index, postId, postIdIndex, double level, Function()? callback) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        commentCard(context, c, c.commentList, index, postId, postIdIndex,
            level, callback),
        sizedBoxH(height: 24)
      ],
    );
  }

  static Obx childCommentList(
      CommentsVM c,
      List<comm.Datum> commentList,
      int index,
      BuildContext context,
      postId,
      postIdIndex,
      level,
      Function()? callback) {
    return Obx(() => Column(
          children: List.generate(
              //c.
              commentList[index].getChildComments!.length, (indexx) {
            return commentCard(
                context,
                c, //c.
                commentList[index].getChildComments!,
                indexx,
                postId,
                postIdIndex,
                level,
                callback);
          }),
        ));
  }

  static Obx commentReplier(CommentsVM c, List<comm.Datum> commentList,
      int index, postId, postIdIndex, level, Function()? callback) {
    return Obx(() => //c.
        commentList[index].getIsReplying!
            ? Container(
                margin: EdgeInsets.only(left: (level * 22.w), right: 22.w),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: //c.
                              commentList[index].getReplyCtrl,
                          autofocus: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  "Reply to ${commentList[index].userInfoData!.firstName.toString() + " " + commentList[index].userInfoData!.lastName.toString()}")),
                    ),
                    sizedBoxW(width: 8),
                    InkWell(
                      onTap: () {
                        if ( //c.
                            commentList[index]
                                .getReplyCtrl
                                .text
                                .trim()
                                .isNotEmpty) {
                          //c.
                          commentList[index].setIsReplying = false;
                          c.showCommentTextField = true;
                          c.update();
                          c.comment(commentList, postId, index, postIdIndex,
                              repliedTo: //c.
                                  commentList[index].id.toString(),
                              callback: callback);
                        }
                      },
                      child: Text("Send",
                          style: AppStyles.interRegularStyle(
                            fontSize: 12.8,
                            color: AppColors.orangePrimary,
                          )),
                    ),
                    sizedBoxW(width: 8),
                    InkWell(
                      onTap: () {
                        //c.
                        commentList[index].setIsReplying = false;
                        c.showCommentTextField = true;
                        c.update();
                      },
                      child: Text("Cancel",
                          style: AppStyles.interRegularStyle(
                            fontSize: 12.8,
                            color: AppColors.hintTextColor,
                          )),
                    )
                  ],
                ),
              )
            : Container());
  }

  static Obx commentContent(CommentsVM c, List<comm.Datum> commentList,
      int index, postId, postIdIndex, level, Function()? callback) {
    commentList[index].getUpdateCtrl.text = commentList[index].comment!;
    commentList[index].getUpdateCtrl.selection = TextSelection.fromPosition(
      TextPosition(offset: commentList[index].getUpdateCtrl.text.length),
    );
    return Obx(
      () => //c.
          commentList[index].getIsUpating!.value
              ? Container(
                  margin: EdgeInsets.only(left: 12.w, right: 12.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            controller: //c.
                                commentList[index].getUpdateCtrl,
                            autofocus: true,
                            decoration: const InputDecoration(
                              hintText: "update comment",
                              contentPadding: EdgeInsets.all(0),
                              border: InputBorder.none,
                            )),
                      ),
                      sizedBoxW(width: 8),
                      InkWell(
                        onTap: () {
                          if ( //c.
                              commentList[index]
                                  .getUpdateCtrl
                                  .text
                                  .trim()
                                  .isNotEmpty) {
                            //c.
                            commentList[index].comment =
                                commentList[index].getUpdateCtrl.text;
                            commentList[index].getIsUpating!.value = false;
                            c.showCommentTextField = true;
                            c.update();
                            c.updateComment(commentList, index, postId,
                                postIdIndex, callback);
                          }
                        },
                        child: Text("Update",
                            style: AppStyles.interRegularStyle(
                              fontSize: 12.8,
                              color: AppColors.orangePrimary,
                            )),
                      ),
                      sizedBoxW(width: 8),
                      InkWell(
                        onTap: () {
                          //c.
                          commentList[index].getIsUpating!.value = false;
                          c.showCommentTextField = true;
                          c.update();
                        },
                        child: Text("Cancel",
                            style: AppStyles.interRegularStyle(
                              fontSize: 12.8,
                              color: AppColors.hintTextColor,
                            )),
                      )
                    ],
                  ),
                )
              : Text(
                  //c.
                  commentList[index].comment!,
                  style: AppStyles.interRegularStyle(
                      fontSize: 15, color: AppColors.textColor),
                ),
    );
  }

  static Widget commentCard(
      BuildContext context,
      CommentsVM c,
      List<comm.Datum> commentList,
      int index,
      postId,
      postIdIndex,
      level,
      Function()? callback) {
    return Column(
      children: [
        commentBody(context, commentList, index, c, level, postId, postIdIndex,
            callback),
        commentReplier(
            c, commentList, index, postId, postIdIndex, level, callback),
        sizedBoxH(height: 15),
        viewAllComment(c, commentList, index, postId, level),
        childCommentList(c, commentList, index, context, postId, postIdIndex,
            level + 0.8, callback),
      ],
    );
  }

  static Widget commentBody(
      BuildContext context,
      List<comm.Datum> commentList,
      int index,
      CommentsVM c,
      level,
      postId,
      postIdIndex,
      Function()? callback) {
    debugPrint("level in combod $level");
    return InkWell(
      onTap: () async {
        String? userId = await SecuredStorage.readStringValue(Keys.userId);
        List<Widget> actions = [
          CupertinoActionSheetAction(
            child: Text(
              AppStrings.reply,
              style: AppStyles.interRegularStyle(color: AppColors.iosBlue),
            ),
            onPressed: () {
              Navigator.pop(context, AppStrings.reply);
              //c.
              commentList[index].setIsReplying = true;
              c.showCommentTextField = false;
              c.update();
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              AppStrings.copy,
              style: AppStyles.interRegularStyle(color: AppColors.iosBlue),
            ),
            onPressed: () async {
              Navigator.pop(context, AppStrings.copy);
              await Clipboard.setData(ClipboardData(
                text: //c.
                    commentList[index].comment.toString(),
              ));
              var snackBar = SnackBar(
                margin: const EdgeInsets.all(10),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                content: const Text('Comment copied to clipboard.'),
              );
              ScaffoldMessenger.of(getContext()).showSnackBar(snackBar);
              //copy
            },
          ),
        ];
        if (userId.toString() == commentList[index].userId.toString()) {
          actions.insert(
            1,
            CupertinoActionSheetAction(
              child: Text(
                AppStrings.edit,
                style: AppStyles.interRegularStyle(color: AppColors.iosBlue),
              ),
              onPressed: () {
                Navigator.pop(context, AppStrings.edit);
                commentList[index].getIsUpating!.value = true;
                c.showCommentTextField = false;
                c.update();
              },
            ),
          );
          actions.add(
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              child: const Text(
                AppStrings.delete,
              ),
              onPressed: () {
                Navigator.pop(context, AppStrings.delete);
                c.deleteComment(
                    commentList, index, postId, postIdIndex, callback);
              },
            ),
          );
        }
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
              actions: actions,
              cancelButton: CupertinoActionSheetAction(
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
        padding: EdgeInsets.only(left: (level * 22.w), right: 22.w),
        child: Row(
          children: [
            //c.
            commentList[index].userInfoData!.profilePic.toString().isNotEmpty
                ? InkWell(
                    onTap: () async {
                      // if (c.userId.toString() ==
                      //     commentList[index].userInfoData.userId!.toString()) {
                      //   Get.back();
                      //   c.bsv.changePage(4);
                      //   return;
                      // }
                      SearchUser.setId =
                          //c.
                          commentList[index].userInfoData!.userId!.toString();
                      //c.dontReload = true;
                      Get.back();
                      await Get.delete<FriendUserProfileScreenVM>();
                      getToNamed(friendUserProfileScreeRoute);
                    },
                    child: MyAvatar(
                      url: ApiInterface.profileImgUrl +
                          //c.
                          commentList[index]
                              .userInfoData!
                              .profilePic
                              .toString(),
                      radiusAll: 16,
                      width: 40,
                      height: 40,
                      isNetwork: true,
                    ),
                  )
                : InkWell(
                    onTap: () async {
                      //if (c.userId.toString() ==
                      //     commentList[index].userInfoData.userId!.toString()) {
                      //   Get.back();
                      //   c.bsv.changePage(4);
                      //   return;
                      // }
                      SearchUser.setId =
                          //c.
                          commentList[index].userInfoData!.userId!.toString();
                      //c.dontReload = true;
                      Get.back();
                      await Get.delete<FriendUserProfileScreenVM>();
                      getToNamed(friendUserProfileScreeRoute);
                    },
                    child: MyAvatar(
                      url: AppImage.sampleAvatar,
                      radiusAll: 16,
                      width: 40,
                      height: 40,
                    ),
                  ),
            sizedBoxW(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                      onTap: () async {
                        //if (c.userId.toString() ==
                        //     commentList[index].userInfoData.userId!.toString()) {
                        //   Get.back();
                        //   c.bsv.changePage(4);
                        //   return;
                        // }
                        SearchUser.setId = //c.
                            commentList[index].userInfoData!.userId!.toString();
                        //c.dontReload = true;
                        Get.back();
                        await Get.delete<FriendUserProfileScreenVM>();
                        getToNamed(friendUserProfileScreeRoute);
                      },
                      child: Text(
                        //c.
                        commentList[index].userInfoData!.firstName.toString() +
                            " " +
                            //c.
                            commentList[index]
                                .userInfoData!
                                .lastName
                                .toString(),
                        style: AppStyles.interSemiBoldStyle(
                            fontSize: 16, color: AppColors.textColor),
                      )),
                  sizedBoxH(height: 2),
                  commentContent(c, commentList, index, postId, postIdIndex,
                      level, callback),
                  sizedBoxH(height: 5),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          var isLiked =
                              commentList[index].isCommentLikeByUser!.value;
                          if (commentList[index].isCommentLikeByUser!.value ==
                              0) {
                            commentList[index].commentLikeCount!.value++;
                            commentList[index].isCommentLikeByUser!.value = 1;
                          } else {
                            commentList[index].commentLikeCount!.value--;
                            commentList[index].isCommentLikeByUser!.value = 0;
                          }
                          c.update();
                          if (isLiked == 0) {
                            c.likeComment(commentList, index);
                          } else {
                            c.dislikeComment(commentList, index);
                          }
                        },
                        child: Obx(() => Row(
                              children: [
                                Icon(
                                    commentList[index]
                                                .isCommentLikeByUser!
                                                .value ==
                                            0
                                        ? Icons.thumb_up_outlined
                                        : Icons.thumb_up_off_alt_rounded,
                                    size: 12,
                                    color: AppColors.hintTextColor),
                                sizedBoxW(width: 3),
                                Text(
                                    commentList[index]
                                        .commentLikeCount!
                                        .value
                                        .toString(),
                                    style: AppStyles.interRegularStyle(
                                        fontSize: 12,
                                        color: AppColors.hintTextColor))
                              ],
                            )),
                      ),
                      sizedBoxW(width: 10),
                      InkWell(
                          onTap: () {
                            //c.
                            commentList[index].setIsReplying = true;
                            c.showCommentTextField = false;
                            debugPrint(
                                "commentList len ${commentList.length} ,index $index, isRplying ${commentList[index].getIsReplying}");
                            c.update();
                          },
                          child: Text(
                            "Reply",
                            style: AppStyles.interRegularStyle(
                                fontSize: 12, color: AppColors.hintTextColor),
                          )),
                    ],
                  )
                ],
              ),
            ),
            Obx(() => commentList[index].getIsUpating!.value
                ? Container()
                : Text(getTime(//c.
                        commentList[index].createdAt.toString()),
                    style: AppStyles.interRegularStyle(
                      fontSize: 12.8,
                      color: AppColors.hintTextColor,
                    )))
          ],
        ),
      ),
    );
  }

  static Widget viewAllComment(
      CommentsVM c, List<comm.Datum> commentList, int index, postId, level) {
    return //c.
        commentList[index].repliedToCount! > 0
            ? Obx(() => //!c.
                !commentList[index].getHideViewReplyText!
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () async {
                                await c.getChildComments(
                                    commentList,
                                    postId, //c.
                                    commentList[index].id.toString(),
                                    index);
                                //c.
                                commentList[index].setHideViewReplyText = true;
                              },
                              child: Text(
                                "------View ${commentList[index].repliedToCount} more replies",
                                style: AppStyles.interRegularStyle(
                                    fontSize: 12,
                                    color: AppColors.hintTextColor),
                              )),
                        ],
                      )
                    : Container())
            : Container();
  }

  static Widget showUsers(c, list, type, ScrollController b) {
    return Container(
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
                Text(
                    type == 0
                        ? AppStrings.peopleInThisPost
                        : type == 1
                            ? AppStrings.jioYou
                            : AppStrings.likes,
                    style: AppStyles.interSemiBoldStyle(
                        fontSize: 16.0, color: AppColors.textColor))
              ],
            ),
            Container(
              height: (MediaQuery.of(getContext()).size.height -
                      (MediaQuery.of(getContext()).size.height * 0.25))
                  .h,
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  list!.isEmpty
                      ? Center(
                          child: Text(
                          "No freinds available",
                          style: AppStyles.interRegularStyle(),
                        ))
                      : Expanded(
                          child: GridView.builder(
                              shrinkWrap: true,
                              //physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12.h,
                                mainAxisSpacing: 16.w,
                                mainAxisExtent: 105.h,
                              ),
                              itemCount: list.length, //25, //c.list.length,
                              itemBuilder: (context, index) {
                                return userCard(c, list, index, type);
                              }),
                        )
                ],
              ),
            ),
            // sizedBoxH(
            //   height: 10,
            // ),
          ],
        ));
  }

  static Widget userCard(c, list, index, type) {
    return InkWell(
      onTap: () async {
        if (type == 0) {
          //if (c.userId.toString() ==
          //     list[index].userId!.toString()) {
          //   Get.back();
          //   c.bsv.changePage(4);
          //   return;
          // }
          SearchUser.setId = list[index].userId!.toString();
        } else if (type == 2) {
          //if (c.userId.toString() ==
          //     list[index].userInfo.userId!.toString()) {
          //   Get.back();
          //   c.bsv.changePage(4);
          //   return;
          // }
          SearchUser.setId = list[index].userInfo.userId!.toString();
        } else {
          //if (c.userId.toString() ==
          //     list[index].jioMeUserList.userId!.toString()) {
          //   Get.back();
          //   c.bsv.changePage(4);
          //   return;
          // }
          SearchUser.setId = list[index].jioMeUserList.userId!.toString();
        }
        Get.back();
        await Get.delete<FriendUserProfileScreenVM>(force: true);
        getToNamed(friendUserProfileScreeRoute);
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
                  child: type == 2
                      ? list[index].userInfo.profilePic.toString().isNotEmpty
                          ? MyAvatar(
                              url: type == 2
                                  ? ApiInterface.profileImgUrl +
                                      list[index].userInfo.profilePic.toString()
                                  : ApiInterface.profileImgUrl +
                                      list[index].profilePic.toString(),
                              height: 72,
                              width: 72,
                              radiusAll: 28.8,
                              isNetwork: true,
                            )
                          : MyAvatar(
                              url: AppImage.sampleAvatar,
                              height: 72,
                              width: 72,
                              radiusAll: 28.8)
                      : type == 1
                          ? list[index].jioMeUserList.profilePic!.isNotEmpty
                              ? MyAvatar(
                                  url: ApiInterface.profileImgUrl +
                                      list[index]
                                          .jioMeUserList
                                          .profilePic
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
                                  radiusAll: 28.8)
                          : list[index].profilePic!.isNotEmpty
                              ? MyAvatar(
                                  url: type == 2
                                      ? ApiInterface.profileImgUrl +
                                          list[index]
                                              .userInfo
                                              .profilePic
                                              .toString()
                                      : ApiInterface.profileImgUrl +
                                          list[index].profilePic.toString(),
                                  height: 72,
                                  width: 72,
                                  radiusAll: 28.8,
                                  isNetwork: true,
                                )
                              : MyAvatar(
                                  url: AppImage.sampleAvatar,
                                  height: 72,
                                  width: 72,
                                  radiusAll: 28.8),
                ),
              ],
            )),
            sizedBoxH(
              height: 7,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    type == 2
                        ? list[index].userInfo.firstName.toString() +
                            " " +
                            list[index].userInfo.lastName.toString()
                        : type == 1
                            ? list[index].jioMeUserList.firstName.toString() +
                                " " +
                                list[index].jioMeUserList.lastName.toString()
                            : list[index].firstName.toString() +
                                " " +
                                list[index].lastName.toString(),
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
  }
}

class MyVideoPlayer extends StatelessWidget {
  const MyVideoPlayer({
    required this.controller,
    this.height,
    this.width,
    this.radiusTL,
    this.radiusTR,
    this.radiusBL,
    this.radiusBR,
    this.radiusAll,
    Key? key,
  }) : super(key: key);

  final VideoPlayerController controller;
  final double? width;
  final double? height;
  final double? radiusTL, radiusTR, radiusBL, radiusBR, radiusAll;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        controller.value.isInitialized
            ? Container(
                height: height == null ? 240.h : height?.h,
                width: width == null ? double.infinity : width?.w,
                decoration: BoxDecoration(
                  borderRadius: radiusAll != null
                      ? BorderRadius.circular(
                          radiusAll == null ? 20.r : radiusAll!.r)
                      : BorderRadius.only(
                          bottomLeft: Radius.circular(
                              radiusBL == null ? 0.r : radiusBL!.r),
                          bottomRight: Radius.circular(
                              radiusBR == null ? 0.r : radiusBR!.r),
                          topLeft: Radius.circular(
                              radiusTL == null ? 0.r : radiusTL!.r),
                          topRight: Radius.circular(
                              radiusTR == null ? 0.r : radiusTR!.r)),
                ),
                child: ClipRRect(
                    borderRadius: radiusAll != null
                        ? BorderRadius.circular(
                            radiusAll == null ? 20.r : radiusAll!.r)
                        : BorderRadius.only(
                            bottomLeft: Radius.circular(
                                radiusBL == null ? 0.r : radiusBL!.r),
                            bottomRight: Radius.circular(
                                radiusBR == null ? 0.r : radiusBR!.r),
                            topLeft: Radius.circular(
                                radiusTL == null ? 0.r : radiusTL!.r),
                            topRight: Radius.circular(
                                radiusTR == null ? 0.r : radiusTR!.r)),
                    child:
                        // FutureBuilder(
                        //     future: Future(() => controller.value.isInitialized),
                        //     builder: (context, snapshot) {
                        //       if (snapshot.connectionState == ConnectionState.done) {
                        //         return
                        AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(
                        controller,
                      ),
                    )
                    //                   ;
                    //                 } else {
                    // return                  Center(
                    //                       child: CircularProgressIndicator(
                    //                     color: AppColors.orangePrimary,
                    //                     strokeWidth: 0.5,
                    //                   ));
                    //                 }
                    //               }),
                    ),
              )
            : const Center(
                child: CircularProgressIndicator(
                color: AppColors.orangePrimary,
                strokeWidth: 0.5,
              )),
        Positioned(
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          color: const Color(0x8A000000)),
                      height: 35.h,
                      width: 35.h,
                      // padding:
                      //     EdgeInsets.symmetric(
                      //         horizontal: 8.w,
                      //         vertical: 8.h),
                      child: Center(
                          child: Icon(
                        controller.value.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: Colors.white,
                      ))),
                )))
      ],
    );
  }
}

class MyAvatar extends StatelessWidget {
  MyAvatar({
    required this.url,
    this.height,
    this.width,
    this.radiusTL,
    this.radiusTR,
    this.radiusBL,
    this.radiusBR,
    this.radiusAll,
    this.isSVG = false,
    this.isFile = false,
    this.isNetwork = false,
    Key? key,
  }) : super(key: key);

  double? height;
  double? width;
  String? url;
  double? radiusTL, radiusTR, radiusBL, radiusBR, radiusAll;
  bool? isSVG, isFile, isNetwork;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height == null ? 50.h : height?.h,
      width: width == null ? 50.w : width?.w,
      decoration: BoxDecoration(
        borderRadius: radiusAll != null
            ? BorderRadius.circular(radiusAll == null ? 20.r : radiusAll!.r)
            : BorderRadius.only(
                bottomLeft:
                    Radius.circular(radiusBL == null ? 0.r : radiusBL!.r),
                bottomRight:
                    Radius.circular(radiusBR == null ? 0.r : radiusBR!.r),
                topLeft: Radius.circular(radiusTL == null ? 0.r : radiusTL!.r),
                topRight:
                    Radius.circular(radiusTR == null ? 0.r : radiusTR!.r)),
      ),
      child: ClipRRect(
        borderRadius: radiusAll != null
            ? BorderRadius.circular(radiusAll == null ? 20.r : radiusAll!.r)
            : BorderRadius.only(
                bottomLeft:
                    Radius.circular(radiusBL == null ? 0.r : radiusBL!.r),
                bottomRight:
                    Radius.circular(radiusBR == null ? 0.r : radiusBR!.r),
                topLeft: Radius.circular(radiusTL == null ? 0.r : radiusTL!.r),
                topRight:
                    Radius.circular(radiusTR == null ? 0.r : radiusTR!.r)),
        child: isSVG!
            ? SvgPicture.asset(
                url!,
                fit: BoxFit.cover,
              )
            : isFile!
                ? Image.file(File(url!), fit: BoxFit.cover)
                : isNetwork!
                    ? Image.network(
                        url!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: AppColors.orangePrimary,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Text(
                              "Unable to load image",
                              style: AppStyles.interMediumStyle(fontSize: 14),
                            ),
                          );
                        },
                      )
                    : Image.asset(url!, fit: BoxFit.cover),
      ),
    );
  }
}

class ActivitySearchedCard extends StatelessWidget {
  const ActivitySearchedCard(
      {required this.activity, this.onTap, this.margin, Key? key})
      : super(key: key);

  final PostOrActivity activity;
  final VoidCallback? onTap;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    //EVENT CARD TEMP HIDE START
    return Container(
      margin: margin ?? EdgeInsets.only(left: 22.w, right: 22.w, top: 16.h),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16.r),
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isValidString(activity.coverImage)
                    ? MyAvatar(
                        url: ApiInterface.profileImgUrl +
                            activity.coverImage.toString(),
                        width: 64,
                        height: 64,
                        radiusAll: 25.6,
                        isNetwork: true,
                      )
                    : MyAvatar(
                        url: AppImage.sampleAvatar,
                        width: 64,
                        height: 64,
                        radiusAll: 25.6,
                      ),
                sizedBoxW(width: 14),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            activity.activityName.toString(),
                            style: AppStyles.interSemiBoldStyle(
                                fontSize: 16, color: AppColors.textColor),
                          ),
                        )
                      ],
                    ),
                    sizedBoxH(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${activity.activityDate.toString()} by ",
                          style: AppStyles.interRegularStyle(
                              fontSize: 13.2, color: AppColors.hintTextColor),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  (activity.group != null &&
                                          activity.group is Map)
                                      ? activity.group["groupName"].toString()
                                      : isValidString(activity.group)
                                          ? activity.group.toString()
                                          : "N/A",
                                  style: AppStyles.interMediumStyle(
                                      fontSize: 13.2,
                                      color: AppColors.editBorderColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
    //sizedBoxH(height: isProfilePost ? 16 : 0),
    //EVENT CARD TEMP HIDE END
  }
}

class GroupSearchedCard extends StatelessWidget {
  const GroupSearchedCard(
      {required this.group, this.onTap, this.onJoinTapped, Key? key})
      : super(key: key);

  final GroupData group;
  final VoidCallback? onTap;
  final VoidCallback? onJoinTapped;

  @override
  Widget build(BuildContext context) {
    //EVENT CARD TEMP HIDE START
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        //borderRadius: BorderRadius.circular(16.r),
      ),
      child: Material(
        //borderRadius: BorderRadius.circular(16.r),
        type: MaterialType.transparency,
        child: InkWell(
          //borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 22.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isValidString(group.group!.groupImage.toString())
                    ? MyAvatar(
                        url: ApiInterface.profileImgUrl +
                            group.group!.groupImage.toString(),
                        width: 64,
                        height: 64,
                        radiusAll: 25.6,
                        isNetwork: true,
                      )
                    : MyAvatar(
                        url: AppImage.avatar2,
                        width: 64,
                        height: 64,
                        radiusAll: 25.6,
                      ),
                sizedBoxW(width: 14),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            group.group!.groupName.toString(),
                            style: AppStyles.interSemiBoldStyle(
                                fontSize: 16, color: AppColors.textColor),
                          ),
                        )
                      ],
                    ),
                    sizedBoxH(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${group.memberCount.toString()} members",
                          style: AppStyles.interRegularStyle(
                              fontSize: 13.2, color: AppColors.hintTextColor),
                        ),
                      ],
                    )
                  ],
                )),
                group.isMember!
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.r),
                            color: group.isJoinedGroup!
                                ? AppColors.disabledColor
                                : group.isMember!
                                    ? AppColors.disabledColor
                                    : null,
                            gradient: group.isJoinedGroup!
                                ? null
                                : !group.isMember!
                                    ? const LinearGradient(colors: [
                                        Color(0xffFFD036),
                                        Color(0xffFFA43C)
                                      ], transform: GradientRotation(240) //120
                                        )
                                    : null),
                        child: Material(
                          type: MaterialType.transparency,
                          borderRadius: BorderRadius.circular(100.r),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100.r),
                            onTap: group.isJoinedGroup! ? null : onJoinTapped,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    group.isJoinedGroup! ? "Pending" : "Join",
                                    style: AppStyles.interMediumStyle(
                                        fontSize: 14.4, color: AppColors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
    //sizedBoxH(height: isProfilePost ? 16 : 0),
    //EVENT CARD TEMP HIDE END
  }
}
