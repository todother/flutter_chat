import 'dart:math';

import 'package:chat_demo/Model/chatRecordModel.dart';
import 'package:chat_demo/Provider/voiceRecordProvider.dart';
import 'package:chat_demo/Tools/StaticMembers.dart';
import 'package:flutter/material.dart';

import 'chatRow.dart';

class VoiceRecordRow extends StatelessWidget {
  const VoiceRecordRow(
      {Key key, @required this.voiceRecordProvider, @required this.record})
      : super(key: key);
  final VoiceRecordProvider voiceRecordProvider;
  final ChatRecord record;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return GestureDetector(
        onTap: () {
          voiceRecordProvider.playVoice(record.content);
        },
        child: ChatRow(
          avatarUrl: record.avatarUrl,
          content: Container(
            width: 100 * rpx,
            child: Row(
              mainAxisAlignment: record.sender == SENDER.SELF
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: <Widget>[
                record.sender == SENDER.SELF
                    ? Text(record.voiceDuration.toString())
                    : Transform.rotate(angle: pi / 2, child: Icon(Icons.wifi)),
                record.sender == SENDER.SELF
                    ? Transform.rotate(angle: -pi / 2, child: Icon(Icons.wifi))
                    : Text(record.toString())
              ],
            ),
          ),
          sender: record.sender,
          chatType: CHATTYPE.VOICE,
          voiceDuration: record.voiceDuration,
        ));
  }
}
