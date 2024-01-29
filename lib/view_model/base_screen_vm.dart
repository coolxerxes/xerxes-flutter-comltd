import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jyo_app/data/local/user_search_model.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/view/calendar_screen_view.dart';
import 'package:jyo_app/view/timeline_screen_view.dart';
import 'package:jyo_app/view_model/calendar_srceen_vm.dart';
import 'package:jyo_app/view_model/freind_user_profile_screen_vm.dart';
import 'package:jyo_app/view_model/message_screen_vm.dart';
import 'package:jyo_app/view_model/profile_screen_vm.dart';
import 'package:jyo_app/view_model/timeline_screen_vm.dart';

import '../utils/bindings/user_binding.dart';
import '../view/explore_screen_view.dart';
import '../view/friend_user_profile_screen_view.dart';
import '../view/message_screen_view.dart';
import '../view/profile_screen_view.dart';

class BaseScreenVM extends GetxController {
  List<int> bottomSelection = [];
  int selectedIndex = BottomBarSelection.explore;
  bool? deleteVM = true;

  final pages = <String>[
    exploreRoute,
    calendarRoute,
    timelineRoute,
    messageScreenRoute,
    profileRoute,
    friendUserProfileScreeRoute
  ];

  void goToUserProfile(String? userFriendId) {
    selectedIndex = 2;
    update();
    Get.back();
    SearchUser.setId = userFriendId;
    changePage(5);
  }

  void changePage(int index, {deleteVM = true}) {
    selectedIndex = index;
    this.deleteVM = deleteVM;
    update();
    Get.toNamed(pages[index], id: 1);
    //update();
  }

  Route? onGenerateRoute(RouteSettings settings) {
    // Get.deleteAll(force: true);
    if (settings.name == exploreRoute) {
      return GetPageRoute(
        settings: settings,
        page: () => const ExploreScreenView(),
        binding: ExploreScreenBinding(),
      );
    }

    Get.delete<CalendarScreenVM>();
    if (settings.name == calendarRoute) {
      return GetPageRoute(
        settings: settings,
        page: () => const CalendarScreenView(),
        binding: CalendarBinding(),
      );
    }

    if (settings.name == timelineRoute) {
      // if(deleteVM!){
      Get.delete<TimelineScreenVM>(force: true); //}
      //Get.delete<PostsAndActivitiesVM>(force: true);
      return GetPageRoute(
        settings: settings,
        page: () => const TimelineScreenView(),
        binding: TimelineScreenBinding(),
      );
    }

    if (settings.name == messageScreenRoute) {
      Get.delete<MessageScreenVM>(force: true);
      return GetPageRoute(
        settings: settings,
        page: () => const MessageScreenView(),
        binding: MessageScreenBinding(),
      );
    }

    if (settings.name == profileRoute) {
      Get.delete<ProfileScreenVM>(force: true);
      //Get.delete<PostsAndActivitiesVM>(force: true);
      return GetPageRoute(
        settings: settings,
        page: () => const ProfileScreenView(),
        binding: ProfileScreenBinding(),
      );
    }
    if (settings.name == friendUserProfileScreeRoute) {
      Get.delete<FriendUserProfileScreenVM>(force: true);
      // Get.delete<PostsAndActivitiesVM>(force: true);
      return GetPageRoute(
        settings: settings,
        page: () => const FriendUserProfileScreenView(),
        binding: FriendUserProfileScreenBinding(),
      );
    }
    //update();
    return null;
  }
}

class BottomBarSelection {
  static const explore = 0;
  static const calendar = 1;
  static const timeline = 2;
  static const message = 3;
  static const profile = 4;
}
