import 'dart:io';

import 'package:chat_demo/Model/chatModel.dart';
import 'package:chat_demo/Model/chatRecordModel.dart';
import 'package:chat_demo/Pages/VideoPage/videoPageMain.dart';
import 'package:chat_demo/Provider/videoProvider.dart';
import 'package:chat_demo/Tools/StaticMembers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'chatRow.dart';

class ImageRecordRow extends StatelessWidget {
  const ImageRecordRow({Key key, @required this.record}) : super(key: key);
  final ChatModel record;
  @override
  Widget build(BuildContext context) {
    var tag=Uuid().v4();
    double rpx = MediaQuery.of(context).size.width / 750;
    
    return ChatRow(
      avatarUrl: record.user.avatar,
      sender: record.user.userId,
      content: Container(
        // width: record.imgWidth,
        // height: record.imgHeight,
        child: Stack(children: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MultiProvider(
                              providers: [
                                ChangeNotifierProvider(
                                  builder: (context) =>
                                      VideoProvider(record.contentModel.videoPath),
                                ),
                              ],
                              child: VideoPlayerPage(tag:record.contentModel.content,),
                            )));
              },
              child: Hero(
                tag: record.contentModel.contentType,
                child: Image.file(
                  File(record.contentModel.imgPath),
                  fit: BoxFit.fitWidth, //!!!!!!need to update
                )
              )),
          Positioned(
              // left: (record.imgWidth - 80 * rpx) / 2,
              // top: (record.imgHeight - 110 * rpx) / 2,
              child: Container(
                  width: 60 * rpx,
                  margin: EdgeInsets.all(10 * rpx),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // border: Border.all(width: 4 * rpx),

                    color: Color.fromARGB(200, 127, 127, 127),
                  ),
                  child: IconButton(
                    splashColor: Colors.transparent,
                    icon: Icon(Icons.play_arrow),
                    iconSize: 40 * rpx,
                    padding: EdgeInsets.all(0),
                    onPressed: () {},
                  )))
        ]),
      ),
      chatType: CHATTYPE.IMAGE,
    );
  }
}
