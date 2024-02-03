import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/activity_details_screen_vm.dart';

import '../data/local/user_search_model.dart';
import '../data/remote/api_interface.dart';
import '../resources/app_colors.dart';
import '../resources/app_image.dart';
import '../resources/app_routes.dart';
import '../resources/app_strings.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_bar.dart';
import '../utils/app_widgets/app_icon_button.dart';
import '../utils/common.dart';
import '../view_model/freind_user_profile_screen_vm.dart';
import 'create_post_screen_view.dart';

class ActivityParticipantsScreenView extends StatelessWidget {
  const ActivityParticipantsScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActivityDetailsScreenVM>(builder: (c) {
      return SafeArea(
          child: Scaffold(
        backgroundColor: AppColors.appBkgColor,
        appBar: MyAppBar(
          color: 0xffffffff,
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
            Text(
              AppStrings.participants,
              style: AppStyles.interSemiBoldStyle(
                  fontSize: 16, color: AppColors.textColor),
            ),
            Text(
              " ${c.members.length}",
              style: AppStyles.interRegularStyle(
                  fontSize: 16, color: AppColors.hintTextColor),
            )
          ],
          actions: [
            MyIconButton(
              onTap: () {},
              icon: AppBarIcons.share,
              isSvg: true,
              size: 28,
            )
          ],
        ),
        body: ListView(
          children: [
            Container(
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
                              radius: 30)
                        ],
                      ),
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
                                  physics: const NeverScrollableScrollPhysics(),
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
                                    return userCard(c, index);
                                  })
                        ],
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ));
    });
  }

  Widget userCard(ActivityDetailsScreenVM c, index) {
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

              if (c.isHost! &&
                  c.searchedMembers![index].role == ActivityRoles.participant) {
                actions.add(CupertinoActionSheetAction(
                  child: Text(
                    AppStrings.setAsSubHost,
                    style:
                        AppStyles.interRegularStyle(color: AppColors.iosBlue),
                  ),
                  onPressed: () async {
                    Navigator.pop(context, AppStrings.setAsSubHost);
                    c.setAsSubHost({
                      "hostId": c.userId.toString(),
                      "toBeSubHost": c
                          .searchedMembers![index].user!.userInfo!.id
                          .toString(),
                      "activityId": c.activityId.toString()
                    });
                  },
                ));
              }

              if (c.isHost! &&
                  c.searchedMembers![index].role == ActivityRoles.subHost) {
                actions.add(CupertinoActionSheetAction(
                    child: Text(
                      "Set as host and demote yourself to sub-host",
                      style:
                          AppStyles.interRegularStyle(color: AppColors.iosBlue),
                    ),
                    onPressed: () async {
                      Navigator.pop(context, AppStrings.setAsSubHost);
                      c.setAsHostAndDemoteYourSelfToSubHost({
                        "hostId": c.userId.toString(),
                        "toBeHost": c.searchedMembers![index].user!.userInfo!.id
                            .toString(),
                        "activityId": c.activityId.toString(),
                        "demoteToNormalParticipant": "0"
                      });
                    }));
              }

              if (c.isHost! &&
                  c.searchedMembers![index].role == ActivityRoles.subHost) {
                actions.add(CupertinoActionSheetAction(
                  child: Text(
                    "Demote to normal participant",
                    style: AppStyles.interRegularStyle(color: Colors.red),
                  ),
                  onPressed: () async {
                    Navigator.pop(context, AppStrings.setAsSubHost);
                    c.demoteToNormalParticipant({
                      "hostId": c.userId.toString(),
                      "toBeParticipants": c
                          .searchedMembers![index].user!.userInfo!.id
                          .toString(),
                      "activityId": c.activityId.toString()
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

              if ((c.isHost! &&
                      c.searchedMembers![index].role != ActivityRoles.host) ||
                  (c.isSubHost! &&
                      c.searchedMembers![index].role != ActivityRoles.host &&
                      c.searchedMembers![index].role !=
                          ActivityRoles.subHost)) {
                actions.add(
                  CupertinoActionSheetAction(
                      child: Text(
                        AppStrings.removeParticipants,
                        style: AppStyles.interRegularStyle(color: Colors.red),
                      ),
                      onPressed: () async {
                        Navigator.pop(context, AppStrings.removeParticipants);
                        c.removeParticipants({
                          "hostId": c.userId.toString(),
                          "userId": c.searchedMembers![index].user!.userInfo!.id
                              .toString(),
                          "activityId": c.activityId.toString()
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
                              ActivityRoles.host ||
                          c.searchedMembers![index].role.toString() ==
                              ActivityRoles.subHost)
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
                                      ActivityRoles.host
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

  bool isAdmin(ActivityDetailsScreenVM c, String userId) {
    return c.postsVM.activitiesList[0].host!.userId.toString() ==
        userId.toString();
  }
}
