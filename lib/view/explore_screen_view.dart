import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/app_widgets/app_gradient_btn.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view_model/explore_screen_vm.dart';
import 'package:latlong2/latlong.dart';

import '../resources/app_colors.dart';

class ExploreScreenView extends StatelessWidget {
  const ExploreScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExploreScreenVM>(
      builder: (c) {
        return Scaffold(
          body: Stack(
            children: [
              FlutterMap(
                //mapController: c.mapController,
                options: MapOptions(
                  minZoom: 5,
                  maxZoom: 25,
                  zoom: 14,
                  center: MapConstants.myLocation,
                ),
                children: [
                  TileLayer(
                    urlTemplate: MapConstants.tempTemplateUrl,
                    additionalOptions: const {
                      "access_token": MapConstants.accessToken,
                    },
                    userAgentPackageName: MapConstants.userAgentPackageName,
                  ),
                ],
              ),
              Positioned(
                top: 50.0.h,
                child: Container(
                  width: MediaQuery.of(context).size.width.w - 40.w,
                  margin: EdgeInsets.symmetric(horizontal: 22.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        //fit: FlexFit.loose,
                        child: InkWell(
                          onTap: () {
                            getToNamed(searchScreenRoute);
                          },
                          child: Container(
                            height: 42.h,
                            padding: EdgeInsets.only(
                                right: 14.w, left: 6.w, top: 4.h, bottom: 4.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.r),
                                color: AppColors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(0, 2),
                                      blurRadius: 4.2,
                                      color: AppColors.dropShadowColor)
                                ]),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  AppIcons.appLogoSearchPng,
                                  width: 31.6.w,
                                  height: 31.6.h,
                                ),
                                sizedBoxW(width: 8.w),
                                Expanded(
                                    //fit: FlexFit.loose,
                                    child:
                                        // Text(AppStrings.search,style:AppStyles.interRegularStyle(
                                        //       fontSize: 15,
                                        //       color: AppColors.hintTextColor))
                                        TextField(
                                  readOnly: true,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: AppStrings.search,
                                      hintStyle: AppStyles.interRegularStyle(
                                          fontSize: 15,
                                          color: AppColors.hintTextColor)),
                                )),
                                sizedBoxW(width: 8.w),
                                SvgPicture.asset(
                                  AppIcons.filterSvg,
                                  width: 24.w,
                                  height: 24.h,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      sizedBoxW(width: 8.w),
                      Container(
                        width: 42.w,
                        height: 42.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.r),
                            color: AppColors.white,
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(0, 2),
                                  blurRadius: 4.2,
                                  color: AppColors.dropShadowColor)
                            ]),
                        child: Center(
                          child: SvgPicture.asset(
                            AppIcons.bookmarkSvg,
                            width: 24.w,
                            height: 24.h,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              sizedBoxW(width: 20),
              AppGradientButton(
                btnText: "Create Activity",
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
                onPressed: () {
                  getToNamed(createActivityScreenRoute);
                },
                icon: const Icon(
                  Icons.add,
                  color: AppColors.white,
                ),
                height: 42,
                width: 185,
              ),
            ],
          ),
        );
      },
    );
  }
}

class MapConstants {
  static final myLocation = LatLng(1.3255469230359649, 103.84470913798347);
  static const accessToken =
      "pk.eyJ1IjoiamlveW91b3V0IiwiYSI6ImNsZ2RxaHhhdjFsaWszdXBjd3RyNW9rbHgifQ.ob5UJhY4lWPDJsf4AoCeoA";
  static const tempTemplateUrl =
      "https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token={access_token}";

  static const userAgentPackageName = "com.jioyouout";
}
