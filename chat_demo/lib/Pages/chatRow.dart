import 'dart:math';

import 'package:chat_demo/Pages/chatDetail.dart';
import 'package:chat_demo/Tools/StaticMembers.dart';
import 'package:flutter/material.dart';

class ChatRow extends StatelessWidget {
  const ChatRow(
      {Key key,
      @required this.sender,
      @required this.content,
      @required this.avatarUrl,
      @required this.chatType,
      this.voiceDuration})
      : super(key: key);
  final int sender; //0 self 1 other
  final Widget content;
  final String avatarUrl;
  final int chatType;
  final int voiceDuration;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20 * rpx, vertical: 20 * rpx),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            sender == SENDER.OTHER ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: <Widget>[
          sender == SENDER.OTHER
              ? CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                )
              : Container(),
          sender == SENDER.OTHER
              ? Container(
                  // padding: EdgeInsets.only(left: 20*rpx),
                  child: CustomPaint(
                  painter: ChatBoxPainter(
                      color: Colors.pinkAccent,
                      width: 20 * rpx,
                      height: 15 * rpx),
                ))
              : Container(),
          Container(
            child: content,
            margin: EdgeInsets.only(left: 20 * rpx, right: 20 * rpx),
            padding: EdgeInsets.all(15 * rpx),
            decoration: BoxDecoration(
                color: sender == SENDER.SELF ? Colors.greenAccent : Colors.pinkAccent,
                borderRadius: BorderRadius.circular(10 * rpx)),
          ),
          sender == SENDER.SELF
              ? Transform.rotate(
                  angle: pi,
                  child: Container(
                      // padding: EdgeInsets.only(top: 20 * rpx),
                      child: CustomPaint(
                    painter: ChatBoxPainter(
                        color: Colors.greenAccent,
                        width: 20 * rpx,
                        height: 15 * rpx),
                  )),
                )
              : Container(),
          sender == SENDER.SELF
              ? CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                )
              : Container(),
        ],
      ),
    );
  }
}
