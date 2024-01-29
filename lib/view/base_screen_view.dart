// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jyo_app/resources/app_colors.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/resources/app_strings.dart';
import 'package:jyo_app/resources/app_styles.dart';
import 'package:jyo_app/view_model/base_screen_vm.dart';

class BaseScreenView extends StatelessWidget {
  const BaseScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BaseScreenVM>(
      builder: (c) {
        return WillPopScope(
          onWillPop: () async {
            if (c.selectedIndex != 0) {
              c.selectedIndex = 0;
              c.changePage(c.selectedIndex);
              return false;
            } else {
              return true;
            }
          },
          child: SafeArea(
            top: false,
            child: Scaffold(
              backgroundColor: AppColors.appBkgColor,
              body: Navigator(
                key: Get.nestedKey(1),
                initialRoute: exploreRoute, //profileRoute,
                onGenerateRoute: c.onGenerateRoute,
              ),
              bottomNavigationBar: Container(
                  color: AppColors.white,
                  child: Padding(
                      padding:
                          EdgeInsets.only(bottom: Platform.isIOS ? 16.h : 10.h),
                      child: BottomNavBar(
                        children: [
                          //Explore
                          BottomNavChild(
                            index: BottomBarSelection.explore,
                            selectedIcon: NavIcons.navExploreSelectedPng,
                            unSelectedIcon: NavIcons.navExploreUnselected,
                            title: NavTitles.navExplore,
                            isSelected:
                                c.selectedIndex == BottomBarSelection.explore
                                    ? true
                                    : false,
                            onTap: () {
                              c.selectedIndex = BottomBarSelection.explore;
                              c.changePage(BottomBarSelection.explore);
                              c.update();
                            },
                          ),
                          //Calendar
                          BottomNavChild(
                            index: BottomBarSelection.calendar,
                            selectedIcon: NavIcons.navCalendarSelectedPng,
                            unSelectedIcon: NavIcons.navCalendarUnselected,
                            title: NavTitles.navCalendar,
                            isSelected:
                                c.selectedIndex == BottomBarSelection.calendar
                                    ? true
                                    : false,
                            onTap: () {
                              c.selectedIndex = BottomBarSelection.calendar;
                              c.changePage(BottomBarSelection.calendar);
                              c.update();
                            },
                          ),
                          //Timeline
                          BottomNavChild(
                            index: BottomBarSelection.timeline,
                            selectedIcon: NavIcons.navTimelineSelectedPng,
                            unSelectedIcon: NavIcons.navTimelineUnselected,
                            title: NavTitles.navTimeline,
                            isSelected:
                                c.selectedIndex == BottomBarSelection.timeline
                                    ? true
                                    : false,
                            onTap: () {
                              c.selectedIndex = BottomBarSelection.timeline;
                              c.changePage(BottomBarSelection.timeline);
                              c.update();
                            },
                          ),
                          //Message
                          BottomNavChild(
                            index: BottomBarSelection.message,
                            selectedIcon: NavIcons.navMessageSelectedPng,
                            unSelectedIcon: NavIcons.navMessageUnselected,
                            title: NavTitles.navMessage,
                            isSelected:
                                c.selectedIndex == BottomBarSelection.message
                                    ? true
                                    : false,
                            onTap: () {
                              c.selectedIndex = BottomBarSelection.message;
                              c.changePage(BottomBarSelection.message);
                              c.update();
                            },
                          ),
                          //Profile
                          BottomNavChild(
                            index: BottomBarSelection.profile,
                            selectedIcon: NavIcons.navProfileSelectedPng,
                            unSelectedIcon: NavIcons.navProfileUnselected,
                            title: NavTitles.navProfile,
                            isSelected:
                                c.selectedIndex == BottomBarSelection.profile
                                    ? true
                                    : false,
                            onTap: () {
                              c.selectedIndex = BottomBarSelection.profile;
                              c.changePage(BottomBarSelection.profile);
                              c.update();
                            },
                          )
                        ],
                      ))),
            ),
          ),
        );
      },
    );
  }
}

class BottomNavBar extends StatelessWidget {
  BottomNavBar({
    required this.children,
    Key? key,
  }) : super(key: key);

  List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BaseScreenVM>(
      builder: (c) {
        return Container(
          height: 52.h,
          color: AppColors.white,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children ?? [Container()],
          ),
        );
      },
    );
  }
}

class BottomNavChild extends StatelessWidget {
  BottomNavChild({
    required this.selectedIcon,
    required this.unSelectedIcon,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.index,
    Key? key,
  }) : super(key: key);

  String? selectedIcon;
  String? unSelectedIcon;
  String? title;
  bool? isSelected;
  VoidCallback? onTap;
  int? index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BaseScreenVM>(
      builder: (c) {
        return InkWell(
            onTap: onTap,
            child: Container(
              color: AppColors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  !isSelected!
                      ? SvgPicture.asset(
                          unSelectedIcon!,
                          width: 32.w,
                          height: 32.h,
                        )
                      : Image.asset(
                          selectedIcon!,
                          width: 32.w,
                          height: 32.h,
                        ),
                  //const SizedBox(height: 14,),
                  Text(
                    title!,
                    style: AppStyles.interMediumStyle(
                        fontSize: 10.2,
                        color: isSelected!
                            ? AppColors.orangePrimary
                            : AppColors.textColor),
                  )
                ],
              ),
            ));
      },
    );
  }
}
