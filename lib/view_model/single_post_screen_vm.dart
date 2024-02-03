
import 'package:get/get.dart';
import 'package:jyo_app/data/local/user_search_model.dart';
import 'package:jyo_app/repository/post_repo/post_repo_impl.dart';
import 'package:jyo_app/repository/profile_repo/profile_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:jyo_app/view_model/posts_and_activities_vm.dart';
import 'package:jyo_app/view_model/timeline_screen_vm.dart';

import '../data/remote/endpoints.dart';


class SinglePostScreenVM extends GetxController {
  ProfileRepoImpl profileRepoImpl = ProfileRepoImpl();
  PostRepoImpl postRepoImpl = PostRepoImpl();
  final tsv = Get.put(TimelineScreenVM());
  final postsVM = PostsAndActivitiesVM(); //Get.find<PostsAndActivitiesVM>();
  String? firstName = "", lastName = "", age = "", userName = "", bio = "";
  String? imageFileName = "";
  String? userId;
  String? postId;
  bool? isLoadingPost = true;
  bool? isAppStartingFromNotification = false;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
     Map? args = Get.arguments;
    if (args != null) {
      isAppStartingFromNotification = args["isAppStartingFromNotification"];
    }
    SecuredStorage.initiateSecureStorage();
    imageFileName = await SecuredStorage.readStringValue(Keys.profile);
    userId = await SecuredStorage.readStringValue(Keys.userId);
    postsVM.afterInit(this,endpoint: Endpoints.post);
    postId = NotiPost.getId.toString();
    getProfileData();
    await getPosts();
    isLoadingPost = false;
    update();
  }

  Future<void> getProfileData() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    await profileRepoImpl.getUserInfo(userId).then((res) async {
      if (res.status == 200) {
        firstName = res.data!.userInfoData!.firstName.toString().trim();
        lastName = res.data!.userInfoData!.lastName.toString().trim();
        imageFileName = res.data!.userInfoData!.profilePic.toString().trim();
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
    var data = {
      "userId": userId.toString(),
      "friendId": userId.toString(),
      "postId": postId.toString()
    };
    await postsVM.getPostByUser(data, this).then((res) async {      
      postsVM.postsList.clear();
      postsVM.postsList.addAll(res);
      update();
    }).onError((error, stackTrace) {
      isLoadingPost = false;
      update();
    });
  }
}
