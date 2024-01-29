import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jyo_app/view/create_post_screen_view.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/post_privacy_screen_vm.dart';

import '../data/remote/api_interface.dart';
import '../data/remote/endpoints.dart';
import '../resources/app_colors.dart';
import '../resources/app_image.dart';
import '../resources/app_strings.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_bar.dart';
import '../utils/app_widgets/app_divider.dart';
import '../utils/app_widgets/app_gradient_btn.dart';
import '../utils/app_widgets/app_icon_button.dart';
import '../utils/app_widgets/setting_list_tile.dart';
import '../utils/common.dart';

class PostPrivacyScreenView extends StatelessWidget {
  const PostPrivacyScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostPrivacyScreenVM>(
      builder: (c) {
        return SafeArea(
            child: Scaffold(
          appBar: MyAppBar(
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
              Text(AppStrings.postPrivacy,
                  style: AppStyles.interSemiBoldStyle(
                      fontSize: 16.0, color: AppColors.textColor))
            ],
          ),
          body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: ListView(
                children: [
                  sizedBoxH(
                    height: 24,
                  ),

                  //Chat
                  SettingListTile(
                    text: AppStrings.everyone,
                    icon: Icon(
                      Icons.check,
                      color: c.privacyStatus == Privacy.everyone
                          ? AppColors.orangePrimary
                          : AppColors.texfieldColor,
                    ),
                    radiusBottomLeft: 0.0,
                    radiusBottomRight: 0.0,
                    onTap: () {
                      c.togglePrivacy(Privacy.everyone);
                    },
                  ),
                  MyDivider(),
                  SettingListTile(
                    text: AppStrings.friendsOnly,
                    icon: Icon(
                      Icons.check,
                      color: c.privacyStatus == Privacy.friendOnly
                          ? AppColors.orangePrimary
                          : AppColors.texfieldColor,
                    ),
                    onTap: () {
                      c.togglePrivacy(Privacy.friendOnly);
                    },
                    radiusTopLeft: 0.0,
                    radiusTopRight: 0.0,
                    radiusBottomLeft: 0.0,
                    radiusBottomRight: 0.0,
                  ),
                  MyDivider(),
                  SettingListTile(
                      text: AppStrings.onlyMe,
                      icon: Icon(
                        Icons.check,
                        color: c.privacyStatus == Privacy.onlyMe
                            ? AppColors.orangePrimary
                            : AppColors.texfieldColor,
                      ),
                      radiusTopLeft: 0.0,
                      radiusTopRight: 0.0,
                      onTap: () {
                        c.togglePrivacy(Privacy.onlyMe);
                      }),

                  sizedBoxH(
                    height: 20,
                  ),
                  //Like and Comments
                  SettingListTile(
                    text: AppStrings.hidePostFrom,
                    icon: Row(
                      children: [
                        Text(
                          c.hideFromCount.toString() + " user ",
                          style: AppStyles.interRegularStyle(fontSize: 16.0),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          color: AppColors.textColor,
                        )
                      ],
                    ),
                    onTap: () {
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
                    },
                  ),
                ],
              )),
        ));
      },
    );
  }

  Widget showUsers(ScrollController b) {
    return GetBuilder<PostPrivacyScreenVM>(
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
                        Text(AppStrings.hidePostFrom,
                            style: AppStyles.interSemiBoldStyle(
                                fontSize: 16.0, color: AppColors.textColor))
                      ],
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchTextField(
                            controller: c.searchCtrl,
                                onChanged: (t) {
                                  if (t.trim().isEmpty) {
                                    c.friends!.clear();
                                    c.friends!.addAll(c.searchedFriends!);
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 22.w, vertical: 22.h),
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
                            btnText: AppStrings.save,
                            onPressed: () {
                              c.updatePostHideFrom();
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

  Widget userCard(PostPrivacyScreenVM c, index) {
    return GetBuilder<PostPrivacyScreenVM>(
      builder: (c) {
        return InkWell(
          onTap: () {
            debugPrint("Is Hidden ${c.friends![index].getIsHidden!}");
            if (!c.friends![index].getIsHidden!) {
              c.friends![index].setIsHidden = true;
              c.hideFromListLocal.add(c.friends![index].user!.userId.toString());
            } else {
              c.friends![index].setIsHidden = false;
              int idx = c.hideFromListLocal.indexWhere((element) {
                return c.friends![index].user!.userId.toString() == element.toString();
              });
              if (idx != -1) {
                c.hideFromListLocal.removeAt(idx);
              }
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
                        url:
                                  ApiInterface.baseUrl +
                                      Endpoints.user +
                                      Endpoints.profileImage +
                                      c.friends![index].user!.profilePic!.toString(),
                            height: 72,width: 72,radiusAll: 28.8,isNetwork: true,
                                )
                              : MyAvatar(url:
                                  AppImage.sampleAvatar,
                                  height: 72,width: 72,radiusAll: 28.8,
                                ),
                    ),
                    Positioned(
                      top: 58.h,
                      left: 27.w,
                      child: Container(
                        width: 22.w,
                        height: 22.h,
                        decoration: BoxDecoration(
                          color: c.friends![index].getIsHidden! ?  AppColors.orangePrimary : AppColors.btnStrokeColor,
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
      }
    );
  }
}
