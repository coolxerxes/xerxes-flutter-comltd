import 'dart:developer';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../resources/app_routes.dart';

class DynamicLinkHandler {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  Future<void> initDynamicLinks() async {
    log('start');

    dynamicLinks.onLink.listen((dynamicLinkData) {
      // Listen and retrieve dynamic links here
      final String deepLink = dynamicLinkData.link.toString(); // Get DEEP LINK
      // Ex: https://namnp.page.link/product/013232
      final String path = dynamicLinkData.link.path; // Get PATH
      // Ex: product/013232
      if (deepLink.isEmpty) return;
      handleDeepLink(path);
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
    // initUniLinks();
  }

  Future<void> initUniLinks() async {
    try {
      final initialLink = await dynamicLinks.getInitialLink();
      if (initialLink == null) return;
      handleDeepLink(initialLink.link.path);
    } catch (e) {
      // Error
    }
  }

  void handleDeepLink(String path) {
    log('----- path $path');

    Get.toNamed(friendUserProfileScreeRoute,
        arguments: {'id': path.split('/').last});
    // navigate to detailed product screen
  }

  Future<String> createDynamicLink(
    BuildContext context,
    String title,
    String image,
    String itemId,
  ) async {
    bool short = true;
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      //add urlPrefix as per point 3.2
      uriPrefix: 'https://jioyouout.page.link',
      //add link as per point 4.7
      link: Uri.parse('https://jioyouout.page.link/${itemId}'),
      androidParameters: AndroidParameters(
        //android/app/build.gradle
        packageName: 'com.jioyouout',
        minimumVersion: 0,
      ),
      // socialMetaTagParameters:
      //     SocialMetaTagParameters(title: title, imageUrl: Uri.parse(image)),

      // d: DynamicLinkParameters(
      //   shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      // ),
      iosParameters: IOSParameters(
        bundleId: 'com.jioyouout',
        minimumVersion: '0',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await FirebaseDynamicLinks.instance.buildLink(parameters);
    }
    log(url.toString());
    return url.toString();
  }
}
