// ignore_for_file: avoid_init_to_null

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jyo_app/resources/app_routes.dart';
import 'package:jyo_app/view_model/most_liked_screen_vm.dart';
import 'package:jyo_app/view_model/profile_screen_vm.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

import '../data/remote/api_interface.dart';
import '../data/remote/endpoints.dart';
import '../models/profile_model/upload_profile_response.dart';
import '../models/registration_model/interest_data_response.dart';
import '../repository/registration_repo/registration_repo_impl.dart';
import '../utils/common.dart';
import '../utils/secured_storage.dart';

class EditProfileScreenVM extends GetxController {
  ProfileScreenVM profileScreenVM = Get.find<ProfileScreenVM>();
  MostLikedScreenVM mostLikedVM = Get.put(MostLikedScreenVM());

  RegistrationRepoImpl registrationRepoImpl = RegistrationRepoImpl();

  TextEditingController fullNameCtrl = TextEditingController();
  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController bioCtrl = TextEditingController();
  List<Datum> userInterestlist = List.empty(growable: true);

  XFile? selectedAvatar;

  String? userPropic;

  String? userName;
  String? bio;

  bool? isUploading = false;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    SecuredStorage.initiateSecureStorage();
    profileScreenVM = Get.find<ProfileScreenVM>();
    mostLikedVM = Get.put(MostLikedScreenVM());
    fullNameCtrl.text =
        profileScreenVM.firstName! + " " + profileScreenVM.lastName!;
    if (userNameCtrl.text.trim().isEmpty) {
      userNameCtrl.text = profileScreenVM.userName!;
    }
    if (bioCtrl.text.trim().isEmpty) {
      bioCtrl.text = profileScreenVM.bio!;
    }

    userInterestlist = List.empty(growable: true);
    for (var i = 0; i < profileScreenVM.userIntrests.length; i++) {
      userInterestlist.add(Datum(
          id: profileScreenVM.userIntrests[i].id,
          name: profileScreenVM.userIntrests[i].name,
          icon: profileScreenVM.userIntrests[i].icon,
          isSelected: true));
      mostLikedVM.selectedIntrestIds.add(profileScreenVM.userIntrests[i].id);
    }
    await mostLikedVM.getIntrest();
    var set1 = Set.from(userInterestlist);
    var set2 = Set.from(mostLikedVM.list);
    mostLikedVM.list = List.from(set2.difference(set1));
    List<Datum> list = List.empty(growable: true);
    for (var i = 0; i < mostLikedVM.list.length; i++) {
      mostLikedVM.list[i].setIsSelected = false;
    }
    list.addAll(mostLikedVM.list);
    mostLikedVM.list.clear();
    mostLikedVM.list
        .addAll(list.where((a) => userInterestlist.every((b) => a.id != b.id)));
    update();
  }

  Future<void> createOrUpdateUserInfo() async {
    var userId = await SecuredStorage.readStringValue(Keys.userId);

    var data = {
      "userId": userId,
      "info": {
        "firstName": fullNameCtrl.text.trim().split(" ").first,
        "lastName": fullNameCtrl.text
            .trim()
            .substring(fullNameCtrl.text.trim().split(" ").first.length),
        "birthday": "12-12-1997",
        "username": userNameCtrl.text.trim(),
        "biography": bioCtrl.text.trim()
      }
    };
    debugPrint("DATAA $data");
    await registrationRepoImpl
        .createOrUpdateUserInfo(data)
        .then((response) async {
      debugPrint("RESPONSE ${response.status}");
      if (response.status == 200) {
        profileScreenVM.getProfileData();
        Get.back();
      } else {
        showAppDialog(msg: response.message.toString());
      }
    }).onError((error, stackTrace) {
      getToNamed(profileRoute);
      debugPrint("RESPONSE HERE ${error.toString()}");
    });
  }

  void pickImage(ImageSource source) async {
    selectedAvatar = await ImagePicker().pickImage(source: source);
    if (selectedAvatar != null) {
      addPropicApi();
    }
    update();
  }

  addPropicApi() async {
    isUploading = true;
    update();
    debugPrint("MAKING IMAGE REQUEST");
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    //var auth = await SharedPref.getString(SharedPref.authToken);
    try {
      ///[1] CREATING INSTANCE
      var dioRequest = dio.Dio();
      dioRequest.options.baseUrl = ApiInterface.baseUrl +
          Endpoints.user +
          Endpoints.uploadProfilePic +
          userId!;

      //[2] ADDING TOKEN
      dioRequest.options.headers = {
        //"Authorization": "Bearer " + auth!,
        //'Content-Type': 'application/x-www-form-urlencoded'
        'Content-Type': 'multipart/form-data',
        'enctype': 'multipart/form-data'
      };

      //[3] ADDING EXTRA INFO
      var formData = dio.FormData.fromMap({
        //'id': id,
      });

      //[4] ADD IMAGE TO UPLOAD
      if (selectedAvatar != null) {
        var file = await dio.MultipartFile.fromFile(selectedAvatar!.path,
            filename: "profile_pic_" + DateTime.now().toIso8601String(),
            contentType: MediaType(
              "image",
              "profile_pic_" + DateTime.now().toIso8601String(),
            ));

        formData.files.add(MapEntry('image', file));
      }

      //[5] SEND TO SERVER
      if (selectedAvatar != null) {
        var response = await dioRequest.post(
          ApiInterface.baseUrl +
              Endpoints.user +
              Endpoints.uploadProfilePic +
              userId,
          data: formData,
        );
        UploadProfileResponse? res = null;
        if (response.statusCode == 200) {
          debugPrint("IMAGE SUCCESS");
          //ApiService().returnResponse(response.data);
          res = UploadProfileResponse.fromJson(response.data);
          userPropic = res.data!.s3FileName!.toString();
          await SecuredStorage.writeStringValue(
              Keys.profile, userPropic.toString());
          profileScreenVM.imageFileName = userPropic.toString();
          await profileScreenVM.getProfileData();
          isUploading = false;

          //profileScreenVM.update();
          //isNotUploading = true;
        } else {
          isUploading = false;
          showAppDialog(
              msg: "Image Upload Failed Response Code " +
                  response.statusCode.toString());
        }
        update();
        //Navigator.of(context).pop();

      } else {
        //Navigator.of(context).pop();
        // isNotUploading = true;
        isUploading = false;
        update();
      }
    } on dio.DioError catch (err) {
      debugPrint("EROR111 ${err.message}");
      isUploading = false;
      if (err.response == null) {
        debugPrint("Error 1");
        //isNotUploading = true;

      }
      if (err.response != null && err.response!.statusCode == 413) {
        debugPrint("Error 413");
        //isNotUploading = true;

      }
      if (err.response != null && err.response!.statusCode == 400) {
        debugPrint("Error 400");
        //isNotUploading = true;

      }
      update();
    }
  }
}

class FromList {
  static const mostLikedVM = 0;
  static const editProfileVM = 1;
}
