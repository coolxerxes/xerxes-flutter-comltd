// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jyo_app/data/remote/api_interface.dart';
import 'package:jyo_app/data/remote/endpoints.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/app_widgets/app_bar.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/profile_screen_vm.dart';

import '../utils/app_widgets/app_icon_button.dart';
import '../view_model/freindlist_screen_vm.dart';

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
                      onTap: () {},
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
                                        "@"+c.userName!,
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
                          : Column()
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
