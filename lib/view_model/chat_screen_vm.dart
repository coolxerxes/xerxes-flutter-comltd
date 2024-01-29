import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat_ui_kit/flutter_chat_ui_kit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jyo_app/repository/freinds_repo/freinds_repo_impl.dart';
import 'package:jyo_app/utils/common.dart';
import 'package:jyo_app/utils/secured_storage.dart';
import 'package:jyo_app/view_model/message_screen_vm.dart';

import 'notification_screen_vm.dart';

class ChatScreenVM extends GetxController
    with CometChatMessageEventListener, MessageListener {
  final messageVM = Get.put(MessageScreenVM());

  @override
  void onInit() {
    super.onInit();
    init();
  }

  User? user;
  User? sender;
  User? receiver;
  late String _dateString;
  late String _uiMessageListener;
  Conversation? conversation;
  bool disableSoundForMessages = false;
  List<BaseMessage> messageList = List.empty(growable: true);
  bool? isBlocked = false;

  TextEditingController textEditingController = TextEditingController();

  void init() async {
    user = await CometChat.getLoggedInUser();
    sender = user;
    receiver = conversation!.conversationWith as User;
    _dateString = DateTime.now().millisecondsSinceEpoch.toString();
    _uiMessageListener = "${_dateString}UI_message_listener";
    //textEditingController = TextEditingController(text: text);

    CometChatMessageEvents.addMessagesListener(_uiMessageListener, this);
    //CometChatUIEvents.addUiListener(_uiEventListener, this);
    MessagesRequest messagesRequest =
        (MessagesRequestBuilder()..uid = receiver!.uid).build();

    CometChat.getLastDeliveredMessageId();

    messagesRequest.fetchPrevious(
      onSuccess: ((message) {
        messageList.clear();
        messageList.addAll(message);
        messageList.reversed;
        update();
        debugPrint("messageList ${messageList.length}");
      }),
      onError: (excep) {
        showAppDialog(msg: "Coudn't get messages");
      },
    );

    update();
  }

  onSendButtonClick() {
    if (textEditingController.text.isNotEmpty) {
      //if (previewMessageMode == PreviewMessageMode.none) {
      sendTextMessage();
      //} else if (previewMessageMode == PreviewMessageMode.edit) {
      //editTextMessage();
      // } else if (previewMessageMode == PreviewMessageMode.reply) {
      //   Map<String, dynamic> _metadata = {};
      //   _metadata["reply-message"] = oldMessage!.toJson();

      //   sendTextMessage(metadata: _metadata);
      // }
    }
  }

  sendTextMessage({Map<String, dynamic>? metadata}) {
    String messagesText = textEditingController.text;
    String type = MessageTypeConstants.text;

    TextMessage textMessage = TextMessage(
        sender: sender,
        text: messagesText,
        receiverUid: receiver!.uid,
        receiverType: 'user',
        type: type,
        metadata: metadata,
        // parentMessageId: parentMessageId,
        muid: DateTime.now().microsecondsSinceEpoch.toString(),
        category: CometChatMessageCategory.message);

    // oldMessage = null;
    // messagePreviewTitle = '';
    // messagePreviewSubtitle = '';
    // previewMessageMode = PreviewMessageMode.none;
    // textEditingController.text = '';
    textEditingController.clear();
    //_previousText = '';
    update();

    CometChatMessageEvents.ccMessageSent(textMessage, MessageStatus.inProgress);

    CometChat.sendMessage(textMessage, onSuccess: (TextMessage message) {
      debugPrint("Message sent successfully:  ${message.text}");
      _playSound();
      messageList.add(message);
      update();
      CometChatMessageEvents.ccMessageSent(message, MessageStatus.sent);
    }, onError: (CometChatException e) {
      if (textMessage.metadata != null) {
        textMessage.metadata!["error"] = e;
      } else {
        textMessage.metadata = {"error": e};
      }
      CometChatMessageEvents.ccMessageSent(textMessage, MessageStatus.error);
      debugPrint("Message sending failed with exception:  ${e.message}");
    });
    update();
  }

  sendMediaMessage(
      {required PickedFile pickedFile,
      required String messageType,
      Map<String, dynamic>? metadata}) async {
    String muid = DateTime.now().microsecondsSinceEpoch.toString();

    MediaMessage _mediaMessage = MediaMessage(
      receiverType: 'user',
      type: messageType,
      receiverUid: receiver!.uid,
      file: pickedFile.path,
      metadata: metadata,
      sender: sender,
      //parentMessageId: parentMessageId,
      muid: muid,
      category: CometChatMessageCategory.message,
    );

    CometChatMessageEvents.ccMessageSent(
        _mediaMessage, MessageStatus.inProgress);

    //for sending files
    MediaMessage _mediaMessage2 = MediaMessage(
      receiverType: 'user',
      type: messageType,
      receiverUid: receiver!.uid,
      //file: Platform.isIOS ? 'file://${pickedFile.path}' : pickedFile.path,

      file: (Platform.isIOS && (!pickedFile.path.startsWith('file://')))
          ? 'file://${pickedFile.path}'
          : pickedFile.path,
      metadata: metadata,
      sender: sender,
      //parentMessageId: parentMessageId,
      muid: muid,
      category: CometChatMessageCategory.message,
    );

    if (textEditingController.text.isNotEmpty) {
      textEditingController.clear();
      //_previousText = '';
      update();
    }

    await CometChat.sendMediaMessage(_mediaMessage2,
        onSuccess: (MediaMessage message) async {
      debugPrint("Media message sent successfully: ${_mediaMessage.muid}");

      if (Platform.isIOS) {
        if (message.file != null) {
          message.file = message.file?.replaceAll("file://", '');
        }
      } else {
        message.file = pickedFile.path;
      }

      _playSound();

      CometChatMessageEvents.ccMessageSent(message, MessageStatus.sent);
    }, onError: (e) {
      if (_mediaMessage.metadata != null) {
        _mediaMessage.metadata!["error"] = e;
      } else {
        _mediaMessage.metadata = {"error": e};
      }
      CometChatMessageEvents.ccMessageSent(_mediaMessage, MessageStatus.error);
      debugPrint("Media message sending failed with exception: ${e.message}");
    });
  }

  _playSound() {
    if (disableSoundForMessages == false) {
      SoundManager.play(
        sound: Sound.outgoingMessage,
        //customSound: customSoundForMessage,
        // packageName:
        //     customSoundForMessage == null || customSoundForMessage == ""
        //         ? UIConstants.packageName
        //         : customSoundForMessagePackage
      );
    }
  }

  @override
  void onTextMessageReceived(TextMessage textMessage) async {
    messageList.add(textMessage);
    update();
    CometChat.markAsRead(textMessage, onSuccess: (_) {}, onError: (_) {});
  }

  @override
  void onMediaMessageReceived(MediaMessage mediaMessage) {
    //if (mounted == true) {
    messageList.add(mediaMessage);
    update();
    //}
    CometChat.markAsRead(mediaMessage, onSuccess: (_) {}, onError: (_) {});
  }

  @override
  void onCustomMessageReceived(CustomMessage customMessage) {
    messageList.add(customMessage);
    update();
  }

  Future<void> blockUserProfile() async {
    var userId = await SecuredStorage.readStringValue(Keys.userId);
    Map data = {"userId": userId, "friendId": receiver!.uid.toString()};
    debugPrint("block user prof req $data");
    await FriendsRepoImpl().blockUserProfile(data)!.then((res) async {
      if (res.status == 200) {
        if (res.message == "User blocked") {
          isBlocked = true;
          update();
          await NotificationScreenVM.removeFriendInCommetChat(
              uid: userId.toString(), fuid: receiver!.uid.toString());
          showAppDialog(msg: res.message);
          String conversationWith = receiver!.uid.toString();
          String conversationType = CometChatConversationType.user;
          await deleteConvo(conversationWith, conversationType);
          messageVM.refreshLists();
          Get.back();
        }
      } else {
        showAppDialog(msg: res.message);
      }
      update();
    }).onError((error, stackTrace) {
      showAppDialog(msg: error.toString());
    });
  }

  Future<void> deleteConvo(String conversationWith, String conversationType) async {
    await CometChat.deleteConversation(conversationWith, conversationType,
        onSuccess: (String str) {
      debugPrint(
          "comet chat Conversation deleted successfully at : $str");
    }, onError: (CometChatException e) {
      debugPrint(
          "comet chat Conversation deletion failed : ${e.message}");
    });
  }
}
