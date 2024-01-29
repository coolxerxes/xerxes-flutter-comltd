import 'package:jyo_app/models/notification_model/notification_history_response.dart';
import 'package:jyo_app/models/notification_model/pending_friend_req_response_model.dart';
import 'package:jyo_app/models/notification_model/send_notification_response.dart';

abstract class NotificationRepo {
  Future<NotificationApiResponse> sendSignInNotification(Map data);
  Future<PendingFreindReqResponseModel> getPendingFriendRequests(dynamic id);
  Future<NotificationHistoryResponseModel> getNotifications(Map data);
}
