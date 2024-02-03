import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jyo_app/data/local/post_edit_model.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/utils/app_widgets/app_gradient_btn.dart';
import 'package:jyo_app/utils/app_widgets/app_icon_button.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/create_activity_screen_vm.dart';
import 'package:latlong2/latlong.dart';

import '../resources/app_colors.dart';
import '../resources/app_strings.dart';
import '../resources/app_styles.dart';
import '../utils/app_widgets/app_bar.dart';
import '../utils/common.dart';
import 'explore_screen_view.dart';

class ChooseLocationOnMapScreenView extends StatelessWidget {
  const ChooseLocationOnMapScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateActivityScreenVM>(builder: (c) {
      return Scaffold(
          body: FlutterMap(
        //mapController: c.mapController,

        options: MapOptions(
            minZoom: 5,
            maxZoom: 18,
            zoom: 16,
            center: PostEdit.getPostOrActivity != null
                ? c.selectedLocation != null
                    ? LatLng(c.selectedLocation!.center![1],
                        c.selectedLocation!.center![0])
                    : c.myLocation ?? MapConstants.myLocation
                : c.myLocation ?? MapConstants.myLocation,
            onTap: (tapPosition, point) {
              c.markers.clear();
              c.point = point;
              debugPrint(
                  "Lat long onTaped ${point.latitude}, ${point.longitude}");
              c.markers.add(Marker(
                  height: 40.h,
                  width: 40.w,
                  point: point,
                  builder: ((context) {
                    return SvgPicture.asset(
                      AppIcons.markerBig,
                    );
                  })));
              c.reverseGeocode(point);
              c.update();
            }),
        children: [
          TileLayer(
            urlTemplate: MapConstants.tempTemplateUrl,
            additionalOptions: const {
              "access_token": MapConstants.accessToken,
            },
            userAgentPackageName: MapConstants.userAgentPackageName,
          ),
          MarkerLayer(
            markers: c.markers,
          ),
        ],
      ));
    });
  }

  static void showLocSheet() {
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
  }

  static Widget chooseLocationSheet(b) {
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
                    decoration: BoxDecoration(
                        color: AppColors.texfieldColor,
                        borderRadius: BorderRadius.circular(16.r)),
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
                                    c.selectedLocation?.text ?? "",
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
                                    c.selectedLocation?.properties?.address ??
                                        "",
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
            onPressed: () {
              Get.back();
              Get.back();
            },
            width: double.infinity,
            height: 47,
            margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
          ),
        );
      }),
    );
  }
}
