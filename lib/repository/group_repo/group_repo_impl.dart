import 'package:jyo_app/models/group_suggestion_model/group_creation_model.dart';
import 'package:jyo_app/models/group_suggestion_model/group_list_model.dart';
import 'package:jyo_app/models/group_suggestion_model/group_search_model.dart';
import 'package:jyo_app/models/group_suggestion_model/group_suggestion_model.dart';
import 'package:jyo_app/repository/group_repo/group_repo.dart';

import '../../data/remote/api_service.dart';
import '../../models/activity_model/activity_request_list_model.dart';
import '../../models/group_suggestion_model/accept_or_reject_group_invite.dart';
import '../../models/group_suggestion_model/group_details_model.dart';
import '../../models/group_suggestion_model/group_invite_model.dart';
import '../../models/group_suggestion_model/group_memeber_list_model.dart';
import '../../models/group_suggestion_model/request_to_join_group_model.dart';
import '../../models/group_suggestion_model/update_group_model.dart';

class GroupRepoImpl extends GroupRepo {
  ApiService apiService = ApiService();

  @override
  Future<AcceptOrRejectGroupInviteModel> acceptOrRejectRequestGroup(
      Map data) async {
    return AcceptOrRejectGroupInviteModel.fromJson(
        await apiService.acceptOrRejectRequestGroup(data));
  }

  @override
  Future<GroupCreateModel> createGroup(Map data) async {
    return GroupCreateModel.fromJson(await apiService.createGroup(data));
  }

  @override
  Future<GroupInviteModel> inviteFriend(Map data) async {
    return GroupInviteModel.fromJson(await apiService.inviteFriend(data));
  }

  @override
  Future<GroupMemeberListModel> memberList(Map data) async {
    return GroupMemeberListModel.fromJson(await apiService.memberList(data));
  }

  @override
  Future<ActivityRequestListResponse> requestList(Map data) async {
    return ActivityRequestListResponse.fromJson(
        await apiService.requestList(data));
  }

  @override
  Future<RequestToJoinGroupModel> requestToJoin(Map dta) async {
    return RequestToJoinGroupModel.fromJson(
        await apiService.requestToJoin(dta));
  }

  @override
  Future<GroupSearchModel>? seachGroup(Map data) async {
    return GroupSearchModel.fromJson(await apiService.searchGroup(data));
  }

  @override
  Future<GroupListModel> getGroupList(Map data) async {
    return GroupListModel.fromJson(await apiService.getGroupList(data));
  }

  @override
  Future<GroupDetailsModel> getGroupDetails(Map data) async {
    return GroupDetailsModel.fromJson(await apiService.getGroupDetails(data));
  }

  @override
  Future acceptOrRejectInvitation(Map data) async {
    return await apiService.acceptOrRejectInvitation(data);
  }

  @override
  Future<UpdateGroupModel> updateGroup(Map data) async {
    return UpdateGroupModel.fromJson(await apiService.updateGroup(data));
  }

  @override
  Future demoteAdminToMember(Map data) async {
    return await apiService.demoteAdminToMember(data);
  }

  @override
  Future leaveGroup(Map data) async {
    return await apiService.leaveGroup(data);
  }

  @override
  Future memberToAdmin(Map data) async {
    return await apiService.memberToAdmin(data);
  }

  @override
  Future removeMember(Map data) async {
    return await apiService.removeMember(data);
  }

  @override
  Future setSuperAdminDemoteToAdmin(Map data) async {
    return await apiService.setSuperAdminDemoteToAdmin(data);
  }

  @override
  Future leaveAndSetSomeOneAsSuperAdmin(Map data) async {
    return await apiService.leaveAndSetSomeOneAsSuperAdmin(data);
  }

  @override
  Future getGroupSuggestion(id) async {
    return  TListGroupSuggestion.fromJson( await apiService.getGroupSuggestion(id));
   
  }
}
