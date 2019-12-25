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
    double arrowWidth = 10 * rpx;
    Color green = Color.fromARGB(255, 129, 233, 85);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20 * rpx, vertical: 20 * rpx),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: sender == SENDER.OTHER
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          sender == SENDER.OTHER
              ? Container(
                  margin: EdgeInsets.only(right: 20 * rpx),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(avatarUrl),
                  ))
              : Container(),
          sender == SENDER.OTHER
              ? (chatType==CHATTYPE.IMAGE?Container(): Container(
                  padding: EdgeInsets.only(top: 20 * rpx),
                  child: CustomPaint(
                    painter: ChatBoxPainter(
                        color: Colors.white,
                        width: arrowWidth,
                        height: 15 * rpx),
                  )))
              : Container(),
          Container(
            child: content,
            margin: EdgeInsets.symmetric(horizontal: arrowWidth),
            // padding: EdgeInsets.symmetric(horizontal:15 * rpx,vertical: 10*rpx),
            decoration: BoxDecoration(
                color: sender == SENDER.SELF
                    ? (chatType == CHATTYPE.LOCATION ? Colors.white : green)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10 * rpx)),
          ),
          sender == SENDER.SELF
              ? (chatType==CHATTYPE.IMAGE?Container(): Container(
                  padding: EdgeInsets.only(top: 30 * rpx),
                  child: Transform.rotate(
                    angle: pi,
                    child: Container(
                        child: CustomPaint(
                      painter: ChatBoxPainter(
                          color: (chatType == CHATTYPE.LOCATION
                              ? Colors.white
                              : green),
                          width: arrowWidth,
                          height: 15 * rpx),
                    )),
                  )))
              : Container(),
          sender == SENDER.SELF
              ? ( Container(
                  margin: EdgeInsets.only(left: 20 * rpx),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(avatarUrl),
                  )))
              : Container(),
        ],
      ),
    );
  }
}
