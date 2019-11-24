import 'dart:io';

import 'package:chat_demo/Provider/signalRProvider.dart';
import 'package:chat_demo/Provider/voiceRecordProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class RecordVoiceRow extends StatelessWidget {
  const RecordVoiceRow({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VoiceRecordProvider provider = Provider.of<VoiceRecordProvider>(context);
    SignalRProvider signalRProvider = Provider.of<SignalRProvider>(context);
    double rpx = MediaQuery.of(context).size.width / 750;
    // String filePath;
    return GestureDetector(
        onTapDown: (result) {
          provider.beginRecord(signalRProvider);
          // signalRProvider.updateVoicePath(filePath);
        },
        onTapUp: (result) {
          provider.stopRecord();
          int second = ((DateTime.now().millisecondsSinceEpoch -
                      provider.start.millisecondsSinceEpoch) /
                  1000)
              .ceil();
          

          signalRProvider.addVoiceChatRecord(second,1);
          // sleep( Duration(seconds: 1));
          provider.uploadVoice(signalRProvider.connId,signalRProvider,second.toString());
        },
        onTapCancel: () {
          provider.cancelRecord();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          // padding: EdgeInsets.all(10*rpx),
          height: 80 * rpx,
          color: provider.ifTap ? Colors.grey[600] : Colors.white,
          child: Center(
              child: Container(
                  child: Text(
            '按住 说话',
            style: TextStyle(fontSize: 30 * rpx),
          ))),
        ));
  }
}