import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jyo_app/data/local/attachements.dart';

import '../models/posts_model/timeline_model.dart';

class FullScreenImageCarousalVM extends GetxController {
  List<Attachment>? attachments = List.empty(growable: true);

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    if (Attachements.getAttachements != null) {
      attachments = Attachements.getAttachements;
      update();
    }
  }
}
