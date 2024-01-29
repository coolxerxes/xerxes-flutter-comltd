import 'package:jyo_app/data/remote/commet_chat_api_interface.dart';
import 'package:jyo_app/data/remote/commet_chat_api_service.dart';
import 'package:jyo_app/models/commetchat_model/freinds_model/remove_friends_model.dart';
import 'package:jyo_app/models/commetchat_model/freinds_model/list_friends_model.dart';
import 'package:jyo_app/repository/commetchat_repo/friends_repo/friends_repo.dart';

import '../../../data/remote/endpoints.dart';

class CCFriendsRepoImpl extends CCFriendsRepo {
  CommetChatApiService apiService = CommetChatApiService();

  @override
  Future<dynamic> addCCFriend(Map data) async {
    return /*CcAddFreindResponse.fromJson*/(await apiService.commetChatPostApi(
      url: CommetChatApiInterface.chatUrl +
          CommetChatEndpoint.users +
          "${data['uid']}/" +
          CommetChatEndpoint.friends,
      data: data['data'],
    ));
  }

  @override
  Future<CcListFriendsResponse> listCCFriend(Map data) async {
    return CcListFriendsResponse.fromJson(await apiService.commetChatGetApi(
      url: CommetChatApiInterface.chatUrl +
          CommetChatEndpoint.users +
          "${data['uid']}/" +
          CommetChatEndpoint.friends
    ));
  }

  @override
  Future<CcRemoveFreindResponse> removeCCFriend(Map data) async {
    return CcRemoveFreindResponse.fromJson(await apiService.commetChatDeleteApi(
      url: CommetChatApiInterface.chatUrl +
          CommetChatEndpoint.users +
          "${data['uid']}/" +
          CommetChatEndpoint.friends,
      data: data['data'],
    ));
  }
}
