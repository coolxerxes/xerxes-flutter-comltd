import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/resources/app_image.dart';

import '../models/group_suggestion_model/group_suggestion_model.dart';

class GroupSuggestionScreenVM extends GetxController {
  List<GroupSuggestionItem> list = List.empty(growable: true);
  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    getGroupSuggestionItems();
  }

  getGroupSuggestionItems() {
    list.add(GroupSuggestionItem(
        heading: "Singapore Brave Introverts",
        member: "1.195",
        image: AppImage.groupImage));
    list.add(GroupSuggestionItem(
        heading: "Singapore Brave Introverts",
        member: "1.195",
        image: AppImage.groupImage));
    list.add(GroupSuggestionItem(
        heading: "Singapore Brave Introverts",
        member: "1.195",
        image: AppImage.groupImage));
    list.add(GroupSuggestionItem(
        heading: "Singapore Brave Introverts",
        member: "1.195",
        image: AppImage.groupImage));
    list.add(GroupSuggestionItem(
        heading: "Singapore Brave Introverts",
        member: "1.195",
        image: AppImage.groupImage));
    list.add(GroupSuggestionItem(
        heading: "Singapore Brave Introverts",
        member: "1.195",
        image: AppImage.groupImage));
    list.add(GroupSuggestionItem(
        heading: "Singapore Brave Introverts",
        member: "1.195",
        image: AppImage.groupImage));
    list.add(GroupSuggestionItem(
        heading: "Singapore Brave Introverts",
        member: "1.195",
        image: AppImage.groupImage));
    update();
  }
}
