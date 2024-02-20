import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jyo_app/data/local/post_edit_model.dart';
import 'package:jyo_app/data/remote/api_interface.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/utils/app_widgets/app_bar.dart';
import 'package:jyo_app/utils/app_widgets/app_gradient_btn.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view/create_post_screen_view.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/activity_details_screen_vm.dart';
import 'package:jyo_app/view_model/create_activity_screen_vm.dart';
import 'package:latlong2/latlong.dart';

import '../data/local/user_search_model.dart';
import '../models/activity_model/activity_details_model.dart';
import '../models/activity_model/activity_request_list_model.dart';
import '../resources/app_colors.dart';
import '../resources/app_image.dart';
import '../resources/app_strings.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_icon_button.dart';
import '../view_model/explore_screen_vm.dart';
import '../view_model/freind_user_profile_screen_vm.dart';
import 'explore_screen_view.dart';
import '../data/local/tab_data.dart' as t;
import 'package:badges/badges.dart' as badges;
import 'package:add_2_calendar/add_2_calendar.dart';

class ActivityDetailsScreeView extends StatelessWidget {
  const ActivityDetailsScreeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActivityDetailsScreenVM>(builder: (c) {
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
            actions: c.isLoadingActs
                ? []
                : c.postsVM.activitiesList.isEmpty
                    ? []
                    : (c.postsVM.activitiesList[0].privateActivity! &&
                            !c.postsVM.activitiesList[0].isMember!)
                        ? []
                        : [
                            InkWell(
                              onTap: () {
                                c.postsVM.activitiesList[0].isSaved =
                                    !c.postsVM.activitiesList[0].isSaved!;
                                c.update();
                                c.postsVM.saveActivity({
                                  "activityId": c
                                      .postsVM.activitiesList[0].activityId
                                      .toString(),
                                  "userId": c.userId.toString(),
                                  "isSaved":
                                      c.postsVM.activitiesList[0].isSaved!
                                          ? "1"
                                          : "0"
                                });
                              },
                              child: Container(
                                  width: 34.w,
                                  height: 34.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: AppColors.tabBkgColor,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      c.postsVM.activitiesList[0].isSaved!
                                          ? AppIcons.bookmarkSvg
                                          : AppIcons.bookmarkUs,
                                      width: 20,
                                      height: 20,
                                    ),
                                  )),
                            ),
                            sizedBoxW(width: 12),
                            (c.postsVM.activitiesList[0].privateActivity! &&
                                    !c.postsVM.activitiesList[0].isMember!)
                                ? Container()
                                : MyIconButton(
                                    onTap: () async {
                                      //getToNamed(createGroupScreenRoute);

                                      showAppDialog(
                                        msg:
                                            "Are you sure you want to share this as post.",
                                        btnText: "Yes",
                                        btnText2: "No",
                                        onPressed: () async {
                                          Get.back();
                                          getToNamed(createPostScreenRoute,
                                              argument: {
                                                "coverImage": c
                                                    .postsVM
                                                    .activitiesList[0]
                                                    .coverImage!,
                                                "activityName": c
                                                    .postsVM
                                                    .activitiesList[0]
                                                    .activityName,
                                                "activityDate": c
                                                    .postsVM
                                                    .activitiesList[0]
                                                    .activityDate,
                                                "group": c.postsVM
                                                    .activitiesList[0].group,
                                                "activityId": c
                                                    .postsVM
                                                    .activitiesList[0]
                                                    .activityId
                                              });
                                          // await c.shareActivityAsPost({
                                          //   "activityId": c.activityId.toString(),
                                          //   "userId": c.userId.toString(),
                                          //   "groupId": null
                                          // });
                                        },
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
                                      if (c.isHost! || c.isSubHost!) {
                                        actions.add(
                                          CupertinoActionSheetAction(
                                              child: Text(
                                                AppStrings.editAct,
                                                style:
                                                    AppStyles.interRegularStyle(
                                                        color:
                                                            AppColors.iosBlue),
                                              ),
                                              onPressed: () async {
                                                Navigator.pop(context,
                                                    AppStrings.editAct);
                                                PostEdit.postOrActivity =
                                                    c.postsVM.activitiesList[0];
                                                Get.delete<
                                                    CreateActivityScreenVM>();
                                                await getToNamed(
                                                    createActivityScreenRoute);
                                                //c.init();

                                                //Edit activity,
                                              }),
                                        );
                                      }

                                      if (c.isHost!) {
                                        actions.add(CupertinoActionSheetAction(
                                          child: Text(
                                            AppStrings.leaveActivityAsHost,
                                            style: AppStyles.interRegularStyle(
                                                color: Colors.red),
                                          ),
                                          onPressed: () async {
                                            Navigator.pop(context,
                                                AppStrings.leaveActivity);
                                            showAppDialog(
                                              msg:
                                                  "Are you sure you want to leave this activity",
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
                                          },
                                        ));
                                      } else if (c
                                          .postsVM.activitiesList[0].isMember!)
                                      //(c.isSubHost! || c.postsVM.activitiesList[0].isMember!)
                                      {
                                        actions.add(CupertinoActionSheetAction(
                                          child: Text(
                                            AppStrings.leaveActivity,
                                            style: AppStyles.interRegularStyle(
                                                color: Colors.red),
                                          ),
                                          onPressed: () async {
                                            Navigator.pop(context,
                                                AppStrings.leaveActivity);
                                            showAppDialog(
                                              msg:
                                                  "Are you sure you want to leave this activity",
                                              btnText: "yes",
                                              onPressed: () async {
                                                Get.back();
                                                await c.postsVM.leaveActivity({
                                                  "userId": c.postsVM.userId
                                                      .toString(),
                                                  "activityId":
                                                      c.activityId.toString()
                                                });
                                                c.init(withoutArg: true);
                                              },
                                              btnText2: "No",
                                            );
                                          },
                                        ));
                                      }
                                      if (!c.isHost!) {
                                        actions.add(CupertinoActionSheetAction(
                                          child: Text(
                                            AppStrings.reportActivity,
                                            style: AppStyles.interRegularStyle(
                                                color: Colors.red),
                                          ),
                                          onPressed: () async {
                                            Navigator.of(getContext(),
                                                    rootNavigator: false)
                                                .pop();
                                            showFlexibleBottomSheet(
                                              initHeight: 0.55,
                                              isExpand: true,
                                              minHeight: 0,
                                              maxHeight: 0.85,
                                              bottomSheetColor:
                                                  Colors.transparent,
                                              context: getContext(),
                                              builder: (a, b, c) {
                                                return reportActivity(b);
                                              },
                                              isSafeArea: true,
                                            );
                                          },
                                        ));
                                      }

                                      if (c.isHost!) {
                                        actions.add(CupertinoActionSheetAction(
                                          child: Text(
                                            AppStrings.deleteAct,
                                            style: AppStyles.interRegularStyle(
                                                color: Colors.red),
                                          ),
                                          onPressed: () async {
                                            Navigator.pop(
                                                context, AppStrings.deleteAcc);
                                            showAppDialog(
                                                msg:
                                                    "Are you want to delete this activity?",
                                                btnText: "Yes",
                                                btnText2: "No",
                                                onPressed: () async {
                                                  Get.back();
                                                  await c.postsVM
                                                      .deleteActivity(
                                                          c.activityId
                                                              .toString()
                                                              .toString(),
                                                          c);
                                                  if (c.isFromExplore) {
                                                    Get.delete<
                                                        ExploreScreenVM>();
                                                    Get.back();
                                                    c.bsvm.changePage(0);
                                                  } else {
                                                    Get.back();
                                                  }
                                                });
                                          },
                                        ));
                                      }

                                      return CupertinoActionSheet(
                                          // title: const Text('Choose Options'),
                                          // message: const Text('Your options are '),
                                          actions: actions,
                                          cancelButton:
                                              CupertinoActionSheetAction(
                                            child: Text(
                                              AppStrings.cancel,
                                              style:
                                                  AppStyles.interRegularStyle(
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
          body: c.isLoadingActs
              ? const Center(
                  child: CircularProgressIndicator(
                  backgroundColor: AppColors.orangePrimary,
                ))
              : c.postsVM.activitiesList.isEmpty
                  ? Center(
                      child: Text(
                      "Activity does not exists.",
                      style: AppStyles.interMediumStyle(),
                    ))
                  : ListView(
                      children: [
                        !c.isInvited!
                            ? Container()
                            : Container(
                                color: AppColors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 22.w, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        "You have been invited to this activity\nDo you want to join.",
                                        style: AppStyles.interMediumStyle()),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                                onTap: () async {
                                                  await c.notiVM
                                                      .rejectActivityInvite(
                                                          data: {
                                                        "userId":
                                                            c.userId.toString(),
                                                        "activityId": c
                                                            .activityId
                                                            .toString()
                                                      });
                                                  c.init(withoutArg: true);
                                                },
                                                child: SvgPicture.asset(
                                                    AppIcons.ignoreActSvg)),
                                            sizedBoxW(width: 8),
                                            InkWell(
                                                onTap: () async {
                                                  await c.notiVM
                                                      .acceptActivityInvite(
                                                          data: {
                                                        "userId":
                                                            c.userId.toString(),
                                                        "activityId": c
                                                            .activityId
                                                            .toString()
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
                        sizedBoxH(height: !c.isInvited! ? 0 : 8),
                        c.isHost!
                            ? InkWell(
                                onTap: () {
                                  showInviteSheet();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 22.w, vertical: 16.h),
                                  color: AppColors.white,
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppImage.invite,
                                        width: 40.w,
                                        height: 40.h,
                                      ),
                                      sizedBoxW(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              AppStrings.inviteYourFriend,
                                              style:
                                                  AppStyles.interSemiBoldStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              AppStrings.inviteYFinfo,
                                              style:
                                                  AppStyles.interRegularStyle(
                                                      fontSize: 14,
                                                      color: AppColors
                                                          .hintTextColor),
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: const Icon(
                                          Icons.keyboard_arrow_right,
                                          size: 24,
                                          color: AppColors.textColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        c.isHost! ? sizedBoxH(height: 8) : Container(),
                        Container(
                          color: AppColors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 22.w),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.postsVM.activitiesList[0].activityName
                                      .toString(),
                                  style: AppStyles.interBoldStyle(fontSize: 22),
                                ),
                                sizedBoxH(height: 8),
                                (c.postsVM.activitiesList[0].privateActivity! &&
                                        !c.postsVM.activitiesList[0].isMember!)
                                    ? Container()
                                    : Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppIcons.markerBig,
                                            width: 18.w,
                                            height: 18.h,
                                          ),
                                          sizedBoxW(width: 4),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    c.locationText.toString(),
                                                    style: AppStyles
                                                        .interMediumStyle(
                                                            fontSize: 15,
                                                            color: AppColors
                                                                .orangePrimary),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                (c.postsVM.activitiesList[0].privateActivity! &&
                                        !c.postsVM.activitiesList[0].isMember!)
                                    ? Container()
                                    : sizedBoxH(height: 16),
                                MyAvatar(
                                  url: isValidString(c
                                          .postsVM.activitiesList[0].coverImage)
                                      ? ApiInterface.postImgUrl +
                                          c.postsVM.activitiesList[0].coverImage
                                              .toString()
                                      : AppImage.addCover,
                                  isNetwork: isValidString(
                                      c.postsVM.activitiesList[0].coverImage),
                                  isSVG: !isValidString(
                                      c.postsVM.activitiesList[0].coverImage),
                                  width: double.infinity,
                                  height: 216,
                                  radiusAll: 16,
                                ),
                                sizedBoxH(height: 16),
                                (c.postsVM.activitiesList[0].privateActivity! &&
                                        !c.postsVM.activitiesList[0].isMember!)
                                    ? Container()
                                    : Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppIcons.groupAd,
                                            width: 30.w,
                                            height: 30.h,
                                          ),
                                          sizedBoxW(width: 7.4),
                                          Text(
                                            c.members.length.toString(),
                                            // c.postsVM.activitiesList[0]
                                            //     .activityParticipantsCount,
                                            style: AppStyles.interRegularStyle(
                                                fontSize: 16),
                                          ),
                                          sizedBoxW(width: 6),
                                          Text(
                                            "•",
                                            style: AppStyles.interRegularStyle(
                                                fontSize: 16),
                                          ),
                                          sizedBoxW(width: 6),
                                          Text(
                                            c.postsVM.activitiesList[0]
                                                    .privateActivity!
                                                ? "Private"
                                                : "Public",
                                            style: AppStyles.interRegularStyle(
                                                fontSize: 15,
                                                color: AppColors.hintTextColor),
                                          ),
                                        ],
                                      ),
                                (c.postsVM.activitiesList[0].privateActivity! &&
                                        !c.postsVM.activitiesList[0].isMember!)
                                    ? Container()
                                    : sizedBoxH(
                                        height: c.members.isEmpty ? 0 : 16),
                                //UserLIst
                                (c.postsVM.activitiesList[0].privateActivity! &&
                                        !c.postsVM.activitiesList[0].isMember!)
                                    ? Container()
                                    : c.members.isEmpty
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              getToNamed(
                                                  activityParticipantsScreenRoute);
                                            },
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: List.generate(
                                                          c.members.length > 8
                                                              ? 8
                                                              : c.members
                                                                  .length,
                                                          (index) {
                                                        return Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 8.w),
                                                          child: MyAvatar(
                                                            url: ApiInterface
                                                                    .profileImgUrl +
                                                                c
                                                                    .members[
                                                                        index]
                                                                    .user!
                                                                    .userInfo!
                                                                    .profilePic
                                                                    .toString(),
                                                            width: 40,
                                                            height: 40,
                                                            radiusAll: 16,
                                                            isNetwork: true,
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  ),
                                                ),
                                                c.members.length >= 8
                                                    ? InkWell(
                                                        onTap: () {
                                                          getToNamed(
                                                              activityParticipantsScreenRoute);
                                                        },
                                                        child: const Icon(
                                                          Icons
                                                              .keyboard_arrow_right,
                                                          size: 40,
                                                          color: AppColors
                                                              .textColor,
                                                        ),
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                (c.postsVM.activitiesList[0].privateActivity! &&
                                        !c.postsVM.activitiesList[0].isMember!)
                                    ? Container()
                                    : sizedBoxH(height: 16),
                                (c.postsVM.activitiesList[0].privateActivity! &&
                                        !c.postsVM.activitiesList[0].isMember!)
                                    ? Container()
                                    : Text(
                                        (DateFormat("EEEE dd MMMM yyyy").format(
                                            DateTime.parse(c
                                                .postsVM
                                                .activitiesList[0]
                                                .activityDate!))),
                                        style: AppStyles.interSemiBoldStyle(
                                            fontSize: 18),
                                      ),
                                (c.postsVM.activitiesList[0].privateActivity! &&
                                        !c.postsVM.activitiesList[0].isMember!)
                                    ? Container()
                                    : sizedBoxH(height: 4),
                                (c.postsVM.activitiesList[0].privateActivity! &&
                                        !c.postsVM.activitiesList[0].isMember!)
                                    ? Container()
                                    : Text(
                                        "${DateFormat("hh.mm a").format(DateTime.parse(c.postsVM.activitiesList[0].activityDate!))} ${getTimeZone((DateTime.parse(c.postsVM.activitiesList[0].activityDate!).toLocal().timeZoneOffset))}",
                                        style: AppStyles.interRegularStyle(
                                            fontSize: 15,
                                            color: AppColors.hintTextColor),
                                      ),
                                (c.postsVM.activitiesList[0].privateActivity! &&
                                        !c.postsVM.activitiesList[0].isMember!)
                                    ? Container()
                                    : sizedBoxH(height: 16),
                                (c.postsVM.activitiesList[0].privateActivity! &&
                                        !c.postsVM.activitiesList[0].isMember!)
                                    ? Container()
                                    : Text(
                                        (c.postsVM.activitiesList[0]
                                                        .activityAbout
                                                        .toString()
                                                        .trim()
                                                        .length >
                                                    100 &&
                                                !c.isReadingMore)
                                            ? c.postsVM.activitiesList[0]
                                                    .activityAbout
                                                    .toString()
                                                    .trim()
                                                    .substring(0, 100) +
                                                "..."
                                            : c.postsVM.activitiesList[0]
                                                .activityAbout
                                                .toString()
                                                .trim(),
                                        style: AppStyles.interRegularStyle(
                                            fontSize: 17.2),
                                      ),
                                c.postsVM.activitiesList[0].activityAbout
                                            .toString()
                                            .trim()
                                            .length >
                                        100
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
                                (c.postsVM.activitiesList[0].privateActivity! &&
                                        !c.postsVM.activitiesList[0].isMember!)
                                    ? Container()
                                    : sizedBoxH(height: 16),
                                //List of Category
                                (c.postsVM.activitiesList[0].privateActivity! &&
                                        !c.postsVM.activitiesList[0].isMember!)
                                    ? Container()
                                    : SizedBox(
                                        height: 46.h,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: c
                                                .postsVM
                                                .activitiesList[0]
                                                .category!
                                                .length,
                                            itemBuilder: (context, index) {
                                              return mostLikedCard(
                                                  category: c
                                                      .postsVM
                                                      .activitiesList[0]
                                                      .category![index]);
                                            }),
                                      ),
                                (c.postsVM.activitiesList[0].privateActivity! &&
                                        !c.postsVM.activitiesList[0].isMember!)
                                    ? Container()
                                    : sizedBoxH(height: 16),
                                (c.postsVM.activitiesList[0].privateActivity! &&
                                        !c.postsVM.activitiesList[0].isMember!)
                                    ? Container()
                                    : Container(
                                        height: 216.h,
                                        width: double
                                            .infinity, //MediaQuery.of(getContext()).size.width / 2.5,
                                        decoration: BoxDecoration(
                                          color: AppColors.lightGray,
                                          borderRadius:
                                              BorderRadius.circular(16.r),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16.r),
                                          child: Stack(
                                            children: [
                                              c.postsVM.activitiesList[0]
                                                      .location!.isEmpty
                                                  ? Center(
                                                      child: Text(
                                                        "No location\nfound",
                                                        style: AppStyles
                                                            .interMediumStyle(
                                                                fontSize: 12),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )
                                                  : FlutterMap(
                                                      //mapController: c.mapController,

                                                      options: MapOptions(
                                                          minZoom: 5,
                                                          maxZoom: 18,
                                                          zoom: 16,
                                                          center: LatLng(
                                                              c
                                                                  .postsVM
                                                                  .activitiesList[
                                                                      0]
                                                                  .location![0],
                                                              c
                                                                      .postsVM
                                                                      .activitiesList[
                                                                          0]
                                                                      .location![
                                                                  1]),
                                                          onTap: (tapPosition,
                                                              point) {
                                                            debugPrint(
                                                                "Lat long onTaped ${point.latitude}, ${point.longitude}");
                                                          }),
                                                      children: [
                                                        TileLayer(
                                                          urlTemplate: MapConstants
                                                              .tempTemplateUrl,
                                                          additionalOptions: const {
                                                            "access_token":
                                                                MapConstants
                                                                    .accessToken,
                                                          },
                                                          userAgentPackageName:
                                                              MapConstants
                                                                  .userAgentPackageName,
                                                        ),
                                                        MarkerLayer(
                                                            markers: c
                                                                .postsVM
                                                                .activitiesList[
                                                                    0]
                                                                .markers!),
                                                      ],
                                                    ),
                                              Positioned(
                                                  child: Container(
                                                      color: Colors.transparent,
                                                      height: 216.h,
                                                      width: double.infinity
                                                      //MediaQuery.of(getContext()).size.width / 2.5,
                                                      ))
                                            ],
                                          ),
                                        ),
                                      ),
                              ]),
                        ),
                        sizedBoxH(height: 8),
                        Container(
                          color: AppColors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 22.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              MyAvatar(
                                url: ApiInterface.postImgUrl +
                                    c.postsVM.activitiesList[0].host!.profilePic
                                        .toString(),
                                height: 40,
                                width: 40,
                                radiusAll: 16,
                                isNetwork: true,
                              ),
                              sizedBoxW(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.postsVM.activitiesList[0].host!
                                              .firstName
                                              .toString() +
                                          " " +
                                          c.postsVM.activitiesList[0].host!
                                              .lastName
                                              .toString(),
                                      style: AppStyles.interSemiBoldStyle(
                                          fontSize: 16),
                                    ),
                                    Text(
                                      "Host",
                                      style: AppStyles.interMediumStyle(
                                          fontSize: 14,
                                          color: AppColors.hintTextColor),
                                    )
                                  ],
                                ),
                              ),
                              sizedBoxW(width: 12),
                              InkWell(
                                onTap: () {
                                  showCupertinoModalPopup(
                                      context: getContext(),
                                      builder: (BuildContext context) {
                                        List<CupertinoActionSheetAction>
                                            actions =
                                            List.empty(growable: true);
                                        //if (!c.isHost!) {
                                        actions.add(
                                          CupertinoActionSheetAction(
                                              child: Text(
                                                AppStrings.checkHostProfile,
                                                style:
                                                    AppStyles.interRegularStyle(
                                                        color:
                                                            AppColors.iosBlue),
                                              ),
                                              onPressed: () async {
                                                Navigator.pop(context,
                                                    AppStrings.editAct);
                                                SearchUser.setId = c
                                                    .postsVM
                                                    .activitiesList[0]
                                                    .host!
                                                    .userId
                                                    .toString();
                                                //Get.back();
                                                Get.delete<
                                                        FriendUserProfileScreenVM>(
                                                    force: true);
                                                getToNamed(
                                                    friendUserProfileScreeRoute);
                                                //c.init();

                                                //Edit activity,
                                              }),
                                        );
                                        //}

                                        return CupertinoActionSheet(
                                            // title: const Text('Choose Options'),
                                            // message: const Text('Your options are '),
                                            actions: actions,
                                            cancelButton:
                                                CupertinoActionSheetAction(
                                              child: Text(
                                                AppStrings.cancel,
                                                style:
                                                    AppStyles.interRegularStyle(
                                                        color:
                                                            AppColors.iosBlue),
                                              ),
                                              isDefaultAction: true,
                                              onPressed: () {
                                                Navigator.pop(
                                                    context, AppStrings.cancel);
                                              },
                                            ));
                                      });
                                },
                                child: const RotatedBox(
                                  quarterTurns: 1,
                                  child: Icon(
                                    Icons.more_vert_rounded,
                                    color: AppColors.textColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        sizedBoxH(height: 8),
                        (c.postsVM.activitiesList[0].privateActivity! &&
                                !c.postsVM.activitiesList[0].isMember!)
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  final Event event = Event(
                                    title: c
                                        .postsVM.activitiesList[0].activityName
                                        .toString(),
                                    description: c
                                        .postsVM.activitiesList[0].activityAbout
                                        .toString(),
                                    location: c.locationText.toString(),
                                    startDate: DateTime.parse(c.postsVM
                                        .activitiesList[0].activityDate!),
                                    endDate: DateTime.parse(c.postsVM
                                        .activitiesList[0].activityDate!),
                                    iosParams: const IOSParams(
                                      reminder: Duration(
                                          minutes:
                                              30 /* Ex. hours:1 */), // on iOS, you can set alarm notification after your event.
                                      // url: 'https://www.example.com', // on iOS, you can set url to your event.
                                    ),
                                    androidParams: const AndroidParams(
                                      emailInvites: [], // on Android, you can add invite emails to your event.
                                    ),
                                  );
                                  Add2Calendar.addEvent2Cal(event);
                                },
                                child: Container(
                                  color: AppColors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 22.w),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      MyAvatar(
                                        url: AppIcons.calAd,
                                        height: 40,
                                        width: 40,
                                        radiusAll: 16,
                                        isSVG: true,
                                      ),
                                      sizedBoxW(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Add to your calendar",
                                              style:
                                                  AppStyles.interSemiBoldStyle(
                                                      fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      sizedBoxW(width: 12),
                                      const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: AppColors.textColor,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                        (c.postsVM.activitiesList[0].privateActivity! &&
                                !c.postsVM.activitiesList[0].isMember!)
                            ? Container()
                            : sizedBoxH(height: 8),
                        (c.postsVM.activitiesList[0].privateActivity! &&
                                !c.postsVM.activitiesList[0].isMember!)
                            ? Container()
                            : Container(
                                color: AppColors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 22.w),
                                child: (c.isHost! || c.isSubHost!)
                                    ? c.tabs.isNotEmpty
                                        ? MyTabBar(
                                            children: List.generate(
                                                c.tabs.length, (index) {
                                              return TabChild(
                                                tabData: c.tabs[index],
                                                selectedIndex:
                                                    c.selectedTab!.index,
                                                showBadge:
                                                    c.tabs[index].showBadge,
                                                onTabSelected: () {
                                                  c.selectedTab = c.tabs[index];
                                                  c.update();
                                                },
                                              );
                                            }),
                                          )
                                        : Container()
                                    : Text(
                                        "Comments (${c.commentCount})",
                                        style: AppStyles.interSemiBoldStyle(
                                          fontSize: 18,
                                        ),
                                      )),
                        (c.postsVM.activitiesList[0].privateActivity! &&
                                !c.postsVM.activitiesList[0].isMember!)
                            ? Container()
                            : Container(
                                color: AppColors.white,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: (c.isHost! || c.isSubHost!)
                                    ? c.selectedTab!.index ==
                                            t.ActivityTabs.commentTab
                                        ? CommentSection(c: c)
                                        : RequestSection(
                                            children: c.requestList.isEmpty
                                                ? [
                                                    SizedBox(
                                                      width: double.infinity,
                                                      height: 250.h,
                                                      child: Center(
                                                          child: Text(
                                                        "No requests yet.",
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
                                                          "hostId": c
                                                              .postsVM
                                                              .activitiesList[0]
                                                              .host!
                                                              .userId
                                                              .toString(),
                                                          "userId": c
                                                              .requestList[
                                                                  index]
                                                              .user!
                                                              .id
                                                              .toString(),
                                                          "activityId": c
                                                              .activityId
                                                              .toString(),
                                                          "isAccept": "1"
                                                        });
                                                        c.init(
                                                            withoutArg: true);
                                                      },
                                                      onReject: () {
                                                        c.acceptRequestToJoin({
                                                          "hostId": c
                                                              .postsVM
                                                              .activitiesList[0]
                                                              .host!
                                                              .userId
                                                              .toString(),
                                                          "userId": c
                                                              .requestList[
                                                                  index]
                                                              .user!
                                                              .id
                                                              .toString(),
                                                          "activityId": c
                                                              .activityId
                                                              .toString(),
                                                          "isAccept": "0"
                                                        });
                                                        c.init(
                                                            withoutArg: true);
                                                      },
                                                    );
                                                  }),
                                          )
                                    : CommentSection(
                                        c: c,
                                      )),
                      ],
                    ),
          bottomNavigationBar: c.isLoadingActs
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(),
                  ],
                )
              : c.postsVM.activitiesList.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(),
                      ],
                    )
                  // : (c.postsVM.activitiesList[0].privateActivity! &&
                  //         !c.postsVM.activitiesList[0].isMember!)
                  //     ? Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         children: [
                  //           Container(),
                  //         ],
                  //       )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 22.w, vertical: 10.h),
                          color: AppColors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              c.postsVM.activitiesList[0].limitParticipants!
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                          AppImage.peoplePng,
                                          color: AppColors.editBorderColor,
                                          width: 20.w,
                                          height: 12.h,
                                        ),
                                        sizedBoxW(width: 4),
                                        Text(
                                          "${c.postsVM.activitiesList[0].spotsLeft} Spots left",
                                          style: AppStyles.interRegularStyle(
                                              color: AppColors.editBorderColor,
                                              fontSize: 15.6),
                                        )
                                      ],
                                    )
                                  : Container(),
                              c.postsVM.activitiesList[0].isMember!
                                  ? AppGradientButton(
                                      width: 150.w,
                                      btnText: "Share moments",
                                      onPressed: () async {
                                        showAppDialog(
                                          msg:
                                              "Are you sure you want to share this as post.",
                                          btnText: "Yes",
                                          btnText2: "No",
                                          onPressed: () async {
                                            Get.back();
                                            await c.shareActivityAsPost({
                                              "activityId":
                                                  c.activityId.toString(),
                                              "userId": c.userId.toString(),
                                              "groupId": null
                                            });
                                          },
                                        );
                                      })
                                  : AppGradientButton(
                                      width: 150.w,
                                      btnText: "Join activity",
                                      isDisabled: ((c.postsVM.activitiesList[0]
                                                  .isMember ??
                                              false) ||
                                          (c.postsVM.activitiesList[0]
                                                  .isJoinedActivity ??
                                              false)),
                                      onPressed: () async {
                                        await c.postsVM.joinActivity({
                                          "userId": c.postsVM.userId.toString(),
                                          "activityId": c.activityId.toString()
                                        });
                                        c.init(withoutArg: true);
                                      })
                            ],
                          ),
                        ),
                      ],
                    ),
        )),
      );
    });
  }

  static Widget mostLikedCard({required Category category}) {
    return Container(
      margin: EdgeInsets.only(right: 10.w),
      padding: EdgeInsets.symmetric(
        vertical: 8.5.h,
      ),
      //height: 40.h,
      width: MediaQuery.of(getContext()).size.width / 2.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.texfieldColor,
      ),
      child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(10.r),
          child: InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: null,
              child: Center(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    category.icon!.toString(),
                    // AppIcons
                    //     .burgerIcon,
                    width: 18.w,
                    height: 18.h,
                  ),
                  sizedBoxW(
                    width: 8,
                  ),
                  Flexible(
                    child: Text(
                      category.name!,
                      style: AppStyles.interMediumStyle(fontSize: 15),
                      // overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              )

                  // child: Wrap(
                  //
                  //     //mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //   // SvgPicture.network(
                  //   //   c.userIntrests[index!].icon!.toString(),
                  //   //   width: 18,
                  //   //   height: 18,
                  //   // ),
                  //   Image.network(
                  //     c.userIntrests[index!].icon!.toString(),
                  //     // AppIcons
                  //     //     .burgerIcon,
                  //     width: 18.w,
                  //     height: 18.h,
                  //   ),
                  //   sizedBoxW(
                  //     width: 8,
                  //   ),
                  //   // Expanded(
                  //   //   child: Row(
                  //   //     children: [
                  //   //       Expanded(
                  //   //         child:
                  //   SizedBox(
                  //     width: c.userIntrests[index!].name!.length >= 14.0 ?  MediaQuery.of(context).size.width / 3.0 :null,
                  //     child: Text(
                  //        c.userIntrests[index!].name!,
                  //       style: AppStyles.interMediumStyle(fontSize: 16),
                  //     ///  overflow: TextOverflow.ellipsis,
                  //     )
                  //   )
                  //   // )
                  //   //],
                  //   //)
                  //   // )
                  // ])

                  ))),
    );
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
    return GetBuilder<ActivityDetailsScreenVM>(
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
                                    return userCard(c, index);
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

  static Widget userCard(ActivityDetailsScreenVM c, index) {
    return GetBuilder<ActivityDetailsScreenVM>(builder: (c) {
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
    return GetBuilder<ActivityDetailsScreenVM>(
      builder: (c) {
        return WillPopScope(
          onWillPop: () async {
            c.toHostId = -1;
            c.toHostIndex = -1;
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
                              c.toHostId = -1;
                              c.toHostIndex = -1;
                              Get.back();
                            },
                            icon: AppBarIcons.closeIcon,
                            isSvg: true,
                          )
                        ],
                        middle: [
                          Text(AppStrings.appointAsHost,
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
                                  c.searchedMembers!.addAll(c.members);
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
                                if (c.toHostId == -1) {
                                  showAppDialog(
                                      msg:
                                          "Please select someone to assign as host");
                                  return;
                                }
                                c.leaveAndSetAsHost({
                                  "hostId": c.hostId.toString(),
                                  "toBeHost": c.toHostId.toString(),
                                  "activityId": c.activityId.toString()
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

  static Widget assigneeCard(ActivityDetailsScreenVM c, index) {
    return GetBuilder<ActivityDetailsScreenVM>(builder: (c) {
      return InkWell(
        onTap: () {
          c.toHostIndex = index;
          c.toHostId = c.searchedMembers![index].user!.id!;

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
                        color: c.toHostIndex ==
                                index //c.searchedMembers![index].getIsHidden!
                            ? AppColors.orangePrimary
                            : AppColors.btnStrokeColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.asset(
                          c.toHostIndex == index
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

class RequestsUI extends StatelessWidget {
  const RequestsUI({
    required this.requestData,
    this.onAccept,
    this.onReject,
    Key? key,
  }) : super(key: key);

  final Datum requestData;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      margin: EdgeInsets.symmetric(vertical: 9.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          !isValidString(requestData.user!.userInfo!.profilePic)
              ? MyAvatar(
                  url: AppImage.sampleAvatar,
                  height: 56,
                  width: 56,
                  radiusAll: 22.4,
                )
              : MyAvatar(
                  url: ApiInterface.profileImgUrl +
                      requestData.user!.userInfo!.profilePic.toString(),
                  height: 56,
                  width: 56,
                  radiusAll: 22.4,
                  isNetwork: true,
                ),
          sizedBoxW(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        requestData.user!.userInfo!.firstName.toString() +
                            " " +
                            requestData.user!.userInfo!.lastName.toString(),
                        style: AppStyles.interSemiBoldStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                sizedBoxH(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          requestData.user!.userInfo!.biography.toString(),
                          style: AppStyles.interRegularStyle(
                              fontSize: 13.2, color: AppColors.hintTextColor),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ],
            ),
          ),
          sizedBoxW(width: 12),
          InkWell(
              onTap: onReject, child: SvgPicture.asset(AppIcons.ignoreActSvg)),
          sizedBoxW(width: 8),
          InkWell(
              onTap: onAccept, child: SvgPicture.asset(AppIcons.acceptActSvg)),
        ],
      ),
    );
  }
}

class RequestSection extends StatelessWidget {
  const RequestSection({
    required this.children,
    Key? key,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children,
    );
  }
}

class CommentSection extends StatelessWidget {
  const CommentSection({
    required this.c,
    Key? key,
  }) : super(key: key);

  final ActivityDetailsScreenVM c;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isValidString(c.profile)
                  ? MyAvatar(
                      url: ApiInterface.profileImgUrl + c.profile!,
                      height: 40,
                      width: 40,
                      radiusAll: 16,
                      isNetwork: true)
                  : MyAvatar(
                      url: AppImage.sampleAvatar,
                      height: 40,
                      width: 40,
                      radiusAll: 16,
                    ),
              sizedBoxW(width: 14),
              Expanded(
                  child: SearchTextField(
                controller: c.postsVM.cvm.commentCtrl,
                radius: 100,
                hint: AppStrings.saySomething,
                icon: false,
              )),
              sizedBoxW(width: 8),
              InkWell(
                  onTap: () async {
                    if (c.postsVM.cvm.commentCtrl.text.isNotEmpty) {
                      await c.postsVM.cvm
                          .comment(null, c.activityId.toString(), null, -1,
                              callback: () {
                        c.commentCount++;
                        c.tabs[0].text = "Comments (${c.commentCount})";
                        c.update();
                      });
                      c.postsVM.cvm.commentCtrl.clear();
                      c.update();
                    }
                  },
                  child: Text(
                    AppStrings.send,
                    style: AppStyles.interRegularStyle(
                      color: AppColors.orangePrimary,
                    ),
                  ))
            ],
          ),
          c.postsVM.cvm.commentList.isEmpty
              ? SizedBox(
                  width: double.infinity,
                  height: 250.h,
                  child: Center(
                      child: Text(
                    "No comments yet.",
                    style: AppStyles.interRegularStyle(fontSize: 15),
                  )),
                )
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: c.postsVM.cvm.commentList.length,
                    itemBuilder: (context, index) {
                      return PostWidget.commentCardWrapper(
                          context,
                          c.postsVM.cvm,
                          index,
                          c.activityId.toString(),
                          -1,
                          1, () {
                        c.commentCount++;
                        c.tabs[0].text = "Comments (${c.commentCount})";
                        c.update();
                      });
                    },
                  ),
                )
        ],
      ),
    );
  }
}

class MyTabBar extends StatelessWidget {
  const MyTabBar({
    required this.children,
    Key? key,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      //padding: EdgeInsets.only(right: 22.w, left: 22.w, bottom: 16.w),
      child: Container(
        height: 41.h,
        // margin: EdgeInsets.symmetric(horizontal: 22.w),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            color: AppColors.tabBkgColor),
        child: Row(mainAxisSize: MainAxisSize.max, children: children),
      ),
    );
  }
}

class TabChild extends StatelessWidget {
  const TabChild({
    required this.tabData,
    this.selectedIndex,
    this.onTabSelected,
    this.showBadge = false,
    Key? key,
  }) : super(key: key);

  final t.Tab tabData;
  final int? selectedIndex;
  final VoidCallback? onTabSelected;
  final bool? showBadge;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
          height: 41.h,
          // padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: selectedIndex == tabData.index
                  ? [
                      BoxShadow(
                          blurRadius: 4.r,
                          offset: const Offset(1, 1),
                          color: AppColors.tabShadowColor)
                    ]
                  : null,
              color: selectedIndex == tabData.index
                  ? AppColors.white
                  : AppColors.tabBkgColor),
          child: Material(
            borderRadius: BorderRadius.circular(14.r),
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(14.r),
              onTap: onTabSelected ?? () {},
              child: Center(
                child: badges.Badge(
                  showBadge: showBadge!,
                  badgeStyle: const badges.BadgeStyle(
                      badgeColor: AppColors.orangePrimary),
                  child: Text(
                    tabData.text.toString(),
                    style: AppStyles.interMediumStyle(
                        fontSize: 12.8,
                        color: selectedIndex == tabData.index
                            ? AppColors.textColor
                            : AppColors.editBorderColor),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

Widget reportActivity(ScrollController b) {
  return GetBuilder<ActivityDetailsScreenVM>(
    builder: (c) {
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
              mainAxisSize: MainAxisSize.min,
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
                  AppStrings.reportActivity,
                  style: AppStyles.interSemiBoldStyle(
                    fontSize: 16.0,
                    color: AppColors.textColor,
                  ),
                )
              ],
            ),
            sizedBoxH(height: 8),
            Container(
              color: const Color(0xffF1F0EE),
              height: 34,
              child: Padding(
                padding: const EdgeInsets.only(left: 22, top: 8),
                child: Text(
                  AppStrings.violatedContent,
                  style: AppStyles.interSemiBoldStyle(fontSize: 18.0),
                ),
              ),
            ),
            sizedBoxH(height: 6),
            ListView.builder(
              itemCount: AppStrings.reportActivities.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                final item = AppStrings.reportActivities[index];

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 6.h),
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xffF1F0EE),
                  ),
                  padding: const EdgeInsets.only(left: 12),
                  child: ListTile(
                    onTap: () async {
                      Navigator.of(context, rootNavigator: false).pop();
                      await c.reportActivity(item);
                    },
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      item,
                      style: AppStyles.interMediumStyle(),
                    ),
                    trailing: const Icon(
                      Icons.keyboard_arrow_right,
                      size: 34,
                      color: AppColors.textColor,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
