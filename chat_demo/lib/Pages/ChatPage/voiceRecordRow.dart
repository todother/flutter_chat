import 'dart:math';

import 'package:chat_demo/Model/chatModel.dart';
import 'package:chat_demo/Model/chatRecordModel.dart';
import 'package:chat_demo/Provider/globalDataProvider.dart';
import 'package:chat_demo/Provider/voiceRecordProvider.dart';
import 'package:chat_demo/Tools/StaticMembers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chatRow.dart';

class VoiceRecordRow extends StatelessWidget {
  const VoiceRecordRow(
      {Key key, @required this.voiceRecordProvider, @required this.record})
      : super(key: key);
  final VoiceRecordProvider voiceRecordProvider;
  final ChatModel record;
  @override
  Widget build(BuildContext context) {
    GlobalDataProvider globalDataProvider=Provider.of<GlobalDataProvider>(context);
    double rpx = MediaQuery.of(context).size.width / 750;
    return GestureDetector(
        onTap: () {
          voiceRecordProvider.playVoice(record.contentModel.voicePath);
        },
        child: ChatRow(
          avatarUrl: record.user.avatar,
          content: Container(
            width: 100 * rpx,
            child: Row(
              mainAxisAlignment: record.user.userId == globalDataProvider.userId
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: <Widget>[
                record.user.userId == globalDataProvider.userId
                    ? Text(record.contentModel.voiceLength.toString())
                    : Transform.rotate(angle: pi / 2, child: Icon(Icons.wifi)),
                record.user.userId == globalDataProvider.userId
                    ? Transform.rotate(angle: -pi / 2, child: Icon(Icons.wifi))
                    : Text(record.toString())
              ],
            ),
          ),
          sender: record.user.userId,
          chatType: CHATTYPE.VOICE,
          voiceDuration: record.contentModel.voiceLength,
        ));
  }
}
