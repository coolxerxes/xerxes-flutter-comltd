import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jyo_app/repository/post_repo/post_repo_impl.dart';
import 'package:jyo_app/repository/profile_repo/profile_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:jyo_app/view_model/posts_and_activities_vm.dart';

import '../data/remote/endpoints.dart';
import '../models/profile_model/get_user_info_response.dart';

class ProfileScreenVM extends GetxController {
  ProfileRepoImpl profileRepoImpl = ProfileRepoImpl();
  PostRepoImpl postRepoImpl = PostRepoImpl();
  //final tsv = Get.put(TimelineScreenVM());
  final postsVM = PostsAndActivitiesVM(); //Get.find<PostsAndActivitiesVM>();
  String? firstName = "", lastName = "", age = "", userName = "", bio = "";
  String? freinds = "0", posts = "0", activities = "0";

  List<UserIntrestDatum> userIntrests = List.empty(growable: true);
  String? imageFileName = "";
  String? userId;

  int profileSection = 0;
  bool? isLoadingPost = true;
  bool? isLoadingActs = true;

  var len = 4;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    SecuredStorage.initiateSecureStorage();
    imageFileName = await SecuredStorage.readStringValue(Keys.profile);
    userId = await SecuredStorage.readStringValue(Keys.userId);
    postsVM.afterInit(this, endpoint: Endpoints.post);
    getProfileData();
    getPosts();
    getActivities();
  }

  GetUserInfoResponse ?getUserInfoResponse;
  Future<void> getProfileData() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    debugPrint("getProfileData $userId");
   getUserInfoResponse= await profileRepoImpl.getUserInfo(userId).then((res) async {
      if (res.status == 200) {
        userIntrests.clear();
        firstName = res.data!.userInfoData!.firstName.toString().trim();
        lastName = res.data!.userInfoData!.lastName.toString().trim();
        age = res.data!.userInfoData!.birthDay.toString().trim();
        if (age!.isNotEmpty) {
          age = (DateTime.now().year - DateTime.parse(age!).year).toString();
        }
        userName = res.data!.userInfoData!.username.toString().trim();
        bio = res.data!.userInfoData!.biography.toString().trim();
        freinds = res.data!.friendCount.toString();
        posts = res.data!.postCount.toString();
        await SecuredStorage.writeBoolValue(
            Keys.privateAcc, res.data!.userInfoData!.privateAccount!);
        await SecuredStorage.writeBoolValue(
            Keys.showActToFrnz, res.data!.userInfoData!.privateActivity!);
        await SecuredStorage.writeBoolValue(
            Keys.appearanceSearch, res.data!.userInfoData!.appearanceSearch!);
        userIntrests.addAll(res.data!.userIntrestData!);
        update();
      } else {
        showAppDialog(msg: "Error ${res.message.toString()}");
      }
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Error ${error.toString()}");
    });
  }

  Future<void> getPosts() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    var data = {"userId": userId.toString(), "friendId": userId.toString()};
    debugPrint("data pb $data");
    await postsVM.getPostByUser(data, this).then((res) async {
      postsVM.postsList.clear();
      postsVM.postsList.addAll(res);
      isLoadingPost = false;
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Error ${error.toString()}");
      isLoadingPost = false;
      update();
    });
  }

  Future<void> getActivities() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    var data = {"userId": userId.toString()};
    debugPrint("data acts $data");
    await postsVM.getActivitiesByUser(data, this).then((res) async {
      postsVM.activitiesList.clear();
      postsVM.activitiesList.addAll(res);
      isLoadingActs = false;
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: "Error ${error.toString()}");
      isLoadingActs = false;
      update();
    });
  }
}

class ProfileSection {
  static const posts = 0;
  static const activities = 1;
}
