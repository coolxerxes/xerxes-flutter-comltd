import 'package:image_picker/image_picker.dart';
import 'package:jyo_app/data/remote/endpoints.dart';

abstract class ApiInterface {
  static const baseUrl = //"http://aa1b-106-213-83-208.ngrok.io/api/v1/";
      "https://main-prod.jioyouout.com/api/v1/";
  static const postImgUrl =
      baseUrl + Endpoints.user + Endpoints.post + Endpoints.attachement + "/";
  static const profileImgUrl =
      ApiInterface.baseUrl + Endpoints.user + Endpoints.profileImage;
  //static const sampleVideoLink =
  //  "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4";

  Future<dynamic>? sendOtp(Map data);
  Future<dynamic>? checkOtp(Map data);
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
  Future<dynamic>? comment(Map data);
  Future<dynamic>? likeAComment(Map data);
  Future<dynamic>? disLikeAComment(Map data);
  Future<dynamic>? deleteAComment(Map data);
  Future<dynamic>? updateComment(Map data);
  Future<dynamic>? like(Map data);
  Future<dynamic>? attachment(XFile? imgFile);
  Future<dynamic>? deletePost(Map data);
  Future<dynamic>? getComment(Map data);
  Future<dynamic>? getLikeUser(dynamic postId);
  Future<dynamic>? getTimeLine(dynamic userId);
  Future<dynamic>? getTimeLineNew(Map data);
  Future<dynamic>? jioMe(Map data);
  Future<dynamic>? taggedUser(Map data);

  //NotificationHistory
  Future<dynamic>? notificationHistory(Map data);

  //Activities
  Future<dynamic>? getCalendarEvents(Map data);
}
