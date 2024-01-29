import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/repository/profile_repo/profile_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';

class PushNotificationScreenVM extends GetxController {
  ProfileRepoImpl profileRepoImpl = ProfileRepoImpl();
  bool? isDirectChatEnabled = false;
  bool? isGroupChatEnabled = false;

  bool? isPostLikeNCommentsEnabled = false;

  bool? isGroupActivityEnabled = false;
  bool? isFriendActivityEnabled = false;
  bool? isActivityInvitationEnabled = false;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() async {
    SecuredStorage.initiateSecureStorage();
    fetchNotificationSetting();
  }

  void toggleDirectChat() {
    isDirectChatEnabled = !isDirectChatEnabled!;
    updateNotificationSetting();
    update();
  }

  void toggleGroupChat() {
    isGroupChatEnabled = !isGroupChatEnabled!;
    updateNotificationSetting();
    update();
  }

  void togglePostLikesAndComments() {
    isPostLikeNCommentsEnabled = !isPostLikeNCommentsEnabled!;
    updateNotificationSetting();
    update();
  }

  void toggleGroupActivity() {
    isGroupActivityEnabled = !isGroupActivityEnabled!;
    updateNotificationSetting();
    update();
  }

  void toggleFriendsActivity() {
    isFriendActivityEnabled = !isFriendActivityEnabled!;
    updateNotificationSetting();
    update();
  }

  void toggleActivityInvitation() {
    isActivityInvitationEnabled = !isActivityInvitationEnabled!;
    updateNotificationSetting();
    update();
  }

  Future<void> fetchNotificationSetting() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    await profileRepoImpl.fetchNotificationSetting(userId).then((res) async {
      if (res.status == 200) {
        isDirectChatEnabled = res.data!.directChat!;
        await SecuredStorage.writeBoolValue(
            Keys.directChat, res.data!.directChat!);

        isGroupChatEnabled = res.data!.groupChat!;
        await SecuredStorage.writeBoolValue(
            Keys.groupChat, res.data!.groupChat!);

        isPostLikeNCommentsEnabled = res.data!.postLikeComment!;
        await SecuredStorage.writeBoolValue(
            Keys.postLikeComment, res.data!.postLikeComment!);

        isGroupActivityEnabled = res.data!.groupActvity!;
        await SecuredStorage.writeBoolValue(
            Keys.groupActvity, res.data!.groupActvity!);

        isFriendActivityEnabled = res.data!.friendActivity!;
        await SecuredStorage.writeBoolValue(
            Keys.friendActivity, res.data!.friendActivity!);

        isActivityInvitationEnabled = res.data!.activityInvitation!;
        await SecuredStorage.writeBoolValue(
            Keys.activityInvitation, res.data!.activityInvitation!);

        update();
      } else {
        showAppDialog(msg: res.message.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> updateNotificationSetting() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    var data = {
      "userId": userId,
      "updates": {
        "directChat": isDirectChatEnabled,
        "groupChat": isGroupChatEnabled,
        "postLikeComment": isPostLikeNCommentsEnabled,
        "groupActvity": isGroupActivityEnabled,
        "friendActivity": isFriendActivityEnabled,
        "activityInvitation": isActivityInvitationEnabled
      }
    };
    await profileRepoImpl.updateNotificationSetting(data).then((res) async {
      if (res.status == 200) {
        await SecuredStorage.writeBoolValue(
            Keys.directChat, isDirectChatEnabled!);
        await SecuredStorage.writeBoolValue(
            Keys.groupChat, isGroupChatEnabled!);
        await SecuredStorage.writeBoolValue(
            Keys.postLikeComment, isPostLikeNCommentsEnabled!);
        await SecuredStorage.writeBoolValue(
            Keys.groupActvity, isGroupActivityEnabled!);
        await SecuredStorage.writeBoolValue(
            Keys.friendActivity, isFriendActivityEnabled!);
        await SecuredStorage.writeBoolValue(
            Keys.activityInvitation, isActivityInvitationEnabled!);

        update();
      } else {
        showAppDialog(msg: res.message.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }
}
