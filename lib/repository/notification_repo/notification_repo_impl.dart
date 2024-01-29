import 'package:jyo_app/data/remote/api_service.dart';
import 'package:jyo_app/models/notification_model/notification_history_response.dart';
import 'package:jyo_app/models/notification_model/pending_friend_req_response_model.dart';
import 'package:jyo_app/models/notification_model/send_notification_response.dart';

import 'notification_repo.dart';

class NotificationRepoImpl extends NotificationRepo {
  ApiService apiService = ApiService();

  @override
  Future<NotificationApiResponse> sendSignInNotification(Map data) async {
    dynamic response = await apiService.sendSignInNotification(data);
    return NotificationApiResponse.fromJson(response);
  }

  @override
  Future<PendingFreindReqResponseModel> getPendingFriendRequests(dynamic id) async {
    dynamic response = await apiService.getPendingFriendReqList(id);
    return PendingFreindReqResponseModel.fromJson(response);
  }

  @override
  Future<NotificationHistoryResponseModel> getNotifications(Map data) async {
    dynamic response = await apiService.notificationHistory(data);
    return NotificationHistoryResponseModel.fromJson(response);
  }
}
