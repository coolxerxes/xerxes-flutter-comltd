import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jyo_app/view/create_post_screen_view.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/blocked_user_screen_vm.dart';

import '../data/remote/api_interface.dart';
import '../data/remote/endpoints.dart';
import '../resources/app_colors.dart';
import '../resources/app_image.dart';
import '../resources/app_strings.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_bar.dart';
import '../utils/app_widgets/app_gradient_btn.dart';
import '../utils/app_widgets/app_icon_button.dart';
import '../utils/common.dart';

class BlockedUserScreenView extends StatelessWidget {
  const BlockedUserScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BlockedUserScreenVM>(builder: (c) {
      return Scaffold(
        backgroundColor: AppColors.texfieldColor,
        body: Container(
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.r),
                    topRight: Radius.circular(32.r))),
            child: ListView(
              //controller: b,
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
                    Text(AppStrings.blockedUser,
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
                            c.blockListServer!.clear();
                            c.blockListServer!
                                .addAll(c.searchedblockListServer!);
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
                      c.blockListServer!.isEmpty
                          ? Center(
                              child: Text(
                              "No blocked users",
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
                                  c.blockListServer!.length, //c.list.length,
                              itemBuilder: (context, index) {
                                return userCard(c, index);
                              })
                    ],
                  ),
                ),
                sizedBoxH(
                  height: 10,
                ),
                c.blockListServer!.isEmpty
                    ? Container()
                    : AppGradientButton(
                        btnText: AppStrings.save,
                        onPressed: () {
                          c.blockUser();
                        },
                        height: 56,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                            horizontal: 22.w, vertical: 16.h),
                      )
              ],
            )),
      );
    });
  }

  Widget userCard(BlockedUserScreenVM c, index) {
    return GetBuilder<BlockedUserScreenVM>(builder: (c) {
      return InkWell(
        onTap: () {
          if (!c.blockListServer![index].getIsHidden!) {
            c.blockListServer![index].setIsHidden = true;
          } else {
            c.blockListServer![index].setIsHidden = false;
          }
          // debugPrint("Is Hidden ${c.friends![index].getIsHidden!}");
          // if (!c.friends![index].getIsHidden!) {
          //   c.friends![index].setIsHidden = true;
          //   c.blockListLocal.add(c.friends![index].friendId.toString());
          // } else {
          //   c.friends![index].setIsHidden = false;
          //   int idx = c.blockListLocal.indexWhere((element) {
          //     return c.friends![index].friendId.toString() == element.toString();
          //   });
          //   if (idx != -1) {
          //     c.blockListLocal.removeAt(idx);
          //   }
          // }
          // debugPrint("Check Changed ${c.blockListLocal}");
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
                    child: c.blockListServer![index].userInfo!.profilePic!
                            .trim()
                            .isNotEmpty
                        ? MyAvatar(
                            url: ApiInterface.baseUrl +
                                Endpoints.user +
                                Endpoints.profileImage +
                                c.blockListServer![index].userInfo!.profilePic!
                                    .toString(),
                            isNetwork: true,
                            width: 72,
                            height: 72,
                            radiusAll: 28.8,
                          )
                        : MyAvatar(
                            url: AppImage.sampleAvatar,
                            width: 72,
                            height: 72,
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
                        color: c.blockListServer![index].getIsHidden!
                            ? AppColors.orangePrimary
                            : AppColors.btnStrokeColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.asset(
                          c.blockListServer![index].getIsHidden!
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
                    c.blockListServer![index].userInfo!.firstName.toString() +
                        " " +
                        c.blockListServer![index].userInfo!.lastName.toString(),
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
    });
  }

  // Widget userCard(, index) {
  //   return Container(
  //     color: AppColors.white,
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Center(
  //             child: Stack(
  //           clipBehavior: Clip.none,
  //           children: [
  //              SizedBox(
  //               height: 76.h,
  //               width: 72.w,
  //             ),
  //             Positioned(
  //               child: Center(
  //                   child: Container(
  //                 width: 72.w,
  //                 height: 72.h,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(28.8.r),
  //                 ),
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.circular(28.8.r),
  //                   child:
  //                   c.friends![index].user!.userInfo!.profilePic!.trim().isNotEmpty
  //                         ? Image.network(
  //                                       ApiInterface.baseUrl +
  //                                           Endpoints.user +
  //                                           Endpoints.profileImage +
  //                                           c.friends![index].user!.userInfo!.profilePic!.toString(),
  //                                       fit: BoxFit.fill,
  //                                     )
  //                                   : Image.asset(
  //                                       AppImage.sampleAvatar,
  //                                       fit: BoxFit.fill,
  //                                     ),
  //                 ),
  //               )),
  //             ),
  //             Positioned(
  //               top: 58.h,
  //               left: 50.w,
  //               child: Container(
  //                 width: 22.w,
  //                 height: 22.h,
  //                 decoration: BoxDecoration(
  //                   color: AppColors.orangePrimary,
  //                   borderRadius: BorderRadius.circular(8.r),
  //                 ),
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.circular(8.r),
  //                   child: Image.asset(
  //                     AppIcons.checkedIcon,
  //                     fit: BoxFit.fill,
  //                     width: 22.w,
  //                     height: 22.h,
  //                   ),
  //                 ),
  //               ),
  //             )
  //           ],
  //         )),
  //         sizedBoxH(
  //           height: 7,
  //         ),
  //         Text(
  //           "User Name",
  //           style: AppStyles.interMediumStyle(fontSize: 15.4),
  //         )
  //       ],
  //     ),
  //   );
  // }

}
