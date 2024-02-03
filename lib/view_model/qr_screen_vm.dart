import 'package:get/get.dart';

import '../utils/DynamicLinkHandler.dart';
import '../utils/secured_storage.dart';

class QrScreenVM extends GetxController {
  bool isGenerateQrCode = false;
  @override
  void onInit() {
    generateQrCode();
    // TODO: implement onInit
    super.onInit();
  }

  String qrData = '';
  generateQrCode() async {
    isGenerateQrCode = true;
    update();
    String? id = await SecuredStorage.readStringValue(Keys.userId);
    qrData = await DynamicLinkHandler()
        .createDynamicLink(Get.context!, 'title', 'image', id!);
    isGenerateQrCode = false;
    update();
  }
}
