import 'package:flutter/foundation.dart';
import 'package:jyo_app/data/remote/api_service.dart';
import 'package:jyo_app/models/search_people_model/accept_reject_friend_model.dart';
import 'package:jyo_app/models/search_people_model/block_user_profile.dart';
import 'package:jyo_app/models/search_people_model/friend_list_model.dart';
import 'package:jyo_app/models/search_people_model/search_people_model.dart';
import 'package:jyo_app/models/search_people_model/send_friend_req_model.dart';
import 'package:jyo_app/models/search_people_model/user_friend_profile_model.dart';
import 'package:jyo_app/repository/freinds_repo/freinds_repo.dart';

class FriendsRepoImpl extends FriendsRepo {
  ApiService apiService = ApiService();

  @override
  Future<SearchPeopleResponseModel>? searchPeople(String? name, String? userId) async {
    dynamic response = await apiService.searchPeople(name,userId);
    debugPrint("Data now $response");
    return SearchPeopleResponseModel.fromJson(response);
  }

  @override
  Future<UserFreindProfileResponseModel>? userFriendProfile(Map data) async {
    dynamic response = await apiService.userFriendProfileView(data);
    return UserFreindProfileResponseModel.fromJson(response);
  }

  @override
  Future<SendFriendReqResponseModel>? sendFriendRequest(Map data) async{
    dynamic response = await apiService.sendFriendRequest(data);
    return SendFriendReqResponseModel.fromJson(response);
  }

  @override
  Future<AcceptOrRejectFriendRequest>? acceptOrRejectRequest(Map data) async {
    dynamic response = await apiService.acceptOrRejectRequest(data);
    return AcceptOrRejectFriendRequest.fromJson(response);
  }

  @override
  Future<FriendListResponseModel>? getFriendList(Map data) async {
    dynamic response = await apiService.getFriendList(data);
    return FriendListResponseModel.fromJson(response);
  }

  @override
  Future<BlockProfileResponse>? blockUserProfile(Map data) async {
    dynamic response = await apiService.blockProfile(data);
    return BlockProfileResponse.fromJson(response);
  }
  
  @override
  Future<BlockProfileResponse>? cancelFriendRequest(Map data) async {
    dynamic response = await apiService.cancelFriendRequest(data);
    return BlockProfileResponse.fromJson(response);
  }
}
