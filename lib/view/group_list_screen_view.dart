import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/utils/app_widgets/app_icon_button.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view/group_suggestion_view.dart';
import 'package:jyo_app/view_model/create_group_screen_vm.dart';
import 'package:jyo_app/view_model/group_list_screen_vm.dart';

import '../resources/app_colors.dart';
import '../resources/app_image.dart';
import '../resources/app_strings.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_bar.dart';

class GroupListScreenView extends StatelessWidget {
  const GroupListScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupListScreenVM>(builder: (c) {
      return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.white,
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
                  AppStrings.myGroup,
                  style: AppStyles.interMediumStyle(
                      fontSize: 18, color: AppColors.textColor),
                )
              ],
              actions: [
                MyIconButton(
                  onTap: () {
                    Get.delete<CreateGroupScreenVM>();
                    getToNamed(createGroupScreenRoute);
                  },
                  icon: AppBarIcons.plusSvg,
                  isSvg: true,
                  size: 24,
                )
              ],
            ),
            body: ListView(
              children: [
                //sizedBoxH(height: 16),
                Container(
                  color: AppColors.white,
                  padding: EdgeInsets.only(
                      right: 22.w, left: 22.w, bottom: 16.h, top: 16.h),
                  child: Container(
                    height: 41.h,
                    // margin: EdgeInsets.symmetric(horizontal: 22.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
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
                                  borderRadius: BorderRadius.circular(14.r),
                                  boxShadow: c.groupSelection ==
                                          GroupSelection.myGroup
                                      ? [
                                          BoxShadow(
                                              blurRadius: 4.r,
                                              offset: const Offset(1, 1),
                                              color: AppColors.tabShadowColor)
                                        ]
                                      : null,
                                  color:
                                      c.groupSelection == GroupSelection.myGroup
                                          ? AppColors.white
                                          : AppColors.tabBkgColor),
                              child: Material(
                                borderRadius: BorderRadius.circular(14.r),
                                type: MaterialType.transparency,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14.r),
                                  onTap: () {
                                    c.groupSelection = GroupSelection.myGroup;
                                    c.update();
                                  },
                                  child: Center(
                                    child: Text(
                                      AppStrings.myGroup,
                                      style: AppStyles.interMediumStyle(
                                          fontSize: 12.8,
                                          color: c.groupSelection ==
                                                  GroupSelection.myGroup
                                              ? AppColors.textColor
                                              : AppColors.editBorderColor),
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
                                  borderRadius: BorderRadius.circular(14.r),
                                  boxShadow: c.groupSelection ==
                                          GroupSelection.pending
                                      ? [
                                          BoxShadow(
                                              blurRadius: 4.r,
                                              offset: const Offset(1, 1),
                                              color: AppColors.tabShadowColor)
                                        ]
                                      : null,
                                  color:
                                      c.groupSelection == GroupSelection.pending
                                          ? AppColors.white
                                          : AppColors.tabBkgColor),
                              child: Material(
                                  borderRadius: BorderRadius.circular(14.r),
                                  type: MaterialType.transparency,
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(14.r),
                                      onTap: () {
                                        c.groupSelection =
                                            GroupSelection.pending;
                                        c.update();
                                      },
                                      child: Center(
                                        child: Text(
                                          AppStrings.pending,
                                          style: AppStyles.interMediumStyle(
                                              fontSize: 12.8,
                                              color: c.groupSelection ==
                                                      GroupSelection.pending
                                                  ? AppColors.textColor
                                                  : AppColors.editBorderColor),
                                        ),
                                      ))),
                            ))
                      ],
                    ),
                  ),
                ),
                c.groupSelection == GroupSelection.myGroup
                    ? Container(
                        color: AppColors.white,
                        margin: EdgeInsets.symmetric(horizontal: 22.w),
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12.h,
                              mainAxisSpacing: 16.w,
                              mainAxisExtent: 169.h,
                            ),
                            itemCount: c.groups.length,
                            itemBuilder: (context, index) {
                              return GroupCard(
                                groupData: c.groups[index],
                                onTap: () {
                                  getToNamed(groupDetailsScreenRoute,
                                      argument: {
                                        "groupId":
                                            c.groups[index].groupId.toString()
                                      });
                                },
                              );
                            }),
                      )
                    : Container(
                        color: AppColors.white,
                        margin: EdgeInsets.symmetric(horizontal: 22.w),
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12.h,
                              mainAxisSpacing: 16.w,
                              mainAxisExtent: 200.h,
                            ),
                            itemCount: c.pendingGroups.length,
                            itemBuilder: (context, index) {
                              return GroupCard(
                                groupData: c.pendingGroups[index],
                                onTap: () {
                                  getToNamed(groupDetailsScreenRoute,
                                      argument: {
                                        "groupId": c
                                            .pendingGroups[index].groupId
                                            .toString()
                                      });
                                },
                              );
                            }),
                      )
              ],
            )),
      );
    });
  }
}

class GroupSelection {
  static const myGroup = 0;
  static const pending = 1;
}
