import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/utils/app_widgets/app_gradient_btn.dart';
import 'package:jyo_app/utils/app_widgets/app_icon_button.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/create_activity_screen_vm.dart';

import '../resources/app_colors.dart';
import '../resources/app_strings.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_bar.dart';
import '../utils/common.dart';

class ChooseLocationOnMapScreenView extends StatelessWidget {
  const ChooseLocationOnMapScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateActivityScreenVM>(builder: (c) {
      return Scaffold(
          body: GestureDetector(
        onTap: () {
          showFlexibleBottomSheet(
            initHeight: 0.37,
            isExpand: true,
            minHeight: 0,
            maxHeight: 0.4,
            //isCollapsible: true,
            bottomSheetColor: Colors.transparent,
            context: getContext(),
            builder: (a, b, d) {
              return chooseLocationSheet(b);
            },
            anchors: [0, 0.37, 0.4],
            isSafeArea: true,
          );
        },
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage(AppImage.mapFrame))),
        ),
      ));
    });
  }

  Widget chooseLocationSheet(b) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
      child: GetBuilder<CreateActivityScreenVM>(builder: (c) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.r),
                  topRight: Radius.circular(32.r)),
              child: Column(
                children: [
                  sizedBoxH(height: 15),
                  Container(
                    height: 4.h,
                    width: 54.w,
                    decoration: BoxDecoration(
                        color: AppColors.disabledColor,
                        borderRadius: BorderRadius.circular(100.r)),
                  ),
                  sizedBoxH(height: 15),
                  MyAppBar(
                    leading: [
                      MyIconButton(
                          onTap: () {
                            Get.back();
                          },
                          isSvg: true,
                          icon: AppIcons.closeSvg)
                    ],
                    middle: [
                      Text(
                        AppStrings.chooseLocation,
                        style: AppStyles.interSemiBoldStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  sizedBoxH(height: 15),
                  Container(
                    
                            decoration:  BoxDecoration(
                              color: AppColors.texfieldColor,
                              borderRadius: BorderRadius.circular(16.r)
                              ),
                    margin:
                        EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),    
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyAvatar(
                          width: 40,
                          height: 40,
                          radiusAll: 80,
                          url: AppImage.placePng,
                        ),
                        sizedBoxW(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Starbucks coffe Bishan",
                                    style: AppStyles.interSemiBoldStyle(
                                        fontSize: 16,
                                        textOverflow: TextOverflow.ellipsis),
                                  )),
                                ],
                              ),
                              sizedBoxH(height: 7),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    "51 Bishan Street 13, #01-02 Bishan Community Club, Singapore 579799",
                                    style: AppStyles.interRegularStyle(
                                        fontSize: 14,
                                        textOverflow: TextOverflow.ellipsis,
                                        color: AppColors.editBorderColor),
                                  )),
                                ],
                              ),
                              
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )),
          bottomNavigationBar: AppGradientButton(
            btnText: AppStrings.selectLocation,
            onPressed: () {},
            width: double.infinity,
            height: 47,
            margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
          ),
        );
      }),
    );
  }
}
