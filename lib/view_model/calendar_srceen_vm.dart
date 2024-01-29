// ignore_for_file: unused_import

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/repository/activities_repo/activities_repo_impl.dart';
import 'package:jyo_app/resources/app_image.dart';
import 'package:jyo_app/utils/common.dart';

class CalendarScreenVM extends GetxController {
  ActivitiesRepoImpl activitiesRepoImpl = ActivitiesRepoImpl();
  List<CalendarData> events = List.empty(growable: true);

  bool isLoading = true;
  String? selectedDate = "";

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    isLoading = true;
    update();
    Map data = {};
    await activitiesRepoImpl.getCalendarEvents(data).then((res) {
      events.clear();
      events.addAll(res);
      isLoading = false;
      update();
    }).onError((error, stackTrace) {
      isLoading = false;
      update();
      showAppDialog(msg: error.toString());
    });
  }
}

class CalendarData {
  CalendarData(
      {this.id,
      this.image,
      this.heading,
      this.activityOrGroupName,
      this.date,
      this.time,
      this.location});

  String? date;
  String? id;
  String? image;
  String? heading;
  String? activityOrGroupName;
  String? time;
  String? location;
}
