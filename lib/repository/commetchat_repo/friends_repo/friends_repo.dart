import 'package:jyo_app/models/commetchat_model/freinds_model/remove_friends_model.dart';

import '../../../models/commetchat_model/freinds_model/list_friends_model.dart';

abstract class CCFriendsRepo {
  Future<dynamic> addCCFriend(Map data);
  Future<CcRemoveFreindResponse> removeCCFriend(Map data);
  Future<CcListFriendsResponse> listCCFriend(Map data);
}
