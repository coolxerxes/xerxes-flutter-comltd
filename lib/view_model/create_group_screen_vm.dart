import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jyo_app/data/remote/api_interface.dart';
import 'package:jyo_app/models/group_suggestion_model/group_creation_model.dart';
import 'package:jyo_app/repository/group_repo/group_repo_impl.dart';
import 'package:jyo_app/repository/registration_repo/registration_repo_impl.dart';
import 'package:jyo_app/repository/freinds_repo/freinds_repo_impl.dart';
import 'package:jyo_app/view/create_group_screen_view.dart';
import 'package:jyo_app/view_model/group_details_screen_vm.dart';
import '../data/local/group_edit_model.dart';
import '../models/search_people_model/friend_list_model.dart' as f;

import '../models/registration_model/interest_data_response.dart';
import '../repository/post_repo/post_repo_impl.dart';
import '../resources/app_colors.dart';
import '../utils/common.dart';
import '../utils/secured_storage.dart';
import 'group_list_screen_vm.dart';

class CreateGroupScreenVM extends GetxController {
  FriendsRepoImpl friendsRepoImpl = FriendsRepoImpl();
  GroupRepoImpl groupRepoImpl = GroupRepoImpl();
  final grpVM = Get.put(GroupListScreenVM());
  List<Datum> list = List.empty(growable: true);
  List<Datum> baseList = List.empty(growable: true);
  List<f.Datum>? friends = List.empty(growable: true);
  List<f.Datum>? searchedFriends = List.empty(growable: true);
  List<f.Datum>? taggedFriends = List.empty(growable: true);
  TextEditingController? searchCtrl = TextEditingController();
  TextEditingController groupNameCtrl = TextEditingController();
  TextEditingController groupAboutCtrl = TextEditingController();

  String selectedCategories = "";
  String userId = "", firstName = "", lastName = "";
  String profileImg = "";
  String? coverImage = "";
  XFile? xCoverImage;
  CroppedFile? xCoverImageC;

  bool isPrivateGroup = false;
  bool requireAccept = false;

  bool isUploading = false;

  String? createdGroupId;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> cropImage() async {
    xCoverImageC = await ImageCropper().cropImage(
      sourcePath: xCoverImage!.path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        // CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        // CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppColors.orangePrimary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioLockEnabled: true,
        ),
        // WebUiSettings(
        //   context: context,
        // ),
      ],
    );
  }

  Future<void> init() async {
    userId = (await SecuredStorage.readStringValue(Keys.userId))!;
    firstName = (await SecuredStorage.readStringValue(Keys.firstName))!;
    lastName = (await SecuredStorage.readStringValue(Keys.lastName))!;
    profileImg = (await SecuredStorage.readStringValue(Keys.profile))!;
    await getIntrest();
    await fetchFreindList();
    if (GroupEdit.getGroup != null) {
      groupNameCtrl.text = GroupEdit.getGroup!.groupName.toString().trim();
      groupAboutCtrl.text = GroupEdit.getGroup!.about.toString();
      for (int i = 0; i < GroupEdit.getGroup!.category!.length; i++) {
        int idx = baseList.indexWhere((element) {
          return element.id.toString() ==
              GroupEdit.getGroup!.category![i].id.toString();
        });
        if (idx != -1) {
          baseList[idx].setIsSelected = true;
        }
      }
      afterCategoriesSelected(this, baseList);
      isPrivateGroup = GroupEdit.getGroup!.isPrivateGroup ?? false;
      requireAccept = GroupEdit.getGroup!.requireAcceptance ?? false;
      coverImage = GroupEdit.getGroup!.groupImage!;
    }
    update();
  }

  void afterCategoriesSelected(CreateGroupScreenVM c, List<Datum> list) {
    c.selectedCategories = "";
    int count = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].getIsSelected!) {
        count++;
        if (count == 1) {
          c.selectedCategories = c.selectedCategories + "${list[i].name}";
        } else {
          c.selectedCategories = c.selectedCategories + ", ${list[i].name}";
        }
      }
    }
  }

  Future<void> fetchFreindList() async {
    Map data = {
      "userId": userId, /*"noHideFriend": "1"*/
    };
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

  Future<void> getIntrest({bool preSelectIfAvailable = false}) async {
    await RegistrationRepoImpl().getAllIntrest().then((res) async {
      if (res.status == 200) {
        list.clear();
        baseList.addAll(res.data!);
        for (var i = 0; i < baseList.length; i++) {
          baseList[i].setIsSelected = false;
        }
        list.addAll(baseList);

        // if (preSelectIfAvailable) {
        //  // dynamic intrest =
        //    //   await SecuredStorage.readStringValue(Keys.interests);
        //   if (intrest != null) {
        //     var intrData = jsonDecode(intrest) as Map;
        //     var intrIds = intrData["intrestIds"] as List;
        //     selectedIntrestIds.clear();
        //     selectedIntrestIds.addAll(intrIds);
        //     for (var i = 0; i < selectedIntrestIds.length; i++) {
        //       var idx = list.indexWhere((Datum element) {
        //         return element.id == selectedIntrestIds[i];
        //       });
        //       if (idx != -1) {
        //         list[idx].setIsSelected = true;
        //       }
        //     }
        //     if (selectedIntrestIds.isNotEmpty) {
        //       isEnabled = true;
        //     }
        //   }
        // }

        update();
      } else {
        showAppDialog(msg: res.message!.toString());
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "ERROR " + error.toString());
    });
  }

  void searchFriends(String t) {
    friends!
        .assignAll(searchedFriends!.where((f.Datum p0) => (t.toString().isEmpty
            ? true
            : (p0.user!.firstName.toString().toLowerCase() +
                    " " + //.contains(t.toString().toLowerCase()) ||
                    p0.user!.lastName.toString().toLowerCase())
                //  (p0.user!.firstName
                //         .toString()
                //         .toLowerCase()
                //         .contains(t.toString().toLowerCase()) ||
                //     p0.user!.lastName
                //         .toString()
                //         .toLowerCase()
                .contains(t.toString().toLowerCase()))));
  }

  void search(String query) {
    list.clear();
    for (int i = 0; i < baseList.length; i++) {
      if (baseList[i]
          .name!
          .trim()
          .toLowerCase()
          .contains(query.toString().trim().toLowerCase())) {
        list.add(baseList[i]);
      }
    }
    update();
  }

  void togglePrivateGroup() {
    isPrivateGroup = !isPrivateGroup;
    update();
  }

  void toggleRequireAccept() {
    requireAccept = !requireAccept;
    update();
  }

  void pickImage(ImageSource source) async {
    String? fileName;

    xCoverImage = await ImagePicker().pickImage(source: source);
    if (xCoverImage != null) {
      debugPrint("selected Avatar ext ${xCoverImage!.path}");
    }

    if (xCoverImage != null) {
      await cropImage();

      if (xCoverImageC != null) {
        isUploading = true;
        update();
        debugPrint("fileNme $fileName");
        await PostRepoImpl()
            .attachment(null, fileName: fileName, filePath: xCoverImageC!.path)!
            .then((res) async {
          if (res.status == 200) {
            // postsToUpload!.insert(postsToUpload!.length - 1, xCoverImage);
            coverImage = res.data!.s3FileName;
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
    }
    update();
  }

  Future<void> createGroup() async {
    var categories = [];

    for (var i = 0; i < baseList.length; i++) {
      if (baseList[i].isSelected!) {
        categories.add(baseList[i].id.toString());
      }
    }
    //else

    if (groupNameCtrl.text.trim().isEmpty) {
      showAppDialog(msg: "Group name is required");
      return;
    }
    if (groupAboutCtrl.text.trim().isEmpty) {
      showAppDialog(msg: "Group about is required");
      return;
    }
    if (categories.isEmpty) {
      showAppDialog(msg: "categories is required");
      return;
    }
    if (coverImage!.isEmpty) {
      showAppDialog(msg: "Group image is required");
      return;
    }

    var data = {
      "userId": userId.toString(),
      "groupName": groupNameCtrl.text.trim(),
      "about": groupAboutCtrl.text.trim(),
      "groupImage": coverImage,
      "category": categories,
      "isPrivateGroup": isPrivateGroup,
      "requireAcceptance": requireAccept
    };

    debugPrint("group req $data");

    if (GroupEdit.getGroup != null) {
      data["groupId"] = GroupEdit.getGroup!.id.toString();
      data["role"] = GroupEdit.getGroup!.role.toString();
      await groupRepoImpl.updateGroup(data).then((res) async {
        await updateGroupInCommetChat();
        if (res.status == 200) {
          GroupEdit.setGroup = null;
          final grpVM = Get.put(GroupDetailsScreenVM());
          grpVM.init(withoutArg: true);
          Get.back();
          showAppDialog(msg: res.message);
        } else {
          Get.back();
          showAppDialog(msg: res.message);
        }
      }).onError((error, stackTrace) {
        showAppDialog(msg: error.toString());
      });
    } else {
      await groupRepoImpl.createGroup(data).then((res) async {
        if (res.status == 200) {
          await createGroupInCommetChat(res);
          if (friends!.isEmpty) {
            grpVM.init();
            Get.back();
          } else {
            createdGroupId = res.data!.id.toString();
            CreateGroupScreenView.showInviteFriendSheet();
          }
        } else {
          showAppDialog(msg: res.message);
        }
      }).onError((error, stackTrace) {
        showAppDialog(msg: error.toString());
      });
    }
  }

  Future<void> inviteFriends() async {
    var userArray = [];
    for (int i = 0; i < friends!.length; i++) {
      if (friends![i].getIsHidden!) {
        userArray.add(friends![i].user!.userId.toString());
      }
    }
    var data = {
      "groupId": createdGroupId.toString(),
      "userArray": userArray,
      "adminId": userId.toString()
    };
    debugPrint("Invite Data Grp $data");
    await groupRepoImpl.inviteFriend(data).then((res) {
      if (res.status == 200) {
        grpVM.init();
        Get.back();
        Get.back();
      } else {
        grpVM.init();
        Get.back();
        Get.back();
        showAppDialog(msg: res.message);
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> createGroupInCommetChat(GroupCreateModel res) async {
    await CometChat.createGroup(
        group: Group(
            guid: res.data!.id.toString(),
            name: res.data!.groupName.toString(),
            type: //res.data!.requireAcceptance ?? false
                //? GroupTypeConstants.private
                //:
                GroupTypeConstants.public,
            icon: ApiInterface.profileImgUrl + res.data!.groupImage.toString(),
            description: res.data!.about.toString(),
            owner: userId.toString(),
            hasJoined: true,
            scope: GroupMemberScope.admin),
        onSuccess: (Group group) {
          debugPrint("chat Group Created Successfully : $group ");
        },
        onError: (CometChatException e) {
          debugPrint("chat Group Creation failed with exception: ${e.message}");
        });
  }

  Future<void> updateGroupInCommetChat() async {
    await CometChat.updateGroup(
        group: Group(
            guid: GroupEdit.getGroup!.id.toString(),
            name: groupNameCtrl.text.trim(),
            type: //requireAccept
                //? GroupTypeConstants.private
                //:
                GroupTypeConstants.public,
            icon: ApiInterface.profileImgUrl + coverImage.toString(),
            description: groupAboutCtrl.text.trim(),
            owner: userId.toString(),
            hasJoined: true,
            scope: GroupMemberScope.admin),
        onSuccess: (Group group) {
          debugPrint("chat Group update Successfully : $group ");
        },
        onError: (CometChatException e) {
          debugPrint("chat Group updation failed with exception: ${e.message}");
        });
  }
}
