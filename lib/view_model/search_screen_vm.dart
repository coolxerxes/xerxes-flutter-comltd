import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jyo_app/repository/freinds_repo/freinds_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:jyo_app/view_model/base_screen_vm.dart';

import '../models/search_people_model/search_people_model.dart';

class SearchScreenVM extends GetxController {
  final baseSreenVM = Get.find<BaseScreenVM>();
  final friendsRepoImpl = FriendsRepoImpl();
  String? userId = "";
  bool? isSearchEmpty = true;

  int selectedSearchType = SearchType.people;
  TextEditingController searchCtrl = TextEditingController();

  List<Datum?>? searchResults = List.empty(growable: true);

  @override
  void onInit() {
    super.onInit();
    init();
  }

  void init() async {
    userId = await SecuredStorage.readStringValue(Keys.userId);
  }

  Future<void> searchPeople(String? name) async {
    await friendsRepoImpl.searchPeople(name, userId)!.then((res) {
      searchResults!.clear();
      if (res.status == 200) {
        if (isSearchEmpty!) {
          searchResults!.clear();
        } else {
          searchResults!.addAll(res.data!);
        }
      } else {
        showAppDialog(msg: res.message);
        searchResults!.clear();
      }
      //searchResults!.add(null);
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
      searchResults!.clear();
      update();
    });
  }
}

class SearchType {
  static const activities = 0;
  static const people = 1;
  static const group = 2;
}
