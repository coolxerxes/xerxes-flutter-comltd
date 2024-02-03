import 'package:flutter/foundation.dart';
import 'package:jyo_app/data/remote/api_service.dart';
import 'package:jyo_app/models/comment_model/update_comment_model.dart';
import 'package:jyo_app/models/comment_model/like_comment_model.dart';
import 'package:jyo_app/models/comment_model/get_comment_model.dart';
import 'package:jyo_app/models/comment_model/dislike_comment_model.dart';
import 'package:jyo_app/models/comment_model/delete_comment_model.dart';
import 'package:jyo_app/models/comment_model/comment_model.dart';

import '../../data/remote/endpoints.dart';
import 'comments_repo.dart';

class CommentsRepoImpl extends CommentsRepo{
  ApiService apiService = ApiService();

  @override
  Future<CommentResponseModel>? comment(Map data, {String? endpoint = Endpoints.post}) async {
    dynamic response = await apiService.comment(data, endpoint: endpoint!);
    debugPrint("comment $response");
    return CommentResponseModel.fromJson(response);
  }

  @override
  Future<DeleteCommentModel>? deleteComment(Map data, {String? endpoint = Endpoints.post}) async {
    dynamic response = await apiService.deleteAComment(data, endpoint: endpoint!);
    debugPrint("delete comm $response");
    return DeleteCommentModel.fromJson(response);
  }

  @override
  Future<DislikeCommentModel>? disLikeComment(Map data, {String? endpoint = Endpoints.post}) async {
    dynamic response = await apiService.disLikeAComment(data, endpoint: endpoint!);
    debugPrint("dislike comm $response");
    return DislikeCommentModel.fromJson(response);
  }

  @override
  Future<GetCommentResponseModel> getComments(Map data, {String? endpoint = Endpoints.post}) async {
    dynamic response = await apiService.getComment(data, endpoint: endpoint!);
    debugPrint("get Comment $response");
    return GetCommentResponseModel.fromJson(response);
  }

  @override
  Future<LikeCommentModel>? likeComment(Map data, {String? endpoint = Endpoints.post}) async {
    dynamic response = await apiService.likeAComment(data, endpoint: endpoint!);
    debugPrint("like comm $response");
    return LikeCommentModel.fromJson(response);
  }

  @override
  Future<UpdateCommentModel>? updateComment(Map data, {String? endpoint = Endpoints.post}) async {
    dynamic response = await apiService.updateComment(data, endpoint: endpoint!);
    debugPrint("upd comm $response");
    return UpdateCommentModel.fromJson(response);
  }
}