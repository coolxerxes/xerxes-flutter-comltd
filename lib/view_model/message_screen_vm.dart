import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';

import '../models/commetchat_model/freinds_model/list_friends_model.dart';
import '../repository/commetchat_repo/friends_repo/friends_repo_impl.dart';

class MessageScreenVM extends GetxController {
  String? userId;
  List<Datum> friends = List.empty(growable: true);
  List<Conversation> conversationList = List.empty(growable: true);
  List<Group> groupsList = List.empty(growable: true);
  bool? isLoading = true;
  bool? isLoadingGroup = true;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    userId = await SecuredStorage.readStringValue(Keys.userId);
    await getConversations();
    await getGroupConversations();
    await listFriendsOfCometChat(uid: userId.toString());
  }

  Future<void> getConversations() async {
    isLoading = true;
    update();
    ConversationsRequest conversationsRequest = (ConversationsRequestBuilder()
          ..conversationType = CometChatConversationType.user
          ..limit = 25)
        .build();
    await conversationsRequest.fetchNext(
      onSuccess: ((coversations) {
        conversationList.clear();
        conversationList.addAll(coversations);
        isLoading = false;
        update();
      }),
      onError: (excep) {
        showAppDialog(msg: excep.message);
        isLoading = false;
        update();
      },
    );
  }

  Future<void> getGroupConversations() async {
    isLoadingGroup = true;
    update();
    GroupsRequest groupRequest = (GroupsRequestBuilder()
          ..joinedOnly = true
          ..limit = 25)
        .build();
    await groupRequest.fetchNext(
      onSuccess: ((groups) {
        groupsList.clear();
        groupsList.addAll(groups);
        isLoadingGroup = false;
        update();
      }),
      onError: (excep) {
        showAppDialog(msg: excep.message);
        isLoadingGroup = false;
        update();
      },
    );
  }

  Future<void> listFriendsOfCometChat({String? uid}) async {
    CCFriendsRepoImpl ccFriendsRepoImpl = CCFriendsRepoImpl();
    var data = {
      'uid': uid.toString(),
    };
    debugPrint("add Json $data");
    await ccFriendsRepoImpl.listCCFriend(data).then((res) {
      friends.clear();
      if (res.data != null) {
        friends.addAll(res.data!);
        update();
      }
    }).onError((error, stackTrace) {
      debugPrint("error add cc friend ${error.toString()}");
    });
  }

  int currentTab = MessageType.friend;

  Future<void> refreshLists() async {
    await init();
  }
}

class MessageType {
  static const friend = 0;
  static const group = 1;
}
