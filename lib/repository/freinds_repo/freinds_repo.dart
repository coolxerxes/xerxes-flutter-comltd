import 'package:jyo_app/models/search_people_model/accept_reject_friend_model.dart';
import 'package:jyo_app/models/search_people_model/block_user_profile.dart';
import 'package:jyo_app/models/search_people_model/friend_list_model.dart';
import 'package:jyo_app/models/search_people_model/search_people_model.dart';
import 'package:jyo_app/models/search_people_model/send_friend_req_model.dart';
import 'package:jyo_app/models/search_people_model/user_friend_profile_model.dart';

abstract class FriendsRepo {
  Future<SearchPeopleResponseModel>? searchPeople(String? name,String? userId);
  Future<UserFreindProfileResponseModel>? userFriendProfile(Map data);
  Future<SendFriendReqResponseModel>? sendFriendRequest(Map data);
  Future<AcceptOrRejectFriendRequest>? acceptOrRejectRequest(Map data);
  Future<FriendListResponseModel>? getFriendList(Map data);
  Future<BlockProfileResponse>? blockUserProfile(Map data);
  Future<BlockProfileResponse>? cancelFriendRequest(Map data);
}
