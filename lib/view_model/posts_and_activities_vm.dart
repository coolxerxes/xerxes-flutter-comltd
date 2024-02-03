import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jyo_app/models/posts_model/post_and_activity_model.dart';
import 'package:jyo_app/repository/activities_repo/activities_repo_impl.dart';
import 'package:jyo_app/repository/post_repo/post_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/view_model/timeline_screen_vm.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import '../data/remote/api_interface.dart';
import '../models/posts_model/timeline_model.dart';
import '../utils/secured_storage.dart';
import 'base_screen_vm.dart';
import 'comments_vm.dart';
import 'create_post_screen_vm.dart';
import 'package:dio/dio.dart' as dio;
import 'package:jyo_app/models/posts_model/tagged_user_model.dart' as tag;
//import 'package:jyo_app/models/comment_model/get_comment_model.dart' as comm;
import 'package:jyo_app/models/posts_model/like_user_model.dart' as lu;

class PostsAndActivitiesVM extends GetxController {
  BaseScreenVM bsv = Get.find<BaseScreenVM>();
  PostRepoImpl postRepoImpl = PostRepoImpl();
  CommentsVM cvm = CommentsVM();
  //CommentsRepoImpl commentsRepoImpl = CommentsRepoImpl();
  ActivitiesRepoImpl activitiesRepoImpl = ActivitiesRepoImpl();
  //ProfileRepoImpl profileRepoImpl = ProfileRepoImpl();
  String? userId;
  GetxController? c;

  List<PostOrActivity> postsList = List.empty(growable: true);
  List<PostOrActivity> activitiesList = List.empty(growable: true);
  List<PostOrActivity> postsListPaged = List.empty(growable: true);
  List<tag.Datum> taggedUsersList = List.empty(growable: true);
  //List<comm.Datum> commentList = List.empty(growable: true);
  List<lu.Datum> likeUsers = List.empty(growable: true);
  //TextEditingController commentCtrl = TextEditingController();

  //bool? showCommentTextField = true;

  // @override
  // void onInit() {
  //   super.onInit();
  //   //afterInit();
  // }

  Future<void> afterInit(GetxController c, {endpoint, usrId}) async {
    debugPrint("AfterInit");
    userId = usrId??(await SecuredStorage.readStringValue(Keys.userId));
    this.c = c;
    cvm.afterInit(c, endpoint);
    //getProfileData();
  }

  Future<void> saveActivity(Map data) async {
    debugPrint("saveActiviyt req $data");
    await activitiesRepoImpl.saveActivity(data)!.then((res) {
      debugPrint("activity save res $res");
      snackbar(title: res["message"]);
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> joinActivity(Map data) async {
    debugPrint("joinAct req $data");
    await activitiesRepoImpl.joinActivity(data)!.then((res) {
      debugPrint("joinAct save res ${res.message}");
      snackbar(title: res.message);
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> leaveActivity(Map data) async {
    debugPrint("leaveAct req $data");
    await activitiesRepoImpl.leaveActivity(data)!.then((res) {
      debugPrint("leaveAct save res $res");
      snackbar(title: res.message);
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  // Future<void> getProfileData() async {
  //   String? userId = await SecuredStorage.readStringValue(Keys.userId);
  //   await profileRepoImpl.getUserInfo(userId).then((res) async {
  //     if (res.status == 200) {
  //       imageFileName = res.data!.userInfoData!.profilePic.toString().trim();
  //       firstName = res.data!.userInfoData!.firstName.toString();
  //       lastName = res.data!.userInfoData!.lastName.toString();
  //       c.c.update();
  //     } else {
  //       showAppDialog(msg: "Error ${res.message.toString()}");
  //     }
  //   }).onError((error, stackTrace) {
  //     showAppDialog(msg: "Error ${error.toString()}");
  //   });
  // }
  Future<PostOrActivity?> getActivitiyDetail(Map data, GetxController c) async {
    debugPrint("Inside POAVM");
    List<PostOrActivity> list = List.empty(growable: true);
    await activitiesRepoImpl.getActivityDetails(data).then((res) async {
      if (res.status == 200) {
        list.addAll(res.postsOrActivities!);
        //c.update();
      } else if (res.status == 400) {
        debugPrint("Activity By User Res : ${res.message.toString()}");
      } else {
        showAppDialog(msg: "Activity By User Res : ${res.message.toString()}");
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Activity By User Error : ${error.toString()}");
    });
    return list.isEmpty ? null : list[0];
  }

  Future<List<PostOrActivity>> getActivitiesByUser(
      Map data, GetxController c) async {
    debugPrint("Inside POAVM");
    List<PostOrActivity> list = List.empty(growable: true);
    await activitiesRepoImpl.getActivityByUser(data).then((res) async {
      if (res.status == 200) {
        list.addAll(res.postsOrActivities!);
        //c.update();
      } else {
        showAppDialog(msg: "Activity By User Res : ${res.message.toString()}");
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Activity By User Error : ${error.toString()}");
    });
    return list;
  }

  Future<List<PostOrActivity>> searchActivities(
      Map data, GetxController c) async {
    debugPrint("Inside POAVM");
    List<PostOrActivity> list = List.empty(growable: true);
    await activitiesRepoImpl.activitySearch(data).then((res) async {
      if (res.status == 200) {
        list.addAll(res.postsOrActivities!);
        //c.update();
      } else {
        showAppDialog(msg: "Activity By User Res : ${res.message.toString()}");
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Activity By User Error : ${error.toString()}");
    });
    return list;
  }

  Future<List<PostOrActivity>> getSavedActivities(
      Map data, GetxController c) async {
    debugPrint("Inside POAVM");
    List<PostOrActivity> list = List.empty(growable: true);
    await activitiesRepoImpl.listOfSave(data).then((res) async {
      if (res.status == 200) {
        list.addAll(res.postsOrActivities!);
        //c.update();
      } else {
        showAppDialog(msg: "ls Activity Res : ${res.message.toString()}");
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "ls Activity Error : ${error.toString()}");
    });
    return list;
  }

  Future<List<PostOrActivity>> getTimeline(Map data, TimelineScreenVM c) async {
    debugPrint("Inside POAVM");
    List<PostOrActivity> list = List.empty(growable: true);
    await postRepoImpl.getTimelineNew(data)!.then((res) async {
      if (res.status == 200) {
        list.addAll(await setData(res.postsOrActivities!, c));
      } else {
        showAppDialog(msg: "Timeline Res : ${res.message.toString()}");
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Timeline Error : ${error.toString()}");
    });
    return list;
  }

  Future<List<PostOrActivity>> getPostByUser(Map data, GetxController c) async {
    debugPrint("Inside POAVM");
    List<PostOrActivity> list = List.empty(growable: true);
    await postRepoImpl.getPostByUser(data)!.then((res) async {
      if (res.status == 200) {
        list.addAll(await setData(res.postsOrActivities!, c));
      } else {
        showAppDialog(msg: "Post By User Res : ${res.message.toString()}");
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Post By User Error : ${error.toString()}");
    });
    return list;
  }

  Future<List<PostOrActivity>> setData(
      List<PostOrActivity> postsList, GetxController c) async {
    for (PostOrActivity element in postsList) {
      for (Attachment attachments in element.attachment!) {
        if (attachments.type == CaptureType.video) {
          attachments.setController = VideoPlayerController.network(
            ApiInterface.postImgUrl + attachments.name!,
            //ApiInterface.sampleVideoLink
          );
          attachments.getController!.setLooping(true);
          attachments.getController!
              .initialize()
              .whenComplete(() => c.update());
        }
      }
    }
    return postsList;
  }

  Future<void> getTaggedUser(taggedUsers) async {
    var data = {"tagedUserId": taggedUsers};
    taggedUsersList.clear();
    await postRepoImpl.getTaggedUsers(data)!.then((res) async {
      if (res.status == 200) {
        taggedUsersList.addAll(res.data!);
        c?.update();
      } else {
        showAppDialog(msg: "Error ${res.message.toString()}");
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Error ${error.toString()}");
    });
  }

  Future<void> deletePost(postId, c) async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);

    var data = {"userId": userId.toString(), "postId": postId.toString()};
    //"repliedTo": 1
    debugPrint("post data $data");

    await postRepoImpl.deletePost(data)!.then((res) async {
      if (res.status == 200) {
        c.init();
        c.update();
      } else {
        showAppDialog(msg: "Error ${res.message.toString()}");
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Error ${error.toString()}");
    });
  }

  Future<void> getLikedUser(postId) async {
    likeUsers.clear();
    await postRepoImpl.getLikeUser(postId)!.then((res) async {
      if (res.status == 200) {
        likeUsers.addAll(res.data!);
        c?.update();
      } else {
        showAppDialog(msg: "Error ${res.message.toString()}");
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Error ${error.toString()}");
    });
  }

  Future<void> like(postId, index) async {
    var data = {
      "userId": userId.toString(),
      "postId": postId.toString(),
      "isLike": postsList[index].isLiked == 0 ? 1.toString() : 0.toString(),
      //"attachment": ["attachment.jpg"]
    };
    //"repliedTo": 1
    debugPrint("like data $data");

    await postRepoImpl.like(data)!.then((res) async {
      if (res.status == 200) {
        postsList[index].likeCount = postsList[index].isLiked == 0
            ? postsList[index].likeCount! + 1
            : postsList[index].likeCount! - 1;
        postsList[index].isLiked = postsList[index].isLiked == 0 ? 1 : 0;
        c?.update();
      } else {
        showAppDialog(msg: "Error ${res.message.toString()}");
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Error ${error.toString()}");
    });
  }

  Future<void> jioMe(postId, index) async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);

    var data = {
      "userId": userId.toString(),
      "postId": postId.toString(),
      "isJioMe": postsList[index].isJioMe == 0 ? 1.toString() : 0.toString(),
      //"attachment": ["attachment.jpg"]
    };
    //"repliedTo": 1
    debugPrint("like data $data");

    await postRepoImpl.jioMe(data)!.then((res) async {
      if (res.status == 200) {
        // postsList[index].likeCount = postsList[index].isLiked == 0
        //     ? postsList[index].likeCount! + 1
        //     : postsList[index].likeCount! - 1;
        postsList[index].isJioMe = postsList[index].isJioMe == 0 ? 1 : 0;
        c?.update();
      } else {
        showAppDialog(msg: "Error ${res.message.toString()}");
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Error ${error.toString()}");
    });
  }

  void getRequiredPermission(url, savePath) async {
    // prints PermissionStatus.granted

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      debugPrint("Here1");
      final result = await Permission.storage.request();
      if (result.isGranted) {
        //getDeviceInformation();
        debugPrint("Here2");
        download2(url, savePath);
      }
      if (result.isPermanentlyDenied) {
        debugPrint("Here4");
        await Permission.storage.request();
      } else {
        debugPrint("Here5");
      }
    } else {
      //getDeviceInformation();
      debugPrint("Here3");
      download2(url, savePath);
    }

    //debugPrint("PERM ${await Permission.phone.status}");
  }

  //profile, userfriendprofile, singleProfile
  Future download2(String url, String savePath) async {
    try {
      dio.Dio d = dio.Dio();
      dio.Response response = await d.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: dio.Options(
            responseType: dio.ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      debugPrint("download header ${response.headers}");
      File file = File(savePath);
      await file.writeAsBytes(response.data);
      OpenFile.open(file.path);
      //var raf = file.openSync(mode: FileMode.write);
      // debugPrint("raf $raf, response.data ${response.data}");
      // // response.data is List<int> type
      // raf.writeFromSync(response.data);
      // await raf.close();
    } catch (e) {
      debugPrint("Exception in Download ${e.toString()}");
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      debugPrint((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  Future deleteActivity(String actId, GetxController pc) async {
    var data = {
      "userId": userId.toString(),
      "activityId": actId.toString(),
    };
    await activitiesRepoImpl.deleteActivity(data).then((res) {
      Get.back();
      showAppDialog(msg: res.message.toString());
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  //CommentsVM...
}
