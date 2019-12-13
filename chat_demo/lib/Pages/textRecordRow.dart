import 'package:chat_demo/Model/chatRecordModel.dart';
import 'package:chat_demo/Tools/StaticMembers.dart';
import 'package:flutter/material.dart';

import 'chatRow.dart';

class TextRecordRow extends StatelessWidget {
  const TextRecordRow({Key key,@required this.record}) : super(key: key);
  final ChatRecord record;
  @override
  Widget build(BuildContext context) {
    double rpx=MediaQuery.of(context).size.width/750;
    return ChatRow(
            avatarUrl: record.avatarUrl,
            content: Text(
                    record.content,
                    style: TextStyle(
                        fontSize: 27 * rpx,
                        letterSpacing: 1.5 * rpx,
                        height: 1.7),
                  ),
            sender: record.sender,
            chatType: CHATTYPE.TEXT,
          );
  }
}