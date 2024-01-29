import 'get_post_by_user_model.dart';
import 'timeline_model.dart';

class PostOrActivityModel {
  PostOrActivityModel({this.status, this.message, this.postsOrActivities});

  int? status;
  String? message;
  List<PostOrActivity>? postsOrActivities;

  static PostOrActivityModel parse(dynamic res) {
    List<PostOrActivity> postsOrActivities = List.empty(growable: true);

    if (res is TimelineResponseModel) {
      for (var i = 0; i < res.data!.length; i++) {
        postsOrActivities.add(PostOrActivity(
          activityId: res.data![i].activityId,
          attachment: res.data![i].attachment,
          commentCount: res.data![i].commentCount,
          createdAt: res.data![i].createdAt,
          document: res.data![i].document,
          groupId: res.data![i].groupId,
          id: res.data![i].id,
          isJioMe: res.data![i].isJioMe,
          isLiked: res.data![i].isLiked,
          jioMeUserInfo: List.empty(growable: true),
          likeCount: res.data![i].likeCount,
          postDate: res.data![i].postDate,
          tagUserInfo: res.data![i].tagUserInfo,
          text: res.data![i].text,
          topicTags: res.data![i].topicTags,
          updatedAt: res.data![i].updatedAt,
          userId: res.data![i].userId,
          userInfo: res.data![i].userInfo,
          userTags: res.data![i].userTags,
          visible: res.data![i].visible,
        ));
      }
    } else if (res is GetPostByUserResponseModel) {
      for (var i = 0; i < res.data!.length; i++) {
        postsOrActivities.add(PostOrActivity(
          activityId: res.data![i].activityId,
          attachment: res.data![i].attachment,
          commentCount: res.data![i].commentCount,
          createdAt: res.data![i].createdAt,
          document: res.data![i].document,
          groupId: res.data![i].groupId,
          id: res.data![i].id,
          isJioMe: res.data![i].isJioMe,
          isLiked: res.data![i].isLiked,
          jioMeUserInfo: res.data![i].jioMeUserInfo,
          likeCount: res.data![i].likeCount,
          postDate: res.data![i].postDate,
          tagUserInfo: res.data![i].tagUserInfo,
          text: res.data![i].text,
          topicTags: res.data![i].topicTags,
          updatedAt: res.data![i].updatedAt,
          userId: res.data![i].userId,
          userInfo: null,
          userTags: res.data![i].userTags,
          visible: res.data![i].visible,
        ));
      }
    }

    return PostOrActivityModel(
        message: res.message,
        status: res.status,
        postsOrActivities: postsOrActivities);
  }
}

class PostOrActivity {
  PostOrActivity({
    this.id,
    this.userId,
    this.text,
    this.postDate,
    this.attachment,
    this.document,
    this.activityId,
    this.topicTags,
    this.userTags,
    this.groupId,
    this.visible,
    this.createdAt,
    this.updatedAt,
    this.isLiked,
    this.isJioMe,
    this.likeCount,
    this.commentCount,
    this.userInfo,
    this.tagUserInfo,
    this.jioMeUserInfo,
  });

  int? id;
  int? userId;
  String? text;
  String? postDate;
  List<Attachment>? attachment;
  List<Document>? document;
  dynamic activityId;
  dynamic topicTags;
  List<int>? userTags;
  dynamic groupId;
  String? visible;
  String? createdAt;
  dynamic updatedAt;
  int? isLiked;
  int? likeCount;
  int? commentCount;
  int? isJioMe;
  UserInfo? userInfo;
  TagUserInfo? tagUserInfo;
  List<JioMeUserInfo>? jioMeUserInfo;
}
