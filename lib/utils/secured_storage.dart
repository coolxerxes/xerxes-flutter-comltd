import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jyo_app/repository/registration_repo/registration_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';

class SecuredStorage {
  static FlutterSecureStorage? storage;
  static const aOptions = AndroidOptions(encryptedSharedPreferences: true);

  static void initiateSecureStorage() {
    storage ??= const FlutterSecureStorage(aOptions: aOptions);
  }

// Read value
  static Future<String?> readStringValue(String key) async {
    String? value = await storage?.read(key: key, aOptions: aOptions);
    return value;
  }

  static Future<int?> readIntValue(String key) async {
    String? value = await storage?.read(key: key, aOptions: aOptions);
    return int.parse(value!);
  }

  static Future<bool?> readBoolValue(String key) async {
    String? value = await storage?.read(key: key, aOptions: aOptions);
    return value == "true" ? true : false;
  }

// Read all values
//Map<String, String> allValues = await storage.readAll();

// Delete value
  static Future<void> deleteValue(String key) async {
    await storage?.delete(key: key, aOptions: aOptions);
  }

// Delete all
  static Future<void> clearSecureStorage() async {
    try {
      await storage?.deleteAll(aOptions: aOptions);
    } catch (e) {
      showAppDialog(
          msg:
              "Unable to logout, please clear the data of app in app management.");
    }
  }

// Write value
  static Future<void> writeStringValue(String key, String value) async {
    await storage?.write(key: key, value: value, aOptions: aOptions);
  }

  static Future<void> writeIntValue(String key, int value) async {
    await storage?.write(key: key, value: value.toString(), aOptions: aOptions);
  }

  static Future<void> writeBoolValue(String key, bool value) async {
    await storage?.write(key: key, value: value.toString(), aOptions: aOptions);
  }

  static Future<void> updateTourStep(Map data) async {
    debugPrint("utd $data");
    await RegistrationRepoImpl().updateTour(data)!.then((value) {
      debugPrint("msg: ${value.message}");
    }).onError((error, stackTrace) {
      debugPrint("msg: ${error.toString()}");
    });
  }
}

class Keys {
  static const userId = "userId";
  static const firstName = "firstName";
  static const lastName = "lastName";
  static const birthday = "birthday";
  static const interests = "interests";
  static const groups = "groups";
  static const profile = "profile";
  static const privateAcc = "privateAcc";
  static const showActToFrnz = "showActToFrnz";
  static const appearanceSearch = "appearanceSearch";
  static const directChat = "directChat";
  static const groupChat = "groupChat";
  static const gender = "gender";
  static const postLikeComment = "postLikeComment";
  static const groupActvity = "groupActvity";
  static const friendActivity = "friendActivity";
  static const activityInvitation = "activityInvitation";
  static const postPrivacy = "postPrivacy";
  static const deviceToken = "deviceToken";
  static const isOverviewed = "isOverviewed";
  static const overviewStep = "overviewStep";
  static const token = "token";
  static const catList = "catList";
  static const radius = "radius";
  static const sortBy = "sortBy";
}
