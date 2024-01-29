import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../resources/app_colors.dart';
import '../resources/app_image.dart';
import '../resources/app_strings.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_bar.dart';
import '../utils/app_widgets/app_icon_button.dart';
import '../utils/app_widgets/setting_list_tile.dart';
import '../utils/common.dart';
import '../view_model/delete_acc_screen_vm.dart';

class DeleteAccScreenView extends StatelessWidget {
  const DeleteAccScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeleteAccScreenVM>(builder: (c) {
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
                  Text(AppStrings.deleteAcc,
                      style: AppStyles.interSemiBoldStyle(
                          fontSize: 16.0, color: AppColors.textColor))
                ],
              ),
              body: Container(
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: ListView(children: [
                    sizedBoxH(
                      height: 24,
                    ),
                    SettingListTile(
                      text: AppStrings.deleteMyAcc,
                      icon: const Icon(
                        Icons.keyboard_arrow_right,
                        color: AppColors.textColor,
                      ),
                      onTap: () {
                        showFlexibleBottomSheet(
                          initHeight: 0.65,
                          //isExpand: true,
                          minHeight: 0,
                          maxHeight: 0.85,
                          //isCollapsible: true,
                          bottomSheetColor: Colors.transparent,
                          context: getContext(),
                          builder: (a, b, c) {
                            return deleteAccSheet(b);
                          },
                          anchors: [0, 0.65, 0.85],
                          isSafeArea: true,
                        );
                        // getToNamed(postPrivacyRoute);
                      },
                    )
                  ]))));
    });
  }

  Widget deleteAccSheet(ScrollController b) {
    return GetBuilder<DeleteAccScreenVM>(
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
                    Text(AppStrings.deleteMyAcc,
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
                      sizedBoxH(
                        height: 24,
                      ),
                      Text(
                        AppStrings.deleteAccWarning,
                        style: AppStyles.interSemiBoldStyle(fontSize: 18.0),
                      )
                    ],
                  ),
                ),
                sizedBoxH(
                        height: 16,
                      ),
                Container(
                  margin:EdgeInsets.symmetric(horizontal: 22.w, ),
                  child: Text(AppStrings.detailDelMsg, style: AppStyles.interRegularStyle(fontSize: 17.2), ),
                ),
                sizedBoxH(height:  24),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Material(
                            type: MaterialType.transparency,
                            borderRadius: BorderRadius.circular(100.r),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100.r),
                              onTap: () {
                                Get.back();
                                c.deleteAccount();
                              },
                              child: SizedBox(
                                height: 47.h,
                                child: Center(
                                    child: Text(
                                  AppStrings.iUnderstand +
                                      ". " +
                                      AppStrings.deleteMyAcc,
                                  style: AppStyles.interMediumStyle(
                                      color: AppColors.white),
                                  textAlign: TextAlign.center,
                                )),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ));
      },
    );
  }
}
