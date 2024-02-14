// ignore_for_file: invalid_use_of_visible_for_testing_member, avoid_init_to_null

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
import 'package:jyo_app/models/profile_model/upload_profile_response.dart';
import 'package:jyo_app/repository/notification_repo/notification_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';

import '../data/remote/api_interface.dart';
import '../data/remote/endpoints.dart';
import '../resources/app_colors.dart';

class SetProfilePicScreenVM extends GetxController {
  NotificationRepoImpl notificationRepoImpl = NotificationRepoImpl();

  XFile? selectedAvatar;
  CroppedFile? selectedAvatarC;

  String? userPropic;
  bool? isEnabled = false;

  bool? isUploading = false;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    SecuredStorage.initiateSecureStorage();
  }

  Future<void> cropImage() async {
    selectedAvatarC = await ImageCropper().cropImage(
      sourcePath: selectedAvatar!.path,
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

  void pickImage(ImageSource source) async {
    selectedAvatar = await ImagePicker().pickImage(source: source);
    if (selectedAvatar != null) {
      await cropImage();
      if (selectedAvatarC != null) {
        addPropicApi();
      }
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
        // "Authorization": "Bearer " + auth!,
        'Authorization': (await SecuredStorage.readStringValue(Keys.token)),
        //'Content-Type': 'application/x-www-form-urlencoded'
        'Content-Type': 'multipart/form-data',
        'enctype': 'multipart/form-data'
      };

      //[3] ADDING EXTRA INFO
      var formData = dio.FormData.fromMap({
        //'id': id,
      });

      //[4] ADD IMAGE TO UPLOAD
      if (selectedAvatarC != null) {
        var file = await dio.MultipartFile.fromFile(selectedAvatarC!.path,
            filename: "profile_pic_" + DateTime.now().toIso8601String(),
            contentType: MediaType(
              "image",
              "profile_pic_" + DateTime.now().toIso8601String(),
            ));

        formData.files.add(MapEntry('image', file));
      }

      //[5] SEND TO SERVER
      if (selectedAvatarC != null) {
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
          isEnabled = true;
          await SecuredStorage.writeStringValue(
              Keys.profile, userPropic.toString());
          // await notificationApi();
          isUploading = false;
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
      showAppDialog(msg: err.message);
      if (err.response == null) {
        debugPrint("Error 1");
        //isNotUploading = true;
      }
      if (err.response != null && err.response!.statusCode == 413) {
        debugPrint("Error 413");
        //isNotUploading = true;
        //update();
      }
      if (err.response != null && err.response!.statusCode == 400) {
        debugPrint("Error 400");
        //isNotUploading = true;
        //update();
      }
      update();
    }
  }

  Future<void> notificationApi() async {
    String? userId = await SecuredStorage.readStringValue(Keys.userId);
    String? deviceToken =
        await SecuredStorage.readStringValue(Keys.deviceToken);
    var data = {"userId": userId, "deviceId": deviceToken};

    await notificationRepoImpl.sendSignInNotification(data).then((res) {
      debugPrint("NOTI MSG ${res.message}");
    }).onError((error, stackTrace) {
      debugPrint("NOTI ERROR ${error.toString()}");
    });
  }
}
