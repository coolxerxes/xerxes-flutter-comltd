import 'package:jyo_app/utils/commet_chat_constants.dart';

abstract class CommetChatApiInterface {
  static const chatUrl =
      "https://${CometChatConstants.appId}.api-${CometChatConstants.region}.cometchat.io/v3/";

  Future commetChatGetApi({
    String? url,
  });

  Future commetChatPostApi({
    String? url,
    Map? data,
  });

  Future commetChatDeleteApi({
    String? url,
    Map? data,
  });
}
