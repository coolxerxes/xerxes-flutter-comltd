import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jyo_app/models/comment_model/get_comment_model.dart' as comm;

import '../repository/comments_repo/comments_repo_impl.dart';
import '../utils/common.dart';
import '../utils/secured_storage.dart';
import '../view/timeline_screen_view.dart';

class CommentsVM extends GetxController {
  CommentsRepoImpl commentsRepoImpl = CommentsRepoImpl();
  String? userId;
  List<comm.Datum> commentList = List.empty(growable: true);
  TextEditingController commentCtrl = TextEditingController();
  bool? showCommentTextField = true;
  GetxController? c;
  String? endpoint;

  Future<void> afterInit(GetxController c, endpoint) async {
    debugPrint("AfterInit CVM");
    userId = await SecuredStorage.readStringValue(Keys.userId);
    debugPrint("AfterInit CVM $userId");
    this.c = c;
    this.endpoint = endpoint;
    debugPrint("Endpoint ${this.endpoint}");
    //getProfileData();
  }

  Future<void> comment(
      List<comm.Datum>? commentList, postId, index, postIdIndex,
      {repliedTo, Function()? callback}) async {
    commentList ??= this.commentList;
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    var data = {
      "userId": userId.toString(),
      "paId": postId.toString(),
      "comment": repliedTo != null
          ? commentList[index].getReplyCtrl.text.trim()
          : commentCtrl.text.trim(),
      //"attachment": ["attachment.jpg"]
    };
    if (repliedTo != null) {
      data["repliedTo"] = repliedTo.toString();
    }
    //"repliedTo": 1
    debugPrint("Comment data $data");
    await commentsRepoImpl.comment(data, endpoint: endpoint)!.then((res) async {
      if (res.status == 200) {
        if (postIdIndex != null) {
          callback!();
          // postsList[postIdIndex].commentCount =
          //     postsList[postIdIndex].commentCount! + 1;
        }
        getComments(postId,
            cIndex: index, postIdIndex: postIdIndex, callback: callback);
        c?.update();
      } else {
        showAppDialog(msg: "Error ${res.message.toString()}");
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Error ${error.toString()}");
    });
  }

  Future<void> likeComment(List<comm.Datum> commentList, index) async {
    var data = {
      "userId": userId.toString(),
      "commentId": commentList[index].id.toString()
    };
    debugPrint("like Comm data $data");
    await commentsRepoImpl.likeComment(data,endpoint: endpoint)!.then((res) {
      if (res.status == 200) {
      } else {
        showAppDialog(msg: res.message.toString());
      }
      c?.update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
      c?.update();
    });
  }

  Future<void> updateComment(List<comm.Datum> commentList, index, postId,
      postIdIndex, Function()? callback) async {
    var data = {
      "updatedComment": commentList[index].getUpdateCtrl.text.toString(),
      "commentId": commentList[index].id.toString()
    };
    debugPrint("upd Comment data $data");
    await commentsRepoImpl.updateComment(data,endpoint: endpoint)!.then((res) {
      if (res.status == 200) {
        //  getComments(postId, cIndex: index, postIdIndex: postIdIndex);
      } else {
        showAppDialog(msg: res.message.toString());
      }
      c?.update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
      c?.update();
    });
  }

  Future<void> deleteComment(List<comm.Datum> commentList, index, postId,
      postIdIndex, Function()? callback) async {
    var data = {"commentId": commentList[index].id.toString()};
    debugPrint("deleteComment data $data");
    await commentsRepoImpl.deleteComment(data,endpoint: endpoint)!.then((res) {
      if (res.status == 200) {
        getComments(postId,
            cIndex: index, postIdIndex: postIdIndex, callback: callback);
      } else {
        showAppDialog(msg: res.message.toString());
      }
      c?.update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
      c?.update();
    });
  }

  Future<void> dislikeComment(List<comm.Datum> commentList, index) async {
    var data = {
      "userId": userId.toString(),
      "commentId": commentList[index].id.toString()
    };
    debugPrint("dislike Comm data $data");
    await commentsRepoImpl.disLikeComment(data,endpoint: endpoint)!.then((res) {
      if (res.status == 200) {
      } else {
        showAppDialog(msg: res.message.toString());
      }
      c?.update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
      c?.update();
    });
  }

  Future<void> getComments(postId,
      {cIndex, postIdIndex, Function()? callback}) async {
    var data = {"userId": userId.toString(), "paId": postId.toString()};
    debugPrint("GetCommData >> $data");
    commentList.clear();
    debugPrint("cdata $data");
    await commentsRepoImpl.getComments(data,endpoint: endpoint).then((res) async {
      if (res.status == 200) {
        commentList.addAll(res.data!);
        //commentCtrl.clear();
        if (commentCtrl.text.isNotEmpty) {
          debugPrint("clearing comment ctrl");

          if (postIdIndex != -1) {
            Get.back();
          }
        }
        if (cIndex != null) {
          // if(commentList[cIndex].getReplyCtrl.text.trim().isNotEmpty){
          //   debugPrint("clearing child comment ctrl");
          if (postIdIndex != -1) {
            Get.back();
          }
          // }
        }

        if (postIdIndex != -1) {
          PostWidget.showCommentModal(this, postId, postIdIndex, callback)
              .whenComplete(() {
            commentCtrl.clear();
            // if (!dontReload!) {
            //   // !dontRelod! means = reload.
            //   getTimeline();
            // }
            // dontReload = false;
            c?.update();
          });
        }
        c?.update();
      } else {
        showAppDialog(msg: "Error ${res.message.toString()}");
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Error ${error.toString()}");
    });
  }

  Future<void> getChildComments(
      List<comm.Datum> commentList, postId, repliedTo, index) async {
    var data = {
      "userId": userId.toString(),
      "paId": postId.toString(),
      "repliedTo": repliedTo.toString()
    };
    await commentsRepoImpl
        .getComments(
      data,
      endpoint: endpoint
    )
        .then((res) async {
      commentList[index].getChildComments!.clear();
      if (res.status == 200) {
        commentList[index].getChildComments!.addAll(res.data!);
        c?.update();
      } else {
        showAppDialog(msg: "Error ${res.message.toString()}");
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Error ${error.toString()}");
    });
  }
}
