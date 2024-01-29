import 'package:image_picker/image_picker.dart';
import 'package:jyo_app/models/posts_model/add_post_model.dart';
import 'package:jyo_app/models/posts_model/attachment_model.dart';
import 'package:jyo_app/models/posts_model/comment_model.dart';
import 'package:jyo_app/models/posts_model/delete_comment_model.dart';
import 'package:jyo_app/models/posts_model/delete_post_model.dart';
import 'package:jyo_app/models/posts_model/dislike_comment_model.dart';
import 'package:jyo_app/models/posts_model/get_comment_model.dart';
import 'package:jyo_app/models/posts_model/jio_me_model.dart';
import 'package:jyo_app/models/posts_model/like_comment_model.dart';
import 'package:jyo_app/models/posts_model/like_model.dart';
import 'package:jyo_app/models/posts_model/like_user_model.dart';
import 'package:jyo_app/models/posts_model/tagged_user_model.dart';
import 'package:jyo_app/models/posts_model/update_post_model.dart';

import '../../models/posts_model/post_and_activity_model.dart';
import '../../models/posts_model/update_comment_model.dart';

abstract class PostRepo {
  Future<AttachmentResponseModel>? attachment(XFile? imgFile);
  Future<AddPostResponseModel>? addPost(Map data);
  Future<PostOrActivityModel>? getPostByUser(Map data);
  Future<PostOrActivityModel>? getTimeline(dynamic id);
  Future<PostOrActivityModel>? getTimelineNew(Map data);
  Future<TaggedUserResponseModel>? getTaggedUsers(Map data);
  Future<CommentResponseModel>? comment(Map data);
  Future<GetCommentResponseModel> getComments(Map data);
  Future<LikeResponseModel>? like(Map data);
  Future<DeletePostResponse>? deletePost(Map data);
  Future<LikeUserResponse>? getLikeUser(dynamic id);
  Future<JioMeResponseModel>? jioMe(Map data);
  Future<UpdatePostResponseModel>? updatePost(Map data);
  Future<LikeCommentModel>? likeComment(Map data);
  Future<DislikeCommentModel>? disLikeComment(Map data);
  Future<DeleteCommentModel>? deleteComment(Map data);
  Future<UpdateCommentModel>? updateComment(Map data);
}
