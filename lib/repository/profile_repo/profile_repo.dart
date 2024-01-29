import 'package:jyo_app/models/profile_model/account_setting_response.dart';
import 'package:jyo_app/models/profile_model/blocked_user_response.dart';
import 'package:jyo_app/models/profile_model/change_phno_response.dart';
import 'package:jyo_app/models/profile_model/fetch_friend_list_response.dart';
import 'package:jyo_app/models/profile_model/fetch_post_privacy_response.dart';
import 'package:jyo_app/models/profile_model/get_user_info_response.dart';
import 'package:jyo_app/models/profile_model/notification_pref_response.dart';
import 'package:jyo_app/models/profile_model/user_info_response.dart';

abstract class ProfileRepo {
  Future<GetUserInfoResponse> getUserInfo(dynamic id);
  Future<AccountSettingResponse> accountSetting(Map data);
  Future<NotificationPrefResponse> fetchNotificationSetting(dynamic id);
  Future<AccountSettingResponse> updateNotificationSetting(Map data);
  Future<FetchPostPrivacyResponse> fetchPostPrivacy(dynamic id);
  Future<AccountSettingResponse> updatePostPrivacy(Map data);
  Future<FetchFriendListResponse> fetchFrientList(dynamic id);
  Future<BlockedUserListResponseModel> fetchBlockedUserList(dynamic id);
  Future<AccountSettingResponse> updatePostHideFrom(Map data);
  Future<AccountSettingResponse> blockUsers(Map data);
  Future<ChangePhNoResponse> changePhoneNumber(Map data);
  Future<AccountSettingResponse> checkChangePhoneNoOTP(Map data);
  Future<UserInfoResponse> getHpNoByUserId(id);
  Future<AccountSettingResponse> deleteAcc(Map data);
  Future getMyVouchers(dynamic id);
}
