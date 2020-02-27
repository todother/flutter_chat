import 'dart:convert';

import 'package:chat_demo/Pages/ChatPage/chatDetail.dart';
import 'package:chat_demo/Provider/voiceRecordProvider.dart';
import 'package:chat_demo/Provider/webRTCProvider.dart';
import 'package:flutter_jpush/flutter_jpush.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'XFVoiceProvider.dart';
import 'bottomRowAnimProvider.dart';
import 'chooseFileProvider.dart';
import 'contentEditingProvider.dart';

class JPushProvider with ChangeNotifier {
  // FlutterJPush jpush;
  JPushProvider(BuildContext context) {
    initJPush(context);
  }

  initJPush(BuildContext context) async {
    await FlutterJPush.startup();
    String regId = await FlutterJPush.getRegistrationID();
    print("regId is : $regId");
    FlutterJPush.addReceiveOpenNotificationListener((msg) {
      String chatId = json.decode(msg.extras)["from"].toString();

      WebRTCProvider webRTCProvider = Provider.of<WebRTCProvider>(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                          builder: (_) => VoiceRecordProvider(),
                        ),
                        ChangeNotifierProvider(
                          builder: (_) => ContentEditingProvider(),
                        ),
                        ChangeNotifierProvider(
                            builder: (_) => XFVoiceProvider()),
                        ChangeNotifierProvider(
                          builder: (_) => BottomRowAnimProvider(context),
                        ),
                        ChangeNotifierProvider(
                          builder: (_) => ChooseFileProvider(),
                        )
                      ],
                      child: DetailPage(
                        webRTCProvider: webRTCProvider,
                        
                      ))));
    });
  }
}
