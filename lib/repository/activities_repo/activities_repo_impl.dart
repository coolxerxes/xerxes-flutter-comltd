import 'package:jyo_app/data/remote/api_service.dart';
import 'package:jyo_app/repository/activities_repo/activities_repo.dart';
import 'package:jyo_app/view_model/calendar_srceen_vm.dart';

import '../../resources/app_image.dart';

class ActivitiesRepoImpl extends ActivitiesRepo {
  ApiService apiService = ApiService();

  @override
  Future<List<CalendarData>> getCalendarEvents(Map data) async {
    List<CalendarData> events = List.empty(growable: true);
    events.add(CalendarData(
        activityOrGroupName: "Sat Nite Jamming",
        date: "Tomorrow",
        heading: "Saturday Night Jamming at Braddell Park - Accoustic",
        time: "8.00 PM",
        id: "0",
        image: AppImage.avatar2,
        location: "Braddell Park Toa Payoh"));

    events.add(CalendarData(
        activityOrGroupName: "Singapore Brave Introverts",
        date: "Sun, 2 May",
        heading: "Sunday Morning at Universal Studio",
        time: "7.00 AM",
        id: "1",
        image: AppImage.avatar1,
        location: "Universal Studio Singapore"));

    events.add(CalendarData(
        activityOrGroupName: "Jimmy Kim",
        date: "Sun, 2 May",
        heading: "Leisure and Chills at Singapore Botanic Gardens",
        time: "5.00 PM",
        id: "1",
        image: AppImage.avatar1,
        location: "Botanic Gardens"));

    events.add(CalendarData(
        activityOrGroupName: "Singapore Brave Introverts",
        date: "Tue, 6 May",
        heading: "Night Movie Sipderman No Way Home and Chills",
        time: "7.30 PM",
        id: "2",
        image: AppImage.avatar3,
        location: "Serangoon Cinema"));

    events.add(CalendarData(
        activityOrGroupName: "Sat Nite Jamming",
        date: "Sat, 12 May",
        heading: "Saturday Jamming at Wimbly Lu Cafe - 8PM until Late Night",
        time: "8.00 PM",
        id: "2",
        image: AppImage.avatar3,
        location: "Wimbly Lu Cafe"));
    return events;
  }
}
