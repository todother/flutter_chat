import 'dart:math';

import 'package:chat_demo/Pages/chatDetail.dart';
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
  final String content;
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
            sender == 0 ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: <Widget>[
          sender == 0
              ? CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                )
              : Container(),
          sender == 0
              ? Container(
                  // padding: EdgeInsets.only(left: 20*rpx),
                  child: CustomPaint(
                  painter: ChatBoxPainter(
                      color: Colors.greenAccent,
                      width: 20 * rpx,
                      height: 15 * rpx),
                ))
              : Container(),
          Container(
            child: chatType == 0
                ? Text(
                    content,
                    style: TextStyle(
                        fontSize: 27 * rpx,
                        letterSpacing: 1.5 * rpx,
                        height: 1.7),
                  )
                : Container(
                    width: 100 * rpx,
                    child: Row(
                      mainAxisAlignment: sender == 1
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: <Widget>[
                        sender == 1
                            ? Text(voiceDuration.toString())
                            : Transform.rotate(
                                angle: pi / 2, child: Icon(Icons.wifi)),
                        sender == 1
                            ? Transform.rotate(
                                angle: -pi / 2, child: Icon(Icons.wifi))
                            : Text(voiceDuration.toString())
                      ],
                    ),
                  ),
            margin: EdgeInsets.only(left: 20 * rpx, right: 20 * rpx),
            padding: EdgeInsets.all(15 * rpx),
            decoration: BoxDecoration(
                color: sender == 0 ? Colors.greenAccent : Colors.pinkAccent,
                borderRadius: BorderRadius.circular(10 * rpx)),
          ),
          sender == 1
              ? Transform.rotate(
                  angle: pi,
                  child: Container(
                      // padding: EdgeInsets.only(top: 20 * rpx),
                      child: CustomPaint(
                    painter: ChatBoxPainter(
                        color: Colors.pinkAccent,
                        width: 20 * rpx,
                        height: 15 * rpx),
                  )),
                )
              : Container(),
          sender == 1
              ? CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl),
                )
              : Container(),
        ],
      ),
    );
  }
}