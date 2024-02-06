import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jyo_app/data/local/post_edit_model.dart';
import 'package:jyo_app/repository/freinds_repo/freinds_repo_impl.dart';
import 'package:jyo_app/repository/post_repo/post_repo_impl.dart';
import 'package:jyo_app/repository/profile_repo/profile_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:jyo_app/view_model/profile_screen_vm.dart';
import 'package:jyo_app/view_model/timeline_screen_vm.dart';
import 'package:video_player/video_player.dart';

import '../data/remote/api_interface.dart';
import '../models/posts_model/timeline_model.dart' as tl;
import '../models/search_people_model/friend_list_model.dart';

class CreatePostScreenVM extends GetxController {
  final tvm = Get.put(TimelineScreenVM());
  PostRepoImpl postRepoImpl = PostRepoImpl();
  FriendsRepoImpl friendsRepoImpl = FriendsRepoImpl();
  ProfileRepoImpl profileRepoImpl = ProfileRepoImpl();
  XFile? selectedAvatar;
  VideoPlayerController? controller;
  String? userId = "";
  List<XFile?>? postsToUpload = List.empty(growable: true);
  TextEditingController userStatusCtrl = TextEditingController();
  List<tl.Attachment?>? attachments = List.empty(growable: true);
  List<String?>? attachmentsOld = List.empty(growable: true);
  List<Datum>? friends = List.empty(growable: true);
  List<Datum>? searchedFriends = List.empty(growable: true);
  List<Datum>? taggedFriends = List.empty(growable: true);
  List<tl.Document>? documents = List.empty(growable: true);
  bool? isEditing = false;
  TextEditingController searchCtrl = TextEditingController();
  bool? isUploading = false;

  String? privacyStatus = "";
  Map activityData = {};

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    userId = await SecuredStorage.readStringValue(Keys.userId);
    attachments!.add(null);
    postsToUpload!.add(null);
    if (Get.arguments != null) {
      activityData = Get.arguments;
    }

    await fetchPostPrivacy();
    await fetchFreindList();

    if (PostEdit.getPostOrActivity != null) {
      setPost();
    }
    update();
  }

  void setPost() async {
    isEditing = true;
    userStatusCtrl.text = PostEdit.getPostOrActivity!.text.toString();
    attachments!.clear();
    postsToUpload!.clear();
    documents!.clear();
    documents!.addAll(PostEdit.getPostOrActivity!.document!);
    if (PostEdit.getPostOrActivity!.activityData != null &&
        PostEdit.getPostOrActivity!.activityData!.isNotEmpty) {
      activityData = PostEdit.getPostOrActivity!.activityData!;
      activityData["activityId"] =
          PostEdit.getPostOrActivity!.activityId.toString();
      debugPrint("ActivityData  $activityData");
    }

    for (var i = 0; i < PostEdit.getPostOrActivity!.userTags!.length; i++) {
      String? id = PostEdit.getPostOrActivity!.userTags![i].toString();
      int idx = friends!.indexWhere((Datum element) {
        if (element.user!.userId.toString() == id.toString()) {
          element.setIsHidden = true;
          return true;
        } else {
          return false;
        }
      });
      if (idx != -1) {
        taggedFriends!.add(friends![idx]);
      }
    }

    attachments!.addAll(PostEdit.getPostOrActivity!.attachment!);
    for (var i = 0; i < attachments!.length; i++) {
      var type = attachments![i]!.type!;
      if (type == CaptureType.video) {
        attachments![i]!.setController = VideoPlayerController.network(
          ApiInterface.postImgUrl + attachments![i]!.name!,
        );
        await attachments![i]!.getController!.initialize();
      }
    }
    attachments!.add(null);
    // for (var i = 0; i < attachments!.length; i++) {
    //   postsToUpload!.add(null);
    // }
  }

  void pickImage(ImageSource source, {type = CaptureType.photo}) async {
    String? fileName;
    if (type == CaptureType.photo) {
      selectedAvatar = await ImagePicker().pickImage(source: source);
      if (selectedAvatar != null) {
        debugPrint("selected Avatar ext ${selectedAvatar!.path}");
      }
    } else if (type == CaptureType.video) {
      selectedAvatar = await ImagePicker().pickVideo(source: source);
      if (selectedAvatar != null) {
        debugPrint("selected Avatar ext ${selectedAvatar!.path}");
        if (selectedAvatar!.path.split(".").last.toString().trim() == "qt" ||
            selectedAvatar!.path.split(".").last.toString().trim() == "mov") {
          showAppDialog(msg: "This video format is not supported");
          return;
        }
      }
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowedExtensions: ["pdf", "xlsx", "docx"], type: FileType.custom);
      if (result != null) {
        //File file = File(result.files.single.path!);
        //selectedAvatar = XFile.fromData(result.files.single.bytes!);
        fileName = result.files.single.name;
        selectedAvatar = XFile(result.files.single.path!);
      } else {
        // User canceled the picker
        selectedAvatar = null;
      }
    }

    if (selectedAvatar != null) {
      isUploading = true;
      update();
      debugPrint("fileNme $fileName");
      await postRepoImpl
          .attachment(selectedAvatar, fileName: fileName)!
          .then((res) async {
        if (res.status == 200) {
          // postsToUpload!.insert(postsToUpload!.length - 1, selectedAvatar);
          if (type == CaptureType.doc) {
            //documents!.add(res.data!.s3FileName.toString().trim());
            documents!.add(
              tl.Document(
                  originalName: res.data!.originalFileName.toString().trim(),
                  s3Name: res.data!.s3FileName.toString().trim()),
            );
          } else {
            attachments!.insert(
                attachments!.length - 1,
                tl.Attachment(
                    type: type, name: res.data!.s3FileName.toString().trim()));
            if (attachments![attachments!.length - 2]!.type ==
                CaptureType.video) {
              attachments![attachments!.length - 2]!.setController =
                  VideoPlayerController.network(
                ApiInterface.postImgUrl +
                    attachments![attachments!.length - 2]!.name!,
              );
              await attachments![attachments!.length - 2]!
                  .getController!
                  .initialize();
            }
          }
          debugPrint("Attachements $attachments");
        } else {
          showAppDialog(msg: res.message.toString());
        }
        isUploading = false;
        update();
      }).onError((error, stackTrace) {
        showAppDialog(msg: error.toString());
        isUploading = false;
        update();
      });
    }
    update();
  }

  Future<void> addPost() async {
    int idx = attachments!.indexWhere((element) {
      return element == null;
    });

    if (idx != -1) {
      debugPrint("idx $idx");
      attachments!.removeAt(idx);
    }

    List<String>? tagged = List.empty(growable: true);

    for (var i = 0; i < taggedFriends!.length; i++) {
      tagged.add(taggedFriends![i].user!.userId.toString());
    }

    var att = [];
    for (var i = 0; i < attachments!.length; i++) {
      var obj = {};
      obj["type"] = attachments![i]!.type!;
      obj["name"] = attachments![i]!.name!;
      att.add(obj);
    }

    var docs = [];
    for (var i = 0; i < documents!.length; i++) {
      var obj = {};
      obj["s3Name"] = documents![i].s3Name!;
      obj["originalName"] = documents![i].originalName!;
      docs.add(obj);
    }

    var data = {
      "userId": userId.toString(),
      "text": userStatusCtrl.text.trim(),
      "attachment": att.isEmpty ? null : att,
      "userTags": tagged.isEmpty ? null : tagged,
      "documents": docs.isEmpty ? null : docs,
      "visible": privacyStatus.toString()
    };
    // if (isEditing!) {
    //   data["id"] = PostEdit.getPostOrActivity!.id.toString();
    // }
    if (activityData.isNotEmpty) {
      data["activityId"] = activityData["activityId"].toString();
    }
    debugPrint("add Post data $data");
    await postRepoImpl.addPost(data)!.then((res) async {
      if (res.status == 200) {
        back();
        final tsvm = Get.put(TimelineScreenVM());
        await tsvm.init();
        tsvm.update();
        //showAppDialog(msg: res.message);
      } else {
        showAppDialog(msg: res.message.toString());
        attachments!.add(null);
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
      attachments!.add(null);
    });
  }

  Future<void> fetchFreindList() async {
    Map data = {"userId": userId, "noHideFriend": "1"};
    await friendsRepoImpl.getFriendList(data)!.then((res) async {
      if (res.status == 200) {
        friends!.clear();
        searchedFriends!.clear();
        friends!.addAll(res.data!);
        for (var i = 0; i < friends!.length; i++) {
          if (friends?[i].user == null) {
            friends?.removeAt(i);
          }
        }
        searchedFriends!.addAll(res.data!);
        for (var i = 0; i < searchedFriends!.length; i++) {
          if (searchedFriends?[i].user == null) {
            searchedFriends?.removeAt(i);
          }
        }
        for (var i = 0; i < friends!.length; i++) {
          friends![i].setIsHidden = false;
          searchedFriends![i].setIsHidden = false;
        }

        update();
      } else {
        showAppDialog(msg: res.message.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  void back() {
    isEditing = false;
    PostEdit.setPostOrActivity = null;
    taggedFriends!.clear();
    friends!.clear();
    attachments!.clear();
    userStatusCtrl.clear();
    selectedAvatar = null;
    Get.back();
  }

  Future<void> updatePost() async {
    int idx = attachments!.indexWhere((element) {
      return element == null;
    });

    if (idx != -1) {
      debugPrint("idx $idx");
      attachments!.removeAt(idx);
    }

    List<String>? tagged = List.empty(growable: true);

    for (var i = 0; i < taggedFriends!.length; i++) {
      tagged.add(taggedFriends![i].user!.userId.toString());
    }
    var att = [];
    for (var i = 0; i < attachments!.length; i++) {
      var obj = {};
      obj["type"] = attachments![i]!.type!;
      obj["name"] = attachments![i]!.name!;
      att.add(obj);
    }

    var docs = [];
    for (var i = 0; i < documents!.length; i++) {
      var obj = {};
      obj["s3Name"] = documents![i].s3Name!;
      obj["originalName"] = documents![i].originalName!;
      docs.add(obj);
    }

    var data = {
      "userId": userId.toString(),
      "text": userStatusCtrl.text.trim(),
      "attachment": att.isEmpty ? null : att,
      "userTags": tagged.isEmpty ? null : tagged,
      "documents": docs.isEmpty ? null : docs,
      "visible": privacyStatus.toString()
    };
    if (isEditing!) {
      data["id"] = PostEdit.getPostOrActivity!.id.toString();
      if (activityData.isNotEmpty) {
        data["activityId"] = activityData["activityId"].toString();
      }
    }
    debugPrint("edit Post data $data");
    await postRepoImpl.updatePost(data)!.then((res) {
      if (res.status == 200) {
        back();
        final psv = Get.put(ProfileScreenVM());
        psv.init();
        showAppDialog(msg: res.message);
      } else {
        showAppDialog(msg: res.message.toString());
        attachments!.add(null);
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
      attachments!.add(null);
    });
  }

  void search(String t) {
    friends!.assignAll(searchedFriends!.where((Datum p0) => (t
            .toString()
            .isEmpty
        ? true
        : ("${p0.user!.firstName.toString().toLowerCase()} ${p0.user!.lastName.toString().toLowerCase()}")
            // (p0.user!.firstName
            //         .toString()
            //         .toLowerCase()
            //         .contains(t.toString().toLowerCase()) ||
            //     p0.user!.lastName
            //         .toString()
            //         .toLowerCase()
            .contains(t.toString().toLowerCase()))));
  }

  Future<void> fetchPostPrivacy() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    await profileRepoImpl.fetchPostPrivacy(userId).then((res) async {
      if (res.status == 200) {
        (res.data!.hidePostFrom);
        switch (res.data!.postPrivacy!.trim().toLowerCase()) {
          case "everyone":
            privacyStatus = "Everyone";
            await SecuredStorage.writeStringValue(Keys.postPrivacy, "everyone");
            break;
          case "friends only":
            privacyStatus = "Friends only";
            await SecuredStorage.writeStringValue(
                Keys.postPrivacy, "friends only");
            break;
          case "only me":
            privacyStatus = "Only me";
            taggedFriends!.clear();
            friends!.clear();
            await fetchFreindList();
            await SecuredStorage.writeStringValue(Keys.postPrivacy, "only me");
            break;
        }
        update();
      } else {
        showAppDialog(msg: res.message.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }
}

class CaptureType {
  static const photo = 0;
  static const video = 1;
  static const doc = 2;
}

class Attachments {
  Attachments(this.type, this.name);

  String? name;
  int? type;
  VideoPlayerController? controller;

  VideoPlayerController? get getController => controller;
  set setController(VideoPlayerController? controller) =>
      this.controller = controller;
}

class Docs {
  String? s3Name;
  String? originalName;

  Docs({this.s3Name, this.originalName});
}
