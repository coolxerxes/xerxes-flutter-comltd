import 'package:jyo_app/data/remote/api_service.dart';
import 'package:jyo_app/models/activity_model/accept_invite_to_activity_model.dart';
import 'package:jyo_app/models/activity_model/activity_details_model.dart';
import 'package:jyo_app/models/activity_model/activity_search_model.dart';
import 'package:jyo_app/models/activity_model/list_of_participants_model.dart';
import 'package:jyo_app/models/activity_model/leave_activity_model.dart';
import 'package:jyo_app/models/activity_model/join_activity_model.dart';
import 'package:jyo_app/models/activity_model/invite_to_activity_model.dart';
import 'package:jyo_app/models/activity_model/activity_request_list_model.dart';
import 'package:jyo_app/models/activity_model/map_filtered_activity_model.dart';
import 'package:jyo_app/models/activity_model/reject_invite_activity_model.dart';
import 'package:jyo_app/repository/activities_repo/activities_repo.dart';
import 'package:jyo_app/view_model/calendar_srceen_vm.dart';
import '../../models/activity_model/create_activity_model.dart';
import '../../models/activity_model/delete_activity_model.dart';
import '../../models/activity_model/fetch_activities_model.dart';
import '../../models/activity_model/fetch_saved_activities.dart';
import '../../models/activity_model/map_tapped_activity_model.dart';
import '../../models/posts_model/post_and_activity_model.dart';
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

  @override
  Future<CreateActivityModel> addActivity(Map data) async {
    return CreateActivityModel.fromJson(await apiService.addActivity(data));
  }

  @override
  Future<PostOrActivityModel> getActivityByUser(Map data) async {
    return PostOrActivityModel.parse(FetchActivitiesModel.fromJson(
        await apiService.getActivityByUser(data)));
  }

  @override
  Future updateActivity(Map data, String id) async {
    return apiService.updateActivity(data, id);
  }

  @override
  Future<PostOrActivityModel> listOfSave(Map data) async {
    return PostOrActivityModel.parse(
        FetchSavedActivitiesModel.fromJson(await apiService.listOfSave(data)));
  }

  @override
  Future? saveActivity(Map data) {
    return apiService.saveActivity(data);
  }

  @override
  Future? shareAsPost(Map data) {
    return apiService.shareAsPost(data);
  }

  @override
  Future<DeleteActivityModel> deleteActivity(Map data) async {
    return DeleteActivityModel.fromJson(await apiService.deleteActivity(data));
  }

  @override
  Future<PostOrActivityModel> getActivityDetails(Map data) async {
    return PostOrActivityModel.parse(ActivityDetailsModel.fromJson(
        await apiService.getActivityDetails(data)));
  }

  @override
  Future<MapFilteredActivityModel>? getMapFilteredActity(Map data) async {
    return MapFilteredActivityModel.fromJson(
        await apiService.getMapFilteredActivity(data));
  }

  @override
  Future<PostOrActivityModel> mapTappedActivity(Map data) async {
    return PostOrActivityModel.parse(MapTappedActivityModel.fromJson(
        await apiService.getMapTappedActivity(data)));
  }

  @override
  Future<AcceptInviteToActivityResponse>? acceptInvite(Map data) async {
    return AcceptInviteToActivityResponse.fromJson(
        await apiService.acceptInvite(data));
  }

  @override
  Future<InviteToActivityResponse>? invite(Map data) async {
    return InviteToActivityResponse.fromJson(await apiService.invite(data));
  }

  @override
  Future<JoinActivityResponse>? joinActivity(Map data) async {
    return JoinActivityResponse.fromJson(await apiService.joinActivity(data));
  }

  @override
  Future<LeaveActivityResponse>? leaveActivity(Map data) async {
    return LeaveActivityResponse.fromJson(await apiService.leaveActivity(data));
  }

  @override
  Future<ListOfParticipantsActivityResponse>? participantsList(Map data) async {
    return ListOfParticipantsActivityResponse.fromJson(
        await apiService.participantsList(data));
  }

  @override
  Future<RejectInviteActivityResponse>? rejectInvite(Map data) async {
    return RejectInviteActivityResponse.fromJson(
        await apiService.rejectInvite(data));
  }

  @override
  Future<ActivityRequestListResponse>? requestListToJoin(Map data) async {
    return ActivityRequestListResponse.fromJson(
        await apiService.requestListToJoin(data));
  }

  @override
  Future acceptRequestToJoin(Map data) async {
    return await apiService.acceptRequestToJoin(data);
  }

  @override
  Future<PostOrActivityModel> activitySearch(Map data) async {
    return PostOrActivityModel.parse(
        ActivitySearchModel.fromJson(await apiService.activitySearch(data)));
  }

  @override
  Future demoteToNormalParticipants(Map data) async {
    return await apiService.demoteToNormalParticipants(data);
  }

  @override
  Future removeParticipants(Map data) async {
    return await apiService.removeParticipants(data);
  }

  @override
  Future setHostAndSelfDemote(Map data) async {
    return await apiService.setHostAndSelfDemote(data);
  }

  @override
  Future setSubHost(Map data) async {
    return await apiService.setSubHost(data);
  }

  @override
  Future leaveActivityAppointSomeoneAsHost(Map data) async {
    return await apiService.leaveActivityAppointSomeoneAsHost(data);
  }

  @override
  Future<dynamic> reportActivity(Map data) async {
    return await apiService.reportActivity(data);
  }
}
