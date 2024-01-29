import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jyo_app/data/local/user_search_model.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/app_widgets/app_bar.dart';
import 'package:jyo_app/utils/app_widgets/app_icon_button.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view/create_post_screen_view.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/freind_user_profile_screen_vm.dart';
import 'package:jyo_app/view_model/freindlist_screen_vm.dart';

import '../data/remote/api_interface.dart';
import '../data/remote/endpoints.dart';
import '../resources/app_colors.dart';
import '../resources/app_routes.dart';

class FreindlistScreenView extends StatelessWidget {
  const FreindlistScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FriendlistScreenVM>(builder: (c) {
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
              AppStrings.freinds,
              style: AppStyles.interSemiBoldStyle(
                  fontSize: 16, color: AppColors.textColor),
            )
          ],
          actions: [
            MyIconButton(
              onTap: () {},
              icon: AppBarIcons.menuSvg,
              isSvg: true,
              size: 24,
            )
          ],
        ),
        body:  RefreshIndicator(
                  color: AppColors.orangePrimary,
                  onRefresh: () async {
                    c.init();
                    return;
                  },
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
                color: AppColors.white,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppImage.shareNew,
                      width: 40.w,
                      height: 40.h,
                    ),
                    sizedBoxW(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.shareJYO,
                            style: AppStyles.interSemiBoldStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            AppStrings.inviteJYO,
                            style: AppStyles.interRegularStyle(
                                fontSize: 14, color: AppColors.hintTextColor),
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
              sizedBoxH(height: 8),
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
                                  c.searchedFriends!.clear();
                                  c.searchedFriends!.addAll(c.friends!);
                                } else {
                                  c.search(t);
                                }
                                c.update();
                              },
                              radius:30
                            )
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
                            c.searchedFriends!.isEmpty
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
                                    itemCount: c.searchedFriends!
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
        ),
      ));
    });
  }

  Widget userCard(FriendlistScreenVM c, index) {
    return InkWell(
      onTap: () {
        SearchUser.setId = c.searchedFriends![index].user!.userId.toString();
        //Get.back();
        Get.delete<FriendUserProfileScreenVM>(force: true);
        getToNamed(friendUserProfileScreeRoute);
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
                  child: (c.searchedFriends![index].user!.profilePic !=
                              null &&
                          c.searchedFriends![index].user!.profilePic!
                              .isNotEmpty)
                      ? 
                      MyAvatar(url: ApiInterface.baseUrl +
                              Endpoints.user +
                              Endpoints.profileImage +
                              c.searchedFriends![index].user!.profilePic!
                                  .toString(),
                              height: 72,
                              width: 72,
                              radiusAll: 28.8,
                              isNetwork: true,    
                                  ):
                                MyAvatar(url: AppImage.sampleAvatar,
                              height: 72,
                              width: 72,
                              radiusAll: 28.8,
                                  )  ,
                      
                ),
                // Positioned(
                //   top: 58.h,
                //   left: 50.w,
                //   child: Container(
                //     width: 22.w,
                //     height: 22.h,
                //     decoration: BoxDecoration(
                //       color: AppColors.orangePrimary,
                //       borderRadius: BorderRadius.circular(8.r),
                //     ),
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(8.r),
                //       child: Image.asset(
                //         AppIcons.checkedIcon,
                //         fit: BoxFit.fill,
                //         width: 22.w,
                //         height: 22.h,
                //       ),
                //     ),
                //   ),
                // )
              ],
            )),
            sizedBoxH(
              height: 7,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  c.searchedFriends![index].user!.firstName.toString() +
                      " " +
                      c.searchedFriends![index].user!.lastName.toString(),
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
}
