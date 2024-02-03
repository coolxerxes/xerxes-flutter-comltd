// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/utils/app_widgets/app_gradient_btn.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:jyo_app/view/profile_screen_view.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/create_activity_screen_vm.dart';
import 'package:jyo_app/view_model/explore_screen_vm.dart';
import 'package:latlong2/latlong.dart' as ll;
//import 'package:latlong2/latlong.dart';
import 'package:showcaseview/showcaseview.dart';

import '../data/local/sort_card_data.dart';
import '../data/local/tour.dart';
import '../models/posts_model/post_and_activity_model.dart';
import '../resources/app_colors.dart';
import '../utils/app_widgets/app_bar.dart';
import '../utils/app_widgets/app_icon_button.dart';

class ExploreScreenView extends StatelessWidget {
  const ExploreScreenView({Key? key}) : super(key: key);
  static var ctx;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExploreScreenVM>(
      builder: (c) {
        return ShowCaseWidget(
            disableBarrierInteraction: true,
            onStart: (index, key) {},
            onComplete: (index, key) async {
              c.step++;
              await SecuredStorage.writeStringValue(
                  Keys.overviewStep, c.step.toString());
              String? userId =
                  await SecuredStorage.readStringValue(Keys.userId);
              SecuredStorage.updateTourStep(
                  {"userId": userId.toString(), "steps": c.step.toString()});
            },
            onFinish: () {
              //End tour
              Tour.setIsTourRunning = false;
              c.update();
              c.bsvm.update();
            },
            builder: Builder(
              builder: (context) {
                ctx = context;
                return Scaffold(
                  body: Stack(
                    children: [
                      !c.showMap
                          ? const Center(
                              child: CircularProgressIndicator(
                              color: AppColors.orangePrimary,
                            ))
                          : FlutterMap(
                              mapController: c.mapController,
                              options: MapOptions(
                                minZoom: 5,
                                maxZoom: 18,
                                zoom: c.zoom,
                                center: c.locationData != null
                                    ? ll.LatLng(c.locationData!.latitude!,
                                        c.locationData!.longitude!)
                                    : MapConstants.myLocation,
                                onPositionChanged: (position, hasGesture) {},
                                onMapReady: () {
                                  c.isMapReady = true;
                                  if (c.myLocMarkers.isNotEmpty) {
                                    c.mapController
                                        .move(c.myLocMarkers[0].point, c.zoom);
                                    c.update();
                                  }
                                },
                                onTap: (tapPosition, point) {
                                  c.pc.hideAllPopups();

                                  c.update();
                                },
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: MapConstants.tempTemplateUrl,
                                  additionalOptions: const {
                                    "access_token": MapConstants.accessToken,
                                  },
                                  userAgentPackageName:
                                      MapConstants.userAgentPackageName,
                                ),
                                MarkerLayer(
                                  markers: c.myLocMarkers,
                                ),
                                MarkerClusterLayerWidget(
                                  options: MarkerClusterLayerOptions(
                                    maxClusterRadius: 45,
                                    size: const Size(160, 50),
                                    anchor: AnchorPos.align(AnchorAlign.center),
                                    fitBoundsOptions: const FitBoundsOptions(
                                      padding: EdgeInsets.all(50),
                                      maxZoom: 15,
                                    ),
                                    onMarkerTap: (marker) {
                                      debugPrint("marker" + marker.toString());
                                    },
                                    onClusterTap: (markerClusterNode) async {
                                      List<String> ids =
                                          List.empty(growable: true);

                                      for (int i = 0;
                                          i < markerClusterNode.markers.length;
                                          i++) {
                                        String id = c.getActivityId(
                                            markerClusterNode.markers[i].key);
                                        ids.add(id);
                                      }
                                      c.clusteredActivities.clear();
                                      c.update();
                                      showclusterSheet((c.clusteredActivities));
                                      c.getActivitys(ids).then((value) {
                                        c.clusteredActivities.addAll(value);
                                        c.update();
                                      });
                                    },
                                    popupOptions: PopupOptions(
                                      popupController: c.pc,
                                      popupBuilder: (context, marker) {
                                        return Container(
                                          margin: EdgeInsets.only(bottom: 7.h),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ActivityWidget.activity(
                                                  c.activity, c.c, c,
                                                  isFromExplore: true,
                                                  showCoverInsteadOfMap: true,
                                                  onPreTap: () {
                                                c.pc.hideAllPopups();
                                                c.update();
                                              },
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 24.w,
                                                      vertical: 0.h),
                                                  radius: 16.r,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12.r,
                                                      vertical: 12.r)),
                                              CustomPaint(
                                                size: const Size(15, 10),
                                                painter: TrianglePainter(
                                                    color: AppColors.white),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      popupState: PopupState(
                                          initiallySelectedMarkers: c.markers),
                                    ),
                                    zoomToBoundsOnClick: false,
                                    centerMarkerOnClick: true,
                                    markers: c.markers,
                                    builder: (context, markers) {
                                      return Container(
                                        color: Colors.transparent,
                                        height: 50.h,
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  //width: 150.w,
                                                  height: 50.h,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5.w,
                                                      vertical: 4.h),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.r),
                                                      color: AppColors
                                                          .orangePrimary,
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: AppColors
                                                              .dropShadowColor,
                                                          blurRadius: 4.2,
                                                          offset: Offset(0, 2),
                                                        )
                                                      ]),
                                                  child: Center(
                                                      child: Row(
                                                    children: [
                                                      Stack(
                                                          children:
                                                              // Row(
                                                              //     mainAxisSize:
                                                              //         MainAxisSize.min,
                                                              //     children:
                                                              List.generate(
                                                                  markers.length >
                                                                          3
                                                                      ? 3
                                                                      : markers
                                                                          .length,
                                                                  (index) {
                                                        return Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: index *
                                                                      30),
                                                          child: Container(
                                                              width: 42.h,
                                                              height: 42.h,
                                                              // margin: EdgeInsets.only() ,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(1.5),
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      AppColors
                                                                          .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              16.r)),
                                                              child: MyAvatar(
                                                                url: c.getUrl(
                                                                    markers[index]
                                                                        .key),
                                                                height: 40.h,
                                                                width: 40.h,
                                                                radiusAll: 16.r,
                                                                isNetwork: true,
                                                              )),
                                                        );
                                                      }) //),
                                                          //],
                                                          ),
                                                      Text(
                                                        markers.length > 3
                                                            ? ("+" +
                                                                (markers.length -
                                                                        3)
                                                                    .toString())
                                                            : "",
                                                        style: AppStyles
                                                            .interMediumStyle(
                                                          color:
                                                              AppColors.white,
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                // PopupMarkerLayerWidget(
                                //   options: PopupMarkerLayerOptions(
                                //     markers: c.markers,
                                //     popupBuilder: (p0, p1) {
                                //       return Container(
                                //         child: Text("This is popup"),
                                //       );
                                //     },
                                //   ),
                                // )
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
                                  child: Showcase.withWidget(
                                    disableMovingAnimation: true,
                                    onBarrierClick: () {},
                                    key: c.key1!,
                                    // description: "Find new activities, friends and groups in\none place!",
                                    width: MediaQuery.of(context).size.width,
                                    height: 100.h,

                                    // targetPadding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                                    targetShapeBorder: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14.r)),
                                    targetBorderRadius:
                                        BorderRadius.circular(14.r),
                                    container: TourToolTip(
                                      //tooltipPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.57),
                                      isArrowDown: false,
                                      tourText:
                                          "Find new activities, friends and groups in\none place!",
                                      width: MediaQuery.of(context).size.width -
                                          50.w,
                                      onTap: () {
                                        ShowCaseWidget.of(ctx).next();
                                      },
                                    ),

                                    child: Container(
                                      height: 42.h,
                                      padding: EdgeInsets.only(
                                          right: 14.w,
                                          left: 6.w,
                                          top: 4.h,
                                          bottom: 4.h),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14.r),
                                          color: AppColors.white,
                                          boxShadow: const [
                                            BoxShadow(
                                                offset: Offset(0, 2),
                                                blurRadius: 4.2,
                                                color:
                                                    AppColors.dropShadowColor)
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
                                                hintStyle:
                                                    AppStyles.interRegularStyle(
                                                        fontSize: 15,
                                                        color: AppColors
                                                            .hintTextColor)),
                                          )),
                                          sizedBoxW(width: 8.w),
                                          InkWell(
                                            onTap: () async {
                                              await setFilterData(c);

                                              showFlexibleBottomSheet(
                                                initHeight: 0.95,
                                                isExpand: true,
                                                minHeight: 0,
                                                maxHeight: 0.96,
                                                //isCollapsible: true,
                                                bottomSheetColor:
                                                    Colors.transparent,
                                                context: getContext(),
                                                builder: (a, b, d) {
                                                  return filterSheet(b);
                                                },
                                                anchors: [0, 0.95, 0.96],
                                                isSafeArea: true,
                                              );
                                            },
                                            child: SvgPicture.asset(
                                              AppIcons.filterSvg,
                                              width: 24.w,
                                              height: 24.h,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              sizedBoxW(width: 8.w),
                              InkWell(
                                  onTap: () {
                                    getToNamed(
                                        listOfSavedActivitiesScreenRoute);
                                  },
                                  child: Showcase.withWidget(
                                    disableMovingAnimation: true,
                                    onBarrierClick: () {},
                                    key: c.key2!,
                                    // description: "Find new activities, friends and groups in\none place!",
                                    width: MediaQuery.of(context).size.width,
                                    height: 100.h,
                                    // targetPadding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                                    targetShapeBorder: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14.r)),
                                    targetBorderRadius:
                                        BorderRadius.circular(14.r),
                                    container: Container(
                                        margin: EdgeInsets.only(left: 22.w),
                                        child: TourToolTip(
                                          tooltipPadding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.57),
                                          isArrowDown: false,
                                          tourText:
                                              "Still consider to join the activity? save them and find here!",
                                          width: (MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50),
                                          onTap: () {
                                            ShowCaseWidget.of(ctx).next();
                                          },
                                        )),
                                    child: Container(
                                      width: 42.w,
                                      height: 42.h,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14.r),
                                          color: AppColors.white,
                                          boxShadow: const [
                                            BoxShadow(
                                                offset: Offset(0, 2),
                                                blurRadius: 4.2,
                                                color:
                                                    AppColors.dropShadowColor)
                                          ]),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          AppIcons.bookmarkSvg,
                                          width: 24.w,
                                          height: 24.h,
                                        ),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  floatingActionButton: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      sizedBoxW(width: 20),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 50.h),
                              child: Showcase.withWidget(
                                  disableMovingAnimation: true,
                                  onBarrierClick: () {},
                                  tooltipPosition: TooltipPosition.top,
                                  key: c.key3!,
                                  // description: "Find new activities, friends and groups in\none place!",
                                  width: MediaQuery.of(context).size.width,
                                  height: 100.h,
                                  // targetPadding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                                  targetShapeBorder: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100.r)),
                                  targetBorderRadius:
                                      BorderRadius.circular(100),
                                  container: Container(
                                      margin: EdgeInsets.only(left: 0.w),
                                      child: TourToolTip(
                                        isArrowDown: true,
                                        tourText:
                                            "You can create your own activity and find new people ✨",
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                55),
                                        onTap: () {
                                          ShowCaseWidget.of(ctx).next();
                                        },
                                      )),
                                  child: AppGradientButton(
                                    btnText: "Create Activity",
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5.h, horizontal: 12.w),
                                    onPressed: () {
                                      Get.delete<CreateActivityScreenVM>();
                                      getToNamed(createActivityScreenRoute);
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      color: AppColors.white,
                                    ),
                                    height: 42,
                                    width: 185,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 45.w,
                        height: 45.h,
                        child: FloatingActionButton(
                          onPressed: () {
                            c.getLocation();
                          },
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.my_location_rounded),
                        ),
                      )
                    ],
                  ),
                );
              },
            ));
      },
    );
  }

  Future<void> setFilterData(ExploreScreenVM c) async {
    dynamic catgList = await SecuredStorage.readStringValue(Keys.catList);
    if (isValidString(catgList)) {
      List ca = jsonDecode(catgList) as List;
      int idx = -1;
      for (int i = 0; i < ca.length; i++) {
        idx = c.catList.indexWhere((element) {
          return element.id.toString() == ca[i].toString();
        });
        if (idx != -1) {
          c.catList[idx].isSelected = true;
        }
      }
    }

    dynamic radius = await SecuredStorage.readStringValue(Keys.radius);
    if (isValidString(radius)) {
      c.radius = double.parse(radius);
    }

    dynamic sortBy = await SecuredStorage.readStringValue(Keys.sortBy);
    if (isValidString(sortBy)) {
      for (int i = 0; i < c.sortList.length; i++) {
        if (c.sortList[i] == sortBy) {
          c.selectedSort = i;
        }
      }
    }

    c.update();
  }

  Widget filterSheet(b) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
      child: GetBuilder<ExploreScreenVM>(builder: (c) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.r),
                  topRight: Radius.circular(32.r)),
              child: SingleChildScrollView(
                  controller: b,
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
                      //sizedBoxH(height: 15),
                      MyAppBar(
                        leading: [
                          MyIconButton(
                              onTap: () {
                                Get.back();
                              },
                              isSvg: true,
                              size: 24,
                              icon: AppIcons.closeSvg)
                        ],
                        middle: [
                          Text(
                            AppStrings.filter,
                            style: AppStyles.interSemiBoldStyle(fontSize: 16),
                          ),
                        ],
                        actions: [
                          MyIconButton(
                              onTap: () async {
                                //  Get.back();
                                SecuredStorage.writeStringValue(
                                    Keys.sortBy, "Nearest");
                                SecuredStorage.writeStringValue(
                                    Keys.catList, "");
                                SecuredStorage.writeStringValue(
                                    Keys.radius, "24");

                                for (int i = 0; i < c.catList.length; i++) {
                                  c.catList[i].setIsSelected = false;
                                }

                                c.selectedSort = 0;
                                c.radius = 24.0;

                                c.update();
                              },
                              size: 24,
                              isSvg: true,
                              icon: AppIcons.reloadSvg)
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                                height: 8.h,
                                color:
                                    AppColors.white //AppColors.texfieldColor,
                                ),
                          ),
                        ],
                      ),
                      sizedBoxH(height: 16.h),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 22.w),
                            child: Text(
                              AppStrings.sortBy,
                              style: AppStyles.interMediumStyle(),
                            ),
                          ),
                        ],
                      ),
                      sizedBoxH(height: 16.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.w),
                        child: Row(
                          children: List.generate(c.sortList.length, (index) {
                            return SortCard(
                              index: c.selectedSort,
                              sortCardData: c.sortList[index],
                            );
                          }),
                        ),
                      ),
                      sizedBoxH(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            height: 8.h,
                            color: AppColors.appBkgColor,
                          ))
                        ],
                      ),
                      sizedBoxH(height: 16.h),

                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 22.w),
                            child: Text(
                              AppStrings.radius,
                              style: AppStyles.interMediumStyle(),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 22.w),
                            child: Text(
                              c.radius.toStringAsFixed(0) + " km",
                              style: AppStyles.interRegularStyle(
                                  color: AppColors.hintTextColor,
                                  fontSize: 17.2),
                            ),
                          ),
                        ],
                      ),
                      sizedBoxH(height: 16.h),
                      SliderTheme(
                          data: const SliderThemeData(
                              thumbColor: AppColors.white,
                              rangeThumbShape: RoundRangeSliderThumbShape(
                                  enabledThumbRadius: 15,
                                  disabledThumbRadius: 15)),
                          child: Slider(
                            value: c.radius,
                            onChanged: (radius) {
                              c.radius = radius;
                              c.update();
                            },
                            min: 1,
                            max: 12000,
                          )),
                      sizedBoxH(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            height: 8.h,
                            color: AppColors.appBkgColor,
                          ))
                        ],
                      ),
                      sizedBoxH(height: 16.h),
                      // Expanded(
                      // child:
                      // SingleChildScrollView(
                      //     controller: b,
                      //child:
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.w),
                        child: Wrap(
                          direction: Axis.horizontal,
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(c.catList.length, (index) {
                            return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  gradient: c.catList[index].getIsSelected!
                                      ? const LinearGradient(
                                          colors: [
                                              Color(0xffFFD036),
                                              Color(0xffFFA43C)
                                            ],
                                          transform: GradientRotation(240) //120
                                          )
                                      : null,
                                  color: AppColors.texfieldColor,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 10.h),
                                child: Material(
                                  type: MaterialType.transparency,
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10.r),
                                    onTap: () {
                                      c.catList[index].setIsSelected =
                                          !c.catList[index].getIsSelected!;
                                      //c.isIntrestListEmpty();

                                      c.update();
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.network(c.catList[index].icon!),
                                        sizedBoxW(width: 8),
                                        Text(
                                          c.catList[index].name!,
                                          style: AppStyles.interMediumStyle(
                                              fontSize: 14.6,
                                              color: c.catList[index]
                                                      .getIsSelected!
                                                  ? AppColors.white
                                                  : AppColors.textColor),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                          }),
                        ),
                      ) //),
                      //),
                    ],
                  ))),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppGradientButton(
                    width: 200,
                    btnText: AppStrings.showResult,
                    onPressed: () {
                      c.showResult();
                    }),
              ],
            ),
          ),
        );
      }),
    );
  }

  static void showclusterSheet(List<PostOrActivity> activities) {
    showFlexibleBottomSheet(
      initHeight: 0.39,
      isExpand: true,
      minHeight: 0,
      maxHeight: 0.55,
      //isCollapsible: true,
      bottomSheetColor: Colors.transparent,
      context: getContext(),
      builder: (a, b, d) {
        return clusterSheet(b, activities);
      },
      anchors: [0, 0.39, 0.55],
      isSafeArea: true,
    );
  }

  static Widget clusterSheet(b, List<PostOrActivity> activities) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
      child: GetBuilder<ExploreScreenVM>(builder: (c) {
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
                      Row(
                        children: [
                          const Icon(Icons.place),
                          sizedBoxW(width: 8),
                          Text(
                            "Activites at this location", //"Bukit Timah Plaza Singapore",
                            style: AppStyles.interSemiBoldStyle(fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: c.clusteredActivities.isEmpty
                        ? SizedBox(
                            height: 250.h,
                            child: const Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.orangePrimary),
                            ),
                          )
                        : Row(
                            children: List.generate(activities.length, (index) {
                            return SizedBox(
                              width: MediaQuery.of(getContext()).size.width,
                              child: ActivityWidget.activity(
                                  activities[index], c.c, c,
                                  isFromExplore: true,
                                  showCoverInsteadOfMap: true, onPreTap: () {
                                Get.back();
                              },
                                  color: AppColors.lightGray.value,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 24.w, vertical: 15.h),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 15.h),
                                  radius: 16.0),
                            );
                          })),
                  )
                ],
              )),
        );
      }),
    );
  }

  static void showcase(ExploreScreenVM c) async {
    bool? isOverviewed = await SecuredStorage.readBoolValue(Keys.isOverviewed);
    String? overViewStep =
        await SecuredStorage.readStringValue(Keys.overviewStep);
    debugPrint("Step $overViewStep, isOverview $isOverviewed");
    c.step = int.parse(overViewStep!);
    if (c.step == 0) {
      c.list.add(c.key1!);
      c.list.add(c.key2!);
      c.list.add(c.key3!);
    } else if (c.step == 1) {
      c.list.add(c.key2!);
      c.list.add(c.key3!);
    } else if (c.step == 2) {
      c.list.add(c.key3!);
    }

    if (!isOverviewed! && c.step < 3) {
      Tour.setIsTourRunning = true;
      ShowCaseWidget.of(ctx).startShowCase(c.list);
      c.update();
      c.bsvm.update();
    }
  }
}

class SortCard extends StatelessWidget {
  const SortCard({
    required this.sortCardData,
    required this.index,
    Key? key,
  }) : super(key: key);

  final int index;
  final SortCardData sortCardData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 12.w),
      child: InkWell(
        borderRadius: BorderRadius.circular(100.r),
        onTap: sortCardData.onTap,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.r),
              border: Border.all(
                  color: index == sortCardData.index
                      ? AppColors.orangePrimary
                      : AppColors.hintTextColor)),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Center(
              child: Text(
            sortCardData.sortBy,
            style: AppStyles.interMediumStyle(
                color: index == sortCardData.index
                    ? AppColors.orangePrimary
                    : AppColors.hintTextColor),
          )),
        ),
      ),
    );
  }
}

class TourToolTip extends StatelessWidget {
  const TourToolTip({
    required this.tourText,
    required this.width,
    required this.onTap,
    this.tooltipPadding,
    this.isArrowDown = true,
    Key? key,
  }) : super(key: key);

  final String? tourText;
  final double? width;
  final VoidCallback? onTap;
  final EdgeInsets? tooltipPadding;
  final bool? isArrowDown;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        !isArrowDown!
            ? Padding(
                padding: tooltipPadding ??
                    EdgeInsets.only(
                        right: MediaQuery.of(getContext()).size.width * 0.23),
                child: CustomPaint(
                  size: const Size(15, 15),
                  painter: TrianglePainter(
                      color: AppColors.white, isDownArrow: isArrowDown!),
                ),
              )
            : Container(),
        Container(
          margin: EdgeInsets.only(right: 100.w),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: width,
                  margin: EdgeInsets.only(bottom: 5.h),
                  child: Text(
                    tourText!,
                    style: AppStyles.interMediumStyle(fontSize: 17.2),
                  )),
              sizedBoxH(height: 5),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: onTap,
                    child: Text(
                      "OK",
                      style: AppStyles.interSemiBoldStyle(
                          fontSize: 18, color: AppColors.orangePrimary),
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        isArrowDown!
            ? Padding(
                padding: tooltipPadding ??
                    EdgeInsets.only(
                        right: MediaQuery.of(getContext()).size.width * 0.23),
                child: CustomPaint(
                  size: const Size(15, 15),
                  painter: TrianglePainter(
                      color: AppColors.white, isDownArrow: isArrowDown!),
                ),
              )
            : Container(),
      ],
    );
  }
}

class Arrow extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;
  final bool isUpArrow;
  final Paint _paint;

  Arrow({
    this.strokeColor = Colors.black,
    this.strokeWidth = 3,
    this.paintingStyle = PaintingStyle.stroke,
    this.isUpArrow = true,
  }) : _paint = Paint()
          ..color = strokeColor
          ..strokeWidth = strokeWidth
          ..style = paintingStyle;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(getTrianglePath(size.width, size.height), _paint);
  }

  Path getTrianglePath(double x, double y) {
    if (isUpArrow) {
      return Path()
        ..moveTo(0, y)
        ..lineTo(x / 2, 0)
        ..lineTo(x, y)
        ..lineTo(0, y);
    }
    return Path()
      ..moveTo(0, 0)
      ..lineTo(x, 0)
      ..lineTo(x / 2, y)
      ..lineTo(0, 0);
  }

  @override
  bool shouldRepaint(covariant Arrow oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// [TrianglePainter] is custom painter for drawing a triangle for popup
/// to point specific widget
class TrianglePainter extends CustomPainter {
  bool isDownArrow;
  Color color;

  TrianglePainter({this.isDownArrow = true, required this.color});

  /// Draws the triangle of specific [size] on [canvas]
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();
    paint.strokeWidth = 2.0;
    paint.color = color;
    paint.style = PaintingStyle.fill;

    if (isDownArrow) {
      path.moveTo(0.0, -1.0);
      path.lineTo(size.width, -1.0);
      path.lineTo(size.width / 2.0, size.height);
    } else {
      path.moveTo(size.width / 2.0, 0.0);
      path.lineTo(0.0, size.height + 1);
      path.lineTo(size.width, size.height + 1);
    }

    canvas.drawPath(path, paint);
  }

  /// Specifies to redraw for [customPainter]
  @override
  bool shouldRepaint(CustomPainter customPainter) {
    return true;
  }
}

class MapConstants {
  static final myLocation = ll.LatLng(1.3255469230359649, 103.84470913798347);
  static const accessToken =
      "pk.eyJ1IjoiamlveW91b3V0IiwiYSI6ImNsZ2RxaHhhdjFsaWszdXBjd3RyNW9rbHgifQ.ob5UJhY4lWPDJsf4AoCeoA";
  static const tempTemplateUrl =
      "https://api.mapbox.com/styles/v1/jioyouout/clgjc5yll007c01qze00yh4gk/tiles/256/{z}/{x}/{y}@2x?access_token={access_token}";

  //? Working with better zoom
  //"https://api.mapbox.com/styles/v1/jioyouout/clgjc5yll007c01qze00yh4gk/tiles/256/{z}/{x}/{y}@2x?access_token={access_token}";

  //! Not Wroking
  //"https://api.mapbox.com/styles/v1/jioyouout/clgjc5yll007c01qze00yh4gk/tiles/256/{col}/{row}@2x?access_token={access_token}";

  //? Working but less zoom
  //"https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token={access_token}";

  static const userAgentPackageName = "com.jioyouout";
}
