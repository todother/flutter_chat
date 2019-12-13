
import 'dart:io';

import 'package:chat_demo/Model/chatRecordModel.dart';
import 'package:chat_demo/Pages/chatRow.dart';
import 'package:chat_demo/Tools/StaticMembers.dart';
import 'package:flutter/material.dart';

class LocationRecordRow extends StatelessWidget {
  const LocationRecordRow({Key key, @required this.record}) : super(key: key);
  final ChatRecord record;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return ChatRow(
      avatarUrl: record.avatarUrl,
      content: Container(
        width: 375 * rpx,
        child: Row(
          mainAxisAlignment: record.sender == SENDER.SELF
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: <Widget>[
            LocationCard(
              address: record.address,
              title: record.title,
              locationImg: record.locationImg,
            )
          ],
        ),
      ),
      sender: record.sender,
      chatType: CHATTYPE.VOICE,
      voiceDuration: record.voiceDuration,
    );
  }
}

class LocationCard extends StatelessWidget {
  const LocationCard(
      {Key key,
      @required this.title,
      @required this.address,
      @required this.locationImg})
      : super(key: key);
  final String title;
  final String address;
  final String locationImg;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Container(
        width: 375 * rpx,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 10 * rpx, vertical: 5 * rpx),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30 * rpx),
                )),
            Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 10 * rpx, vertical: 5 * rpx),
                child: Text(
                  address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.normal, fontSize: 26 * rpx),
                )),
            Image.file(
              File(locationImg),
              fit: BoxFit.fitWidth,
              width: 375 * rpx,
              height: 0.7 * 375 * rpx,
            )
          ],
        ));
  }
}
