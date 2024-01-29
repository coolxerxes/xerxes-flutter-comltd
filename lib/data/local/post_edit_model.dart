import 'package:jyo_app/models/posts_model/get_post_by_user_model.dart';

import '../../models/posts_model/post_and_activity_model.dart';

class PostEdit {
  static Datum? post;
  static PostOrActivity? postOrActivity;

  static Datum? get getPost => PostEdit.post;
  static set setPost(Datum? post) => PostEdit.post = post;

  static PostOrActivity? get getPostOrActivity => PostEdit.postOrActivity;
  static set setPostOrActivity(PostOrActivity? postOrActivity) => PostEdit.postOrActivity = postOrActivity;
}
