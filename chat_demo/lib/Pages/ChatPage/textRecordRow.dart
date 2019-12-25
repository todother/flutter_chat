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
            content: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15*rpx,vertical: 10*rpx),
                  
                  child: Text(
                          record.content,
                          style: TextStyle(
                              fontSize: 30 * rpx,
                              letterSpacing: 1.2 * rpx,
                              height: 1.5),
                        )
                )
              ]
            ),
            sender: record.sender,
            chatType: CHATTYPE.TEXT,
          );
  }
}