
import 'dart:io';

import 'package:chat_demo/Model/chatRecordModel.dart';
import 'package:chat_demo/Tools/StaticMembers.dart';
import 'package:flutter/material.dart';

import 'chatRow.dart';

class LocationRecordRow extends StatelessWidget {
  const LocationRecordRow({Key key, @required this.record}) : super(key: key);
  final ChatRecord record;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    double width=450*rpx;
    return ChatRow(
      avatarUrl: record.avatarUrl,
      content: Container(
        width: width,
        child: Row(
          mainAxisAlignment: record.sender == SENDER.SELF
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: <Widget>[
            LocationCard(
              address: record.address,
              title: record.title,
              locationImg: record.locationImg,
              width: width,
            )
          ],
        ),
      ),
      sender: record.sender,
      chatType: CHATTYPE.LOCATION,
      voiceDuration: record.voiceDuration,
    );
  }
}

class LocationCard extends StatelessWidget {
  const LocationCard(
      {Key key,
      @required this.title,
      @required this.address,
      @required this.locationImg,
      @required this.width})
      : super(key: key);
  final String title;
  final String address;
  final String locationImg;
  final double width;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    
    return Container(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 15*rpx,),
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20 * rpx, vertical: 5 * rpx),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 30 * rpx),
                )),
            Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 20 * rpx, vertical: 5 * rpx),
                child: Text(
                  address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w200, fontSize: 26 * rpx),
                )),
                SizedBox(height: 5*rpx,),
            Image.file(
              File(locationImg),
              fit: BoxFit.fitWidth,
              width: width,
              height: 0.45 * width,
            )
          ],
        ));
  }
}
