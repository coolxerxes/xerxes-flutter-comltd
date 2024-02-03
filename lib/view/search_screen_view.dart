import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/group_details_screen_vm.dart';
import 'package:jyo_app/view_model/search_screen_vm.dart';

import '../data/local/user_search_model.dart';
import '../data/remote/api_interface.dart';
import '../data/remote/endpoints.dart';
import '../view_model/activity_details_screen_vm.dart';

class SearchScreenView extends StatelessWidget {
  const SearchScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchScreenVM>(builder: (c) {
      return SafeArea(
          child: Scaffold(
              backgroundColor: AppColors.appBkgColor,
              appBar: PreferredSize(
                preferredSize: Size(
                    double.infinity,
                    //Platform.isIOS ?
                    142.h //: 131.h,
                    ),
                child: Container(
                  color: AppColors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          // Platform.isIOS
                          //   ?
                          Expanded(
                            child: TextField(
                              controller: c.searchCtrl,
                              onChanged: (t) async {
                                if (t.trim().isNotEmpty) {
                                  c.isSearchEmpty = false;
                                  if (c.selectedSearchType ==
                                      SearchType.people) {
                                    await c
                                        .searchPeople(c.searchCtrl.text.trim());
                                    c.searchResults!.add(null);
                                  } else if (c.selectedSearchType ==
                                      SearchType.activities) {
                                    await c.searchActivity(
                                        c.searchCtrl.text.trim());
                                  } else if (c.selectedSearchType ==
                                      SearchType.group) {
                                    await c.searchGroup(t);
                                  }
                                  c.update();
                                } else {
                                  c.isSearchEmpty = true;
                                  c.searchResults!.clear();
                                  c.activityResults.clear();
                                  c.groupResults.clear();
                                  c.update();
                                }
                              },
                              autofocus: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(5),
                                //isCollapsed: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                  borderSide: BorderSide(
                                      color: AppColors.texfieldColor,
                                      width: 1.0.w,
                                      style: BorderStyle.none),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                  borderSide: BorderSide(
                                      color: AppColors.texfieldColor,
                                      width: 1.0.w,
                                      style: BorderStyle.none),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                  borderSide: BorderSide(
                                      color: AppColors.texfieldColor,
                                      width: 1.0.w,
                                      style: BorderStyle.none),
                                ),
                                hintText: "Search",
                                filled: true,
                                fillColor: AppColors.texfieldColor,
                                hintStyle: AppStyles.interRegularStyle(
                                    fontSize: 18,
                                    color: AppColors.hintTextColor),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: AppColors.hintTextColor,
                                ),
                              ),
                              style: AppStyles.interRegularStyle(
                                  fontSize: 18, color: AppColors.hintTextColor),
                            ),
                          )
                          // : Expanded(
                          //     child: AppTextField(
                          //     controller: c.searchCtrl,
                          //     autoFocus: true,
                          //     onChanged: (t) async {
                          //       if (t.trim().isNotEmpty) {
                          //         await c.searchPeople(
                          //             c.searchCtrl.text.trim());
                          //         c.searchResults!.add(null);
                          //         c.update();
                          //       } else {
                          //         c.searchResults!.clear();
                          //         c.update();
                          //       }
                          //     },
                          //     margin: const EdgeInsets.all(0.0),
                          //     radiusBottomLeft: 14.r,
                          //     radiusBottomRight: 14.r,
                          //     radiusTopLeft: 14.r,
                          //     radiusTopRight: 14.r,
                          //     height: 42.h,
                          //     icon: const Icon(
                          //       Icons.search,
                          //       color: AppColors.hintTextColor,
                          //     ),
                          //     hintText: AppStrings.search,
                          //     contentPaddingTop: 7,
                          //   ))
                          ,
                          sizedBoxW(width: 16.w),
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Text(
                                AppStrings.cancel,
                                style: AppStyles.interRegularStyle(
                                    fontSize: 15,
                                    color: AppColors.hintTextColor),
                              ))
                        ],
                      ),
                      sizedBoxH(height: 16.h),
                      Container(
                        color: AppColors.white,
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
                                        boxShadow: c.selectedSearchType ==
                                                SearchType.activities
                                            ? [
                                                BoxShadow(
                                                    blurRadius: 4.r,
                                                    offset: const Offset(1, 1),
                                                    color: AppColors
                                                        .tabShadowColor)
                                              ]
                                            : null,
                                        color: c.selectedSearchType ==
                                                SearchType.activities
                                            ? AppColors.white
                                            : AppColors.tabBkgColor),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(14.r),
                                      type: MaterialType.transparency,
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(14.r),
                                        onTap: () {
                                          c.selectedSearchType =
                                              SearchType.activities;
                                          c.onTabChanged();
                                          c.update();
                                        },
                                        child: Center(
                                          child: Text(
                                            AppStrings.activities,
                                            style: AppStyles.interMediumStyle(
                                                fontSize: 12.8,
                                                color: c.selectedSearchType ==
                                                        SearchType.activities
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
                                        boxShadow: c.selectedSearchType ==
                                                SearchType.people
                                            ? [
                                                BoxShadow(
                                                    blurRadius: 4.r,
                                                    offset: const Offset(1, 1),
                                                    color: AppColors
                                                        .tabShadowColor)
                                              ]
                                            : null,
                                        color: c.selectedSearchType ==
                                                SearchType.people
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
                                              c.selectedSearchType =
                                                  SearchType.people;
                                              c.onTabChanged();
                                              c.update();
                                            },
                                            child: Center(
                                              child: Text(
                                                AppStrings.people,
                                                style: AppStyles.interMediumStyle(
                                                    fontSize: 12.8,
                                                    color: c.selectedSearchType ==
                                                            SearchType.people
                                                        ? AppColors.textColor
                                                        : AppColors
                                                            .editBorderColor),
                                              ),
                                            ))),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 41.h,
                                    // padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(14.r),
                                        boxShadow: c.selectedSearchType ==
                                                SearchType.group
                                            ? [
                                                BoxShadow(
                                                    blurRadius: 4.r,
                                                    offset: const Offset(1, 1),
                                                    color: AppColors
                                                        .tabShadowColor)
                                              ]
                                            : null,
                                        color: c.selectedSearchType ==
                                                SearchType.group
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
                                              c.selectedSearchType =
                                                  SearchType.group;
                                              c.onTabChanged();
                                              c.update();
                                            },
                                            child: Center(
                                              child: Text(
                                                AppStrings.groups,
                                                style: AppStyles.interMediumStyle(
                                                    fontSize: 12.8,
                                                    color: c.selectedSearchType ==
                                                            SearchType.group
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
                    ],
                  ),
                ),
              ),
              body: Container(
                margin: EdgeInsets.only(top: 8.h),
                child: c.selectedSearchType == SearchType.activities
                    ? Container(
                        color: AppColors.white,
                        child: ListView.builder(
                            itemCount: c.activityResults.length,
                            itemBuilder: (context, index) {
                              return ActivitySearchedCard(
                                activity: c.activityResults[index],
                                onTap: () {
                                  Get.delete<ActivityDetailsScreenVM>();
                                  getToNamed(activityDetailsScreenRoute,
                                      argument: {
                                        "id":
                                            c.activityResults[index].activityId
                                      });
                                },
                              );
                            }),
                      )
                    : c.selectedSearchType == SearchType.people
                        ? ListView.builder(
                            itemCount: c.searchResults!.length,
                            itemBuilder: (context, index) {
                              return c.searchResults![index] == null
                                  ? nearbyCard(index)
                                  : peopleCard(c, index);
                            })
                        : ListView.builder(
                            itemCount: c.groupResults.length,
                            itemBuilder: (context, index) {
                              return GroupSearchedCard(
                                group: c.groupResults[index],
                                onTap: () {
                                  Get.delete<GroupDetailsScreenVM>();
                                  getToNamed(groupDetailsScreenRoute,
                                      argument: {
                                        "groupId": c.groupResults[index].groupId
                                            .toString()
                                      });
                                },
                                onJoinTapped: c.groupResults[index].isJoinedGroup!
                                    ? null
                                    : () {
                                        c.joinGroup(index);
                                      },
                              );
                            }),
              )));
    });
  }

  Widget peopleCard(SearchScreenVM c, int index) {
    return Container(
      color: AppColors.white,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () {
            SearchUser.setId = c.searchResults![index]!.userId.toString();
            getToNamed(friendUserProfileScreeRoute);
            //c.baseSreenVM.goToUserProfile(c.searchResults![index]!.userId.toString());
            //c.update();
          },
          child: Container(
            padding: EdgeInsets.only(
                left: 22.w,
                right: 22.w,
                top: index == 0 ? 16.h : 0,
                bottom: 24.h),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                c.searchResults![index]!.profilePic!.trim().isNotEmpty
                    ? MyAvatar(
                        url: ApiInterface.baseUrl +
                            Endpoints.user +
                            Endpoints.profileImage +
                            c.searchResults![index]!.profilePic!
                                .trim()
                                .toString(), //AppImage.avatar1,
                        width: 56.w,
                        height: 56.h,
                        radiusAll: 22.6,
                        isNetwork: true,
                      )
                    : MyAvatar(
                        url: AppImage.sampleAvatar,
                        width: 56.w,
                        height: 56.h,
                        radiusAll: 22.6,
                      ),
                sizedBoxW(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            c.searchResults![index]!.firstName.toString() +
                                " " +
                                c.searchResults![index]!.lastName.toString(),
                            style: AppStyles.interSemiBoldStyle(fontSize: 16),
                          ),
                          c.searchResults![index]!.username
                                  .toString()
                                  .trim()
                                  .isEmpty
                              ? Container()
                              : Text(
                                  "(@" +
                                      c.searchResults![index]!.username
                                          .toString() +
                                      ")",
                                  style: AppStyles.interRegularStyle(
                                      fontSize: 15.0,
                                      color: AppColors.hintTextColor),
                                ),
                        ],
                      ),
                      sizedBoxH(height: 2.h),
                      Text(
                        c.searchResults![index]!.biography.toString(),
                        style: AppStyles.interRegularStyle(
                            fontSize: 13.2,
                            color: AppColors.hintTextColor,
                            textOverflow: TextOverflow.ellipsis),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nearbyCard(int index) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.only(
          left: 22.w, right: 22.w, top: index == 0 ? 16.h : 0, bottom: 24.h),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          MyAvatar(
            url: AppImage.nearbySearchLogo,
            width: 56.w,
            height: 56.h,
            radiusAll: 22.6,
          ),
          sizedBoxW(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.searchByNearby,
                  style: AppStyles.interSemiBoldStyle(
                      fontSize: 16, color: AppColors.orangePrimary),
                ),
                sizedBoxH(height: 2.h),
                Text(
                  AppStrings.searchByNearbyDesc,
                  style: AppStyles.interRegularStyle(
                      fontSize: 13.2,
                      color: AppColors.hintTextColor,
                      textOverflow: TextOverflow.ellipsis),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
