import 'dart:math';
import 'package:chat_demo/Provider/globalDataProvider.dart';
import 'package:chat_demo/Tools/StaticMembers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chatDetail.dart';

class ChatRow extends StatelessWidget {
  const ChatRow(
      {Key key,
      @required this.sender,
      @required this.content,
      @required this.avatarUrl,
      @required this.chatType,
      this.voiceDuration})
      : super(key: key);
  final String sender; //0 self 1 other
  final Widget content;
  final String avatarUrl;
  final int chatType;
  final int voiceDuration;
  @override
  Widget build(BuildContext context) {
    GlobalDataProvider globalDataProvider=Provider.of<GlobalDataProvider>(context);
    double rpx = MediaQuery.of(context).size.width / 750;
    double arrowWidth = 10 * rpx;
    Color green = Color.fromARGB(255, 129, 233, 85);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20 * rpx, vertical: 20 * rpx),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: sender!=globalDataProvider.userId 
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          sender != globalDataProvider.userId 
              ? Container(
                  margin: EdgeInsets.only(right: 20 * rpx),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(avatarUrl),
                  ))
              : Container(),
          sender != globalDataProvider.userId 
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
                color: sender == globalDataProvider.userId 
                    ? (chatType == CHATTYPE.LOCATION ? Colors.white : green)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10 * rpx)),
          ),
          sender == globalDataProvider.userId 
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
          sender == globalDataProvider.userId 
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
