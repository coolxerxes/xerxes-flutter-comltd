import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jyo_app/models/posts_model/TSuggestedPeople.dart';
import 'package:jyo_app/models/posts_model/add_post_model.dart';
import 'package:jyo_app/models/posts_model/attachment_model.dart';
import 'package:jyo_app/models/posts_model/delete_post_model.dart';
import 'package:jyo_app/models/posts_model/get_post_by_user_model.dart';
import 'package:jyo_app/models/posts_model/jio_me_model.dart';
import 'package:jyo_app/models/posts_model/like_model.dart';
import 'package:jyo_app/models/posts_model/like_user_model.dart';
import 'package:jyo_app/models/posts_model/post_and_activity_model.dart';
import 'package:jyo_app/models/posts_model/tagged_user_model.dart';
import 'package:jyo_app/models/posts_model/timeline_model.dart';
import 'package:jyo_app/models/posts_model/update_post_model.dart';
import 'package:jyo_app/repository/post_repo/post_repo.dart';

import '../../data/remote/api_service.dart';

class PostRepoImpl extends PostRepo {
  ApiService apiService = ApiService();

  @override
  Future<AttachmentResponseModel>? attachment(XFile? imgFile,
      {String? fileName, String? filePath}) async {
    dynamic response = await apiService.attachment(imgFile,
        fileName: fileName, filePath: filePath);
    debugPrint("att $response");
    return AttachmentResponseModel.fromJson(response);
  }

  @override
  Future<AddPostResponseModel>? addPost(Map data) async {
    dynamic response = await apiService.addPost(data);
    debugPrint("ad post $response");
    return AddPostResponseModel.fromJson(response);
  }

  @override
  Future<PostOrActivityModel>? getPostByUser(Map data) async {
    dynamic response = await apiService.getPostByUser(data);
    debugPrint("get pb $response");
    return PostOrActivityModel.parse(
        GetPostByUserResponseModel.fromJson(response));
  }

  @override
  Future<PostOrActivityModel>? getTimeline(id) async {
    dynamic response = await apiService.getTimeLine(id);
    debugPrint("get pb $response");
    return PostOrActivityModel.parse(TimelineResponseModel.fromJson(response));
  }

  @override
  Future<PostOrActivityModel>? getTimelineNew(Map data) async {
    dynamic response = await apiService.getTimeLineNew(data);
    debugPrint("get pbn $response");
    return PostOrActivityModel.parse(timelineResponseModelFromJson(response));
  }

  @override
  Future<TaggedUserResponseModel>? getTaggedUsers(Map data) async {
    dynamic response = await apiService.taggedUser(data);
    debugPrint("get tu $response");
    return TaggedUserResponseModel.fromJson(response);
  }

  // @override
  // Future<CommentResponseModel>? comment(Map data) async {
  //   dynamic response = await apiService.comment(data);
  //   debugPrint("comment $response");
  //   return CommentResponseModel.fromJson(response);
  // }

  @override
  Future<LikeResponseModel>? like(Map data) async {
    dynamic response = await apiService.like(data);
    debugPrint("like $response");
    return LikeResponseModel.fromJson(response);
  }

  // @override
  // Future<GetCommentResponseModel> getComments(Map data) async {
  //   dynamic response = await apiService.getComment(data);
  //   debugPrint("get Comment $response");
  //   return GetCommentResponseModel.fromJson(response);
  // }

  @override
  Future<DeletePostResponse>? deletePost(Map data) async {
    dynamic response = await apiService.deletePost(data);
    debugPrint("delete post $response");
    return DeletePostResponse.fromJson(response);
  }

  @override
  Future<LikeUserResponse>? getLikeUser(dynamic id) async {
    dynamic response = await apiService.getLikeUser(id);
    debugPrint("like user res $response");
    return LikeUserResponse.fromJson(response);
  }

  @override
  Future<JioMeResponseModel>? jioMe(Map data) async {
    dynamic response = await apiService.jioMe(data);
    debugPrint("like user res $response");
    return JioMeResponseModel.fromJson(response);
  }

  @override
  Future<UpdatePostResponseModel>? updatePost(Map data) async {
    dynamic response = await apiService.updatePost(data);
    debugPrint("upd post $response");
    return UpdatePostResponseModel.fromJson(response);
  }

  @override
  Future<TSuggestedPeople>? postSuggestedPeople(Map data) async {
    dynamic response = await apiService.postGetSuggestedPeople(data);
    debugPrint("postSuggestedPeople post $response");
    return TSuggestedPeople.fromJson(response);
  }

  // @override
  // Future<DeleteCommentModel>? deleteComment(Map data) async {
  //   dynamic response = await apiService.deleteAComment(data);
  //   debugPrint("delete comm $response");
  //   return DeleteCommentModel.fromJson(response);
  // }

  // @override
  // Future<DislikeCommentModel>? disLikeComment(Map data) async {
  //   dynamic response = await apiService.disLikeAComment(data);
  //   debugPrint("dislike comm $response");
  //   return DislikeCommentModel.fromJson(response);
  // }

  // @override
  // Future<LikeCommentModel>? likeComment(Map data) async {
  //   dynamic response = await apiService.likeAComment(data);
  //   debugPrint("like comm $response");
  //   return LikeCommentModel.fromJson(response);
  // }

  // @override
  // Future<UpdateCommentModel>? updateComment(Map data) async {
  //   dynamic response = await apiService.updateComment(data);
  //   debugPrint("upd comm $response");
  //   return UpdateCommentModel.fromJson(response);
  // }
}
