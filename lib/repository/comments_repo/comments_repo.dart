import 'package:jyo_app/models/comment_model/delete_comment_model.dart';

import '../../data/remote/endpoints.dart';
import '../../models/comment_model/comment_model.dart';
import '../../models/comment_model/dislike_comment_model.dart';
import '../../models/comment_model/get_comment_model.dart';
import '../../models/comment_model/like_comment_model.dart';
import '../../models/comment_model/update_comment_model.dart';

abstract class CommentsRepo {
  Future<LikeCommentModel>? likeComment(Map data, {String endpoint = Endpoints.post});
  Future<DislikeCommentModel>? disLikeComment(Map data, {String endpoint = Endpoints.post});
  Future<DeleteCommentModel>? deleteComment(Map data, {String endpoint = Endpoints.post});
  Future<UpdateCommentModel>? updateComment(Map data, {String endpoint = Endpoints.post});
  Future<CommentResponseModel>? comment(Map data, {String endpoint = Endpoints.post});
  Future<GetCommentResponseModel> getComments(Map data, {String endpoint = Endpoints.post});
}
