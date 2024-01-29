import 'package:jyo_app/data/remote/api_service.dart';
import 'package:jyo_app/models/profile_model/blocked_user_response.dart';
import 'package:jyo_app/models/profile_model/change_phno_response.dart';
import 'package:jyo_app/models/profile_model/fetch_friend_list_response.dart';
//import 'package:jyo_app/models/profile_model/fetch_blocked_user_response.dart';
import 'package:jyo_app/models/profile_model/fetch_post_privacy_response.dart';
import 'package:jyo_app/models/profile_model/get_user_info_response.dart';
import 'package:jyo_app/models/profile_model/my_voucher_model.dart';
import 'package:jyo_app/models/profile_model/notification_pref_response.dart';
import 'package:jyo_app/models/profile_model/user_info_response.dart';
import 'package:jyo_app/repository/profile_repo/profile_repo.dart';

import '../../models/profile_model/account_setting_response.dart';

class ProfileRepoImpl extends ProfileRepo {
  ApiService apiService = ApiService();

  @override
  Future<GetUserInfoResponse> getUserInfo(id) async {
    dynamic response = await apiService.getUserInfo(id);
    return GetUserInfoResponse.fromJson(response);
  }

  @override
  Future<AccountSettingResponse> accountSetting(Map data) async {
    dynamic response = await apiService.putAccountSetting(data);
    return AccountSettingResponse.fromJson(response);
  }

  @override
  Future<NotificationPrefResponse> fetchNotificationSetting(id) async {
    dynamic response = await apiService.fetchNotificationSetting(id);
    return NotificationPrefResponse.fromJson(response);
  }

  @override
  Future<AccountSettingResponse> updateNotificationSetting(Map data) async {
    dynamic response = await apiService.updateNotificationSetting(data);
    return AccountSettingResponse.fromJson(response);
  }

  @override
  Future<FetchPostPrivacyResponse> fetchPostPrivacy(id) async {
    dynamic response = await apiService.fetchPostPrivacy(id);
    return FetchPostPrivacyResponse.fromJson(response);
  }

  @override
  Future<AccountSettingResponse> updatePostPrivacy(Map data) async {
    dynamic response = await apiService.updatePostPrivacy(data);
    return AccountSettingResponse.fromJson(response);
  }

  @override
  Future<AccountSettingResponse> blockUsers(Map data) async {
    dynamic response = await apiService.blockUser(data);
    return AccountSettingResponse.fromJson(response);
  }

  @override
  Future<BlockedUserListResponseModel> fetchBlockedUserList(id) async {
    dynamic response = await apiService.fetchBlockedList(id);
    return BlockedUserListResponseModel.fromJson(response);
  }

  @override
  Future<FetchFriendListResponse> fetchFrientList(id) async {
    dynamic response = await apiService.fetchFriendList(id);
    return FetchFriendListResponse.fromJson(response);
  }

  @override
  Future<AccountSettingResponse> updatePostHideFrom(Map data) async {
    dynamic response = await apiService.updatePostHideFrom(data);
    return AccountSettingResponse.fromJson(response);
  }

  @override
  Future<ChangePhNoResponse> changePhoneNumber(Map data) async {
    dynamic response = await apiService.changePhoneNumber(data);
    return ChangePhNoResponse.fromJson(response);
  }

  @override
  Future<AccountSettingResponse> checkChangePhoneNoOTP(Map data) async {
    dynamic response = await apiService.checkChangePhoneNoOTP(data);
    return AccountSettingResponse.fromJson(response);
  }

  @override
  Future<UserInfoResponse> getHpNoByUserId(id) async {
    dynamic response = await apiService.getHpNoByUserId(id);
    return UserInfoResponse.fromJson(response);
  }

  @override
  Future<AccountSettingResponse> deleteAcc(Map data) async {
    dynamic response = await apiService.deleteAccount(data);
    return AccountSettingResponse.fromJson(response);
  }

  @override
  Future<VoucherDataResponse> getMyVouchers(id) async {
    dynamic response = await apiService.getMyVouchers(id);
    return VoucherDataResponse.fromJson( response);
  }
}
