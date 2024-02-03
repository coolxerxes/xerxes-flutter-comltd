import '../../models/activity_model/activity_request_list_model.dart';
import '../../models/group_suggestion_model/accept_or_reject_group_invite.dart';
import '../../models/group_suggestion_model/group_creation_model.dart';
import '../../models/group_suggestion_model/group_details_model.dart';
import '../../models/group_suggestion_model/group_invite_model.dart';
import '../../models/group_suggestion_model/group_list_model.dart';
import '../../models/group_suggestion_model/group_memeber_list_model.dart';
import '../../models/group_suggestion_model/group_search_model.dart';
import '../../models/group_suggestion_model/request_to_join_group_model.dart';
import '../../models/group_suggestion_model/update_group_model.dart';

abstract class GroupRepo {
  Future<GroupCreateModel> createGroup(Map data);
  Future<RequestToJoinGroupModel>? requestToJoin(Map dta);
  Future<ActivityRequestListResponse>? requestList(Map data);
  Future<AcceptOrRejectGroupInviteModel>? acceptOrRejectRequestGroup(Map data);
  Future<GroupMemeberListModel>? memberList(Map data);
  Future<GroupInviteModel>? inviteFriend(Map data);
  Future<GroupSearchModel>? seachGroup(Map data);
  Future<GroupListModel> getGroupList(Map data);
  Future<GroupDetailsModel> getGroupDetails(Map data);
  Future acceptOrRejectInvitation(Map data);
  Future<UpdateGroupModel> updateGroup(Map data);
  Future memberToAdmin(Map data);
  Future removeMember(Map data);
  Future setSuperAdminDemoteToAdmin(Map data);
  Future demoteAdminToMember(Map data);
  Future leaveGroup(Map data);
  Future<dynamic> leaveAndSetSomeOneAsSuperAdmin(Map data);
  Future<dynamic> getGroupSuggestion(id);

}
