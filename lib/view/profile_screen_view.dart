// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jyo_app/data/remote/api_interface.dart';
import 'package:jyo_app/data/remote/endpoints.dart';
import 'package:jyo_app/models/posts_model/post_and_activity_model.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/app_widgets/app_bar.dart';
import 'package:jyo_app/utils/app_widgets/app_gradient_btn.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/activity_details_screen_vm.dart';
import 'package:jyo_app/view_model/posts_and_activities_vm.dart';
import 'package:jyo_app/view_model/profile_screen_vm.dart';
import 'package:latlong2/latlong.dart';

import '../data/local/user_search_model.dart';
import '../utils/app_widgets/app_icon_button.dart';
import '../view_model/freindlist_screen_vm.dart';
import 'explore_screen_view.dart';

class ProfileScreenView extends StatelessWidget {
  const ProfileScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileScreenVM>(
      builder: (c) {
        return SafeArea(
            child: Scaffold(
                backgroundColor: AppColors.appBkgColor,
                appBar: MyAppBar(
                  color: 0xffffffff,
                  leading: [
                    MyIconButton(
                      onTap: () async {
                        Get.toNamed(qrScreenRoute);
                      },
                      icon: AppBarIcons.actionQRCodeScanSvg,
                      isSvg: true,
                      color: 0xffFFA43C,
                    )
                  ],
                  middle: [Text("", style: AppStyles.interMediumStyle())],
                  actions: [
                    MyIconButton(
                        onTap: () {
                          getToNamed(voucherScreenRoute);
                        },
                        icon: AppBarIcons.actionCouponSvg,
                        isSvg: true),
                    sizedBoxW(
                      width: 12,
                    ),
                    MyIconButton(
                      onTap: () {
                        getToNamed(accountSettingScreenRoute);
                      },
                      icon: AppBarIcons.actionSettingSvg,
                      isSvg: true,
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
                                            fit: BoxFit.cover,
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
                              InkWell(
                                  borderRadius: BorderRadius.circular(100.r),
                                  onTap: () {
                                    getToNamed(editProfileScreenRoute);
                                  },
                                  child: Container(
                                    height: 34.h,
                                    // width: 78.w,
                                    padding: EdgeInsets.only(
                                        right: 8.w, top: 5.h, bottom: 5.h),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(100.r),
                                      border: Border.all(
                                          color: AppColors.editBorderColor),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        sizedBoxW(
                                          width: 12,
                                        ),
                                        SvgPicture.asset(
                                          AppIcons.editIcon,
                                          width: 22.w,
                                          height: 22.h,
                                        ),
                                        sizedBoxW(
                                          width: 6,
                                        ),
                                        Text(AppStrings.edit,
                                            style: AppStyles.interMediumStyle(
                                              fontSize: 14.4,
                                              color: AppColors.editBorderColor,
                                            )),
                                        sizedBoxW(
                                          width: 8,
                                        ),
                                      ],
                                    ),
                                  ))
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
                                  "${c.firstName!} ${c.lastName!}",
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
                                        "@${c.userName!}",
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
                            Row(
                              children: [
                                InkWell(
                                    onTap: () async {
                                      SearchUser.setId = c.userId;
                                      await Get.delete<FriendlistScreenVM>(
                                          force: true);
                                      getToNamed(friendlistScreenRoute);
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          c.freinds!,
                                          style: AppStyles.interMediumStyle(
                                              fontSize: 17.2,
                                              color: AppColors.textColor),
                                        ),
                                        sizedBoxW(
                                          width: 4,
                                        ),
                                        Text(
                                          "Friends",
                                          style: AppStyles.interRegularStyle(
                                              fontSize: 15.0,
                                              color: AppColors.hintTextColor),
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
                            Row(
                              children: [
                                Text(
                                  "Interests",
                                  style: AppStyles.interRegularStyle(
                                      fontSize: 15.0,
                                      color: AppColors.hintTextColor),
                                ),
                              ],
                            ),
                            sizedBoxH(
                              height: 8,
                            ),
                            SizedBox(
                              height: 46.h,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: c.userIntrests.length,
                                  itemBuilder: (context, index) {
                                    return mostLikedCard(context, c, index);
                                  }),
                            )
                          ],
                        ),
                      ),

                      //Posts and activity tabs
                      Container(
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
                                                    offset: const Offset(1, 1),
                                                    color: AppColors
                                                        .tabShadowColor)
                                              ]
                                            : null,
                                        color: c.profileSection ==
                                                ProfileSection.posts
                                            ? AppColors.white
                                            : AppColors.tabBkgColor),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(14.r),
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
                                                        ProfileSection.posts
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
                                                    offset: const Offset(1, 1),
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
                                                BorderRadius.circular(14.r),
                                            onTap: () {
                                              c.profileSection =
                                                  ProfileSection.activities;
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
                                        "No posts available",
                                        style: AppStyles.interRegularStyle(),
                                      )),
                                    )
                                  : Column(
                                      children: List.generate(
                                          c.postsVM.postsList.length, (index) {
                                        return PostWidget.post(
                                          c.postsVM,
                                          c,
                                          index,
                                          isProfilePost: true,
                                        );
                                      }),
                                    )
                          : c.isLoadingActs!
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
                                        "No activities available",
                                        style: AppStyles.interRegularStyle(),
                                      )),
                                    )
                                  : Column(
                                      children: List.generate(
                                          c.postsVM.activitiesList.length,
                                          (index) {
                                        return ActivityWidget.activity(
                                            c.postsVM.activitiesList[index],
                                            c.postsVM,
                                            c,
                                            isProfile: true);
                                      }),
                                    )
                    ],
                  ),
                )));
      },
    );
  }

  static Widget mostLikedCard(BuildContext context, c, int? index) {
    return Container(
      margin: EdgeInsets.only(right: 10.w),
      padding: EdgeInsets.symmetric(
        vertical: 8.5.h,
      ),
      //height: 40.h,
      width: MediaQuery.of(context).size.width / 2.5,
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
                    c.userIntrests[index!].icon!.toString(),
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
                      c.userIntrests[index].name!,
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
}

// class MostLikedCard extends StatelessWidget {
//   MostLikedCard(
//     this.index, {
//     Key? key,
//   }) : super(key: key);

//   int? index;

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ProfileScreenVM>(
//       builder: (c) {
//         return mostLikedCard(context, c);
//       },
//     );
//   }

// }

class ActivityWidget {
  static Widget activity(
      PostOrActivity activity, GetxController c, GetxController pc,
      {bool isFromExplore = false,
      bool isProfile = false,
      EdgeInsets? padding,
      EdgeInsets? margin,
      double? radius = 0.0,
      int color = 0xffFFFFFF,
      Function()? onPreTap,
      bool? showCoverInsteadOfMap = false}) {
    return InkWell(
      onTap: () {
        if (onPreTap != null) {
          onPreTap();
        }
        Get.delete<ActivityDetailsScreenVM>();
        getToNamed(activityDetailsScreenRoute, argument: {
          "id": activity.activityId ?? activity.id,
          "isFromExplore": isFromExplore
        });
      },
      child: Container(
        width: MediaQuery.of(getContext()).size.width * 0.9,
        margin: margin,
        decoration: BoxDecoration(
            color: Color(color),
            borderRadius: BorderRadius.circular(radius!.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius.r),
                color: Color(color),
              ),
              padding: padding ??
                  EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          showCoverInsteadOfMap!
                              ? Container()
                              : Row(
                                  children: [
                                    MyAvatar(
                                      url: AppIcons.crownPng,
                                      width: 12,
                                      height: 8,
                                    ),
                                    sizedBoxW(width: 2),
                                    Expanded(
                                      child: Text(
                                        (activity.group != null &&
                                                activity.group is Map)
                                            ? activity.group["groupName"]
                                                .toString()
                                            : isValidString(activity.group)
                                                ? activity.group.toString()
                                                : "N/A",
                                        style: AppStyles.interMediumStyle(
                                            fontSize: 12.8),
                                      ),
                                    )
                                  ],
                                ),
                          showCoverInsteadOfMap
                              ? Container()
                              : sizedBoxH(height: 2),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  isValidString(activity.activityName)
                                      ? activity.activityName.toString()
                                      : "",
                                  style: AppStyles.interSemiBoldStyle(
                                      fontSize: 18.8),
                                ),
                              )
                            ],
                          ),
                        ],
                      )),
                      sizedBoxW(width: 10),
                      InkWell(
                        onTap: () {
                          activity.isSaved = !activity.isSaved!;
                          pc.update();
                          (c as PostsAndActivitiesVM).saveActivity({
                            "activityId": activity.activityId ?? activity.id,
                            "userId": c.userId.toString(),
                            "isSaved": activity.isSaved! ? "1" : "0"
                          });
                        },
                        child: MyAvatar(
                          url: activity.isSaved ?? false
                              ? AppIcons.bookmarkSvg
                              : AppIcons.bookmarkUs,
                          isSVG: true,
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ],
                  ),
                  sizedBoxH(height: 12),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 136.h,
                          width: MediaQuery.of(getContext()).size.width / 2.5,
                          decoration: BoxDecoration(
                            color: AppColors.lightGray,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: Stack(
                              children: [
                                showCoverInsteadOfMap
                                    ? MyAvatar(
                                        url: ApiInterface.postImgUrl +
                                            activity.coverImage.toString(),
                                        radiusAll: 16,
                                        height: 136,
                                        width: MediaQuery.of(getContext())
                                                .size
                                                .width /
                                            2.5,
                                        isNetwork: true,
                                      )
                                    : activity.location!.isEmpty
                                        ? Center(
                                            child: Text(
                                              "No location\nfound",
                                              style: AppStyles.interMediumStyle(
                                                  fontSize: 12),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        : FlutterMap(
                                            //mapController: c.mapController,

                                            options: MapOptions(
                                                minZoom: 5,
                                                maxZoom: 18,
                                                zoom: 16,
                                                center: LatLng(
                                                    activity.location![0],
                                                    activity.location![1]),
                                                onTap: (tapPosition, point) {
                                                  debugPrint(
                                                      "Lat long onTaped ${point.latitude}, ${point.longitude}");
                                                }),
                                            children: [
                                              TileLayer(
                                                urlTemplate: MapConstants
                                                    .tempTemplateUrl,
                                                additionalOptions: const {
                                                  "access_token":
                                                      MapConstants.accessToken,
                                                },
                                                userAgentPackageName:
                                                    MapConstants
                                                        .userAgentPackageName,
                                              ),
                                              MarkerLayer(
                                                  markers: activity.markers!),
                                            ],
                                          ),
                                Positioned(
                                    child: Container(
                                  color: Colors.transparent,
                                  height: 136.h,
                                  width:
                                      MediaQuery.of(getContext()).size.width /
                                          2.5,
                                ))
                              ],
                            ),
                          ),
                        ),
                        sizedBoxW(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              !showCoverInsteadOfMap
                                  ? Container()
                                  : Row(
                                      children: [
                                        MyAvatar(
                                          url: AppIcons.crownPng,
                                          width: 12,
                                          height: 8,
                                        ),
                                        sizedBoxW(width: 2),
                                        Expanded(
                                          child: Text(
                                            (activity.group != null &&
                                                    activity.group is Map)
                                                ? activity.group["groupName"]
                                                    .toString()
                                                : isValidString(activity.group)
                                                    ? activity.group.toString()
                                                    : "N/A",
                                            style: AppStyles.interMediumStyle(
                                                fontSize: 12.8,
                                                color:
                                                    AppColors.editBorderColor),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                              !showCoverInsteadOfMap
                                  ? Container()
                                  : sizedBoxH(height: 2),
                              isValidString(activity.activityDate)
                                  ? Text(
                                      isValidString(activity.activityDate)
                                          ? activity.activityDate.toString()
                                          : "",
                                      style: AppStyles.interMediumStyle(
                                          fontSize: 14,
                                          color: AppColors.orangePrimary),
                                    )
                                  : Container(),
                              sizedBoxH(height: 8),
                              Row(
                                children: [
                                  MyAvatar(
                                    url: AppIcons.pinStroke,
                                    height: 16,
                                    width: 16,
                                    isSVG: true,
                                  ),
                                  sizedBoxW(width: 2),
                                  Text(
                                    "4.2 Km",
                                    style: AppStyles.interRegularStyle(
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                              sizedBoxH(height: 8),
                              Row(
                                children: [
                                  Stack(
                                      children:
                                          // Row(
                                          //     mainAxisSize:
                                          //         MainAxisSize.min,
                                          //     children:
                                          List.generate(
                                              activity.members!.length > 3
                                                  ? 3
                                                  : activity.members!.length,
                                              (index) {
                                    return Container(
                                      margin: EdgeInsets.only(left: index * 22),
                                      child: Container(
                                          width: 32.h,
                                          height: 32.w,
                                          // margin: EdgeInsets.only() ,
                                          padding: const EdgeInsets.all(1.5),
                                          decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12.8.r)),
                                          child: isValidString(activity
                                                  .members![index].profilePic)
                                              ? MyAvatar(
                                                  url: ApiInterface
                                                          .profileImgUrl +
                                                      activity.members![index]
                                                          .profilePic!,
                                                  height: 32.h,
                                                  width: 32.w,
                                                  radiusAll: 12.8.r,
                                                  isNetwork: true,
                                                )
                                              : Container()),
                                    );
                                  }) //),
                                      //],
                                      ),
                                  activity.members!.length > 3
                                      ? Container(
                                          width: 32.h,
                                          height: 32.w,
                                          // margin: EdgeInsets.only() ,
                                          padding: const EdgeInsets.all(1.5),
                                          decoration: BoxDecoration(
                                              color: AppColors.tabBkgColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12.8.r)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MyAvatar(
                                                url: AppIcons
                                                    .profile, //activity.members![index].url
                                                height: 8.h,
                                                width: 8.w,
                                                radiusAll: 0.r,
                                                isSVG: true,
                                                //isNetwork: true,
                                              ),
                                              Text(
                                                (activity.activityParticipantsCount -
                                                        3)
                                                    .toString(),
                                                style:
                                                    AppStyles.interMediumStyle(
                                                        fontSize: 12.2,
                                                        color: AppColors
                                                            .hintTextColor),
                                              )
                                            ],
                                          ))
                                      : SizedBox(
                                          width: 32.h,
                                          height: 32.w,
                                        ),

                                  // Text(
                                  //   markers.length > 3
                                  //       ? ("+" +
                                  //           (markers.length -
                                  //                   3)
                                  //               .toString())
                                  //       : "",
                                  //   style: AppStyles
                                  //       .interMediumStyle(
                                  //     color:
                                  //         AppColors.white,
                                  //   ),
                                  // )
                                ],
                              ),
                              sizedBoxH(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppGradientButton(
                                      btnText: "Join Activity",
                                      onPressed: () async {
                                        activity.isJoinedActivity = true;
                                        pc.update();

                                        await (c as PostsAndActivitiesVM)
                                            .joinActivity({
                                          "userId": (c).userId.toString(),
                                          "activityId":
                                              activity.activityId ?? activity.id
                                        });
                                      },
                                      isDisabled: ((activity.isMember ??
                                              false) ||
                                          (activity.isJoinedActivity ?? false)),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            !showCoverInsteadOfMap
                ? sizedBoxH(height: 8)
                : sizedBoxH(height: 0),
          ],
        ),
      ),
    );
  }

  static Widget wrapper({Widget? child}) {
    return Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: Colors.white, width: 1.50),
          borderRadius: BorderRadius.circular(12.8.r),
        ),
        child: child!);
  }
}
