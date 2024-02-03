import 'package:jyo_app/view_model/calendar_srceen_vm.dart';

import '../../models/activity_model/accept_invite_to_activity_model.dart';
import '../../models/activity_model/activity_request_list_model.dart';
import '../../models/activity_model/create_activity_model.dart';
import '../../models/activity_model/invite_to_activity_model.dart';
import '../../models/activity_model/join_activity_model.dart';
import '../../models/activity_model/leave_activity_model.dart';
import '../../models/activity_model/list_of_participants_model.dart';
import '../../models/activity_model/map_filtered_activity_model.dart';
import '../../models/activity_model/reject_invite_activity_model.dart';
import '../../models/posts_model/post_and_activity_model.dart';

abstract class ActivitiesRepo {
  Future<List<CalendarData>> getCalendarEvents(Map data);
  Future<CreateActivityModel> addActivity(Map data);
  Future<dynamic> updateActivity(Map data, String id);
  Future<PostOrActivityModel> getActivityByUser(Map data);
  Future<dynamic>? saveActivity(Map data);
  Future<PostOrActivityModel> listOfSave(Map data);
  Future<dynamic>? shareAsPost(Map data);
  Future<dynamic>? deleteActivity(Map data);
  Future<PostOrActivityModel>? getActivityDetails(Map data);
  Future<MapFilteredActivityModel>? getMapFilteredActity(Map data);
  Future<PostOrActivityModel> mapTappedActivity(Map data);
  Future<InviteToActivityResponse>? invite(Map data);
  Future<AcceptInviteToActivityResponse>? acceptInvite(Map data);
  Future<ListOfParticipantsActivityResponse>? participantsList(Map data);
  Future<RejectInviteActivityResponse>? rejectInvite(Map data);
  Future<LeaveActivityResponse>? leaveActivity(Map data);
  Future<JoinActivityResponse>? joinActivity(Map data);
  Future<ActivityRequestListResponse>? requestListToJoin(Map data);
  Future acceptRequestToJoin(Map data);
  Future<PostOrActivityModel> activitySearch(Map data);
  Future setSubHost(Map data);
  Future setHostAndSelfDemote(Map data);
  Future demoteToNormalParticipants(Map data);
  Future removeParticipants(Map data);
  Future? leaveActivityAppointSomeoneAsHost(Map data);
}
