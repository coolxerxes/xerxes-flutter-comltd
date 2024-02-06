import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/common.dart';
import '../../utils/secured_storage.dart';
import 'api_interface.dart';
import 'endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';

class ApiService extends ApiInterface {
  dynamic returnResponse(http.Response response) {
    try {
      dynamic responseJson = jsonDecode(response.body);
      debugPrint(
          "Request : ${response.request!.url} ,header : ${response.request!.headers.toString()} ,method : ${response.toString()} ,RESPONSE $responseJson");
      return responseJson;
    } catch (e) {
      return {};
    }
  }

  Future<String?> get authorizationToken async {
    final token = await SecuredStorage.readStringValue(Keys.token);
    return token;
  }

  @override
  Future? sendOtp(Map data) async {
    var client = http.Client();

    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl + Endpoints.user + Endpoints.sendOtp),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? checkOtp(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl + Endpoints.user + Endpoints.checkOtp),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? createOrUpdateUserInfo(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.createOrUpdateUserInfo),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? signIn(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl + Endpoints.user + Endpoints.signIn),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? userCreate(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl + Endpoints.user + Endpoints.create),
        headers: {
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? getAllIntrest() async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.get(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.metaData +
            Endpoints.getAllIntrest),
        headers: {
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        });
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? saveIntrest(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(
            ApiInterface.baseUrl + Endpoints.user + Endpoints.saveIntrest),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);

    return responseJson;
  }

  @override
  Future? getUserInfo(dynamic id) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client
        .get(Uri.parse(ApiInterface.baseUrl + Endpoints.user + id), headers: {
      if (await authorizationToken != null)
        'Authorization': (await authorizationToken)!
    });
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? putAccountSetting(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.put(
        Uri.parse(
            ApiInterface.baseUrl + Endpoints.user + Endpoints.accountSetting),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);

    return responseJson;
  }

  @override
  Future? fetchNotificationSetting(id) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.get(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.notificationSetting +
            id),
        headers: {
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        });
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? updateNotificationSetting(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.put(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.updateNotification),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);

    return responseJson;
  }

  @override
  Future? fetchPostPrivacy(id) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.get(
        Uri.parse(
            ApiInterface.baseUrl + Endpoints.user + Endpoints.postPrivacy + id),
        headers: {
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        });
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? updatePostPrivacy(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.put(
        Uri.parse(
            ApiInterface.baseUrl + Endpoints.user + Endpoints.updatePrivacy),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);

    return responseJson;
  }

  @override
  Future? blockUser(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.put(
        Uri.parse(ApiInterface.baseUrl + Endpoints.user + Endpoints.blockUsers),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);

    return responseJson;
  }

  @override
  Future? fetchBlockedList(id) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.get(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.friend +
            Endpoints.blockedUserList +
            id),
        headers: {
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        });
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? fetchFriendList(id) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.get(
        Uri.parse(
            ApiInterface.baseUrl + Endpoints.user + Endpoints.friendList + id),
        headers: {
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        });
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? updatePostHideFrom(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.put(
        Uri.parse(
            ApiInterface.baseUrl + Endpoints.user + Endpoints.postHidefrom),
        headers: <String, String>{
          // 'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);

    return responseJson;
  }

  @override
  Future? changePhoneNumber(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.changePhoneNumber),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? checkChangePhoneNoOTP(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.checkChangePhoneNoOTP),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? getHpNoByUserId(id) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.get(
      Uri.parse(ApiInterface.baseUrl +
          Endpoints.user +
          Endpoints.getHpNoByUserId +
          id),
    );
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? deleteAccount(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(
            ApiInterface.baseUrl + Endpoints.user + Endpoints.deleteAccount),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? getMyVouchers(id) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.get(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.getMyVouchers +
            id),
        headers: {
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        });
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? sendSignInNotification(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.sendSignInNotification),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  //Freinds apis
  @override
  Future? searchPeople(String? name, userId) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.get(
        Uri.parse(
            "${ApiInterface.baseUrl}${Endpoints.user}${Endpoints.friend}search/${name!}/$userId"),
        headers: {
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        });
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? userFriendProfileView(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.friend +
            Endpoints.profile),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? sendFriendRequest(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.friend +
            Endpoints.sentRequest),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? acceptOrRejectRequest(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.friend +
            Endpoints.accept),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? getFriendList(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.friend.substring(0, (Endpoints.friend.length - 1))),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? blockProfile(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.friend +
            Endpoints.block),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? getPendingFriendReqList(dynamic id) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.get(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.friend +
            Endpoints.pendingRequestList +
            id.toString()),
        headers: {
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        });
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? cancelFriendRequest(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.friend +
            Endpoints.cancelFriendRequest),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? addPost(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl + Endpoints.user + Endpoints.post),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? getPostByUser(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.post +
            Endpoints.byUser),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? attachment(XFile? imgFile,
      {String? fileName, String? filePath}) async {
    debugPrint("MAKING IMAGE REQUEST");
    try {
      ///[1] CREATING INSTANCE
      var dioRequest = dio.Dio();
      dioRequest.options.baseUrl = ApiInterface.baseUrl +
          Endpoints.user +
          Endpoints.post +
          Endpoints.attachment;

      //[2] ADDING TOKEN
      dioRequest.options.headers = {
        'Content-Type': 'multipart/form-data',
        'enctype': 'multipart/form-data',
        if (await authorizationToken != null)
          'Authorization': (await authorizationToken)!
      };

      //[3] ADDING EXTRA INFO
      var formData = dio.FormData.fromMap({
        //'id': id,
      });

      //[4] ADD IMAGE TO UPLOAD
      if (imgFile != null || filePath != null) {
        var file = await dio.MultipartFile.fromFile(filePath ?? imgFile!.path,
            filename: fileName ?? "post_pic${DateTime.now().toIso8601String()}",
            contentType: MediaType(
              "attachment",
              fileName ?? "post_pic${DateTime.now().toIso8601String()}",
            ));

        formData.files.add(MapEntry('attachment', file));
      }

      //[5] SEND TO SERVER
      if (imgFile != null || filePath != null) {
        var response = await dioRequest.post(
          ApiInterface.baseUrl +
              Endpoints.user +
              Endpoints.post +
              Endpoints.attachment,
          data: formData,
        );
        return response.data;
      }
    } on dio.DioError catch (err) {
      debugPrint("EROR111 ${err.message}");

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
    }
  }

  @override
  Future? comment(Map data, {String endpoint = Endpoints.post}) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            endpoint +
            Endpoints.comment),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? deletePost(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.post +
            Endpoints.delete),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? getComment(Map data, {String endpoint = Endpoints.post}) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            endpoint +
            Endpoints.getComment),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? getLikeUser(dynamic postId) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.get(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.post +
            Endpoints.getLikeUser +
            postId),
        headers: {
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        });
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? getPost(dynamic userId, dynamic postId) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.get(
        Uri.parse(
            "${ApiInterface.baseUrl + Endpoints.user + Endpoints.post + postId}/" +
                userId),
        headers: {
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        });
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? getTimeLine(dynamic userId) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.get(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.post +
            Endpoints.getTimeLine +
            userId),
        headers: {
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        });
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? getTimeLineNew(Map data) async {
    var headers = {
      'Content-Type': 'application/json',
      if (await authorizationToken != null)
        'Authorization': (await authorizationToken)!
    };
    var request = http.Request(
        'POST', Uri.parse('${ApiInterface.baseUrl}/user/post/getTimeLineNew'));
    debugPrint(
        "data gTln $data, url ${ApiInterface.baseUrl}/user/post/getTimeLineNew");
    request.body = json.encode(data);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    dynamic responseJson;
    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      responseJson =
          await response.stream.bytesToString(); //returnResponse(response);
      return responseJson;
    } else {
      debugPrint(response.reasonPhrase);
    }

    // var client = http.Client();

    // final response = await client.post(
    //   Uri.parse(ApiInterface.baseUrl +
    //       Endpoints.user +
    //       Endpoints.post +
    //       Endpoints.getTimeLineNew),
    //    headers: <String, String>{
    //       'Content-Type': 'application/json',
    //     },
    //   body: jsonEncode(data),

    // );
    // responseJson = returnResponse(response);
    //return responseJson;
  }

  @override
  Future? jioMe(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.post +
            Endpoints.jioMe),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? like(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.post +
            Endpoints.like),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? updatePost(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.patch(
        Uri.parse(ApiInterface.baseUrl + Endpoints.user + Endpoints.post),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? taggedUser(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.post +
            Endpoints.getTagedUser),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? notificationHistory(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.getMyNotifications),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? deleteAComment(Map data, {String endpoint = Endpoints.post}) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            endpoint +
            Endpoints.deleteComment),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? disLikeAComment(Map data, {String endpoint = Endpoints.post}) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            endpoint +
            Endpoints.disLikeComment),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? likeAComment(Map data, {String endpoint = Endpoints.post}) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            endpoint +
            Endpoints.likeComment),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? updateComment(Map data, {String endpoint = Endpoints.post}) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            endpoint +
            Endpoints.updateComment),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? getCalendarEvents(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.get(
        Uri.parse(ApiInterface.baseUrl
            // Endpoints.user +
            // Endpoints.post +
            // Endpoints.getTimeLine
            ),
        headers: {
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        });
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? addActivity(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl + Endpoints.user + Endpoints.activity),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? getActivityByUser(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.byUser),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? updateActivity(Map data, String id) async {
    debugPrint("Upd Act id $id");
    var client = http.Client();
    dynamic responseJson;
    final response = await client.patch(
        Uri.parse(
            ApiInterface.baseUrl + Endpoints.user + Endpoints.activity + id),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? acceptOrRejectRequestGroup(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.group +
            Endpoints.acceptOrRejectRequest),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? createGroup(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl + Endpoints.user + Endpoints.group),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? inviteFriend(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.group +
            Endpoints.inviteFriend),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? listOfSave(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.listOfSave),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? memberList(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.group +
            Endpoints.memberList),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? requestList(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.group +
            Endpoints.requestList),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? requestToJoin(Map dta) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.group +
            Endpoints.requestToJoin),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(dta));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? searchGroup(Map dta) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.group +
            Endpoints.search),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(dta));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? saveActivity(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.saveActivity),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? shareAsPost(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.shareAsPost),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? deleteActivity(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.delete),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? getActivityDetails(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.details),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? updateTourStep(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(
            ApiInterface.baseUrl + Endpoints.user + Endpoints.overviewSteps),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? getMapFilteredActivity(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.getActivityByFilter),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? getMapTappedActivity(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.getActivitys),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? acceptInvite(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.acceptInvite),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  // @override
  // Future? activityComment(Map data) async {
  //    var client = http.Client();
  //   dynamic responseJson;
  //   final response = await client.post(
  //       Uri.parse(ApiInterface.baseUrl +
  //           Endpoints.user +
  //           Endpoints.activity+
  //           Endpoints.comment
  //           ),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(data));
  //   responseJson = returnResponse(response);
  //   return responseJson;
  // }

  // @override
  // Future? getActivityComment(Map data)async  {
  //    var client = http.Client();
  //   dynamic responseJson;
  //   final response = await client.post(
  //       Uri.parse(ApiInterface.baseUrl +
  //           Endpoints.user +
  //           Endpoints.activity+
  //           Endpoints.getComment
  //           ),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(data));
  //   responseJson = returnResponse(response);
  //   return responseJson;
  // }

  @override
  Future? invite(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.invite),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? joinActivity(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.joinActivity),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? leaveActivity(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.leaveActivity),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? participantsList(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.participantsList),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? rejectInvite(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.rejectInvite),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? requestListToJoin(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.requestListToJoin),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? acceptRequestToJoin(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.acceptRequestToJoin),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? activitySearch(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.search),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? getGroupList(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.group +
            Endpoints.myGroup),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? getGroupDetails(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.group +
            Endpoints.details),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future acceptOrRejectInvitation(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.group +
            Endpoints.acceptOrRejectInvitation),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future updateGroup(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.group +
            Endpoints.update),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future demoteAdminToMember(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.group +
            Endpoints.demoteAdminToMember),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? demoteToNormalParticipants(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.host +
            Endpoints.demoteToNormalParticipants),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future leaveGroup(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.group +
            Endpoints.leave),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future memberToAdmin(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.group +
            Endpoints.memberToAdmin),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future removeMember(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.group +
            Endpoints.removeMember),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? removeParticipants(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.removeParticipants),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? setHostAndSelfDemote(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.host +
            Endpoints.setHostAndSelfDemote),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? setSubHost(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.host +
            Endpoints.setSubHost),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future setSuperAdminDemoteToAdmin(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.group +
            Endpoints.setSuperAdminDemoteToAdmin),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? leaveActivityAppointSomeoneAsHost(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.activity +
            Endpoints.host +
            Endpoints.leaveActivityAppointSomeoneAsHost),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future leaveAndSetSomeOneAsSuperAdmin(Map data) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
        Uri.parse(ApiInterface.baseUrl +
            Endpoints.user +
            Endpoints.group +
            Endpoints.leaveAndSetSomeOneAsSuperAdmin),
        headers: <String, String>{
          'Content-Type': 'application/json',
          if (await authorizationToken != null)
            'Authorization': (await authorizationToken)!
        },
        body: jsonEncode(data));
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future getGroupSuggestion(String id) async {
    var client = http.Client();
    dynamic responseJson;
    final response = await client.get(
      Uri.parse(
          ApiInterface.baseUrl + Endpoints.suggestionGroups + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json',
        if (await authorizationToken != null)
          'Authorization': (await authorizationToken)!
      },
    );
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? postGetSuggestedPeople(Map data) async {
    log('data api $data');
    var client = http.Client();
    dynamic responseJson;
    final response = await client.post(
      Uri.parse('${ApiInterface.baseUrl}user/friend/getSuggestedPeople'),
      body: jsonEncode(data),
      headers: <String, String>{
        'Content-Type': 'application/json',
        if (await authorizationToken != null)
          'Authorization': (await authorizationToken)!
      },
    );
    responseJson = returnResponse(response);
    return responseJson;
  }

  @override
  Future? postSugge(userId) {
    // TODO: implement postSugge
    throw UnimplementedError();
  }
}
