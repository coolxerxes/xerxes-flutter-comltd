import 'package:image_picker/image_picker.dart';
import 'package:jyo_app/data/remote/endpoints.dart';

abstract class ApiInterface {
  static const qaBaseUrl = "https://qa.jioyouout.com/api/v1/";
  static const prodBaseUrl = "https://main-prod.jioyouout.com/api/v1/";

  static const baseUrl = qaBaseUrl;
  static const postImgUrl =
      baseUrl + Endpoints.user + Endpoints.post + Endpoints.attachement + "/";
  static const profileImgUrl =
      ApiInterface.baseUrl + Endpoints.user + Endpoints.profileImage;
  //static const sampleVideoLink =
  //  "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4";

  Future<dynamic>? sendOtp(Map data);
  Future<dynamic>?checkOtp(Map data);
  Future<dynamic>? userCreate(Map data);
  Future<dynamic>? createOrUpdateUserInfo(Map data);
  Future<dynamic>? signIn(Map data);
  Future<dynamic>? getAllIntrest();
  Future<dynamic>? saveIntrest(Map data);
  Future<dynamic>? getUserInfo(dynamic id);
  Future<dynamic>? putAccountSetting(Map data);
  Future<dynamic>? fetchNotificationSetting(dynamic id);
  Future<dynamic>? updateNotificationSetting(Map data);
  Future<dynamic>? fetchPostPrivacy(dynamic id);
  Future<dynamic>? updatePostPrivacy(Map data);
  Future<dynamic>? fetchFriendList(dynamic id); //DO NOT USE THIS
  Future<dynamic>? fetchBlockedList(dynamic id);
  Future<dynamic>? updatePostHideFrom(Map data);
  Future<dynamic>? blockUser(Map data);
  Future<dynamic>? getHpNoByUserId(dynamic id);
  Future<dynamic>? changePhoneNumber(Map data);
  Future<dynamic>? checkChangePhoneNoOTP(Map data);
  Future<dynamic>? deleteAccount(Map data);
  Future<dynamic>? getMyVouchers(dynamic id);
  Future<dynamic>? sendSignInNotification(Map data);

  //Friends
  Future<dynamic>? searchPeople(String? name, String? userId);
  Future<dynamic>? userFriendProfileView(Map data);
  Future<dynamic>? sendFriendRequest(Map data);
  Future<dynamic>? acceptOrRejectRequest(Map data);
  Future<dynamic>? getFriendList(Map data);
  Future<dynamic>? blockProfile(Map data);
  Future<dynamic>? getPendingFriendReqList(dynamic id);
  Future<dynamic>? cancelFriendRequest(Map data);

  //Posts
  Future<dynamic>? addPost(Map data);
  Future<dynamic>? updatePost(Map data);
  Future<dynamic>? getPost(dynamic userId, dynamic postId);
  Future<dynamic>? getPostByUser(Map data);
  Future<dynamic>? comment(Map data, {String endpoint = Endpoints.post});
  Future<dynamic>? likeAComment(Map data, {String endpoint = Endpoints.post});
  Future<dynamic>? disLikeAComment(Map data,
      {String endpoint = Endpoints.post});
  Future<dynamic>? deleteAComment(Map data, {String endpoint = Endpoints.post});
  Future<dynamic>? updateComment(Map data, {String endpoint = Endpoints.post});
  Future<dynamic>? getComment(Map data, {String endpoint = Endpoints.post});
  Future<dynamic>? like(Map data);
  Future<dynamic>? attachment(XFile? imgFile);
  Future<dynamic>? deletePost(Map data);
  Future<dynamic>? getLikeUser(dynamic postId);
  Future<dynamic>? getTimeLine(dynamic userId);
  Future<dynamic>? postSugge(dynamic userId);
  Future<dynamic>? postGetSuggestedPeople(Map data);
  Future<dynamic>? jioMe(Map data);
  Future<dynamic>? taggedUser(Map data);

  //NotificationHistory
  Future<dynamic>? notificationHistory(Map data);

  //Activities
  Future<dynamic>? getCalendarEvents(Map data);
  Future<dynamic>? addActivity(Map data);
  Future<dynamic>? updateActivity(Map data, String id);
  Future<dynamic>? getActivityByUser(Map data);
  Future<dynamic>? saveActivity(Map data);
  Future<dynamic>? listOfSave(Map data);
  Future<dynamic>? shareAsPost(Map data);
  Future<dynamic>? deleteActivity(Map data);
  Future<dynamic>? getActivityDetails(Map data);
  Future<dynamic>? getMapFilteredActivity(Map data);
  Future<dynamic>? getMapTappedActivity(Map data);
  Future<dynamic>? invite(Map data);
  Future<dynamic>? acceptInvite(Map data);
  Future<dynamic>? participantsList(Map data);
  Future<dynamic>? rejectInvite(Map data);
  Future<dynamic>? leaveActivity(Map data);
  Future<dynamic>? joinActivity(Map data);
  Future<dynamic>? requestListToJoin(Map data);
  Future<dynamic>? acceptRequestToJoin(Map data);
  Future<dynamic>? activitySearch(Map data);
  Future<dynamic>? setSubHost(Map data);
  Future<dynamic>? setHostAndSelfDemote(Map data);
  Future<dynamic>? demoteToNormalParticipants(Map data);
  Future<dynamic>? removeParticipants(Map data);
  Future<dynamic>? leaveActivityAppointSomeoneAsHost(Map data);

  //Group
  Future<dynamic>? createGroup(Map data);
  Future<dynamic>? requestToJoin(Map dta);
  Future<dynamic>? requestList(Map data);
  Future<dynamic>? acceptOrRejectRequestGroup(Map data);
  Future<dynamic>? memberList(Map data);
  Future<dynamic>? inviteFriend(Map data);
  Future<dynamic>? searchGroup(Map dta);
  Future<dynamic>? getGroupList(Map data);
  Future<dynamic>? getGroupDetails(Map data);
  Future<dynamic> acceptOrRejectInvitation(Map data);
  Future<dynamic> updateGroup(Map data);
  Future<dynamic> memberToAdmin(Map data);
  Future<dynamic> removeMember(Map data);
  Future<dynamic> setSuperAdminDemoteToAdmin(Map data);
  Future<dynamic> demoteAdminToMember(Map data);
  Future<dynamic> leaveGroup(Map data);
  Future<dynamic> leaveAndSetSomeOneAsSuperAdmin(Map data);
  Future<dynamic> getGroupSuggestion(String id);

  //Tour
  Future<dynamic>? updateTourStep(Map data);
}
